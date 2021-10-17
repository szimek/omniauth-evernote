require 'spec_helper'
require 'ostruct'

# Fix OpenStruct in Ruby 1.8
if RUBY_VERSION <= "1.9"
  class OpenStruct
    undef id
  end
end

describe OmniAuth::Strategies::Evernote do
  before do
    @consumer_key = 'key'
    @consumer_secret = 'secret'
  end

  subject do
    args = [@consumer_key, @consumer_secret, @options].compact
    OmniAuth::Strategies::Evernote.new(nil, *args)
  end

  describe '#consumer' do
    it 'has correct Evernote site' do
      expect(subject.consumer.options[:site]).to eq('https://www.evernote.com')
    end

    it 'has correct request token url' do
      expect(subject.consumer.options[:request_token_path]).to eq('/oauth')
    end

    it 'has correct access token url' do
      expect(subject.consumer.options[:access_token_path]).to eq('/oauth')
    end

    it 'has correct authorize url' do
      expect(subject.consumer.options[:authorize_path]).to eq('/OAuth.action')
    end
  end

  describe "#uid" do
    before do
      allow(subject).to receive(:raw_info).and_return({'id' => '123'})
    end

    it 'returns the id from raw_info' do
      expect(subject.uid).to eq('123')
    end
  end

  describe "#info" do
    before :each do
      allow(subject).to receive(:raw_info).and_return({'name' => "Mike Rotch", 'username' => "mikerotch"})
    end

    it 'returns the name from raw_info' do
      expect(subject.info['name']).to eq('Mike Rotch')
    end

    it 'returns the username from raw_info as nickname' do
      expect(subject.info['nickname']).to eq('mikerotch')
    end
  end

  describe "#extra" do
  end

  describe "#raw_info" do
  end
end
