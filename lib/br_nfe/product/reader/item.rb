module BrNfe
	module Product
		module Reader
			class Item
				class << self
					def new xml, path
						@xml      = xml
						@path     = path
						@item = BrNfe::Product::Nfe::Item.new
						populate!
						@item
					end
				private
					def safe_parse_date value
						Date.parse value
					rescue
						nil
					end
					def safe_parse_datetime value
						Time.parse value
					rescue
						nil
					end
					def populate!
						set_product_details
						set_icms            if @xml.css( @path[:icms][:root] ).present?
						set_ipi             if @xml.css( @path[:ipi][:root] ).present?
						set_pis             if @xml.css( @path[:pis][:root] ).present?
						set_cofins          if @xml.css( @path[:cofins][:root] ).present?
						set_icms_uf_destino if @xml.css( @path[:icms_uf_destino][:root] ).present?
						set_declaracoes_importacao if @xml.css( @path[:declaracoes_importacao][:root] ).present?
						set_detalhes_exportacao    if @xml.css( @path[:detalhes_exportacao][:root] ).present?
						set_pis_st                 if @xml.css( @path[:pis_st][:root] ).present?
						set_cofins_st              if @xml.css( @path[:cofins_st][:root] ).present?
						set_importacao_tax         if @xml.css( @path[:importacao][:root] ).present?
						set_issqn                  if @xml.css( @path[:issqn][:root] ).present?
					end

					def set_product_details
						@item.tipo_produto              = @xml.css( @path[:issqn][:root] ).present? ? :service : :product
						@item.codigo_produto            = @xml.css( @path[:codigo_produto] ).text
						@item.codigo_ean                = @xml.css( @path[:codigo_ean] ).text
						@item.descricao_produto         = @xml.css( @path[:descricao_produto] ).text
						@item.codigo_ncm                = @xml.css( @path[:codigo_ncm] ).text
						@item.codigos_nve               = @xml.css( @path[:codigos_nve] ).map(&:text)
						@item.codigo_extipi             = @xml.css( @path[:codigo_extipi] ).text
						@item.cfop                      = @xml.css( @path[:cfop] ).text
						@item.unidade_comercial         = @xml.css( @path[:unidade_comercial] ).text
						@item.quantidade_comercial      = @xml.css( @path[:quantidade_comercial] ).text.to_f
						@item.valor_unitario_comercial  = @xml.css( @path[:valor_unitario_comercial] ).text.to_f
						@item.valor_total_produto       = @xml.css( @path[:valor_total_produto] ).text.to_f
						@item.codigo_ean_tributavel     = @xml.css( @path[:codigo_ean_tributavel] ).text
						@item.unidade_tributavel        = @xml.css( @path[:unidade_tributavel] ).text
						@item.quantidade_tributavel     = @xml.css( @path[:quantidade_tributavel] ).text.to_f
						@item.valor_unitario_tributavel = @xml.css( @path[:valor_unitario_tributavel] ).text.to_f
						@item.total_frete               = @xml.css( @path[:total_frete] ).text.to_f
						@item.total_seguro              = @xml.css( @path[:total_seguro] ).text.to_f
						@item.total_desconto            = @xml.css( @path[:total_desconto] ).text.to_f
						@item.total_outros              = @xml.css( @path[:total_outros] ).text.to_f
						@item.soma_total_nfe            = @xml.css( @path[:soma_total_nfe] ).text == '1' ? true : false
						@item.codigo_cest               = @xml.css( @path[:codigo_cest] ).text
						@item.numero_pedido_compra      = @xml.css( @path[:numero_pedido_compra] ).text
						@item.item_pedido_compra        = @xml.css( @path[:item_pedido_compra] ).text
						@item.numero_fci                = @xml.css( @path[:numero_fci] ).text
						@item.percentual_devolucao      = @xml.css( @path[:percentual_devolucao] ).text.to_f
						@item.total_ipi_devolucao       = @xml.css( @path[:total_ipi_devolucao] ).text.to_f
						@item.informacoes_adicionais    = @xml.css( @path[:informacoes_adicionais] ).text
						@item.total_tributos            = @xml.css( @path[:total_tributos] ).text.to_f
					end

					def set_icms
						codigo_cst =  @xml.css( @path[:icms][:cst] ).text
						codigo_cst =  @xml.css( @path[:icms][:csosn] ).text if codigo_cst.blank?
						@item.icms = {
							origem:                       @xml.css( @path[:icms][:origem] ).text,
							codigo_cst:                   codigo_cst,
							modalidade_base_calculo:      @xml.css( @path[:icms][:modalidade_base_calculo]     ).text,
							reducao_base_calculo:         @xml.css( @path[:icms][:reducao_base_calculo]        ).text.to_f,
							total_base_calculo:           @xml.css( @path[:icms][:total_base_calculo]          ).text.to_f,
							aliquota:                     @xml.css( @path[:icms][:aliquota]                    ).text.to_f,
							total:                        @xml.css( @path[:icms][:total]                       ).text.to_f,
							modalidade_base_calculo_st:   @xml.css( @path[:icms][:modalidade_base_calculo_st]  ).text,
							mva_st:                       @xml.css( @path[:icms][:mva_st]                      ).text.to_f,
							reducao_base_calculo_st:      @xml.css( @path[:icms][:reducao_base_calculo_st]     ).text.to_f,
							total_base_calculo_st:        @xml.css( @path[:icms][:total_base_calculo_st]       ).text.to_f,
							aliquota_st:                  @xml.css( @path[:icms][:aliquota_st]                 ).text.to_f,
							total_st:                     @xml.css( @path[:icms][:total_st]                    ).text.to_f,
							total_desoneracao:            @xml.css( @path[:icms][:total_desoneracao]           ).text.to_f,
							motivo_desoneracao:           @xml.css( @path[:icms][:motivo_desoneracao]          ).text,
							total_icms_operacao:          @xml.css( @path[:icms][:total_icms_operacao]         ).text.to_f,
							percentual_diferimento:       @xml.css( @path[:icms][:percentual_diferimento]      ).text.to_f,
							total_icms_diferido:          @xml.css( @path[:icms][:total_icms_diferido]         ).text.to_f,
							total_base_calculo_st_retido: @xml.css( @path[:icms][:total_base_calculo_st_retido]).text.to_f,
							total_st_retido:              @xml.css( @path[:icms][:total_st_retido]             ).text.to_f,
							aliquota_credito_sn:          @xml.css( @path[:icms][:aliquota_credito_sn]         ).text.to_f,
							total_credito_sn:             @xml.css( @path[:icms][:total_credito_sn]            ).text.to_f
						}
					end
					def set_ipi
						@item.ipi do |ipi|
							ipi.codigo_cst           = @xml.css( @path[:ipi][:codigo_cst]          ).text
							ipi.classe_enquadramento = @xml.css( @path[:ipi][:classe_enquadramento]).text
							ipi.cnpj_produtor        = @xml.css( @path[:ipi][:cnpj_produtor]       ).text
							ipi.codigo_selo          = @xml.css( @path[:ipi][:codigo_selo]         ).text
							ipi.quantidade_selo      = @xml.css( @path[:ipi][:quantidade_selo]     ).text
							ipi.codigo_enquadramento = @xml.css( @path[:ipi][:codigo_enquadramento]).text
							ipi.base_calculo         = @xml.css( @path[:ipi][:base_calculo]        ).text.to_f
							ipi.aliquota             = @xml.css( @path[:ipi][:aliquota]            ).text.to_f
							ipi.quantidade_unidade   = @xml.css( @path[:ipi][:quantidade_unidade]  ).text.to_f
							ipi.total_unidade        = @xml.css( @path[:ipi][:total_unidade]       ).text.to_f
							ipi.total                = @xml.css( @path[:ipi][:total]               ).text.to_f
						end
					end
					def set_pis
						@item.pis do |pis|
							pis.codigo_cst         = @xml.css( @path[:pis][:codigo_cst]        ).text
							pis.total_base_calculo = @xml.css( @path[:pis][:total_base_calculo]).text.to_f
							pis.aliquota           = @xml.css( @path[:pis][:aliquota]          ).text.to_f
							pis.total              = @xml.css( @path[:pis][:total]             ).text.to_f
							pis.quantidade_vendida = @xml.css( @path[:pis][:quantidade_vendida]).text.to_f
							pis.total_aliquota     = @xml.css( @path[:pis][:total_aliquota]    ).text.to_f
						end
					end
					def set_cofins
						@item.cofins do |cofins|
							cofins.codigo_cst         = @xml.css( @path[:cofins][:codigo_cst]        ).text
							cofins.total_base_calculo = @xml.css( @path[:cofins][:total_base_calculo]).text.to_f
							cofins.aliquota           = @xml.css( @path[:cofins][:aliquota]          ).text.to_f
							cofins.total              = @xml.css( @path[:cofins][:total]             ).text.to_f
							cofins.quantidade_vendida = @xml.css( @path[:cofins][:quantidade_vendida]).text.to_f
							cofins.total_aliquota     = @xml.css( @path[:cofins][:total_aliquota]    ).text.to_f
						end
					end
					def set_icms_uf_destino
						@item.icms_uf_destino do |icms_uf_destino|
							icms_uf_destino.total_base_calculo          = @xml.css( @path[:icms_uf_destino][:total_base_calculo]         ).text.to_f
							icms_uf_destino.percentual_fcp              = @xml.css( @path[:icms_uf_destino][:percentual_fcp]             ).text.to_f
							icms_uf_destino.aliquota_interna_uf_destino = @xml.css( @path[:icms_uf_destino][:aliquota_interna_uf_destino]).text.to_f
							icms_uf_destino.aliquota_interestadual      = @xml.css( @path[:icms_uf_destino][:aliquota_interestadual]     ).text.to_f
							icms_uf_destino.percentual_partilha_destino = @xml.css( @path[:icms_uf_destino][:percentual_partilha_destino]).text.to_f
							icms_uf_destino.total_fcp_destino           = @xml.css( @path[:icms_uf_destino][:total_fcp_destino]          ).text.to_f
							icms_uf_destino.total_destino               = @xml.css( @path[:icms_uf_destino][:total_destino]              ).text.to_f
							icms_uf_destino.total_origem                = @xml.css( @path[:icms_uf_destino][:total_origem]               ).text.to_f
						end
					end
					def set_declaracoes_importacao
						@xml.css( @path[:declaracoes_importacao][:root] ).each do |xml_declaracao|
							@item.declaracoes_importacao << BrNfe.declaracao_importacao_product_class.new do |declaracao|
								declaracao.numero_documento   = xml_declaracao.css( @path[:declaracoes_importacao][:numero_documento]  ).text
								declaracao.data_registro      = safe_parse_date xml_declaracao.css( @path[:declaracoes_importacao][:data_registro]     ).text
								declaracao.local_desembaraco  = xml_declaracao.css( @path[:declaracoes_importacao][:local_desembaraco] ).text
								declaracao.uf_desembaraco     = xml_declaracao.css( @path[:declaracoes_importacao][:uf_desembaraco]    ).text
								declaracao.data_desembaraco   = safe_parse_date xml_declaracao.css( @path[:declaracoes_importacao][:data_desembaraco]  ).text
								declaracao.via_transporte     = xml_declaracao.css( @path[:declaracoes_importacao][:via_transporte]    ).text
								declaracao.valor_afrmm        = xml_declaracao.css( @path[:declaracoes_importacao][:valor_afrmm]       ).text.to_f
								declaracao.tipo_intermediacao = xml_declaracao.css( @path[:declaracoes_importacao][:tipo_intermediacao]).text
								declaracao.cnpj_adquirente    = xml_declaracao.css( @path[:declaracoes_importacao][:cnpj_adquirente]   ).text
								declaracao.uf_terceiro        = xml_declaracao.css( @path[:declaracoes_importacao][:uf_terceiro]       ).text
								declaracao.codigo_exportador  = xml_declaracao.css( @path[:declaracoes_importacao][:codigo_exportador] ).text
								xml_declaracao.css( @path[:declaracoes_importacao][:adicoes][:root] ).each do |xml_adi|
									declaracao.adicoes << {
										numero_adicao:     xml_adi.css( @path[:declaracoes_importacao][:adicoes][:numero_adicao]    ).text,
										sequencial:        xml_adi.css( @path[:declaracoes_importacao][:adicoes][:sequencial]       ).text.to_i,
										codigo_fabricante: xml_adi.css( @path[:declaracoes_importacao][:adicoes][:codigo_fabricante]).text,
										valor_desconto:    xml_adi.css( @path[:declaracoes_importacao][:adicoes][:valor_desconto]   ).text.to_f,
										numero_drawback:   xml_adi.css( @path[:declaracoes_importacao][:adicoes][:numero_drawback]  ).text,
									}
								end
							end
						end
					end
					def set_detalhes_exportacao
						@xml.css( @path[:detalhes_exportacao][:root] ).each do |xml_exportacao|
							@item.detalhes_exportacao << BrNfe.detalhe_exportacao_product_class.new do |declaracao|
								declaracao.numero_drawback    = xml_exportacao.css( @path[:detalhes_exportacao][:numero_drawback]   ).text
								declaracao.numero_registro    = xml_exportacao.css( @path[:detalhes_exportacao][:numero_registro]   ).text
								declaracao.chave_nfe_recebida = xml_exportacao.css( @path[:detalhes_exportacao][:chave_nfe_recebida]).text
								declaracao.quantidade         = xml_exportacao.css( @path[:detalhes_exportacao][:quantidade]        ).text.to_f
							end
						end
					end

					def set_importacao_tax
						@item.importacao do |importacao|
							importacao.total_base_calculo        = @xml.css( @path[:importacao][:total_base_calculo]       ).text.to_f
							importacao.total_despesas_aduaneiras = @xml.css( @path[:importacao][:total_despesas_aduaneiras]).text.to_f
							importacao.total_imposto             = @xml.css( @path[:importacao][:total_imposto]            ).text.to_f
							importacao.total_iof                 = @xml.css( @path[:importacao][:total_iof]                ).text.to_f
						end
					end

					def set_pis_st
						@item.pis_st do |pis|
							pis.total_base_calculo = @xml.css( @path[:pis_st][:total_base_calculo]).text.to_f
							pis.aliquota           = @xml.css( @path[:pis_st][:aliquota]          ).text.to_f
							pis.total              = @xml.css( @path[:pis_st][:total]             ).text.to_f
							pis.quantidade_vendida = @xml.css( @path[:pis_st][:quantidade_vendida]).text.to_f
							pis.total_aliquota     = @xml.css( @path[:pis_st][:total_aliquota]    ).text.to_f
						end
					end

					def set_cofins_st
						@item.cofins_st do |pis|
							pis.total_base_calculo = @xml.css( @path[:cofins_st][:total_base_calculo]).text.to_f
							pis.aliquota           = @xml.css( @path[:cofins_st][:aliquota]          ).text.to_f
							pis.total              = @xml.css( @path[:cofins_st][:total]             ).text.to_f
							pis.quantidade_vendida = @xml.css( @path[:cofins_st][:quantidade_vendida]).text.to_f
							pis.total_aliquota     = @xml.css( @path[:cofins_st][:total_aliquota]    ).text.to_f
						end
					end

					def set_issqn
						@item.issqn do |issqn|
							issqn.total_base_calculo            = @xml.css( @path[:issqn][:total_base_calculo]           ).text.to_f
							issqn.aliquota                      = @xml.css( @path[:issqn][:aliquota]                     ).text.to_f
							issqn.total                         = @xml.css( @path[:issqn][:total]                        ).text.to_f
							issqn.municipio_ocorrencia          = @xml.css( @path[:issqn][:municipio_ocorrencia]         ).text
							issqn.codigo_servico                = @xml.css( @path[:issqn][:codigo_servico]               ).text
							issqn.total_deducao_bc              = @xml.css( @path[:issqn][:total_deducao_bc]             ).text.to_f
							issqn.total_outras_retencoes        = @xml.css( @path[:issqn][:total_outras_retencoes]       ).text.to_f
							issqn.total_desconto_incondicionado = @xml.css( @path[:issqn][:total_desconto_incondicionado]).text.to_f
							issqn.total_desconto_condicionado   = @xml.css( @path[:issqn][:total_desconto_condicionado]  ).text.to_f
							issqn.total_iss_retido              = @xml.css( @path[:issqn][:total_iss_retido]             ).text.to_f
							issqn.indicador_iss                 = @xml.css( @path[:issqn][:indicador_iss]                ).text
							issqn.codigo_servico_municipio      = @xml.css( @path[:issqn][:codigo_servico_municipio]     ).text
							issqn.municipio_incidencia          = @xml.css( @path[:issqn][:municipio_incidencia]         ).text
							issqn.codigo_pais                   = @xml.css( @path[:issqn][:codigo_pais]                  ).text
							issqn.numero_processo               = @xml.css( @path[:issqn][:numero_processo]              ).text
							issqn.incentivo_fiscal              = @xml.css( @path[:issqn][:incentivo_fiscal]             ).text == '1'
						end
					end
				end
			end
		end
	end
end