require 'httparty'

class CodeClimateProjectMetrics
  def initialize identifier
    @identifier = "github#{URI::parse(identifier).path}"
  end

  def image
    @identifier.gsub!(/\/$/, '')
    "https://codeclimate.com/#{@identifier}/badges/gpa.svg"
  end

  def scalar
    response = HTTParty.get(image)
    stat_regex = /fill-opacity=".3">.*?fill-opacity=".3">([^<]+)/
    (response.body =~ stat_regex ? $1 : nil).to_f
  end
end