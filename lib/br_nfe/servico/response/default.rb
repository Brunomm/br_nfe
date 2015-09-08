module BrNfe
	module Servico
		module Response
			class Default  < BrNfe::ActiveModelBase
				attr_accessor :success
				attr_accessor :error_messages
				attr_accessor :notas_fiscais

				attr_accessor :protocolo
				attr_accessor :data_recebimento
				attr_accessor :numero_lote


				def initialize(attributes = {})
					self.notas_fiscais  = [] # Para poder utilizar o <<
					self.error_messages = [] # Para poder utilizar o <<
					super
				end
				
				def notas_fiscais
					@notas_fiscais = [@notas_fiscais].flatten # Para retornar sempre um vetor
				end

				def error_messages
					@error_messages = [@error_messages].flatten
				end

				def success?
					success
				end				
			end
		end
	end
end