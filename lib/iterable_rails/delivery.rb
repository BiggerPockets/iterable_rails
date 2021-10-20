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
        message.to_email_address,
        message.campaign_id || campaign_id,
        attachments: message.attachments,
        dataFields: message.data_fields,
        metadata: message.metadata
      )

      unless response.success?
        raise "Iterable API request failed: #{response.message}"
      end
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
