module KartitSigno

  class TokenStore

    def initialize(token_dir)
      @token_dir = token_dir
    end

    def add_token(token)
      path = File.join(@token_dir, token.name)
      File.open(path, 'w') do |out|
        YAML.dump(token, out)
      end
    end
  end
end
