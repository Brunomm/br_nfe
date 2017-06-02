module BrNfe
	module Product
		module Response
			class Base < BrNfe::ActiveModelBase

				# XML ORIGINAL RECEBIDO DA SEFAZ
				attr_accessor :soap_xml

				# AMBIENTE DO PROCESSAMENTO
				attr_accessor :environment
				alias_attribute :tpAmb, :environment
				def environment
					if @environment.to_i == 1
						:production
					else
						:test
					end
				end

				# Versão do aplicativo da SEFAZ
				attr_accessor :app_version
				alias_attribute :verAplic, :app_version

				# DATA E HORA DO PROCESSAMENTO DA REQUISIÇÃO
				# 
				attr_accessor :processed_at
				def processed_at
					convert_to_time(@processed_at)
				end
				alias_attribute :dhRecbto, :processed_at

				# PROTOCOLO / NÚMERO DO RECIBO
				#  Número do Recibo gerado pelo Portal da
				#  Secretaria de Fazenda Estadual
				#
				attr_accessor :protocol
				alias_attribute :nRec, :protocol
				
				# STATUS PARA SABER SE A REQUISIÇÃO PARA A SEFAZ FOI BEM SUCEDIDA
				#   Pode ocorrer erros como HTTPError quando o servidor está offline.
				#   Nesses casos a requsição sempre será tratada e adicionado as mensagens
				#   de erro no attr :request_message_error
				#
				# Status possíveis:
				#  + :success    = Requisição efetuada com sucesso e contém um XML para verificação dos dados
				#  + :soap_error = Quando houve um erro do tipo Savon::SOAPFault
				#  + :http_error = Quando houve um erro do tipo Savon::HTTPError
				#  + :unknown_error = Quando houve outro erro desconhecido
				#
				attr_accessor :request_status
				attr_accessor :request_message_error

				# STATUS DO PROCESSAMENTO DA OPERAÇÃO
				#  Esse status é utilizado para saber se a operação 
				#  foi processada com sucesso ou não.
				#  Será preenchida apenas se o attr :request_status for :success
				#
				#  Retornos possíveis:
				#    + :success - Quando a operação requisitada foi processada e obteve 
				#                 sucesso no processamento. Será necessário verificar o 
				#                 status individual de cada operação.
				# 
				#    + :processing - Quando ainda está em processamento e será necessário 
				#                    fazer uma nova requisição.
				# 
				#    + :offline - Quando o serviço estiver offline
				# 
				#    + :denied - Quando o acesso foi denegado
				# 
				#    + :error - Quando houve algum erro no processamento
				#
				attr_accessor :processing_status_code
				alias_attribute :cStat, :processing_status_code
				attr_accessor :processing_status_motive
				alias_attribute :xMotivo, :processing_status_motive
				
				def processing_status
					if "#{processing_status_code}   ".strip.in?( BrNfe::Constants::NFE_STATUS_SUCCESS )
						:success
					elsif "#{processing_status_code}".strip.in?( BrNfe::Constants::NFE_STATUS_PROCESSING )
						:processing
					elsif "#{processing_status_code}".strip.in?( BrNfe::Constants::NFE_STATUS_OFFLINE )
						:offline
					elsif "#{processing_status_code}".strip.in?( BrNfe::Constants::NFE_STATUS_DENIED )
						:denied
					else
						:error
					end
				end

				def processed_successfully?
					processing_status == :success
				end
			end
		end
	end
end