# frozen_string_literal: true

require "spec_helper"

describe "Delivering messages with iterable-rails" do
  let(:api_key) { "ITERABLE_API_KEY" }
  let(:campaign_id) { 12345678 }

  before do
    ActionMailer::Base.iterable_settings = { api_key: api_key, campaign_id: campaign_id }
  end

  it 'delivers a simple message' do
    message = TestMailer.simple_message

    message.deliver
  end

  it 'delivers a tagged message' do
    message = TestMailer.tagged_message

    expect { message.deliver }.to change{message.delivered?}.to(true)
  end

  it 'delivers a multipart message' do
    message = TestMailer.multipart_message

    expect { message.deliver }.to change{message.delivered?}.to(true)
  end

  it 'delivers a message with attachments' do
    message = TestMailer.message_with_attachment
    request = message.to_postmark_hash

    expect(request['Attachments'].count).not_to be_zero
    expect { message.deliver }.to change{message.delivered?}.to(true)
  end

  it 'delivers a message with inline image' do
    message = TestMailer.message_with_inline_image
    request = message.to_postmark_hash

    expect(request['Attachments'].count).not_to be_zero
    expect(request['Attachments'].first).to have_key('ContentID')
    expect { message.deliver }.to change{message.delivered?}.to(true)
  end

  it 'delivers a message with metadata' do
    message = TestMailer.message_with_metadata

    request = message.to_postmark_hash

    expect(request['Metadata']).to eq('foo' => 'bar')
    expect { message.deliver }.to change { message.delivered? }.to true
  end
end
