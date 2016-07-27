require 'httparty'

class ProjectMetricCodeClimate
  def initialize credentials = {}, raw_data = nil
    @identifier = "github#{URI::parse(credentials[:url]).path}"
  end

  def image
    @identifier.gsub!(/\/$/, '')
    "https://codeclimate.com/#{@identifier}/badges/gpa.svg"
  end

  def score
    response = HTTParty.get(image)
    stat_regex = /fill-opacity=".3">.*?fill-opacity=".3">([^<]+)/
    (response.body =~ stat_regex ? $1 : nil).to_f
  end
end