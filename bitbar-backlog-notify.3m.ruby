#! /usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'

SPACE = "your backlog space"
BKKEY = "your backlog api key"
COUNT = 10
uri = URI.parse("#{SPACE}/api/v2/notifications?count=#{COUNT}&apiKey=#{BKKEY}")

https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true
res = https.start {
    https.get(uri.request_uri)
}

count = 0
tasks = []
if res.code == '200'
    # get notify detail
    result = JSON.parse(res.body)
    result.each do |child|
        if child['alreadyRead'] == false 
            tasks.push("#{child['issue']['issueKey']} #{child['issue']['summary']} | size=10 href=#{SPACE}/view/#{child['issue']['issueKey']}#comment-#{child['comment']['id']}")
            count += 1
        end
    end

    # set display
    if count == 0
        puts "Backlog | color=green"
        puts "---"
    else
        puts "Backlog | color=red"
        puts "---"

        tasks.uniq.each do |task|
            puts task
        end
    end

else
    puts "error #{res.code} #{res.message}"
end
