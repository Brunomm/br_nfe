#encoding UTF-8
module BrNfe
	module Service
		module Response
			module Build
				class ConsultaSituacaoLoteRps  < BrNfe::Service::Response::Build::Base
					##############################################################################################################
					#######################   CAMINHOS PARA ENCONTRAR OS VALORES NA RESPOSTA DA REQUISIÇÃO   #####################
						# o numero do lote
						attr_accessor :lot_number_path
						
						# a situação do lote rps
						attr_accessor :situation_path
						
						attr_accessor :situation_key_values
						def situation_key_values
							@situation_key_values.is_a?(Hash) ? @situation_key_values : {
								'1' =>  :unreceived, # Não Recebido
								'2' =>  :unprocessed,# Não Processado
								'3' =>  :error,      # Processado com Erro
								'4' =>  :success,    # Processado com Sucesso
							}
						end

						def default_values
							super.merge({
								message_errors_path: [:consultar_situacao_lote_rps_resposta, :lista_mensagem_retorno, :mensagem_retorno],
								lot_number_path:     [:consultar_situacao_lote_rps_resposta, :numero_lote],
								situation_path:      [:consultar_situacao_lote_rps_resposta, :situacao],
							})
						end
					#######################   FIM DA DEFINIÇÃO DOS CAMINHOS   ############################
					######################################################################################
					def response
						@response ||= BrNfe::Service::Response::ConsultaSituacaoLoteRps.new({
							error_messages:   get_message_for_path(message_errors_path),
							numero_lote:      get_lot_number,
							situation:        get_situation,
							original_xml:     savon_response.xml.force_encoding('UTF-8'),
						})
					end

					# Método utilizado para pegar a situação do RPS
					#
					# <b>Tipo de retorno: </b> _Symbol_
					#
					def get_situation
						situation_value = find_value_for_keys(savon_body, path_with_root(situation_path))
						situation_value = situation_key_values[situation_value.to_s.strip] if situation_value.present?
						situation_value
					end
				end
			end
		end
	end
end