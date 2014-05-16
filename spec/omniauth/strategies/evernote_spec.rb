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
      subject.consumer.options[:site].should eq('https://www.evernote.com')
    end

    it 'has correct request token url' do
      subject.consumer.options[:request_token_path].should eq('/oauth')
    end

    it 'has correct access token url' do
      subject.consumer.options[:access_token_path].should eq('/oauth')
    end

    it 'has correct authorize url' do
      subject.consumer.options[:authorize_path].should eq('/OAuth.action')
    end
  end

  describe "#uid" do
    before do
      subject.stub(:raw_info) do
        {'id' => '123'}
      end
    end

    it 'returns the id from raw_info' do
      subject.uid.should eq('123')
    end
  end

  describe "#info" do
    before :each do
      subject.stub(:raw_info) do
        {'name' => "Mike Rotch", 'username' => "mikerotch"}
      end
    end

    it 'returns the name from raw_info' do
      subject.info['name'].should eq('Mike Rotch')
    end

    it 'returns the username from raw_info as nickname' do
      subject.info['nickname'].should eq('mikerotch')
    end
  end

  describe "#extra" do
  end

  describe "#raw_info" do
  end
end
