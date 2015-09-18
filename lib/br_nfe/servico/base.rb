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

		private
		
			def validar_lote_rps
				if lote_rps.empty?
					errors.add(:base, "Deve conter ao menos 1 RPS")
				else
					lote_rps.each_with_index do |rps, i|
						rps.validar_recepcao_rps = true
						if rps.invalid?
							rps.errors.full_messages.map{|msg| errors.add(:base, "RPS #{i+1}: #{msg}") } 
						end
					end
				end
			end
			
		end
	end
end