module BrNfe
	module Servico
		class Base < BrNfe::Base

			def initialize(attributes = {})
				self.lote_rps = [] # Para poder utilizar o << para adicionar rps
				super
			end
			
			attr_accessor :lote_rps
			attr_accessor :numero_lote_rps
			attr_accessor :operacao

			def lote_rps
				@lote_rps = [@lote_rps].flatten # Para retornar sempre um vetor
			end
			
		end
	end
end