# frozen_string_literal: true

require 'project_metric_code_climate/version'
require 'project_metric_code_climate/test_generator'

require 'faraday'
require 'open-uri'
require 'date'
require 'json'

# The main class
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
    refresh unless @raw_data

    { chartType: 'code_climate',
      data: { ratings: @snapshot['attributes']['ratings'],
              meta: @snapshot['meta'],
              issue_link: @p['links']['web_issues'] } }.to_json
  end

  def score
    refresh unless @raw_data

    100.0 - maintainability['measure']['value']
  end

  def commit_sha
    refresh unless @raw_data

    @snapshot['attributes']['commit_sha']
  end

  def raw_data=(new)
    @raw_data = new
    @score = @image = nil
  end

  def refresh
    set_project
    set_snapshot
    @raw_data = { project: @p, snapshot: @snapshot }.to_json
    @score = @image = nil
    true
  end

  def self.credentials
    %I[github_project codeclimate_token]
  end

  private

  def set_project
    # Collect project information from code climate.
    resp = JSON.parse(@conn.get("repos?github_slug=#{@identifier}").body)
    @p = resp['data'].last
  end

  def set_snapshot
    snapshot_id = @p['relationships']['latest_default_branch_snapshot']['data']['id']
    @snapshot = JSON.parse(@conn.get("repos/#{@p['id']}/snapshots/#{snapshot_id}").body)['data']
  end

  def maintainability
    @snapshot['attributes']['ratings'].select { |elem| elem['pillar'].eql? 'Maintainability' }.first
  end
end