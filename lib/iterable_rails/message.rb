# frozen_string_literal: true

module IterableRails
  class Message
    attr_reader :mail

    def initialize(mail)
      @mail = mail
    end

    def attachments
      mail.attachments.map do |attachment|
        {
          name: attachment.filename,
          mimeType: attachment.mime_type,
          content: Base64.encode64(attachment.body.decoded)
        }
      end
    end

    def data_fields
      {
        bcc_address: bcc_address,
        from_email: from_email,
        from_name: from_name,
        html: html,
        subject: subject,
        text: text,
      }.merge(additional_data_fields)
    end

    def additional_data_fields
      { tracking_id: get_value(:tracking_id) }.merge(get_value(:data_fields) || {}).compact
    end

    def metadata
      get_value(:metadata) || {}
    end

    def to_email_address
      to.address
    end

    private

    def bcc_address
      return_string_value(:bcc_address)
    end

    def from_email
      from.address
    end

    def from_name
      from.display_name
    end

    def html
      return mail.html_part.body.decoded if mail.html_part
      return_decoded_body('text/html')
    end

    def template
      return_string_value(:template)
    end

    def template_content
      get_value(:template_content)
    end

    def important
      mail[:important].to_s == 'true'
    end

    def inline_css
      nil_true_false?(:inline_css)
    end

    def ip_pool
      return_string_value(:ip_pool)
    end

    def preserve_recipients
      nil_true_false?(:preserve_recipients)
    end

    def return_path_domain
      return_string_value(:return_path_domain)
    end

    def send_at
      value = get_value(:send_at)
      value ? send_at_formatted_string(value) : nil
    end

    # mandrill expects `send_at` in UTC as `YYYY-MM-DD HH:MM:SS`
    def send_at_formatted_string(obj)
      return obj if obj.is_a?(String)

      obj = obj.to_time if obj.is_a?(DateTime)
      return obj.utc.strftime('%Y-%m-%d %H:%M:%S') if obj.is_a?(Time)

      raise ArgumentError, 'send_at should be Time/DateTime or String'
    end

    def signing_domain
      return_string_value(:signing_domain)
    end

    def subaccount
      return_string_value(:subaccount)
    end

    def subject
      mail.subject
    end

    def tags
      collect_tags
    end

    def text
      return mail.text_part.body.decoded if mail.text_part
      return_decoded_body('text/plain')
    end

    def track_clicks
      nil_true_false?(:track_clicks)
    end

    def track_opens
      nil_true_false?(:track_opens)
    end

    def tracking_domain
      return_string_value(:tracking_domain)
    end

    def url_strip_qs
      nil_true_false?(:url_strip_qs)
    end

    def view_content_link
      nil_true_false?(:view_content_link)
    end

    # Returns an array of tags
    def collect_tags
      mail[:tags].to_s.split(', ').map { |tag| tag }
    end

    def from
      address = mail[:from].formatted
      Mail::Address.new(address.first)
    end

    def to
      address = mail[:to].formatted
      Mail::Address.new(address.first)
    end

    def get_value(field)
      if mail[field].respond_to?(:unparsed_value)                     # `mail` gem > 2.7.0
        mail[field].unparsed_value
      elsif mail[field].instance_variable_defined?('@unparsed_value') # `mail` gem = 2.7.0
        mail[field].instance_variable_get('@unparsed_value')
      elsif mail[field].instance_variable_defined?('@value')          # `mail` gem < 2.7.0
        mail[field].instance_variable_get('@value')
      end
    end

    def attachments?
      mail.attachments.any? { |a| !a.inline? }
    end

    def inline_attachments?
      mail.attachments.any?(&:inline?)
    end

    def return_decoded_body(mime_type)
      mail.mime_type == mime_type ? mail.body.decoded : nil
    end

    def return_string_value(field)
      mail[field] ? mail[field].to_s : nil
    end

    def nil_true_false?(field)
      return nil if mail[field].nil?
      mail[field].to_s == 'true'
    end
  end
end
