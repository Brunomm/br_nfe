module BrNfe
	module Servico
		class Rps < BrNfe::ActiveModelBase
			attr_accessor :numero
			attr_accessor :serie
			attr_accessor :tipo
			attr_accessor :data_emissao
			attr_accessor :status
			attr_accessor :competencia

			attr_accessor :numero_substituicao
			attr_accessor :serie_substituicao
			attr_accessor :tipo_substituicao
			
			#Para construção civil
			attr_accessor :codigo_obra
			attr_accessor :codigo_art

			attr_accessor :valor_servicos
			attr_accessor :valor_deducoes
			attr_accessor :valor_pis
			attr_accessor :valor_cofins
			attr_accessor :valor_inss
			attr_accessor :valor_ir
			attr_accessor :valor_csll
			attr_accessor :outras_retencoes
			attr_accessor :iss_retido
			attr_accessor :valor_iss
			attr_accessor :aliquota
			attr_accessor :base_calculo
			attr_accessor :desconto_incondicionado
			attr_accessor :desconto_condicionado
			
			attr_accessor :responsavel_retencao
			attr_accessor :item_lista_servico
			attr_accessor :codigo_tributacao_municipio
			attr_accessor :discriminacao
			attr_accessor :exigibilidade_iss
			attr_accessor :codigo_municipio
			attr_accessor :numero_processo
			attr_accessor :codigo_cnae
			attr_accessor :outras_informacoes

			########################### DADOS DO DESTINATÁRIO ###########################
			def destinatario
				yield(destinatario) if block_given?
				@destinatario.is_a?(BrNfe.destinatario_class) ? @destinatario : @destinatario = BrNfe.destinatario_class.new()
			end

			def destinatario=(value)
				if value.is_a?(BrNfe.destinatario_class) 
					@destinatario = value
				elsif value.is_a?(Hash)
					destinatario.assign_attributes(value)
				end
			end
			#############################################################################

			########################### DADOS DO INTERMEDIÁRIO ##########################
			def intermediario
				yield(intermediario || new_intermediario) if block_given?
				@intermediario.is_a?(BrNfe.intermediario_class) ? @intermediario : nil
			end

			def intermediario=(value)
				if value.is_a?(BrNfe.intermediario_class) || value.nil? 
					@intermediario = value
				elsif value.is_a?(Hash)
					intermediario ? intermediario.assign_attributes(value) : new_intermediario(value)
				end
			end
			#############################################################################

			####################### DADOS DO CONDICAO DE PAGAMENTO ######################
			def condicao_pagamento
				yield(condicao_pagamento || new_condicao_pagamento) if block_given?
				@condicao_pagamento.is_a?(BrNfe.condicao_pagamento_class) ? @condicao_pagamento : nil
			end

			def condicao_pagamento=(value)
				if value.is_a?(BrNfe.condicao_pagamento_class) || value.nil? 
					@condicao_pagamento = value
				elsif value.is_a?(Hash)
					condicao_pagamento ? condicao_pagamento.assign_attributes(value) : new_condicao_pagamento(value)
				end
			end
			#############################################################################

			def contem_substituicao?
				numero_substituicao.present? && serie_substituicao.present? && tipo_substituicao.present?
			end
		
		private

			def new_condicao_pagamento(params={})
				@condicao_pagamento = BrNfe.condicao_pagamento_class.new(params)
			end

			def new_intermediario(params={})
				@intermediario = BrNfe.intermediario_class.new(params)
			end

		end
	end
end