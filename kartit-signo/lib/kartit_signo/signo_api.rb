require 'httpclient'
require 'json'

module KartitSigno

  class SignoAPI
    def initialize(signo_uri, username, password)
      @signo_uri = signo_uri
      @username = username
      @password = password
    end

    def login()
      response = post "/login.json", :username => @username, :password => @password
      KartitSigno::Token.new response['oauth_secret'], response['expiration']
    end

    private

    def post(page, data={})
      cli = HTTPClient.new
      cli.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
      uri = URI.parse @signo_uri+page
      resp = cli.post(uri, data)
      JSON.parse(resp.body)
    end
  end
end
