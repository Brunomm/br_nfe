# Grupo Processo referenciado
# (NT 2012/003)
#
# <b>Type:     </b> _Group_
# <b>Length:   </b> _max: 100_
# <b>tag:      </b> procRef
#
module BrNfe
	module Product
		module Nfe
			class ProcessoReferencia < BrNfe::ActiveModelBase
				# IDENTIFICADOR DO PROCESSO OU ATO CONCESSÓRIO
				# 
				# <b>Type:     </b> _String_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _PRF226482_
				# <b>Length:   </b> _max: 60_
				# <b>tag:      </b> nProc
				#
				attr_accessor :numero_processo
				alias_attribute :nProc, :numero_processo

				# INDICADOR DA ORIGEM DO PROCESSO
				#  0 = SEFAZ;
				#  1 = Justiça Federal;
				#  2 = Justiça Estadual;
				#  3 = Secex/RFB;
				#  9 = Outros
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Default:  </b> _0_
				# <b>Example:  </b> _1_
				# <b>Length:   </b> _max: 60_
				# <b>tag:      </b> indProc
				#
				attr_accessor :indicador
				def indicador
					@indicador.to_i
				end
				alias_attribute :indProc, :indicador

				validates :indicador,       inclusion: {in: [0,1,2,3,9]}
				validates :numero_processo, presence: true
			end
		end
	end
end