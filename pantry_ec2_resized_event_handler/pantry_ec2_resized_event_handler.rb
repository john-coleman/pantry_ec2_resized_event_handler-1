module Wonga
  module Daemon
    class PantryEc2ResizedEventHandler
      def initialize(api_client, logger)
        @api_client = api_client
        @logger = logger
      end

      def handle_message(message)
        message[:event] = :resized
        @api_client.send_put_request("/api/ec2_instances/#{message["id"]}", message)
        @logger.info "Updating resized status for Request:#{message["id"]} (#{message["name"]}.#{message["domain"]}) succeeded"
      end
    end
  end
end
