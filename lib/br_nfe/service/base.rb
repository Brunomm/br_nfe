module BrNfe
	module Service
		class Base < BrNfe::Base
			include BrNfe::Helper::ValuesTs::ServiceV1
			
			# Declaro que o método `render_xml` irá verificar os arquivos também presentes
			# no diretório especificado
			#
			# <b>Tipo de retorno: </b> _Array_
			#
			def xml_current_dir_path
				["#{BrNfe.root}/lib/br_nfe/service/xml/#{xml_version}"]+super
			end

			def response_path_module
				raise "Não implementado."
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

			def id_attribute?
				true
			end

			def request
				set_response( client_wsdl.call(method_wsdl, xml: soap_xml) )
			rescue Savon::SOAPFault => error
				return @response = BrNfe::Response::Service::Default.new(status: :soap_error, error_messages: [error.message])
			rescue Savon::HTTPError => error
				return @response = BrNfe::Response::Service::Default.new(status: :http_error, error_messages: [error.message])
			rescue Exception => error
				return @response = BrNfe::Response::Service::Default.new(status: :unknown_error, error_messages: [error.message])
			end

			def set_response(resp)
				@original_response = resp
				@response = BrNfe::Response::Service::BuildResponse.new(
					savon_response: resp, # Rsposta da requisição SOAP
					keys_root_path: response_root_path, # Caminho inicial da resposta / Chave pai principal
					nfe_xml_path:   nfse_xml_path, # Caminho para encontrar a NF dentro do XML
					module_methods: response_path_module, # Module que contém os caminhos para encontrar cada informação pertinente para cada requisição
					body_xml_path:  body_xml_path,
				).response
			end

		end
	end
end