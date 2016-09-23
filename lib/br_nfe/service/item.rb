module BrNfe
	module Service
		class Item < BrNfe::ActiveModelBase
			
			# ID do código CNAE
			# Algumas cidades necessitam que esse ID seja passado
			# e normalmente é encontrado junto a documentação da mesma.
			#
			# <b>Tipo: </b> _Integer_
			attr_accessor :cnae_id

			# Código CNAE (Classificação Nacional de Atividades Econômicas)
			# Pode ser encontrado em  http://www.cnae.ibge.gov.br/
			# Tamanho de 8 caracteres
			#
			# <b>Tipo: </b> _String_
			attr_accessor :cnae_code

			# Descrição do serviço
			# Será utilizada apenas para as cidades que permitem adicionar mais de 1 item de
			#  serviço na mesma nota
			#
			# <b>Tipo: </b> _Text_
			attr_accessor :description


			# CST
			# Código da situação tributária
			#  onde apenas alguns municipios utilizam
			#
			# <b>Tipo: </b> _Text_
			attr_accessor :cst

			# Alíquota
			# Percentual de aliquota dividido por 100
			# Ex: se a aliquita for 7.5% então o valor setado no campo é 0.075
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :iss_aliquota

			# Valor unitário do item
			# Refere-se ao valor separado de cada serviço prestado
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :valor_unitario

			# Quantidade prestada de serviços do item
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :quantidade

			# Valor total cobrado do item
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :valor_total

			
			def default_values
				{
					quantidade: 1.0,
				}
			end


			def valor_total
				@valor_total || (quantidade.to_f * valor_unitario.to_f)
			end
		end
	end
end