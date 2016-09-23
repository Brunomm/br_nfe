module BrNfe
	module Service
		module Response
			class Cancelamento  < Default
				
				# Data e hora do cancelamento da NF-e
				# utilizado apenas para o Cancelamento da NF
				#
				# <b>Tipo de retorno: </b> _DateTime_
				#
				attr_accessor :data_hora_cancelamento
				
				# Codigo do Cancelamento
				#
				attr_accessor :codigo_cancelamento

				# Número da nota fiscal cancelada
				attr_accessor :numero_nfs
			end
		end
	end
end