# frozen_string_literal: true

module IterableRails
  class Delivery
    attr_accessor :settings

    def initialize(settings)
      self.settings = settings
      configure_iterable_client
    end

    def deliver!(mail)
      message = Message.new(mail)

      response = Iterable::Email.new.target(
        message.to,
        campaign_id,
        dataFields: message.data_fields,
        metadata: message.metadata
      )

      # TODO: error handling
    end

    private

    def configure_iterable_client
      Iterable.configure do |config|
        config.token = settings[:api_key]
      end
    end

    def campaign_id
      settings[:campaign_id]
    end
  end
end
