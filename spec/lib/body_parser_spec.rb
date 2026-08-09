# frozen_string_literal: true

# rubocop:disable Metrics/LineLength

require 'rails_helper'

describe BodyParser do
  let(:service) { described_class.new(body) }

  describe '#call' do
    subject { service.call }

    context 'when body contains script tag' do
      let(:body) do
        '<script>alert("yo")</script> <a href="https://example.com">yo</a>'
      end

      it 'strips the script tag' do
        expect(subject)
          .to eq "<p>alert(&amp;quot;yo&amp;quot;) <a href=\"https://example.com\">yo</a></p>\n"
      end
    end

    context 'when body contains markdown marks' do
      let(:body) { '**bold** not bold' }

      it 'converts them to proper HTML tags' do
        expect(subject).to eq "<p><strong>bold</strong> not bold</p>\n"
      end
    end

    context 'when body contains URL' do
      let(:body) { 'Is https://example.com linked properly?' }

      it 'converts URL to link' do
        expect(subject)
          .to eq "<p>Is <a href=\"https://example.com\">https://example.com</a> linked properly?</p>\n"
      end
    end

    context 'when body contains a markdown link' do
      let(:body) { 'Is [this link](https://example.com) linked properly?' }

      it 'converts URL to link properly' do
        expect(subject)
          .to eq "<p>Is <a href=\"https://example.com\">this link</a> linked properly?</p>\n"
      end
    end

    context 'when body contains a local mention' do
      let(:body) { "Hey there @mxb what's up?" }

      it 'converts mention to link' do
        expect(subject)
          .to eq "<p>Hey there <a href=\"/@mxb\">@mxb</a> what's up?</p>\n"
      end
    end

    context 'when body contains a remote mention' do
      let(:body) { "Hey there @mb@mstdn.io what's up?" }

      it 'converts mention to link' do
        expect(subject)
          .to eq "<p>Hey there <a href=\"https://mstdn.io/@mb\">@mb</a> what's up?</p>\n"
      end
    end

    context 'when body contains a mail' do
      let(:body) { 'Hey my mail is mb@mstdn.io' }

      it 'leaves email address in raw form' do
        expect(subject).to eq "<p>Hey my mail is mb@mstdn.io</p>\n"
      end
    end

    context 'when body contains an empty paragraph' do
      let(:body) { "hello\n\n<p></p>\n\nworld" }

      it 'removes the empty paragraph' do
        expect(subject).to eq "<p>hello</p>\n\n\n\n<p>world</p>\n"
      end
    end

    context 'when body contains a paragraph with only a non-breaking space' do
      let(:body) { "para1\n\n&nbsp;\n\npara2" }

      it 'removes the empty paragraph' do
        expect(subject).to eq "<p>para1</p>\n\n\n\n<p>para2</p>\n"
      end
    end

    context 'when body contains a paragraph with only a line break' do
      let(:body) { "one\n\n<br>\n\ntwo" }

      it 'removes the empty paragraph' do
        expect(subject).to eq "<p>one</p>\n\n\n\n<p>two</p>\n"
      end
    end
  end
end

# rubocop:enable Metrics/LineLength
