require 'httparty'
require 'byebug'

class ProjectMetricCodeClimate

  attr_reader :raw_data

  def initialize credentials = {}, raw_data = nil
    @identifier = "github#{URI::parse(credentials[:url]).path}"
    @raw_data = raw_data
  end

  def image
    @raw_data ||= load_remote_image
    @image ||= raw_data
  end

  def score
    stat_regex = /fill-opacity=".3">.*?fill-opacity=".3">([^<]+)/
    @raw_data ||= load_remote_image
    @score ||= (@raw_data =~ stat_regex ? $1 : nil).to_f
  end

  def raw_data=(new)
    @raw_data = new
    @score = @image = nil
  end

  def refresh
    @raw_data = load_remote_image
    @score = @image = nil
    true
  end

  private 

  def load_remote_image
    HTTParty.get(image_url).body
  end

  def image_url
    @identifier.gsub!(/\/$/, '')
    @image ||= "https://codeclimate.com/#{@identifier}/badges/gpa.svg"
  end
end