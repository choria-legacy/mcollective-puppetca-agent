module MCollective
  module Agent
    class Puppetca < RPC::Agent

      activate_when do
        require 'mcollective/util/puppetca/puppetca'
        true
      end

      def startup_hook
        @puppetca = Util::Puppetca.new
      end

      ['clean', 'revoke'].each do |command|
        action command do
          reply[:out] = @puppetca.clean(request[:certname])
        end
      end

      action 'sign' do
        reply[:out] = @puppetca.sign(request[:certname])
      end

      action 'list' do
        reply[:requests], reply[:signed] = @puppetca.certificates
      end

      action 'status' do
        status =  @puppetca.status(request[:certname])
        case status
        when 0
          reply[:msg] = 'signed'
        when 1
          reply[:msg] = 'awaiting signature'
        when 2
          reply[:msg] = 'not found'
        else
          reply[:msg] = 'could not determine status of certificate: %s' % request[:certname]
        end
      end
    end
  end
end
