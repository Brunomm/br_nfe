module BrNfe
	module Service
		module Response
			module Paths
				module V1
					module TcNfse
						extend ActiveSupport::Concern

						included do
							def response_default_path_to_nf
								[:nfse, :inf_nfse]
							end

							def response_invoice_numero_nf_path
								response_default_path_to_nf + [:numero] 
							end

							def response_invoice_codigo_verificacao_path
								response_default_path_to_nf + [:codigo_verificacao] 
							end

							def response_invoice_data_emissao_path
								response_default_path_to_nf + [:data_emissao]
							end

							def response_invoice_rps_numero_path
								response_default_path_to_nf + [:identificacao_rps, :numero]
							end

							def response_invoice_rps_serie_path
								response_default_path_to_nf + [:identificacao_rps, :serie]
							end

							def response_invoice_rps_tipo_path
								response_default_path_to_nf + [:identificacao_rps, :tipo]
							end

							def response_invoice_data_emissao_rps_path
								response_default_path_to_nf + [:data_emissao_rps]
							end

							def response_invoice_natureza_operacao_path
								response_default_path_to_nf + [:natureza_operacao]
							end

							def response_invoice_regime_especial_tributacao_path
								response_default_path_to_nf + [:regime_especial_tributacao]
							end

							def response_invoice_optante_simples_nacional_path
								response_default_path_to_nf + [:optante_simples_nacional]
							end

							def response_invoice_incentivador_cultural_path
								response_default_path_to_nf + [:incentivador_cultural]
							end

							def response_invoice_competencia_path
								response_default_path_to_nf + [:competencia] 
							end

							def response_invoice_outras_informacoes_path
								response_default_path_to_nf + [:outras_informacoes] 
							end

							def response_invoice_item_lista_servico_path
								response_default_path_to_nf + [:servico, :item_lista_servico] 
							end

							def response_invoice_cnae_code_path
								response_default_path_to_nf + [:servico, :codigo_cnae] 
							end

							def response_invoice_description_path
								response_default_path_to_nf + [:servico, :discriminacao] 
							end

							def response_invoice_codigo_municipio_path
								response_default_path_to_nf + [:servico, :codigo_municipio] 
							end

							def response_invoice_valor_total_servicos_path
								response_default_path_to_nf + [:servico, :valores, :valor_servicos]
							end

							def response_invoice_deducoes_path
								response_default_path_to_nf + [:servico, :valores, :valor_deducoes]
							end

							def response_invoice_valor_pis_path
								response_default_path_to_nf + [:servico, :valores, :valor_pis]
							end

							def response_invoice_valor_cofins_path
								response_default_path_to_nf + [:servico, :valores, :valor_cofins]
							end

							def response_invoice_valor_inss_path
								response_default_path_to_nf + [:servico, :valores, :valor_inss]
							end

							def response_invoice_valor_ir_path
								response_default_path_to_nf + [:servico, :valores, :valor_ir]
							end

							def response_invoice_valor_csll_path
								response_default_path_to_nf + [:servico, :valores, :valor_csll]
							end

							def response_invoice_iss_retido_path
								response_default_path_to_nf + [:servico, :valores, :iss_retido]
							end

							def response_invoice_outras_retencoes_path
								response_default_path_to_nf + [:servico, :valores, :outras_retencoes]
							end

							def response_invoice_total_iss_path
								response_default_path_to_nf + [:servico, :valores, :valor_iss]
							end

							def response_invoice_base_calculo_path
								response_default_path_to_nf + [:servico, :valores, :base_calculo]
							end

							def response_invoice_iss_aliquota_path
								response_default_path_to_nf + [:servico, :valores, :aliquota]
							end

							def response_invoice_valor_liquido_path
								response_default_path_to_nf + [:servico, :valores, :valor_liquido_nfse]
							end

							def response_invoice_desconto_condicionado_path
								response_default_path_to_nf + [:servico, :valores, :desconto_condicionado]
							end

							def response_invoice_desconto_incondicionado_path
								response_default_path_to_nf + [:servico, :valores, :desconto_incondicionado]
							end

							def response_invoice_orgao_gerador_municipio_path
								response_default_path_to_nf + [:orgao_gerador, :codigo_municipio]
							end

							def response_invoice_orgao_gerador_uf_path
								response_default_path_to_nf + [:orgao_gerador, :uf]
							end

							def response_invoice_codigo_obra_path
								response_default_path_to_nf + [:construcao_civil, :codigo_obra]
							end
							
							def response_invoice_codigo_art_path
								response_default_path_to_nf + [:construcao_civil, :art]
							end

							def response_invoice_cancelamento_codigo_path
								[:nfse_cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :codigo_cancelamento]
							end
							def response_invoice_cancelamento_numero_nf_path
								[:nfse_cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :identificacao_nfse, :numero]
							end
							def response_invoice_cancelamento_cnpj_path
								[:nfse_cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :identificacao_nfse, :cnpj]
							end
							def response_invoice_cancelamento_inscricao_municipal_path
								[:nfse_cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :identificacao_nfse, :inscricao_municipal]
							end
							def response_invoice_cancelamento_municipio_path
								[:nfse_cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :identificacao_nfse, :codigo_municipio]
							end
							def response_invoice_cancelamento_data_hora_path
								[:nfse_cancelamento, :confirmacao, :data_hora_cancelamento]
							end
							def response_invoice_nfe_substituidora_path
								[:nfse_substituicao, :substituicao_nfse, :nfse_substituidora]
							end

							############################## PATH PARA EMITENTE ##########################################
							def response_invoice_emitente_path
								response_default_path_to_nf+[:prestador_servico]
							end						
							def response_invoice_emitente_cnpj_path
								response_invoice_emitente_path + [:identificacao_prestador, :cnpj]
							end
							def response_invoice_emitente_inscricao_municipal_path
								response_invoice_emitente_path + [:identificacao_prestador, :inscricao_municipal]
							end
							def response_invoice_emitente_razao_social_path
								response_invoice_emitente_path + [:razao_social]
							end
							def response_invoice_emitente_nome_fantasia_path
								response_invoice_emitente_path + [:nome_fantasia]
							end
							def response_invoice_emitente_telefone_path
								response_invoice_emitente_path + [:contato, :telefone]
							end
							def response_invoice_emitente_email_path
								response_invoice_emitente_path + [:contato, :email]
							end
							def response_invoice_emitente_endereco_logradouro_path
								response_invoice_emitente_path + [:endereco, :endereco]
							end
							def response_invoice_emitente_endereco_numero_path
								response_invoice_emitente_path + [:endereco, :numero]
							end
							def response_invoice_emitente_endereco_complemento_path
								response_invoice_emitente_path + [:endereco, :complemento]
							end
							def response_invoice_emitente_endereco_bairro_path
								response_invoice_emitente_path + [:endereco, :bairro]
							end
							def response_invoice_emitente_endereco_codigo_municipio_path
								response_invoice_emitente_path + [:endereco, :codigo_municipio]
							end
							def response_invoice_emitente_endereco_uf_path
								response_invoice_emitente_path + [:endereco, :uf]
							end
							def response_invoice_emitente_endereco_cep_path
								response_invoice_emitente_path + [:endereco, :cep]
							end
							############################## PATH PARA DESTINATÁRIO ##########################################
							def response_invoice_destinatario_cpf_path
								response_default_path_to_nf+[:tomador_servico, :identificacao_tomador, :cpf_cnpj, :cpf]
							end
							def response_invoice_destinatario_cnpj_path
								response_default_path_to_nf+[:tomador_servico, :identificacao_tomador, :cpf_cnpj, :cnpj]
							end
							def response_invoice_destinatario_inscricao_municipal_path
								response_default_path_to_nf+[:tomador_servico, :identificacao_tomador, :inscricao_municipal]
							end
							def response_invoice_destinatario_inscricao_estadual_path
								response_default_path_to_nf+[:tomador_servico, :identificacao_tomador, :inscricao_estadual]
							end
							def response_invoice_destinatario_inscricao_suframa_path
								response_default_path_to_nf+[:tomador_servico, :identificacao_tomador, :inscricao_suframa]
							end
							def response_invoice_destinatario_razao_social_path
								response_default_path_to_nf+[:tomador_servico, :razao_social]
							end
							def response_invoice_destinatario_telefone_path
								response_default_path_to_nf+[:tomador_servico, :contato, :telefone]
							end
							def response_invoice_destinatario_email_path
								response_default_path_to_nf+[:tomador_servico, :contato, :email]
							end
							def response_invoice_destinatario_endereco_logradouro_path
								response_default_path_to_nf+[:tomador_servico, :endereco, :endereco]
							end
							def response_invoice_destinatario_endereco_numero_path
								response_default_path_to_nf+[:tomador_servico, :endereco, :numero]
							end
							def response_invoice_destinatario_endereco_complemento_path
								response_default_path_to_nf+[:tomador_servico, :endereco, :complemento]
							end
							def response_invoice_destinatario_endereco_bairro_path
								response_default_path_to_nf+[:tomador_servico, :endereco, :bairro]
							end
							def response_invoice_destinatario_endereco_codigo_municipio_path
								response_default_path_to_nf+[:tomador_servico, :endereco, :codigo_municipio]
							end
							def response_invoice_destinatario_endereco_uf_path
								response_default_path_to_nf+[:tomador_servico, :endereco, :uf]
							end
							def response_invoice_destinatario_endereco_cep_path
								response_default_path_to_nf+[:tomador_servico, :endereco, :cep]
							end
						end
					end
				end
			end
		end
	end
end