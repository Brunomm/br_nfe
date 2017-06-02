module BrNfe
	module Product
		module Response
			class Event < BrNfe::ActiveModelBase

				# CÓDIGO DA UF QUE REGISTROU O EVENTO
				# Será setado 90 para o Ambiente Nacional.
				# 
				attr_accessor :codigo_orgao
				alias_attribute :cOrgao, :codigo_orgao

				# CÓDIGO DO STATUS DO EVENTO
				# 
				attr_accessor :status_code
				alias_attribute :cStat, :status_code

				# DESCRIÇÃO DO STATUS DO EVENTO
				# 
				attr_accessor :status_motive
				alias_attribute :xMotivo, :status_motive

				# CÓDIGO DO EVENTO
				# Código do Tipo do Evento.
				#   110111: Cancelamento
				#   110110: CCe - Carta de Correcao
				#   110140: EPEC
				# Eventos de manifestação do destinatário
				#   210200: Confirmação da Operação
				#   210210: Ciência da Emissão
				#   210220: Desconhecimento da Operação
				#   210240: Operação não Realizada
				#
				attr_accessor :code
				alias_attribute :tpEvento, :code

				# SEQUENCIAL DO EVENTO PARA O MESMO TIPO DE EVENTO.
				#
				attr_accessor :sequence
				alias_attribute :nSeqEvento, :sequence

				# CPF OU CNPJ DO DESTINATÁRIO DA NF-E
				# 
				attr_accessor :cpf_cnpj_destino
				alias_attribute :CNPJDest, :cpf_cnpj_destino
				alias_attribute :CPFDest, :cpf_cnpj_destino

				# DATA E HORA EM QUE O EVENTO FOI ENVIADO 
				#
				attr_accessor :sent_at
				def sent_at
					convert_to_time( @sent_at )
				end
				alias_attribute :dhEvento, :sent_at

				# DATA E HORA EM QUE O EVENTO FOI PROCESSADO PELA SEFAZ
				# 
				attr_accessor :registred_at
				def registred_at
					convert_to_time( @registred_at )
				end
				alias_attribute :dhRegEvento, :registred_at

				# NÚMERO DO PROTOCOLO DO ENVIO DO EVENTO
				attr_accessor :event_protocol
				alias_attribute :evento_nProt, :event_protocol

				# NÚMERO DO PROTOCOLO DE AUTORIZAÇÃO DO EVENTO
				attr_accessor :authorization_protocol
				alias_attribute :retEvento_nProt, :authorization_protocol

				# DESCRIÇÃO DO EVENTO
				attr_accessor :description
				alias_attribute :descEvento, :description

				# JUSTIFICATIVA DO EVENTO
				# Utilizado no evento de cancelamento de NF-e
				attr_accessor :justification
				alias_attribute :xJust, :justification

				# DESCRIÇÃO DA CARTA DE CORREÇÃO
				attr_accessor :correction_text
				alias_attribute :xCorrecao, :correction_text

				# XML DO EVENTO
				attr_accessor :xml

				def success?
					"#{status_code}".strip.in? BrNfe::Constants::NFE_STATUS_SUCCESS
				end

				def status
					success? ? :success : :error
				end

				def event_type
					case code
					when '110111'
						:cancellation
					when '110110'
						:correction
					when '110140'
						:epec
					else
						:recipient_manifestation
					end
				end
			end
		end
	end
end