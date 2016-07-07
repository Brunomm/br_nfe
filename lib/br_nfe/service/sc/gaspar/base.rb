module BrNfe
	module Service
		module SC
			module Gaspar
				class Base < BrNfe::Service::Base

					def namespaces
						{"xmlns:ns1" => "http://server.nfse.thema.inf.br"}
					end

					def namespace_identifier
						:ns1
					end

					def wsdl_encoding
						'ISO-8859-1'
					end

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					def request
						set_response( 
							client_wsdl.call("#{method_wsdl}".to_sym, 
								message:    "#{cabecalho}#{content_xml}"
							) 
						)
					rescue Savon::SOAPFault => error
						return @response = BrNfe::Service::Response::Default.new(success: false, error_messages: [error.message])
					end

					def cabecalho
						"<nfseCabecMsg><cabecalho versao=\"0.5\"><versaoDados>0.5</versaoDados></cabecalho></nfseCabecMsg>"
					end

					def set_response(resp)
					end

					def content_xml
						"<nfseDadosMsg>#{xml_builder.html_safe}</nfseDadosMsg>"
					end
					
				end
			end
		end
	end
end