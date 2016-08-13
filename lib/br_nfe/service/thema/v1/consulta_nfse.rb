module BrNfe
	module Service
		module Thema
			module V1
				class ConsultaNfse < BrNfe::Service::Thema::V1::Base
					include BrNfe::Service::Concerns::Rules::ConsultaNfse

					def wsdl
						get_wsdl_by_city[:consult]
					end

					def method_wsdl
						:consultar_nfse
					end
					
					def xml_builder
						render_xml 'servico_consultar_nfse_envio'
					end

					def response_path_module
						BrNfe::Service::Response::Paths::V1::ServicoConsultarNfseResposta
					end
					
					# Não é utilizado o response_root_path pois
					# esse órgão emissor trata o XML de forma diferente
					# e para instanciar a resposta adequadamente é utilizado o 
					# body_xml_path.
					# A resposta contém outro XML dentro do Body.
					#
					def response_root_path
						[]
					end

					# Caminho de hash através do body da resposta SOAP até encontrar
					# o XML correspondente na qual contém as informações necessárias 
					# para encontrar os valores para setar na resposta
					#
					def body_xml_path
						[:consultar_nfse_response, :return]
					end

					# Tag root da requisição
					#
					def soap_body_root_tag
						'consultarNfse'
					end
				end
			end
		end
	end
end