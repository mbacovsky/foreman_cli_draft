#!/usr/bin/env ruby
require 'rubygems'

# FIRST PART - OBTAIN I TICKET
gem 'httpclient'
require 'httpclient'
require 'json'
require 'restclient'
require 'net/http'
require 'net/https'
require 'pp'

cli = HTTPClient.new
cli.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
uri = URI.parse "http://localhost:3000/signo/login.json"
resp = cli.post(uri, :username => 'admin', :password => 'admin')
pp resp
oauth_secret = JSON.parse(resp.body).to_hash["oauth_secret"]

pp oauth_secret
exit
# SECOND PART - REUSE TICKET oauth_secret

require 'oauth'
### BEWARE, DON'T ADD SLASH TO THE END OF THE URL!
url = 'https://localhost/katello/api/organizations'

params = { :site => 'https://localhost/',
           :http_method => 'get',
           :request_token_path => "",
           :authorize_path => "",
           :access_token_path => ""
}

# New OAuth consumer to setup signing the request
consumer = OAuth::Consumer.new('admin',
                               oauth_secret,
                               params)

uri = URI.parse(url)
request = Net::HTTP::Get.new(uri.path)


# Sign the request with OAuth
consumer.sign!(request)

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
resp = http.request(request)

pp JSON.parse(resp.body)

