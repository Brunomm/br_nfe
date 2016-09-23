#encoding UTF-8
module BrNfe
	module Service
		module Response
			module Build
				class Cancelamento  < Base
					##############################################################################################################
					#######################   CAMINHOS PARA ENCONTRAR OS VALORES NA RESPOSTA DA REQUISIÇÃO   #####################
					attr_accessor :codigo_cancelamento_path
					def codigo_cancelamento_path
						@codigo_cancelamento_path ||= []
					end
					attr_accessor :data_hora_cancelamento_path
					def data_hora_cancelamento_path
						@data_hora_cancelamento_path ||= []
					end
					attr_accessor :numero_nfs_path
					def numero_nfs_path
						@numero_nfs_path ||= []
					end
					#######################   FIM DA DEFINIÇÃO DOS CAMINHOS   ############################
					######################################################################################
					
					def response
						@response ||= BrNfe::Service::Response::Cancelamento.new({
							original_xml:     savon_response.xml.force_encoding('UTF-8'),
							error_messages:   get_message_for_path(message_errors_path),
							codigo_cancelamento:    get_codigo_cancelamento,
							data_hora_cancelamento: get_data_hora_cancelamento,
							numero_nfs:             get_numero_nfs,
						})
					end

					# Método utilizado para pegar o valor da data e hora de cancelmaento
					#
					# <b>Tipo de retorno: </b> _DateTime_ OU _Nil_ OU _String_
					#
					def get_codigo_cancelamento
						find_value_for_keys(savon_body, path_with_root(codigo_cancelamento_path)) if codigo_cancelamento_path.present?
					end

					# Método utilizado para pegar o código do cancelamento
					#
					# <b>Tipo de retorno: </b> _String_ OU _Integer_
					#
					def get_data_hora_cancelamento
						find_value_for_keys(savon_body, path_with_root(data_hora_cancelamento_path)) if data_hora_cancelamento_path.present?
					end

					# Método utilizado para pegar o valor da data e hora de cancelmaento
					# Só é utilizado para cancelar a NF-e
					#
					# <b>Tipo de retorno: </b> _DateTime_ OU _Nil_ OU _String_
					#
					def get_numero_nfs
						find_value_for_keys(savon_body, path_with_root(numero_nfs_path)) if numero_nfs_path.present?
					end
				end
			end
		end
	end
end