#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/parser/scanners/verisign'


module Whois
  class Record
    class Parser

      #
      # = whois.nic.cc parser
      #
      # Parser for the whois.nic.cc server.
      #
      class WhoisNicCc < Base
        include Scanners::Ast

        property_supported :disclaimer do
          node("Disclaimer")
        end


        property_supported :domain do
          node("Domain Name") { |raw| raw.downcase }
        end

        property_not_supported :domain_id


        property_supported :referral_whois do
          node("Whois Server")
        end

        property_supported :referral_url do
          node("Referral URL")
        end


        property_supported :status do
          node("Status")
        end

        property_supported :available? do
          node("Registrar").nil?
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Creation Date") { |raw| Time.parse(raw) }
        end

        property_supported :updated_on do
          node("Updated Date") { |raw| Time.parse(raw) }
        end

        property_supported :expires_on do
          node("Expiration Date") { |raw| Time.parse(raw) }
        end


        property_supported :registrar do
          # Return nil because when the response contains more than one registrar section
          # the response can be messy. See, for instance, the Verisign response for google.com.
          nil
        end


        property_supported :nameservers do
          Array.wrap(node("Name Server")).reject { |value| value =~ /no nameserver/i }.map do |name|
            Nameserver.new(name.downcase)
          end
        end


        # Initializes a new {Scanners::Verisign} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::Verisign.new(content_for_scanner).parse
        end

      end

    end
  end
end
