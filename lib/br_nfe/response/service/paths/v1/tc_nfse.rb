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

						def invoice_url_nf_path
							default_path_to_nf + [:outras_informacoes] 
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

						def invoice_competencia_path
							default_path_to_nf + [:competencia] 
						end

						def invoice_outras_informacoes_path
							default_path_to_nf + [:outras_informacoes] 
						end

						def invoice_item_lista_servico_path
							default_path_to_nf + [:intermediario_servico] 
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
							default_path_to_nf + [:servico, :valores, :valor_iss_retido]
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
							default_path_to_nf + [:servico, :valores, :iss_retido]
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
					end
				end
			end
		end
	end
end