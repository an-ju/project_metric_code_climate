require 'faraday'
require 'open-uri'
require 'date'
require 'json'

class ProjectMetricCodeClimate

  attr_reader :raw_data
  attr_reader :conn

  def initialize(credentials = {}, raw_data = nil)
    @project_url = credentials[:github_project]
    @identifier = URI.parse(@project_url).path[1..-1]

    @conn = Faraday.new(url: 'https://api.codeclimate.com/v1')
    @conn.headers['Content-Type'] = 'application/vnd.api+json'
    @conn.headers['Authorization'] = "Token token=#{credentials[:codeclimate_token]}"

    @raw_data = raw_data
  end

  def image
    @raw_data ||= project
    p = project['data'].last
    badge_link = p['links']['maintainability_badge']
    @image ||= { chartType: 'code_climate_v2',
                 titleText: 'Code Climate GPA',
                 data: {
                   maint_badge: open(badge_link).read,
                   gpa: p['attributes']['score']
                 } }.to_json
  end

  def score
    @raw_data ||= project
    p = project['data'].last
    @score ||= p['attributes']['score'].nil? ? -1 : p['attributes']['score']
  end

  def raw_data=(new)
    @raw_data = new
    @score = @image = nil
  end

  def refresh
    @raw_data = project
    @score = @image = nil
    true
  end

  def self.credentials
    %I[github_project codeclimate_token]
  end

  private

  def project
    JSON.parse(@conn.get("repos?github_slug=#{@identifier}").body)
  end
end