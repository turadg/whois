#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'
require 'whois/answer/parser/scanners/whoisit'


module Whois
  class Answer
    class Parser

      #
      # = whois.nic.it parser
      #
      # Parser for the whois.nic.it server.
      #
      class WhoisNicIt < Base
        include Features::Ast


        property_supported :disclaimer do
          node("Disclaimer")
        end


        property_supported :domain do
          node("Domain") { |raw| raw.downcase }
        end

        property_not_supported :domain_id


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          case node("Status").to_s.downcase
          when /^ok/, "active"
            :registered
          when /\bclient/
            :registered
          when "pendingdelete / redemptionperiod", "grace-period"
            :registered
          when "available"
            :available
          else
            Whois.bug!(ParserError, "Unknown status `#{node("Status")}'.")
          end
        end

        property_supported :available? do
          node("Status") == "AVAILABLE"
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Created") { |raw| Time.parse(raw) }
        end

        property_supported :updated_on do
          node("Last Update") { |raw| Time.parse(raw) }
        end

        property_supported :expires_on do
          node("Expire Date") { |raw| Time.parse(raw) }
        end


        property_supported :registrar do
          node("Registrar") do |raw|
            Answer::Registrar.new(
              :id           => raw["Name"],
              :name         => raw["Name"],
              :organization => raw["Organization"]
            )
          end
        end


        property_supported :registrant_contact do
          contact("Registrant", Whois::Answer::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contact do
          contact("Admin Contact", Whois::Answer::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contact do
          contact("Technical Contacts", Whois::Answer::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          (node("Nameservers") || []).map do |name|
            Answer::Nameserver.new(name)
          end
        end


        # Initializes a new {Scanner} instance
        # passing the {Whois::Answer::Parser::Base#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::Whoisit.new(content_for_scanner).parse
        end


        protected

          def contact(element, type)
            node(element) do |raw|
              address = (raw["Address"] || "").split("\n")
              company = address.size == 6 ? address.shift : nil
              Answer::Contact.new(
                :id           => raw["ContactID"],
                :type         => type,
                :name         => raw["Name"],
                :organization => raw["Organization"] || company,
                :address      => address[0],
                :city         => address[1],
                :zip          => address[2],
                :state        => address[3],
                :country_code => address[4],
                :created_on   => raw["Created"] ? Time.parse(raw["Created"]) : nil,
                :updated_on   => raw["Last Update"] ? Time.parse(raw["Last Update"]) : nil
              )
            end
          end

      end

    end
  end
end
