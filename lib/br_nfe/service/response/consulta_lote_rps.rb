module BrNfe
	module Service
		module Response
			class ConsultaLoteRps  < Default
				# Número do protocolo de recebimento do XML
				# Setado normalmente quando é enviado um lote RPS
				# para processamento.
				# O valor desse atributo é utilizado para posteriormente
				# fazer a consulta para saber se o RPS já foi processado
				#
				# <b>Tipo de retorno: </b> _Integer_ ou _String_
				#
				attr_accessor :protocolo
				
			end
		end
	end
end