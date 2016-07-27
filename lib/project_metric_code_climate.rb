require 'httparty'
require 'byebug'

class ProjectMetricCodeClimate

  attr_reader :raw_data

  def initialize credentials = {}, raw_data = nil
    @identifier = "github#{URI::parse(credentials[:url]).path}"
    @raw_data = raw_data
  end

  def image
    @identifier.gsub!(/\/$/, '')
    @image ||= "https://codeclimate.com/#{@identifier}/badges/gpa.svg"
  end

  def score
    stat_regex = /fill-opacity=".3">.*?fill-opacity=".3">([^<]+)/
    @raw_data ||= HTTParty.get(image).body
    @score ||= (@raw_data =~ stat_regex ? $1 : nil).to_f
  end

  def raw_data=(new)
    @raw_data = new
    @score = @image = nil
  end

  def refresh
    @raw_data = HTTParty.get(image).body
    @score = @image = nil
    true
  end
end