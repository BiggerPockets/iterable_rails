# frozen_string_literal: true

class TestMailer < ActionMailer::Base
  default subject: "Example Subject", to: "David <david@example.com>", from: "Sally <sally@example.com>"

  def simple_message
    mail
  end

  def message_with_extra_data_fields
    mail(subject: "Message with data fields", data_fields: { key: "value" })
  end

  def message_with_tracking_id
    mail(tracking_id: "tracking_id")
  end

  def message_with_metadata
    mail(subject: "Message with metadata", metadata: { key: "value" })
  end

  def multipart_message
    mail(subject: "Your invitation to join BiggerPockets") do |format|
      format.text
      format.html
    end
  end

  def message_with_attachment
    attachments["empty.gif"] = File.read(image_file)
    mail(subject: "Message with attachment")
  end

  def message_with_custom_campaign_id
    mail(subject: "Message with custom campaign id", campaign_id: "98765", body: "")
  end

  protected

  def image_file
    gem_root = Gem::Specification.find_by_name("iterable_rails").gem_dir
    File.join(gem_root, "spec", "fixtures", "empty.gif")
  end
end
