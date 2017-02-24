module BrNfe
	module Product
		module Evento
			class Cancelamento < Base

				# NÚMERO DO PROTOCOLO DA NF-e
				#  Informar o número do Protocolo de Autorização da NF-e a
				#   ser Cancelada. (vide item 5.8).
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _4223456789012345_
				# <b>Length:   </b> _15_
				# <b>tag:      </b> nProt
				#
				attr_accessor :protocolo_nfe
				alias_attribute :nProt, :protocolo_nfe

				# JUSTIFICATIVA DO CANCELAMENTO
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _DESCRIÇÃO PARA UMA JUSTIFICATIVA QUALQUER_
				# <b>Length:   </b> _min: 15, max: 255_
				# <b>tag:      </b> xJust
				#
				attr_accessor :justificativa
				alias_attribute :xJust, :justificativa


				validates :protocolo_nfe, presence: true
				validates :protocolo_nfe, length: {is: 15}, allow_blank: true
				validates :justificativa, length: {in: 15..255 }

			private

				def default_values
					super.merge({
						codigo_evento: '110111'
					})
				end

			end
		end
	end
end