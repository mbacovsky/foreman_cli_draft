
module Kartit
  module Messages

    def self.included(base)
      base.extend(ClassMethods)
    end

    def success_message_for action
      self.class.success_message_for action
    end

    def success_message
      self.class.success_message
    end

    module ClassMethods
      def success_message_for action, msg=nil
        @success_message ||= {}
        @success_message[action] = msg unless msg.nil?
        @success_message[action]
      end

      def success_message msg=nil
        success_message_for :default, msg
      end
    end

  end
end



