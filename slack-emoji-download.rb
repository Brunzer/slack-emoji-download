#!/usr/bin/ruby

require 'net/http'
require 'json'
require 'optparse'

def getEmojiList(token)
  uri = URI("https://slack.com/api/emoji.list")
  params = { :token => token }
  uri.query = URI.encode_www_form(params)

  res = Net::HTTP.get_response(uri)
  JSON.parse(res.body)
end

def downloadEmojis(emojiList, path=File.expand_path('~/Downloads'))
  path ||= File.expand_path('~/Downloads')
  emojiList.each do |k,e|
    if !e.include? "alias"
      uri = URI.parse(e)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      resp = http.get(uri.path)
      ftype = uri.path.split(".")[-1]
      open("#{path}/#{k}.#{ftype}", "wb") do |file|
        file.write(resp.body)
      end
    end
  end
end

options = {}

opt_parse = OptionParser.new do |opts|
  opts.banner = "Usage: slack-emoji-download.rb [options]"

  opts.on("-t", "--tokeni TOKEN", "Slack API Token (Required)") {|token| options[:token] = token }
  opts.on("-d", "--directory DIR_PATH", "Download Directory (Default: Downloads)") {|dir| options[:directory] = dir}
end

mandatory = [:token]

begin
  opt_parse.parse! ARGV
  missing = mandatory.select {|param| options[param].nil? }
  unless missing.empty?
    puts "Missing options: #{missing.join(', ')}"
    puts opt_parse
    exit
  end
rescue OptionParser::ParseError, OptionParser::InvalidOption, OptionParser::MissingArgument => e
  puts e
  puts opt_parse
  exit
end

emojis = getEmojiList(options[:token])

if emojis['emoji'].nil? || emojis['emoji'].length = 0
  puts "Could not find any custom emoji's using the supplied token"
else
  puts "Downloading #{emojis['emoji'].length} emoji's..."
  downloadEmojis(emojis['emoji'], options[:path])
end
