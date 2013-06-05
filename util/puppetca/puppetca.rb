module MCollective
  module Util
    class Puppetca

      attr_reader :puppetca

      def initialize
        config = Config.instance
        @puppetca = config.pluginconf.fetch('puppetca.puppetca', '/usr/bin/puppet cert')
      end

      # Clean the cert
      def clean(certname)
        waiting, signed = certificates
        unless waiting.include?(certname) || signed.include?(certname)
          raise 'Could not find any certificates to delete'
        end

        output = ''
        shell = Shell.new('%s clean %s --color=none' % [@puppetca, certname], :stdout => output).runcommand

        return output
      end

      # Sign a cert if one is waiting
      def sign(certname)
        waiting, signed = certificates

        raise('Already have a certificate for %s. Not attempting to sign again' % certname) if signed.include?(certname)

        if waiting.include?(certname)
          output = ''
          Shell.new('%s sign %s --color=none' % [@puppetca, certname], :stdout => output).runcommand
          return output
        else
          raise('Could not find certificate to sign: %s' % certname)
        end
      end

      # Return the status of a cert
      # Status can return one of three values
      # 0 - signed
      # 1 - awaiting signature
      # 2 - not found
      def status(certname)
        waiting, signed = certificates

        if signed.include?(certname)
          return 0
        elsif waiting.include?(certname)
          return 1
        else
          return 2
        end
      end

      # Returns the list of both signed certificates and waiting to
      # be signed certificates
      def certificates(output = '')
        requests = []
        signed = []

        Shell.new('%s list --all --color=none' % @puppetca, :stdout => output).runcommand

        output.each do |line|
          result = line.gsub("\"", '').split("\s")

          if result[0] == '+'
            signed << result[1]
          else
            requests << result[0]
          end
        end

        [requests, signed]
      end
    end
  end
end
