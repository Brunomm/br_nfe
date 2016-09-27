module BrNfe
	module Product
		class NfeStatusServico < BrNfe::Product::Base
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

			# XML que será enviado no body da requisição SOAP contendo as informações
			# específicas de cada operação.
			def xml_builder
				render_xml 'nfe_status_servico'
			end
		end
	end
end