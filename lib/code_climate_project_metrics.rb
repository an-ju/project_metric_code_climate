require 'httparty'

class CodeClimateProjectMetrics
  def initialize identifier
    @identifier = identifier
  end

  def image
    @identifier.gsub!(/\/$/, '')
    "https://codeclimate.com/#{@identifier}/badges/gpa.svg"
  end

  def scalar
    response = HTTParty.get(gpa_badge_url)
    stat_regex = /fill-opacity=".3">.*?fill-opacity=".3">([^<]+)/
    response.body =~ stat_regex ? $1 : nil
  end
end