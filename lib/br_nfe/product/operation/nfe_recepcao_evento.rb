module BrNfe
	module Product
		module Operation
			class NfeRecepcaoEvento < Base

				# NÚMERO DO LOTE
				# Identificador de controle do Lote de envio do Evento.
				# Número sequencial autoincremental único para identificação
				# do Lote. A responsabilidade de gerar e controlar é exclusiva
				# do autor do evento. O Web Service não faz qualquer uso
				# deste identificador.
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _20161230135547_
				# <b>Length:   </b> _max: 15_
				# <b>tag:      </b> idLote
				#
				attr_accessor :numero_lote
				alias_attribute :idLote, :numero_lote

				# EVENTO DE CANCELAMENTO
				# Só pode haver 1 evento do tipo cancelamento por Lote.
				#
				has_one :cancelamento, 'BrNfe.cancelamento_product_class'

				validate_has_one :cancelamento

				validates :numero_lote, presence: true
				validates :numero_lote, numericality: {only_integer: true}, allow_blank: true
				validates :numero_lote, length: {maximum: 15}, allow_blank: true

				# URL do webservice para enviar as informações.
				# Ex:
				# https://www.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx?wsdl
				def wsdl
					gateway.wsdl_recepcao_evento
				end

				# Método SOAP que será chamado para enviar o XML
				def method_wsdl
					gateway.operation_recepcao_evento
				end

				# Versão utilizada pelo webservice do  estado para determinada ação.
				def gateway_xml_version
					gateway.version_xml_recepcao_evento
				end

				# URL que será setada no atribto xmlns do XML;
				# Ex:
				# nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2"
				def url_xmlns
					gateway.url_xmlns_recepcao_evento
				end

				# Versão SSL utilizada pelo webservice
				def ssl_version
					gateway.ssl_version_recepcao_evento
				end

				# XML que será enviado no body da requisição SOAP contendo as informações
				# específicas de cada operação.
				def xml_builder
					render_xml 'root/NfeRecepcaoEvento'
				end
			end
		end
	end
end