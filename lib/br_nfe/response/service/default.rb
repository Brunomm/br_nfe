module BrNfe
	module Response
		module Service
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
				# É um Array contendo objetos da classe BrNfe::Response::Service::NotaFiscal
				#
				# <b>Tipo de retorno: </b> _Array_
				#
				attr_accessor :notas_fiscais

				# Código da situação do lote RPS
				# Utilizado para saber se o Lote RPS já foi processado
				# e se foi processado com sucesso ou teve algum erro
				#
				# <b>Tipo de retorno: </b> _Integer_ ou _String_
				#
				attr_accessor :situation
				
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
			end
		end
	end
end