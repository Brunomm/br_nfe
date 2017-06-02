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

				def operation_name
					:recepcao_evento
				end

				# XML que será enviado no body da requisição SOAP contendo as informações
				# específicas de cada operação.
				def xml_builder
					@xml_builder ||= render_xml 'root/NfeRecepcaoEvento'
				end

				def response_class_builder
					BrNfe::Product::Response::Build::NfeRecepcaoEvento
				end
			end
		end
	end
end