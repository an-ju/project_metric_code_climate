# require 'httparty'
require 'nokogiri'
require 'rubygems'
require 'open-uri'
require 'json'
class Test

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

  # private 

  def load_remote_image
    HTTParty.get(image_url).body
  end

  def json
    # page = Nokogiri::HTML(open("https://codeclimate.com/#{@identifier}"))
    page = Nokogiri::HTML(open("https://codeclimate.com/github/hrzlvn/coursequestionbank"))

    raw_data = page.css('div.repos-show__overview-summary-number')
    data_hash = {'GPA' => raw_data[0].text[/\d.+/], 'issues' => raw_data[1].text[/\d+/], 'coverage' => raw_data[2].text[/\d+/]}
    data_hash.to_json
  end

  def image_url
    @identifier.gsub!(/\/$/, '')
    @image ||= "https://codeclimate.com/#{@identifier}/badges/gpa.svg"
  end
end

credentials = {url: "codeclimate.com/github/hrzlvn/coursequestionbank"}
a = Test.new(credentials)
print(a.json)