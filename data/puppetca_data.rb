module MCollective
  module Data
    class Puppetca_data<Base

      activate_when do
        require 'mcollective/util/puppetca/puppetca'
        true
      end

      # Data query returns 1 of three possible values.
      # 'signed' - The cert has been signed
      # 'waiting' - Awaiting signature
      # 'missing' - No cert matching certname found
      query do |certname|
        status = Util::Puppetca.new.status(certname)

        case status
        when 0
          result[:status] = 'signed'
        when 1
          result[:status] = 'waiting'
        else
          result[:status] = 'missing'
        end
      end
    end
  end
end
