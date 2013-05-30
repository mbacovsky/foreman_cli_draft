module Kartit

  class Settings

    def self.[] key
      settings[key.to_sym]
    end

    def self.load settings_hash
      settings.merge! settings_hash.inject({}){ |sym_hash,(k,v)| sym_hash[k.to_sym] = v; sym_hash }
    end

    def self.clear
      settings.clear
    end

    private
    def self.settings
      @settings_hash ||= {}
      @settings_hash
    end

  end
end
