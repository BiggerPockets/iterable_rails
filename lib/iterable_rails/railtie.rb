# frozen_string_literal: true

module IterableRails
  class Railtie < Rails::Railtie
    initializer "iterable_rails", before: "action_mailer.set_configs" do
      ActiveSupport.on_load :action_mailer do
        IterableRails.install
      end
    end
  end
end
