module BrNfe
	module Service
		module Response
			module Paths
				module Base
					# Caminho referente ao caminho do número do lote
					def response_lot_number_path; [] end
					
					# Caminho para encontrar o número do protocolo
					def response_protocol_path; [] end
					
					# Caminho para encontrar a data de recebimento do lote/rps/nfe
					def response_received_date_path; [] end

					# Caminho para encontrar a situação
					def response_situation_path; [] end
					
					# Chaves para formatar a situação do Lote RPS
					def response_situation_key_values
						{
							'1' =>  :unreceived, # Não Recebido
							'2' =>  :unprocessed,# Não Processado
							'3' =>  :error,      # Processado com Erro
							'4' =>  :success,    # Processado com Sucesso
						}
					end
					
					# Caminho para encontrar a data e hora do cancelamento da nF
					def response_cancelation_date_time_path; [] end
					
					def response_message_errors_path; [] end
					def response_message_code_key;     :codigo   end
					def response_message_msg_key;      :mensagem end
					def response_message_solution_key; :correcao end

					# Caminho referente ao caminho onde se encontra as notas fiscais
					# poderá encontrar apenas uma ou várias
					def response_invoices_path; [] end
					
					# Demais caminhos para encontrar os dados da NF-e
					def response_invoice_numero_nf_path;               [] end
					def response_invoice_codigo_verificacao_path;      [] end
					def response_invoice_data_emissao_path;            [] end
					def response_invoice_url_nf_path;                  [] end
					def response_invoice_rps_numero_path;              [] end
					def response_invoice_rps_serie_path;               [] end
					def response_invoice_rps_tipo_path;                [] end
					def response_invoice_rps_situacao_path;            [] end
					def response_invoice_rps_substituido_numero_path;  [] end
					def response_invoice_rps_substituido_serie_path;   [] end
					def response_invoice_rps_substituido_tipo_path;    [] end
					def response_invoice_data_emissao_rps_path;        [] end
					def response_invoice_competencia_path;             [] end
					def response_invoice_natureza_operacao_path;         [] end
					def response_invoice_regime_especial_tributacao_path;[] end
					def response_invoice_optante_simples_nacional_path;  [] end
					def response_invoice_incentivador_cultural_path;     [] end
					def response_invoice_outras_informacoes_path;      [] end
					def response_invoice_item_lista_servico_path;      [] end
					def response_invoice_cnae_code_path;               [] end
					def response_invoice_description_path;             [] end
					def response_invoice_codigo_municipio_path;        [] end
					def response_invoice_total_services_path;          [] end
					def response_invoice_deductions_path;              [] end
					def response_invoice_valor_pis_path;               [] end
					def response_invoice_valor_cofins_path;            [] end
					def response_invoice_valor_inss_path;              [] end
					def response_invoice_valor_ir_path;                [] end
					def response_invoice_valor_csll_path;              [] end
					def response_invoice_iss_retained_path;            [] end
					def response_invoice_outras_retencoes_path;        [] end
					def response_invoice_total_iss_path;               [] end
					def response_invoice_base_calculation_path;        [] end
					def response_invoice_iss_tax_rate_path;            [] end
					def response_invoice_valor_liquido_path;           [] end
					def response_invoice_desconto_condicionado_path;   [] end
					def response_invoice_desconto_incondicionado_path; [] end
					def response_invoice_responsavel_retencao_path;    [] end
					def response_invoice_numero_processo_path;         [] end
					def response_invoice_municipio_incidencia_path;    [] end
					def response_invoice_orgao_gerador_municipio_path; [] end
					def response_invoice_orgao_gerador_uf_path;        [] end
					def response_invoice_cancelamento_codigo_path;     [] end
					def response_invoice_cancelamento_numero_nf_path;  [] end
					def response_invoice_cancelamento_cnpj_path;       [] end
					def response_invoice_cancelamento_municipio_path;  [] end
					def response_invoice_cancelamento_data_hora_path;  [] end
					def response_invoice_nfe_substituidora_path;       [] end
					def response_invoice_codigo_obra_path;             [] end
					def response_invoice_codigo_art_path;              [] end
					def response_invoice_cancelamento_inscricao_municipal_path; [] end
					
					def response_invoice_emitente_cnpj_path; [] end
					def response_invoice_emitente_inscricao_municipal_path; [] end
					def response_invoice_emitente_razao_social_path; [] end
					def response_invoice_emitente_nome_fantasia_path; [] end
					def response_invoice_emitente_telefone_path; [] end
					def response_invoice_emitente_email_path; [] end
					def response_invoice_emitente_endereco_logradouro_path; [] end
					def response_invoice_emitente_endereco_numero_path; [] end
					def response_invoice_emitente_endereco_complemento_path; [] end
					def response_invoice_emitente_endereco_bairro_path; [] end
					def response_invoice_emitente_endereco_codigo_municipio_path; [] end
					def response_invoice_emitente_endereco_uf_path; [] end
					def response_invoice_emitente_endereco_cep_path; [] end

					def response_invoice_destinatario_cpf_path ; end
					def response_invoice_destinatario_cnpj_path ; end
					def response_invoice_destinatario_inscricao_municipal_path ; end
					def response_invoice_destinatario_inscricao_estadual_path ; end
					def response_invoice_destinatario_inscricao_suframa_path ; end
					def response_invoice_destinatario_razao_social_path ; end
					def response_invoice_destinatario_telefone_path ; end
					def response_invoice_destinatario_email_path ; end
					def response_invoice_destinatario_endereco_logradouro_path ; end
					def response_invoice_destinatario_endereco_numero_path ; end
					def response_invoice_destinatario_endereco_complemento_path ; end
					def response_invoice_destinatario_endereco_bairro_path ; end
					def response_invoice_destinatario_endereco_codigo_municipio_path ; end
					def response_invoice_destinatario_endereco_uf_path ; end
					def response_invoice_destinatario_endereco_cep_path ; end

				end
			end
		end
	end
end