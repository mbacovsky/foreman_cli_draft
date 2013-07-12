require 'digest/sha1'

module KartitSigno

  class Token

    attr_reader :secret, :expires, :name

    def initialize(secret, expires, name=nil)
      @name = name || Digest::SHA1.hexdigest(secret).force_encoding("UTF-8")
      @secret = secret
      @expires = expires
    end
  end

end
