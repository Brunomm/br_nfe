module BrNfe
	module Product
		module Operation
			class NfeRetAutorizacao < Base
				# NÚMERO DO RECIBO/PROTOCOLO
				#  Número gerado pelo Portal da Secretaria de
				#  Fazenda Estadual
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _42201612301355_
				# <b>Length:   </b> _max: 15_
				# <b>tag:      </b> nRec
				#
				attr_accessor :numero_recibo
				alias_attribute :nRec, :numero_recibo


				validates :numero_recibo, presence: true
				validates :numero_recibo, numericality: {only_integer: true}, allow_blank: true
				validates :numero_recibo, length: {maximum: 15}, allow_blank: true

				# URL do webservice para enviar as informações.
				# Ex:
				# https://www.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx?wsdl
				def wsdl
					gateway.wsdl_retorno_autorizacao
				end

				# Método SOAP que será chamado para enviar o XML
				def method_wsdl
					gateway.operation_retorno_autorizacao
				end

				# Versão utilizada pelo webservice do  estado para determinada ação.
				def gateway_xml_version
					gateway.version_xml_retorno_autorizacao
				end

				# URL que será setada no atribto xmlns do XML;
				# Ex:
				# nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2"
				def url_xmlns
					gateway.url_xmlns_retorno_autorizacao
				end

				# Versão SSL utilizada pelo webservice
				def ssl_version
					gateway.ssl_version_retorno_autorizacao
				end

				# XML que será enviado no body da requisição SOAP contendo as informações
				# específicas de cada operação.
				def xml_builder
					render_xml 'root/NfeRetAutorizacao'
				end

				def response_class_builder
					BrNfe::Product::Response::Build::NfeRetAutorizacao
				end
			end
		end
	end
end