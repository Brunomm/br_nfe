module BrNfe
	module Product
		module Reader
			class Nfe < BrNfe::ActiveModelBase
				def initialize xml
					@xml = Nokogiri::XML xml
					@xml_version = find_xml_version
					@xml_nfe = @xml.css("NFe")
					@invoice = BrNfe::Product::NotaFiscal.new
					populate_invoice!
					@invoice
				end
				def invoice
					@invoice
				end

				def xml_version
					@xml_version
				end
			
			private

				def path
					BrNfe.settings[:nfe][@xml_version][:reader_xml_paths]
				end

				def proc_is_present?
					@xml.css("nfeProc").present?
				end

				def find_xml_version
					"v#{@xml.css("infNFe").attr("versao")}".gsub('.','_').to_sym
				end

				def populate_invoice!
					build_associations

					# Totais
					build_product_total_values! if @xml_nfe.css(path[:total_icms][:root]).present?
					build_service_total_values! if @xml_nfe.css(path[:total_issqn][:root]).present?
					build_total_retencao!       if @xml_nfe.css(path[:total_retencao][:root]).present?
					build_state_protocol_nfe!   if proc_is_present?

					@invoice.codigo_tipo_emissao       = @xml_nfe.css(path[:codigo_tipo_emissao]).text
					@invoice.codigo_nf                 = @xml_nfe.css(path[:codigo_nf]).text
					@invoice.natureza_operacao         = @xml_nfe.css(path[:natureza_operacao]).text
					@invoice.forma_pagamento           = @xml_nfe.css(path[:forma_pagamento]).text
					@invoice.modelo_nf                 = @xml_nfe.css(path[:modelo_nf]).text
					@invoice.serie                     = @xml_nfe.css(path[:serie]).text
					@invoice.numero_nf                 = @xml_nfe.css(path[:numero_nf]).text.to_i
					@invoice.data_hora_emissao         = parse_time @xml_nfe.css(path[:data_hora_emissao]).text
					@invoice.data_hora_expedicao       = parse_time @xml_nfe.css(path[:data_hora_expedicao]).text
					@invoice.tipo_operacao             = @xml_nfe.css(path[:tipo_operacao]).text
					@invoice.tipo_impressao            = @xml_nfe.css(path[:tipo_impressao]).text
					@invoice.tipo_ambiente             = @xml_nfe.css(path[:tipo_ambiente]).text
					@invoice.finalidade_emissao        = @xml_nfe.css(path[:finalidade_emissao]).text
					@invoice.consumidor_final          = @xml_nfe.css(path[:consumidor_final]).text
					@invoice.presenca_comprador        = @xml_nfe.css(path[:presenca_comprador]).text
					@invoice.processo_emissao          = @xml_nfe.css(path[:processo_emissao]).text
					@invoice.versao_aplicativo         = @xml_nfe.css(path[:versao_aplicativo]).text
					@invoice.informacoes_fisco         = @xml_nfe.css(path[:informacoes_fisco]).text
					@invoice.informacoes_contribuinte  = @xml_nfe.css(path[:informacoes_contribuinte]).text
					@invoice.exportacao_uf_saida       = @xml_nfe.css(path[:exportacao_uf_saida]).text
					@invoice.exportacao_local_embarque = @xml_nfe.css(path[:exportacao_local_embarque]).text
					@invoice.exportacao_local_despacho = @xml_nfe.css(path[:exportacao_local_despacho]).text
				end

				def build_associations
					@invoice.emitente        = Emitente.new(@xml_nfe, path)
					@invoice.destinatario    = Destinatario.new(@xml_nfe, path)
					@invoice.transporte      = Transporte.new(@xml_nfe, path)
					build_endereco_retirada!
					build_endereco_entrega!
					build_fatura!
					build_pagamentos!
					build_items!
				end

				def build_product_total_values!
					@invoice.total_icms_base_calculo    = @xml_nfe.css(path[:total_icms][:total_icms_base_calculo]).text.to_f
					@invoice.total_icms                 = @xml_nfe.css(path[:total_icms][:total_icms]).text.to_f
					@invoice.total_icms_desonerado      = @xml_nfe.css(path[:total_icms][:total_icms_desonerado]).text.to_f
					@invoice.total_icms_fcp_uf_destino  = @xml_nfe.css(path[:total_icms][:total_icms_fcp_uf_destino]).text.to_f
					@invoice.total_icms_uf_destino      = @xml_nfe.css(path[:total_icms][:total_icms_uf_destino]).text.to_f
					@invoice.total_icms_uf_origem       = @xml_nfe.css(path[:total_icms][:total_icms_uf_origem]).text.to_f
					@invoice.total_icms_base_calculo_st = @xml_nfe.css(path[:total_icms][:total_icms_base_calculo_st]).text.to_f
					@invoice.total_icms_st              = @xml_nfe.css(path[:total_icms][:total_icms_st]).text.to_f
					@invoice.total_produtos             = @xml_nfe.css(path[:total_icms][:total_produtos]).text.to_f
					@invoice.total_frete                = @xml_nfe.css(path[:total_icms][:total_frete]).text.to_f
					@invoice.total_seguro               = @xml_nfe.css(path[:total_icms][:total_seguro]).text.to_f
					@invoice.total_desconto             = @xml_nfe.css(path[:total_icms][:total_desconto]).text.to_f
					@invoice.total_imposto_importacao   = @xml_nfe.css(path[:total_icms][:total_imposto_importacao]).text.to_f
					@invoice.total_ipi                  = @xml_nfe.css(path[:total_icms][:total_ipi]).text.to_f
					@invoice.total_pis                  = @xml_nfe.css(path[:total_icms][:total_pis]).text.to_f
					@invoice.total_cofins               = @xml_nfe.css(path[:total_icms][:total_cofins]).text.to_f
					@invoice.total_outras_despesas      = @xml_nfe.css(path[:total_icms][:total_outras_despesas]).text.to_f
					@invoice.total_nf                   = @xml_nfe.css(path[:total_icms][:total_nf]).text.to_f
					@invoice.total_tributos             = @xml_nfe.css(path[:total_icms][:total_tributos]).text.to_f
				end

				def build_service_total_values!
					@invoice.total_servicos                         = @xml_nfe.css(path[:total_issqn][:total_servicos]).text.to_f
					@invoice.total_servicos_base_calculo            = @xml_nfe.css(path[:total_issqn][:total_servicos_base_calculo]).text.to_f
					@invoice.total_servicos_iss                     = @xml_nfe.css(path[:total_issqn][:total_servicos_iss]).text.to_f
					@invoice.total_servicos_pis                     = @xml_nfe.css(path[:total_issqn][:total_servicos_pis]).text.to_f
					@invoice.total_servicos_cofins                  = @xml_nfe.css(path[:total_issqn][:total_servicos_cofins]).text.to_f
					@invoice.servicos_data_prestacao                = parse_date( @xml_nfe.css(path[:total_issqn][:servicos_data_prestacao]).text )
					@invoice.total_servicos_deducao                 = @xml_nfe.css(path[:total_issqn][:total_servicos_deducao]).text.to_f
					@invoice.total_servicos_outras_retencoes        = @xml_nfe.css(path[:total_issqn][:total_servicos_outras_retencoes]).text.to_f
					@invoice.total_servicos_desconto_incondicionado = @xml_nfe.css(path[:total_issqn][:total_servicos_desconto_incondicionado]).text.to_f
					@invoice.total_servicos_desconto_condicionado   = @xml_nfe.css(path[:total_issqn][:total_servicos_desconto_condicionado]).text.to_f
					@invoice.total_servicos_iss_retido              = @xml_nfe.css(path[:total_issqn][:total_servicos_iss_retido]).text.to_f
					@invoice.regime_tributario_servico              = @xml_nfe.css(path[:total_issqn][:regime_tributario_servico]).text
				end

				def build_total_retencao!
					@invoice.total_retencao_pis                      = @xml_nfe.css(path[:total_retencao][:total_retencao_pis]).text.to_f
					@invoice.total_retencao_cofins                   = @xml_nfe.css(path[:total_retencao][:total_retencao_cofins]).text.to_f
					@invoice.total_retencao_csll                     = @xml_nfe.css(path[:total_retencao][:total_retencao_csll]).text.to_f
					@invoice.total_retencao_base_calculo_irrf        = @xml_nfe.css(path[:total_retencao][:total_retencao_base_calculo_irrf]).text.to_f
					@invoice.total_retencao_irrf                     = @xml_nfe.css(path[:total_retencao][:total_retencao_irrf]).text.to_f
					@invoice.total_retencao_base_calculo_previdencia = @xml_nfe.css(path[:total_retencao][:total_retencao_base_calculo_previdencia]).text.to_f
					@invoice.total_retencao_previdencia              = @xml_nfe.css(path[:total_retencao][:total_retencao_previdencia]).text.to_f
				end


				def build_endereco_retirada!
					if @xml_nfe.css(path[:endereco_retirada][:root]).present?
						@invoice.endereco_retirada_cpf_cnpj = @xml_nfe.css(path[:endereco_retirada][:cnpj]).text
						@invoice.endereco_retirada_cpf_cnpj = @xml_nfe.css(path[:endereco_retirada][:cpf]).text unless @invoice.endereco_retirada_cpf_cnpj.present?
						@invoice.endereco_retirada = EnderecoRetiradaEntrega.new(@xml_nfe, path[:endereco_retirada])
					end
				end

				def build_endereco_entrega!
					if @xml_nfe.css(path[:endereco_entrega][:root]).present?
						@invoice.endereco_entrega_cpf_cnpj = @xml_nfe.css(path[:endereco_entrega][:cnpj]).text
						@invoice.endereco_entrega_cpf_cnpj = @xml_nfe.css(path[:endereco_entrega][:cpf]).text unless @invoice.endereco_entrega_cpf_cnpj.present?
						@invoice.endereco_entrega = EnderecoRetiradaEntrega.new(@xml_nfe, path[:endereco_entrega])
					end
				end

				def build_fatura!
					if @xml_nfe.css(path[:fatura][:root]).present? || @xml_nfe.css(path[:fatura][:duplicatas][:root]).present?
						@invoice.fatura = Fatura.new(@xml_nfe, path)
					end
				end

				def build_pagamentos!
					@xml_nfe.css(path[:pagamentos][:root]).each do |xml_pag|
						@invoice.pagamentos << {
							forma_pagamento:    xml_pag.css(path[:pagamentos][:forma_pagamento]).text,
							total:              xml_pag.css(path[:pagamentos][:total]).text.to_f,
							tipo_integracao:    xml_pag.css(path[:pagamentos][:tipo_integracao]).text,
							cartao_cnpj:        xml_pag.css(path[:pagamentos][:cartao_cnpj]).text,
							cartao_bandeira:    xml_pag.css(path[:pagamentos][:cartao_bandeira]).text,
							cartao_autorizacao: xml_pag.css(path[:pagamentos][:cartao_autorizacao]).text
						}
					end
				end

				def build_items!
					@xml_nfe.css(path[:items][:root]).each do |xml_item|
						@invoice.itens << Item.new(xml_item, path[:items])
					end
				end

				def build_state_protocol_nfe!
					@invoice.protocol     = @xml.css( path[:protocol][:protocol]    ).text
					@invoice.digest_value = @xml.css( path[:protocol][:digest_value]).text
					@invoice.processed_at = parse_time @xml.css( path[:protocol][:processed_at]).text
					@invoice.status_code  = @xml.css( path[:protocol][:status_code] ).text
					@xml.css( path[:info_events][:root] ).each do |info_xml|
						tipo_evento = info_xml.css( path[:info_events][:tipo_evento] ).text
						if tipo_evento == '110111' # Cancelada
							@invoice.situation = :canceled

							@invoice.protocol     = info_xml.css( path[:info_events][:protocol]    ).text
							@invoice.processed_at = parse_time info_xml.css( path[:info_events][:processed_at]).text
							@invoice.status_code  = info_xml.css( path[:info_events][:status_code] ).text
						end
					end
				end

				def parse_date value
					Date.parse value
				rescue
					nil
				end

				def parse_time value
					Time.parse(value)
				rescue
					nil
				end

			end
		end
	end
end