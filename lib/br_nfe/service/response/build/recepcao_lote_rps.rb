#encoding UTF-8
module BrNfe
	module Service
		module Response
			module Build
				class RecepcaoLoteRps  < BrNfe::Service::Response::Build::Base
					##############################################################################################################
					#######################   CAMINHOS PARA ENCONTRAR OS VALORES NA RESPOSTA DA REQUISIÇÃO   #####################
						# o numero do lote
						attr_accessor :lot_number_path

						# o protocolo
						attr_accessor :protocol_path

						# a data de recebimento do xml
						attr_accessor :received_date_path

						def default_values
							super.merge({
								lot_number_path:     [:enviar_lote_rps_resposta, :numero_lote],
								protocol_path:       [:enviar_lote_rps_resposta, :protocolo],
								received_date_path:  [:enviar_lote_rps_resposta, :data_recebimento],
								message_errors_path: [:enviar_lote_rps_resposta, :lista_mensagem_retorno, :mensagem_retorno]
							})
						end

					#######################   FIM DA DEFINIÇÃO DOS CAMINHOS   ############################
					######################################################################################
					def response
						@response ||= BrNfe::Service::Response::RecepcaoLoteRps.new({
							original_xml:     savon_response.xml.force_encoding('UTF-8'),
							error_messages:   get_message_for_path(message_errors_path),
							protocolo:        get_protocol,
							data_recebimento: get_received_date,
							numero_lote:      get_lot_number,
						})
					end

					# Método utilizado para pegar protocolo de solicitação de
					# processamento do RPS.
					# Esse protocolo é utilizado posteriormente para consultar se
					# o RPS já foi processado
					#
					# <b>Tipo de retorno: </b> _String_
					#
					def get_protocol
						find_value_for_keys(savon_body, path_with_root(protocol_path))
					end

					# Método utilizado para pegar a data de recebimento do lote
					#
					# <b>Tipo de retorno: </b> _String_
					#
					def get_received_date
						find_value_for_keys(savon_body, path_with_root(received_date_path))
					end

					# Método utilizado para pegar o número do lote RPS
					#
					# <b>Tipo de retorno: </b> _String_
					#
					def get_lot_number
						find_value_for_keys(savon_body, path_with_root(lot_number_path))
					end
				end
			end
		end
	end
end