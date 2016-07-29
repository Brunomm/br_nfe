module BrNfe
	module Service
		module Response
			module Paths
				module V1
					module TcNfse
						def default_path_to_nf
							[:nfse, :inf_nfse]
						end

						def invoice_numero_nf_path
							default_path_to_nf + [:numero] 
						end

						def invoice_codigo_verificacao_path
							default_path_to_nf + [:codigo_verificacao] 
						end

						def invoice_data_emissao_path
							default_path_to_nf + [:data_emissao]
						end

						def invoice_rps_numero_path
							default_path_to_nf + [:identificacao_rps, :numero]
						end

						def invoice_rps_serie_path
							default_path_to_nf + [:identificacao_rps, :serie]
						end

						def invoice_rps_tipo_path
							default_path_to_nf + [:identificacao_rps, :tipo]
						end

						def invoice_data_emissao_rps_path
							default_path_to_nf + [:data_emissao_rps]
						end

						def invoice_natureza_operacao_path
							default_path_to_nf + [:natureza_operacao]
						end

						def invoice_regime_especial_tributacao_path
							default_path_to_nf + [:regime_especial_tributacao]
						end

						def invoice_optante_simples_nacional_path
							default_path_to_nf + [:optante_simples_nacional]
						end

						def invoice_incentivador_cultural_path
							default_path_to_nf + [:incentivador_cultural]
						end

						def invoice_competencia_path
							default_path_to_nf + [:competencia] 
						end

						def invoice_outras_informacoes_path
							default_path_to_nf + [:outras_informacoes] 
						end

						def invoice_item_lista_servico_path
							default_path_to_nf + [:servico, :item_lista_servico] 
						end

						def invoice_cnae_code_path
							default_path_to_nf + [:servico, :codigo_cnae] 
						end

						def invoice_description_path
							default_path_to_nf + [:servico, :discriminacao] 
						end

						def invoice_codigo_municipio_path
							default_path_to_nf + [:servico, :codigo_municipio] 
						end

						def invoice_total_services_path
							default_path_to_nf + [:servico, :valores, :valor_servicos]
						end

						def invoice_deductions_path
							default_path_to_nf + [:servico, :valores, :valor_deducoes]
						end

						def invoice_valor_pis_path
							default_path_to_nf + [:servico, :valores, :valor_pis]
						end

						def invoice_valor_cofins_path
							default_path_to_nf + [:servico, :valores, :valor_cofins]
						end

						def invoice_valor_inss_path
							default_path_to_nf + [:servico, :valores, :valor_inss]
						end

						def invoice_valor_ir_path
							default_path_to_nf + [:servico, :valores, :valor_ir]
						end

						def invoice_valor_csll_path
							default_path_to_nf + [:servico, :valores, :valor_csll]
						end

						def invoice_iss_retained_path
							default_path_to_nf + [:servico, :valores, :iss_retido]
						end

						def invoice_outras_retencoes_path
							default_path_to_nf + [:servico, :valores, :outras_retencoes]
						end

						def invoice_total_iss_path
							default_path_to_nf + [:servico, :valores, :valor_iss]
						end

						def invoice_base_calculation_path
							default_path_to_nf + [:servico, :valores, :base_calculo]
						end

						def invoice_iss_tax_rate_path
							default_path_to_nf + [:servico, :valores, :aliquota]
						end

						def invoice_valor_liquido_path
							default_path_to_nf + [:servico, :valores, :valor_liquido_nfse]
						end

						def invoice_desconto_condicionado_path
							default_path_to_nf + [:servico, :valores, :desconto_condicionado]
						end

						def invoice_desconto_incondicionado_path
							default_path_to_nf + [:servico, :valores, :desconto_incondicionado]
						end

						def invoice_orgao_gerador_municipio_path
							default_path_to_nf + [:orgao_gerador, :codigo_municipio]
						end

						def invoice_orgao_gerador_uf_path
							default_path_to_nf + [:orgao_gerador, :uf]
						end

						def invoice_codigo_obra_path
							default_path_to_nf + [:construcao_civil, :codigo_obra]
						end
						
						def invoice_codigo_art_path
							default_path_to_nf + [:construcao_civil, :art]
						end

						def invoice_cancelamento_codigo_path
							[:nfse_cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :codigo_cancelamento]
						end
						def invoice_cancelamento_numero_nf_path
							[:nfse_cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :identificacao_nfse, :numero]
						end
						def invoice_cancelamento_cnpj_path
							[:nfse_cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :identificacao_nfse, :cnpj]
						end
						def invoice_cancelamento_inscricao_municipal_path
							[:nfse_cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :identificacao_nfse, :inscricao_municipal]
						end
						def invoice_cancelamento_municipio_path
							[:nfse_cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :identificacao_nfse, :codigo_municipio]
						end
						def invoice_cancelamento_data_hora_path
							[:nfse_cancelamento, :confirmacao, :data_hora_cancelamento]
						end
						def invoice_nfe_substituidora_path
							[:nfse_substituicao, :substituicao_nfse, :nfse_substituidora]
						end

						############################## PATH PARA EMITENTE ##########################################
						def invoice_emitente_path
							default_path_to_nf+[:prestador_servico]
						end						
						def invoice_emitente_cnpj_path
							invoice_emitente_path + [:identificacao_prestador, :cnpj]
						end
						def invoice_emitente_inscricao_municipal_path
							invoice_emitente_path + [:identificacao_prestador, :inscricao_municipal]
						end
						def invoice_emitente_razao_social_path
							invoice_emitente_path + [:razao_social]
						end
						def invoice_emitente_nome_fantasia_path
							invoice_emitente_path + [:nome_fantasia]
						end
						def invoice_emitente_telefone_path
							invoice_emitente_path + [:contato, :telefone]
						end
						def invoice_emitente_email_path
							invoice_emitente_path + [:contato, :email]
						end
						def invoice_emitente_endereco_logradouro_path
							invoice_emitente_path + [:endereco, :endereco]
						end
						def invoice_emitente_endereco_numero_path
							invoice_emitente_path + [:endereco, :numero]
						end
						def invoice_emitente_endereco_complemento_path
							invoice_emitente_path + [:endereco, :complemento]
						end
						def invoice_emitente_endereco_bairro_path
							invoice_emitente_path + [:endereco, :bairro]
						end
						def invoice_emitente_endereco_codigo_municipio_path
							invoice_emitente_path + [:endereco, :codigo_municipio]
						end
						def invoice_emitente_endereco_uf_path
							invoice_emitente_path + [:endereco, :uf]
						end
						def invoice_emitente_endereco_cep_path
							invoice_emitente_path + [:endereco, :cep]
						end
						############################## PATH PARA DESTINATÁRIO ##########################################
						def invoice_destinatario_cpf_path
							default_path_to_nf+[:tomador_servico, :identificacao_tomador, :cpf_cnpj, :cpf]
						end
						def invoice_destinatario_cnpj_path
							default_path_to_nf+[:tomador_servico, :identificacao_tomador, :cpf_cnpj, :cnpj]
						end
						def invoice_destinatario_inscricao_municipal_path
							default_path_to_nf+[:tomador_servico, :identificacao_tomador, :inscricao_municipal]
						end
						def invoice_destinatario_inscricao_estadual_path
							default_path_to_nf+[:tomador_servico, :identificacao_tomador, :inscricao_estadual]
						end
						def invoice_destinatario_inscricao_suframa_path
							default_path_to_nf+[:tomador_servico, :identificacao_tomador, :inscricao_suframa]
						end
						def invoice_destinatario_razao_social_path
							default_path_to_nf+[:tomador_servico, :razao_social]
						end
						def invoice_destinatario_telefone_path
							default_path_to_nf+[:tomador_servico, :contato, :telefone]
						end
						def invoice_destinatario_email_path
							default_path_to_nf+[:tomador_servico, :contato, :email]
						end
						def invoice_destinatario_endereco_logradouro_path
							default_path_to_nf+[:tomador_servico, :endereco, :endereco]
						end
						def invoice_destinatario_endereco_numero_path
							default_path_to_nf+[:tomador_servico, :endereco, :numero]
						end
						def invoice_destinatario_endereco_complemento_path
							default_path_to_nf+[:tomador_servico, :endereco, :complemento]
						end
						def invoice_destinatario_endereco_bairro_path
							default_path_to_nf+[:tomador_servico, :endereco, :bairro]
						end
						def invoice_destinatario_endereco_codigo_municipio_path
							default_path_to_nf+[:tomador_servico, :endereco, :codigo_municipio]
						end
						def invoice_destinatario_endereco_uf_path
							default_path_to_nf+[:tomador_servico, :endereco, :uf]
						end
						def invoice_destinatario_endereco_cep_path
							default_path_to_nf+[:tomador_servico, :endereco, :cep]
						end
					end
				end
			end
		end
	end
end