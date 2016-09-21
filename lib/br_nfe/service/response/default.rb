module BrNfe
	module Service
		module Response
			class Default  < BrNfe::ActiveModelBase
				
				# Array contendo as mensagens de erros
				# No array pode conter Hash (com :codigo, :mensagem e :correcao)
				# mas também pode conter mensagens de texto puro
				#
				# <b>Tipo de retorno: </b> _Array_
				#
				attr_accessor :error_messages
				
				# Array contendo as notas fiscais encontradas no xml de retorno.
				# Utillizado em algumas requisições onde pode ser que retorne algum XML de NFe
				# É um Array contendo objetos da classe BrNfe::Service::Response::NotaFiscal
				#
				# <b>Tipo de retorno: </b> _Array_
				#
				attr_accessor :notas_fiscais

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
				
				# XML original da resposta
				# Contém todo o XML Envelope da resposta SOAP
				#
				# <b>Tipo de retorno: </b> _String_ XML
				#
				attr_accessor :original_xml

				# Data e hora do cancelamento da NF-e
				# utilizado apenas para o Cancelamento da NF
				#
				# <b>Tipo de retorno: </b> _DateTime_
				#
				attr_accessor :cancelation_date_time

				# Status possíveis
				# [:success, :falied, :soap_error, :http_error, :unknown_error]
				#
				# <b>Tipo de retorno: </b> _Hash_
				#
				attr_accessor :status

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

				# Método para saber se a conexão com a prefeitura foi mal-sucedida.
				# Caso ocorra algum erro na requisição irá retornar true.
				#
				# <b>Tipo de retorno: </b> _Boolean_
				#
				def unsuccessful_request?
					status.in?([:soap_error, :http_error, :unknown_error])
				end

				# Método para saber se a conexão com a prefeitura foi bem-sucedida.
				# Caso a requisição ocorra certo e não apresente nenhuma exception
				# irá retornar true.
				#
				# <b>Tipo de retorno: </b> _Boolean_
				#
				def successful_request?
					!unsuccessful_request?
				end

				def success?
					status == :success
				end

				def status
					@status ||= get_status
				end

				def get_status
					error_messages.blank? ? :success : :falied
				end

				# Retorna um array apenas com os códigos das mensagens de erro.
				# Sempre retornar o código no formato de String.
				#
				# <b>Tipo de retorno: </b> _Array_
				#
				def message_codes
					@message_codes ||= error_messages.select{|msg| msg.is_a?(Hash)}.map{|msg| msg[:code].try(:to_s) }
				end
			end
		end
	end
end