module BrNfe
	module Service
		class Base < BrNfe::Base
			include BrNfe::Service::Concerns::ValuesTs::ServiceV1

			# Alguns orgãos emissores necessitam que seja
			# passado junto ao XML o Usuário e Senha do acesso do sistema
			# da prefeitura.
			#
			attr_accessor :username
			attr_accessor :password
			
			# Declaro que o método `render_xml` irá verificar os arquivos também presentes
			# no diretório especificado
			#
			# <b>Tipo de retorno: </b> _Array_
			#
			def xml_current_dir_path
				["#{BrNfe.root}/lib/br_nfe/service/xml/#{xml_version}"]+super
			end

			def response_root_path
				[]
			end

			def nfse_xml_path
				#//Envelope/Body/ConsultarLoteRpsEnvioResponse/ConsultarLoteRpsResposta
				'//*/*/*/*'
			end

			def body_xml_path
				[]
			end

			def request
				@original_response = client_wsdl.call(method_wsdl, xml: soap_xml)
				set_response
			rescue Savon::SOAPFault => error
				return @response = response_class.new(status: :soap_error, error_messages: [error.message])
			rescue Savon::HTTPError => error
				return @response = response_class.new(status: :http_error, error_messages: [error.message])
			rescue Exception => error
				return @response = response_class.new(status: :unknown_error, error_messages: [error.message])
			end

		private

			def emitente_class
				BrNfe.emitente_service_class
			end

			def set_response
				raise "O método #set_response deve ser implementado para a classe #{self}"
			end

		end
	end
end