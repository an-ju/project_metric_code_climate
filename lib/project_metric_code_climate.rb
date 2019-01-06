# frozen_string_literal: true

require 'project_metric_code_climate/version'
require 'project_metric_code_climate/test_generator'

require 'faraday'
require 'open-uri'
require 'date'
require 'json'

require 'project_metric_base'

# The main class
class ProjectMetricCodeClimate
  include ProjectMetricBase

  add_credentials %I[github_project codeclimate_token]
  add_raw_data %I[codeclimate_project codeclimate_snapshot]

  def initialize(credentials = {}, raw_data = nil)
    @project_url = credentials[:github_project]
    @identifier = URI.parse(@project_url).path[1..-1]

    @conn = Faraday.new(url: 'https://api.codeclimate.com/v1')
    @conn.headers['Content-Type'] = 'application/vnd.api+json'
    @conn.headers['Authorization'] = "Token token=#{credentials[:codeclimate_token]}"

    self.raw_data = raw_data
  end

  def image
    { chartType: 'code_climate',
      data: { ratings: @codeclimate_snapshot['attributes']['ratings'],
              meta: @codeclimate_snapshot['meta'],
              issue_link: @codeclimate_project['links']['web_issues'] } }
  end

  def score
    100.0 - maintainability['measure']['value']
  end

  def obj_id
    @codeclimate_snapshot['attributes']['commit_sha']
  end

  private

  def codeclimate_project
    # Collect project information from code climate.
    resp = JSON.parse(@conn.get("repos?github_slug=#{@identifier}").body)
    @codeclimate_project = resp['data'].last
  end

  def codeclimate_snapshot
    snapshot_id = @codeclimate_project['relationships']['latest_default_branch_snapshot']['data']['id']
    @codeclimate_snapshot = JSON.parse(@conn.get("repos/#{@codeclimate_project['id']}/snapshots/#{snapshot_id}").body)['data']
  end

  def maintainability
    @codeclimate_snapshot['attributes']['ratings'].select { |elem| elem['pillar'].eql? 'Maintainability' }.first
  end
end