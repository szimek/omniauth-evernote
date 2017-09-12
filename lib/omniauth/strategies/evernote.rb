require 'omniauth/strategies/oauth'

module OmniAuth
  module Strategies
    class Evernote < OmniAuth::Strategies::OAuth
      option :name, 'evernote'
      option :client_options, {
        :site => 'https://www.evernote.com',
        :request_token_path => '/oauth',
        :access_token_path => '/oauth',
        :authorize_path => '/OAuth.action'
      }

      uid { raw_info['id'].to_s }

      info do
        info_hash = {
          name:     raw_info['name'],
          nickname: raw_info['username']
        }

        if raw_info.accounting?
          info_hash.merge!(
            company: raw_info.accounting['businessName']
          )
        end

        if user_profile
          info_hash.merge!(
            email: user_profile['email'],
            image: user_profile['photoUrl'],
            phone: user_profile['attributes']['mobilePhone'] || user_profile['attributes']['workPhone'],
            location: user_profile['attributes']['location'],
            urls: {
              profile_url: user_profile['attributes']['linkedInProfileUrl']
            }
          )
        end

        prune!(info_hash)
      end

      extra do
        prune!(raw_info: raw_info, user_profile: user_profile)
      end

      def raw_info
        @raw_info ||= convert_to_hashie(evernote_client.getUser)
      end

      def business_member?
        raw_info.accounting? && raw_info.accounting.businessId?
      end

      def business_token
        return unless business_member?
        @business_token ||= convert_to_hashie(evernote_client.authenticateToBusiness(access_token.token))
      end

      def user_profile
        @user_profile ||= business_users.find{ |profile| profile.id == raw_info.id }
      end

      def business_users
        return []

        # TODO: Add these business-related endpoints to the Ruby SDK
        
        # return [] unless business_token
        # @business_users ||= convert_to_hashie(evernote_client.listBusinessUsers(business_token.authenticationToken))
      end

      def evernote_client
        require 'evernote_oauth'
        @evernote_client ||= ::EvernoteOAuth::Client.new(token: access_token.token).user_store
      end

      def convert_to_hashie(object)
        Hashie::Mash.new(MultiJson.load(MultiJson.dump(object)))
      end

      def prune!(hash)
        hash.delete_if do |_, v|
          prune!(v) if v.is_a?(Hash)
          v.nil? || (v.respond_to?(:empty?) && v.empty?)
        end
      end
    end
  end
end
