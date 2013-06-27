require 'kartit'

module KartitForeman

  class ListCommand < Kartit::Apipie::ReadCommand

  end


  class InfoCommand < Kartit::Apipie::ReadCommand

    option "--id", "ID", "resource id"
    option "--name", "NAME", "resource name"

    def validate_options
      if name.nil? and id.nil?
        signal_usage_error "Either --id or --name is required."
      end
    end

    def request_params
      {'id' => (id || name)}
    end

    def self.apipie_options options={}
      super(options.merge(:without => ["name", "id"]))
    end
  end


  class CreateCommand < Kartit::Apipie::WriteCommand

  end


  class UpdateCommand < Kartit::Apipie::WriteCommand

    option "--id", "ID", "resource id"
    option "--name", "NAME", "resource name", :attribute_name => :current_name
    option "--new-name", "NEW_NAME", "new name for the resource", :attribute_name => :name

    def validate_options
      if current_name.nil? and id.nil?
        signal_usage_error "Either --id or --name is required."
      end
    end

    def request_params
      params = method_options
      params['id'] = id || current_name
      params
    end

    def self.apipie_options options={}
      super({:without => ['name', 'id']}.merge(options))
    end

  end


  class DeleteCommand < Kartit::Apipie::WriteCommand

    option "--id", "ID", "resource id"
    option "--name", "NAME", "resource name"

    def validate_options
      if name.nil? and id.nil?
        signal_usage_error "Either --id or --name is required."
      end
    end

    def request_params
      {'id' => (id || name)}
    end

    def self.apipie_options options={}
      super(options.merge(:without => ["name", "id"]))
    end

  end


end
