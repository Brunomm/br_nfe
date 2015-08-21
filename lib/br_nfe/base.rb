module BrNfe
	class Base < BrNfe::ActiveModelBase
		
		attr_accessor :certificado_path
		attr_accessor :certificado_password

		attr_accessor :ssl_cert_path
		attr_accessor :ssl_key_path
		attr_accessor :ssl_cert_password

		def emitente
			@emitente.is_a?(BrNfe::Emitente) ? @emitente : @emitente = BrNfe::Emitente.new()
		end

		def emitente=(value)
			if value.is_a?(BrNfe::Emitente) 
				@emitente = value
			elsif value.is_a?(Hash)
				emitente.assign_attributes(value)
			end
		end

		def wsdl
			raise "Não implementado."
		end

		def method_wsdl
			raise "Não implementado."
		end

		def xml_builder
			raise "Não implementado."
		end

		def namespaces
			{}
		end

	private

		def certificado
			@certificado ||= OpenSSL::PKCS12.new(File.read(certificado_path), certificado_password)
		end

		def client_wsdl
			@client_wsdl ||= Savon.client do |globals|
				globals.namespaces            namespaces
				globals.env_namespace         :soapenv
				globals.wsdl                  wsdl
				globals.namespace_identifier  :e
				globals.ssl_verify_mode       :none 
				globals.encoding              "UTF-8"

				# globals.log      true
				# globals.pretty_print_xml      true
				# globals.ssl_cert_file         ssl_cert_path
				# globals.ssl_cert_key_file     ssl_key_path
				# globals.ssl_cert_key_password ssl_cert_password
			end
		end

	end
end