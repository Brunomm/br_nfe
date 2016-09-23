module BrNfe
	module Service
		module Response
			class RecepcaoLoteRps  < Default				
				# Número do protocolo de recebimento do XML
				# Setado normalmente quando é enviado um lote RPS
				# para processamento.
				# O valor desse atributo é utilizado para posteriormente
				# fazer a consulta para saber se o RPS já foi processado
				#
				# <b>Tipo de retorno: </b> _Integer_ ou _String_
				#
				attr_accessor :protocolo
				
				# Data/Data hora do recebimento do XML pelo orgão emissor
				# Nesse atrubuto pe setado a data/hora na qual o orgão emissor
				# recebeu o XML que foi enviado.
				# também é nesse atributo que é setado a data/hora do processamento
				# da NF-e (nos casos de consulta)
				#
				# <b>Tipo de retorno: </b> _DateTime_
				#
				attr_accessor :data_recebimento
				
				# Número do lote RPS
				# Nesse atributo é setado o número do lote RPS
				# quando o mesmo for retornado na resposta
				#
				# <b>Tipo de retorno: </b> _Integer_
				#
				attr_accessor :numero_lote
			end
		end
	end
end