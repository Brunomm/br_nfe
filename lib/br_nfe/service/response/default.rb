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

				# XML original da resposta
				# Contém todo o XML Envelope da resposta SOAP
				#
				# <b>Tipo de retorno: </b> _String_ XML
				#
				attr_accessor :original_xml

				# Status possíveis
				# [:success, :falied, :soap_error, :http_error, :unknown_error]
				#
				# <b>Tipo de retorno: </b> _Symbol_
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