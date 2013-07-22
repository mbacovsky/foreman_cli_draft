require 'kartit'
require 'kartit_foreman/exception_handler'


module KartitForeman

  def self.exception_handler_class
    KartitForeman::ExceptionHandler
  end

  require 'kartit_foreman/architecture'
  require 'kartit_foreman/compute_resource'
  require 'kartit_foreman/domain'
  require 'kartit_foreman/organization'
  require 'kartit_foreman/subnet'
  require 'kartit_foreman/user'

end

