#!/bin/env rspec

require 'spec_helper'
require File.join(File.dirname(__FILE__), '../../../', 'util', 'puppetca', 'puppetca.rb')

module MCollective
  module Util
    describe Puppetca do
      let(:config) { mock }
      let(:shell) { mock }

      before do
        Config.stubs(:instance).returns(config)
        config.stubs(:pluginconf).returns({})
        @puppetca = Puppetca.new
      end

      describe '#initialize' do
        it 'should set puppetca command' do
          config.stubs(:pluginconf).returns({'puppetca.puppetca' => 'bin/puppetca'})

          result = Puppetca.new
          result.puppetca.should == 'bin/puppetca'
        end
      end

      describe '#clean' do
        it 'should fail if no certs exist' do
          @puppetca.stubs(:certificates).returns([[],[]])

          expect{
            @puppetca.clean('rspec')
          }.to raise_error
        end

        it 'should clean waiting and signed certs' do
          shell.expects(:runcommand)
          @puppetca.stubs(:certificates).returns([[], ['rspec']])
          Shell.expects(:new).with('/usr/bin/puppet cert clean rspec --color=none', :stdout => '').returns(shell)
          @puppetca.clean('rspec')
        end
      end

      describe '#sign' do
        it 'should fail if the cert has already been signed' do
          @puppetca.stubs(:certificates).returns([[],['rspec']])

          expect{
            @puppetca.sign('rspec')
          }.to raise_error
        end

        it 'should fail if there are no certs to sign' do
          @puppetca.stubs(:certificates).returns([[],[]])

          expect{
            @puppetca.sign('rspec')
          }.to raise_error
        end

        it 'should sign a cert' do
          @puppetca.stubs(:certificates).returns([['rspec'], []])
          Shell.stubs(:new).with('/usr/bin/puppet cert sign rspec --color=none', :stdout => '').returns(shell)
          shell.expects(:runcommand)
          @puppetca.sign('rspec')
        end
      end

      describe '#status' do
        it 'should return 0 if the cert has been signed' do
          @puppetca.stubs(:certificates).returns([[],['rspec']])
          @puppetca.status('rspec').should == 0
        end

        it 'should return 1 if there is a cert waiting' do
          @puppetca.stubs(:certificates).returns([['rspec'],[]])
          @puppetca.status('rspec').should == 1
        end

        it 'should return 2 if the cert is not present' do
          @puppetca.stubs(:certificates).returns([[],[]])
          @puppetca.status('rspec').should == 2
        end
      end

      describe '#certificates' do
        it 'should return lists of signed and waiting requests' do
          output = "+ rspec_signed\nrspec_waiting\n"

          Shell.stubs(:new).with('/usr/bin/puppet cert list --all --color=none', :stdout => output).returns(shell)
          shell.expects(:runcommand)

          waiting, signed = @puppetca.certificates(output)
          waiting.should == ['rspec_waiting']
          signed.should == ['rspec_signed']
        end
      end
    end
  end
end
