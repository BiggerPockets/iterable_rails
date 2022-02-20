# frozen_string_literal: true

require "spec_helper"

describe "Delivering messages with iterable-rails" do
  let(:api_key) { "ITERABLE_API_KEY" }
  let(:campaign_id) { 12345678 }

  before(:each) do
    stub_request(:post, /api.iterable.com\/api\/email\/target/)

    TestMailer.delivery_method = :iterable
    TestMailer.iterable_settings = { api_key: api_key, campaign_id: campaign_id }
  end

  it "delivers a simple message" do
    TestMailer.simple_message.deliver

    expect(
      a_request(:post, /api.iterable.com\/api\/email\/target/).with(
        query: hash_including(api_key: api_key),
        body: {
          "attachments": [],
          "dataFields": {
            "bcc_address": nil,
            "from_email": "sally@example.com",
            "from_name": "Sally",
            "html": "hello\n",
            "subject": "Example Subject",
            "text": nil,
          },
          "metadata": {},
          "recipientEmail": "david@example.com",
          "campaignId": campaign_id,
        }.to_json
      )
    ).to have_been_made.once
  end

  it "delivers a message with a tracking ID" do
    TestMailer.message_with_tracking_id.deliver

    expect(
      a_request(:post, /api.iterable.com\/api\/email\/target/).with(
        query: hash_including(api_key: api_key),
        body: {
          "attachments": [],
          "dataFields": {
            "bcc_address": nil,
            "from_email": "sally@example.com",
            "from_name": "Sally",
            "html": "hello\n",
            "subject": "Example Subject",
            "text": nil,
            "tracking_id": "tracking_id",
          },
          "metadata": {},
          "recipientEmail": "david@example.com",
          "campaignId": campaign_id,
        }.to_json
      )
    ).to have_been_made.once
  end

  it "delivers a message with metadata" do
    TestMailer.message_with_metadata.deliver

    expect(
      a_request(:post, /api.iterable.com\/api\/email\/target/).with(
        query: hash_including(api_key: api_key),
        body: {
          "attachments": [],
          "dataFields": {
            "bcc_address": nil,
            "from_email": "sally@example.com",
            "from_name": "Sally",
            "html": nil,
            "subject": "Message with metadata",
            "text": "This is a message with metadata.\n",
          },
          "metadata": {
            "key": "value"
          },
          "recipientEmail": "david@example.com",
          "campaignId": campaign_id,
        }.to_json
      )
    ).to have_been_made.once
  end

  it "delivers a multipart message" do
    TestMailer.multipart_message.deliver

    expect(
      a_request(:post, /api.iterable.com\/api\/email\/target/).with(
        query: hash_including(api_key: api_key),
        body: {
          "attachments": [],
          "dataFields": {
            "bcc_address": nil,
            "from_email": "sally@example.com",
            "from_name": "Sally",
            "html": "<b>hello</b>\n",
            "subject": "Your invitation to join BiggerPockets",
            "text": "hello\n",
          },
          "metadata": {},
          "recipientEmail": "david@example.com",
          "campaignId": campaign_id,
        }.to_json
      )
    ).to have_been_made.once
  end

  it "delivers a message with attachments" do
    TestMailer.message_with_attachment.deliver

    expect(
      a_request(:post, /api.iterable.com\/api\/email\/target/).with(
        query: hash_including(api_key: api_key),
        body: {
          "attachments": [{
            name: "empty.gif",
            mimeType: "image/gif",
            content: "R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw==\n"
          }],
          "dataFields": {
            "bcc_address": nil,
            "from_email": "sally@example.com",
            "from_name": "Sally",
            "html": "<p>Attachments!</p>\n",
            "subject": "Message with attachment",
            "text": nil,
          },
          "metadata": {},
          "recipientEmail": "david@example.com",
          "campaignId": campaign_id,
        }.to_json
      )
    ).to have_been_made.once
  end

  it "delivers a message with bcc" do
    TestMailer.message_with_bcc("joe@example.com").deliver

    expect(
      a_request(:post, /api.iterable.com\/api\/email\/target/).with(
        query: hash_including(api_key: api_key),
        body: {
          "attachments": [],
          "dataFields": {
            "bcc_address": "joe@example.com",
            "from_email": "sally@example.com",
            "from_name": "Sally",
            "html": "hello\n",
            "subject": "Example Subject",
            "text": nil,
          },
          "metadata": {},
          "recipientEmail": "david@example.com",
          "campaignId": campaign_id,
        }.to_json
      )
    ).to have_been_made.once
  end

  it "delivers a message with multiple bccs" do
    TestMailer.message_with_bcc(["joe@example.com", "jane@example.com"]).deliver

    expect(
      a_request(:post, /api.iterable.com\/api\/email\/target/).with(
        query: hash_including(api_key: api_key),
        body: {
          "attachments": [],
          "dataFields": {
            "bcc_address": "joe@example.com, jane@example.com",
            "from_email": "sally@example.com",
            "from_name": "Sally",
            "html": "hello\n",
            "subject": "Example Subject",
            "text": nil,
          },
          "metadata": {},
          "recipientEmail": "david@example.com",
          "campaignId": campaign_id,
        }.to_json
      )
    ).to have_been_made.once
  end
end
