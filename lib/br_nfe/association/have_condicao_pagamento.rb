module BrNfe
	module Association
		module HaveCondicaoPagamento
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

		protected

			def new_condicao_pagamento(params={})
				@condicao_pagamento = BrNfe.condicao_pagamento_class.new(params)
			end
		end
	end
end