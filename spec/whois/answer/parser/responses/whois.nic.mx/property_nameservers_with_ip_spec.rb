# encoding: utf-8

# This file is autogenerated. Do not edit it manually.
# If you want change the content of this file, edit
#
#   /spec/whois/answer/parser/responses/whois.nic.mx/property_nameservers_with_ip_spec.rb
#
# and regenerate the tests with the following rake task
#
#   $ rake genspec:parsers
#

require 'spec_helper'
require 'whois/answer/parser/whois.nic.mx'

describe Whois::Answer::Parser::WhoisNicMx, "property_nameservers_with_ip.expected" do

  before(:each) do
    file = fixture("responses", "whois.nic.mx/property_nameservers_with_ip.txt")
    part = Whois::Answer::Part.new(:body => File.read(file))
    @parser = klass.new(part)
  end

  context "#nameservers" do
    it do
      @parser.nameservers.should be_a(Array)
    end
    it do
      @parser.nameservers.should have(2).items
    end
    it do
      @parser.nameservers[0].should be_a(_nameserver)
    end
    it do
      @parser.nameservers[0].should == _nameserver.new(:name => "dns1.mpsnet.net.mx", :ipv4 => "200.4.48.15")
    end
    it do
      @parser.nameservers[1].should be_a(_nameserver)
    end
    it do
      @parser.nameservers[1].should == _nameserver.new(:name => "dns2.mpsnet.net.mx", :ipv4 => "200.4.48.16")
    end
  end
end