module BrNfe
	module Product
		module Nfe
			module Transporte
				class Veiculo < BrNfe::ActiveModelBase
					# Placa do veículo (NT2011/004)
					# Conforme a documentação oficial:
					#    Informar em um dos seguintes formatos: XXX9999, XXX999, XX9999 ou XXXX999.
					#    Informar a placa em informações complementares quando a placa do veículo 
					#    tiver lei de formação diversa. (NT 2011/005)
					# Porém a gem permite informar a placa com o - (hífen), Exemplo:
					#      XXX-0000, XXX9999, XXX999, XX9999 ou XXXX999.
					# Esse attr só irá considerar as letras e números, onde as letras sempre
					# vai converter para maiúsculo
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _Yes_
					# <b>tag:      </b> placa
					#
					attr_accessor :placa
					def placa
						"#{@placa}".gsub(/[^\d\w]/, '').upcase
					end

					# Sigla da UF
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _Yes_
					# <b>Length:   </b> _2_
					# <b>tag:      </b> UF
					#
					attr_accessor :uf

					# Registro Nacional de Transportador de Carga (ANTT)
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Length:   </b> _max: 20_
					# <b>tag:      </b> RNTC
					#
					attr_accessor :rntc


					validates :placa, :uf, presence: true
					validates :uf,  inclusion: { in: BrNfe::Constants::SIGLAS_UF} , allow_blank: true
					validates :rntc,  length: { maximum: 20 }
					validates :placa, length: { is: 7 }

				end
			end
		end
	end
end