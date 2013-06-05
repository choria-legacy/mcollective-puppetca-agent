#!/bin/env rspec

require 'spec_helper'
require File.join(File.dirname(__FILE__), '../../', 'data', 'puppetca_data.rb')
require File.join(File.dirname(__FILE__), '../../', 'util', 'puppetca', 'puppetca.rb')

module MCollective
  module Data
    describe Puppetca_data do
      let(:puppetca) { mock }

      before do
        Util::Puppetca.stubs(:new).returns(puppetca)
        data_file = File.join(File.dirname(__FILE__), '../../', 'data', 'puppetca_data.rb')
        @data = MCollective::Test::DataTest.new('puppetca_data', :data_file => data_file).plugin
      end

      it 'should return the correct status if a cert is signed' do
        puppetca.stubs(:status).with('rspec').returns(0)
        @data.query_data('rspec').should == 'signed'
      end

      it 'should return the correct status for a cert waiting to be signed' do
        puppetca.stubs(:status).with('rspec').returns(1)
        @data.query_data('rspec').should == 'waiting'
      end

      it 'should return the correct status for a missing cert' do
        puppetca.stubs(:status).with('rspec').returns(nil)
        @data.query_data('rspec').should == 'missing'
      end
    end
  end
end
