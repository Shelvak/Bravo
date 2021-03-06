require 'active_support/time'

module Bravo
  class AuthData

    class << self
      def fetch
        unless File.exists?(Bravo.pkey)
          raise "Archivo de llave privada no encontrado en #{Bravo.pkey}"
        end

        unless File.exists?(Bravo.cert)
          raise "Archivo certificado no encontrado en #{Bravo.cert}"
        end

        todays_datafile = "/tmp/bravo_#{Bravo.cuit}_#{Time.new.in_time_zone('Buenos Aires').strftime('%d_%m_%Y')}.yml"
        opts = "-u #{Bravo.auth_url}"
        opts += " -k #{Bravo.pkey}"
        opts += " -c #{Bravo.cert}"
        opts += " -i #{Bravo.cuit}"

        unless File.exists?(todays_datafile)
          %x(#{File.dirname(__FILE__)}/../../wsaa-client.sh #{opts})
        end

        @data = YAML.load_file(todays_datafile).each do |k, v|
          Bravo.const_set(k.to_s.upcase, v) unless Bravo.const_defined?(k.to_s.upcase)
        end
      end
    end
  end
end
