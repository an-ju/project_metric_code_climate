require 'faraday'
require 'open-uri'
require 'date'
require 'json'

class ProjectMetricCodeClimate

  attr_reader :raw_data
  attr_reader :conn
  attr_reader :p

  def initialize(credentials = {}, raw_data = nil)
    @project_url = credentials[:github_project]
    @identifier = URI.parse(@project_url).path[1..-1]

    @conn = Faraday.new(url: 'https://api.codeclimate.com/v1')
    @conn.headers['Content-Type'] = 'application/vnd.api+json'
    @conn.headers['Authorization'] = "Token token=#{credentials[:codeclimate_token]}"

    @raw_data = raw_data
  end

  def image
    set_project
    @raw_data ||= snapdata ref_points['data'].first
    badge_link = @p['links']['maintainability_badge']
    if @raw_data['data']['attributes']['ratings'].empty?
      measure = @raw_data['data']['attributes']['gpa']
    else
      measure = 100.0 - @raw_data['data']['attributes']['ratings'].first['measure']['value']
    end

    @image ||= { chartType: 'code_climate_v2',
                 titleText: 'Code Climate GPA',
                 data: {
                   maint_badge: open(badge_link).read,
                   measure: measure,
                   gpa: @p['attributes']['score']
                 } }.to_json
  end

  def score
    set_project
    @raw_data ||= snapdata ref_points['data'].first
    if @raw_data['data']['attributes']['ratings'].empty?
      measure = @raw_data['data']['attributes']['gpa']
    else
      measure = 100.0 - @raw_data['data']['attributes']['ratings'].first['measure']['value']
    end
    @score ||= measure
  end

  def raw_data=(new)
    @raw_data = new
    @score = @image = nil
  end

  def refresh
    set_project
    @raw_data = snapdata ref_points['data'].first
    @score = @image = nil
    true
  end

  def self.credentials
    %I[github_project codeclimate_token]
  end

  private

  def set_project
    resp = JSON.parse(@conn.get("repos?github_slug=#{@identifier}").body)
    @p = resp['data'].last
  end

  def ref_points
    JSON.parse(@conn.get("repos/#{@p['id']}/ref_points").body)
  end

  def snapdata(ref)
    snapshot = ref['relationships']['snapshot']['data']
    JSON.parse(@conn.get("repos/#{@p['id']}/snapshots/#{snapshot['id']}").body)
  end
end