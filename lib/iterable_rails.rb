require "action_mailer"
require "iterable"

require "iterable_rails/version"
require "iterable_rails/message"
require "iterable_rails/delivery"

module IterableRails
  module ActionMailerExtensions
    def metadata
      @_message.metadata
    end

    def metadata=(val)
      @_message.metadata=(val)
    end
  end

  def self.install
    ActionMailer::Base.add_delivery_method :iterable, IterableRails::Delivery
  end
end

if defined?(Rails)
  require "iterable_rails/railtie"
else
  IterableRails.install
end
