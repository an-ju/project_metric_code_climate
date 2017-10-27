require 'faraday'
require 'open-uri'
require 'date'
require 'json'

class ProjectMetricCodeClimate

  attr_reader :raw_data

  def initialize(credentials = {}, raw_data = nil)
    @project_url = credentials[:github_project]
    @identifier = URI.parse(@project_url).path[1..-1]

    @conn = Faraday.new(url: 'https://api.codeclimate.com/v1')
    @conn.headers['Content-Type'] = 'application/vnd.api+json'
    @conn.headers['Authorization'] = "Token token=#{credentials[:codeclimate_token]}"

    @raw_data = raw_data
  end

  def image
    @raw_data ||= gpa
    @image ||= { chartType: 'code_climate_v2', data: @raw_data['data'], titleText: 'Code Climate GPA' }.to_json
  end

  def score
    @raw_data ||= gpa
    @score ||= @raw_data['data']['attributes']['points'].last['value']
  end

  def raw_data=(new)
    @raw_data = new
    @score = @image = nil
  end

  def refresh
    @raw_data = gpa
    @score = @image = nil
    true
  end

  def self.credentials
    %I[github_project codeclimate_token]
  end

  private

  def set_project_id
    @project_id = JSON.parse(@conn.get("repos?github_slug=#{@identifier}").body)['data'][0]['id']
  end

  def gpa
    set_project_id
    end_date = Date.today.strftime '%Y-%m-%d'
    start_date = (Date.today - 7).strftime '%Y-%m-%d'
    JSON.parse(@conn.get("repos/#{@project_id}/metrics/gpa?filter[from]=#{start_date}&filter[to]=#{end_date}").body)
  end

end