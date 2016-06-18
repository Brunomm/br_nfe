module BrNfe
	module Servico
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
			# Ex: 7.5% = 0.075
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :iss_tax_rate

			# Valor unitário do item
			# Refere-se ao valor separado de cada serviço prestado
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :unit_value

			# Quantidade prestada de serviços do item
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :quantity

			# Valor total cobrado do item
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :total_value



			def default_values
				{
					quantity: 1.0,
				}
			end


			def total_value
				@total_value || (quantity.to_f * unit_value.to_f)
			end
		end
	end
end