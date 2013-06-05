#!/bin/env rspec

require 'spec_helper'
require File.join(File.dirname(__FILE__), '../../', 'agent', 'puppetca.rb')
require File.join(File.dirname(__FILE__), '../../', 'util', 'puppetca', 'puppetca.rb')

module MCollective
  module Agent
    describe Puppetca do

      let(:puppetca) { mock }

      before do
        Util::Puppetca.stubs(:new).returns(puppetca)
        agent_file = File.join(File.dirname(__FILE__), '../../', 'agent', 'puppetca.rb')
        @agent = MCollective::Test::LocalAgentTest.new('puppetca', :agent_file => agent_file).plugin
      end

      describe '#clean' do
        it 'should clean the certificate' do
          puppetca.expects(:clean).with('rspec').returns('cleaned')
          result = @agent.call(:clean, :certname => 'rspec')
          result.should be_successful
          result.should have_data_items(:out => 'cleaned')
        end
      end

      describe '#revoke' do
        it 'should revoke the certificate by calling clean' do
          puppetca.expects(:clean).with('rspec').returns('revoked')
          result = @agent.call(:revoke, :certname => 'rspec')
          result.should be_successful
          result.should have_data_items(:out => 'revoked')
        end
      end

      describe '#sign' do
        it 'should sign the certificate' do
          puppetca.expects(:sign).with('rspec').returns('signed')
          result = @agent.call(:sign, :certname => 'rspec')
          result.should be_successful
          result.should have_data_items(:out => 'signed')
        end
      end

      describe '#list' do
        it 'should list the requested and signed certificates' do
          puppetca.stubs(:certificates).returns([['waiting1', 'waiting2'],
                                                 ['signed1', 'signed2']])
          result = @agent.call(:list)
          result.should be_successful
          result.should have_data_items({:requests => ['waiting1', 'waiting2'],
                                        :signed => ['signed1', 'signed2']})
        end
      end

      describe '#status' do
        it 'should return the correct message for a signed cert' do
          puppetca.expects(:status).with('rspec').returns(0)
          result = @agent.call(:status, :certname => 'rspec')
          result.should be_successful
          result.should have_data_items(:msg => 'signed')
        end

        it 'should return the correct message for a cert awaiting signed' do
          puppetca.expects(:status).with('rspec').returns(1)
          result = @agent.call(:status, :certname => 'rspec')
          result.should be_successful
          result.should have_data_items(:msg => 'awaiting signature')
        end

        it 'should return the correct message for a cert that cannot be found' do
          puppetca.expects(:status).with('rspec').returns(2)
          result = @agent.call(:status, :certname => 'rspec')
          result.should be_successful
          result.should have_data_items(:msg => 'not found')
        end

        it 'should return the correct message if the cert status cannot be determined' do
          puppetca.expects(:status).with('rspec').returns(nil)
          result = @agent.call(:status, :certname => 'rspec')
          result.should be_successful
          result.should have_data_items(:msg => 'could not determine status of certificate: rspec')
        end
      end
    end
  end
end
