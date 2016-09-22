module BrNfe
	module Service
		module Response
			class ConsultaSituacaoLoteRps  < Default
				
				# Número do lote RPS
				# Nesse atributo é setado o número do lote RPS
				# quando o mesmo for retornado na resposta
				#
				# <b>Tipo de retorno: </b> _Integer_
				#
				attr_accessor :numero_lote

				# Código da situação do lote RPS
				# Utilizado para saber se o Lote RPS já foi processado
				# e se foi processado com sucesso ou teve algum erro
				#
				# <b>Tipo de retorno: </b> _Integer_ ou _String_
				#
				attr_accessor :situation
				def situation
					@situation ||= get_situation_by_message_codes if error_messages.present?
					@situation
				end

				def situation_unreceived_code_errors
					@situation_unreceived_code_errors ||= []
					@situation_unreceived_code_errors+['E4']
				end
				def situation_unreceived_code_errors=(value)
					@situation_unreceived_code_errors = [value].flatten
				end

				def situation_unprocessed_code_errors
					@situation_unprocessed_code_errors ||= []
					@situation_unprocessed_code_errors+['E92']
				end
				def situation_unprocessed_code_errors=(value)
					@situation_unprocessed_code_errors = [value].flatten
				end

				def situation_success_code_errors
					@situation_success_code_errors ||= []
					@situation_success_code_errors#+[]
				end
				def situation_success_code_errors=(value)
					@situation_success_code_errors = [value].flatten
				end

				# Como alguns orgãos emissores (como a Betha) não tem a capacidade
				# de programar para colocar o codigo da situação em determinados momentos
				# e simplesmente colocam uma mensagem de erro na resposta sem setar a situação
				# foi necessário construir esse método para que a partir dos códigos das mensagens
				# seja possível distinguir qual a situação atual do lote enviado.
				# Por exemplo: Quando retornar o erro com código 'E92' quer dizer que a situação
				# do lote é :unprocessed. Equivalente ao código de situação 2
				#
				# <b>Tipo de retorno: </b> _Symbol_
				#
				def get_situation_by_message_codes
					if (situation_unprocessed_code_errors & message_codes).any?
						:unprocessed
					elsif (situation_unreceived_code_errors & message_codes).any?
						:unreceived
					elsif (situation_success_code_errors & message_codes).any?
						:success
					elsif message_codes.any?
						:error
					end				
				end
			end
		end
	end
end