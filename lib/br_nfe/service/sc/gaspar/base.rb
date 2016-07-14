module BrNfe
	module Service
		module SC
			module Gaspar
				class Base < BrNfe::Service::Base

					def namespaces
						{"xmlns" => "http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"}
					end

					def wsdl
						"https://nfse.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl"
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
								xml:    "#{content_xml}"
							) 
						)
					rescue Savon::SOAPFault => error
						return @response = BrNfe::Service::Response::Default.new(success: false, error_messages: [error.message])
					end

					def cabecalho
						"<nfseCabecMsg><cabecalho versao=\"1.0\"><versaoDados>1.0</versaoDados></cabecalho></nfseCabecMsg>"
					end

					def set_response(resp)
					end

					def content_xml
						xml =  '<?xml version="1.0" encoding="ISO-8859-1"?>'
						xml += '<soapenv:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://server.nfse.thema.inf.br" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ins0="http://www.w3.org/2000/09/xmldsig#">'
  						xml += '<soapenv:Body>'
  						# xml += '<![CDATA['
						xml += xml_builder.html_safe
  						# xml += ']]>'
  						xml += '</soapenv:Body>'
  						xml += '</soapenv:Envelope>'
  						xml.html_safe
					end					
				end
			end
		end
	end
end