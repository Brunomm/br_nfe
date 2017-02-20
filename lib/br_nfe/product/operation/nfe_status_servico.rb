module BrNfe
	module Product
		module Operation
			class NfeStatusServico < Base
				# URL que será setada no atribto xmlns do XML;
				# Ex:
				# nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2"
				def url_xmlns
					gateway.url_xmlns_status_servico
				end

				# URL do webservice para enviar as informações.
				# Ex:
				# https://www.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx?wsdl
				def wsdl
					gateway.wsdl_status_servico
				end

				# Método SOAP que será chamado para enviar o XML
				def method_wsdl
					gateway.operation_status_servico
				end

				# Versão utilizada pelo webservice do  estado para determinada ação.
				def gateway_xml_version
					gateway.version_xml_status_servico
				end

				# Versão SSL utilizada pelo webservice
				def ssl_version
					gateway.ssl_version_status_servico
				end

				# XML que será enviado no body da requisição SOAP contendo as informações
				# específicas de cada operação.
				def xml_builder
					@xml_builder ||= render_xml 'root/NfeStatusServico'
				end

				def response_class_builder
					BrNfe::Product::Response::Build::NfeStatusServico
				end
			end
		end
	end
end