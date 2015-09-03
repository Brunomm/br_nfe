module BrNfe
	class CondicaoPagamento  < BrNfe::ActiveModelBase

		def initialize(attributes = {})
			@parcelas = [] # Para poder utilizar o << para adicionar parcelas
			super
		end
		
		# A_VISTA ou A_PRAZO
		attr_accessor :condicao

		# 
		# EX Valor para parcelas = [{valor: 50.33, vencimento: '15/11/2016'}, {valor: '27.00', vencimento: '2016-11-15'}]
		#
		attr_accessor :parcelas

		def parcelas
			@parcelas = [@parcelas].flatten
		end
	end
end