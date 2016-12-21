module BrNfe
	module Product
		module Operation
			class NfeConsultaProtocolo < Base
				# CHAVE DE ACESSO DA NF-E.
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _42000082176983000186550000000000006313331836_
				# <b>Length:   </b> _44_
				# <b>tag:      </b> chNFe
				#
				attr_accessor :chave_nfe
				alias_attribute :chNFe, :chave_nfe


				validates :chave_nfe, presence: true
				validates :chave_nfe, length: {is: 44}, allow_blank: true

				# URL do webservice para enviar as informações.
				# Ex:
				# https://www.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx?wsdl
				def wsdl
					gateway.wsdl_consulta_protocolo
				end

				# Método SOAP que será chamado para enviar o XML
				def method_wsdl
					gateway.operation_consulta_protocolo
				end

				# Versão utilizada pelo webservice do  estado para determinada ação.
				def gateway_xml_version
					gateway.version_xml_consulta_protocolo
				end

				# URL que será setada no atribto xmlns do XML;
				# Ex:
				# nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2"
				def url_xmlns
					gateway.url_xmlns_consulta_protocolo
				end

				# Versão SSL utilizada pelo webservice
				def ssl_version
					gateway.ssl_version_consulta_protocolo
				end

				# XML que será enviado no body da requisição SOAP contendo as informações
				# específicas de cada operação.
				def xml_builder
					render_xml 'root/NfeConsultaProtocolo'
				end
			end
		end
	end
end