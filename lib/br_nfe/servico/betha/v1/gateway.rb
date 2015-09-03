module BrNfe
	module Servico
		module Betha
			module V1
				class Gateway < BrNfe::Servico::Betha::Base
					def namespaces
						{"xmlns:ns1" => "http://www.betha.com.br/e-nota-contribuinte-ws"}
					end

					def namespace_identifier
						:ns1	
					end

					def version
						:v1
					end

					def request
						set_response( 
							client_wsdl.call("#{method_wsdl}_envio".to_sym, 
								message:    "#{content_xml}",
								attributes: {'xmlns:ns1' => 'http://www.betha.com.br/e-nota-contribuinte-ws'} 
							) 
						)
					end

					def set_response(resp)
						method_response = (method_wsdl.to_s + "_envio_response").to_sym
						@response = BrNfe::Servico::Betha::V1::Response.new(xml: resp.hash[:envelope][:body][method_response], nfe_method: method_wsdl)
					end

					def content_xml
						canonicalize(xml_builder).gsub('<Temp>','').gsub('</Temp>','')
					end

				private

					def tag_dados_servico(xml, rps)
						xml.Servico {
							xml.ItemListaServico          rps.item_lista_servico
							xml.CodigoCnae                rps.codigo_cnae                 if rps.codigo_cnae.present?
							xml.CodigoTributacaoMunicipio rps.codigo_tributacao_municipio if rps.codigo_tributacao_municipio.present?
							xml.Discriminacao             rps.discriminacao
							xml.CodigoMunicipio           rps.codigo_municipio

							xml.Valores {
								xml.ValorServicos    rps.valor_servicos   # Valores obrigatórios
								xml.IssRetido        rps.iss_retido       # Valores obrigatórios
								xml.BaseCalculo      rps.base_calculo     # Valores obrigatórios
								
								xml.ValorDeducoes    rps.valor_deducoes   if rps.valor_deducoes.present?
								xml.ValorPis         rps.valor_pis        if rps.valor_pis.present?
								xml.ValorCofins      rps.valor_cofins     if rps.valor_cofins.present?
								xml.ValorInss        rps.valor_inss       if rps.valor_inss.present?
								xml.ValorIr          rps.valor_ir         if rps.valor_ir.present?
								xml.ValorCsll        rps.valor_csll       if rps.valor_csll.present?
								xml.ValorIss         rps.valor_iss        if rps.valor_iss.present?
								xml.OutrasRetencoes  rps.outras_retencoes if rps.outras_retencoes.present?
								xml.Aliquota         rps.aliquota         if rps.aliquota.present?
							}
						}
					end

					def tag_prestador(xml)
						xml.Prestador { 
							tag_cpf_cnpj(xml, emitente.cnpj)
							xml.InscricaoMunicipal emitente.inscricao_municipal if emitente.inscricao_municipal.present?
						}
					end
					
					def tag_intermediario_servico(xml, intermediario)
						return unless intermediario
						xml.IntermediarioServico{
							xml.RazaoSocial intermediario.razao_social
							xml.CpfCnpj{
								tag_cpf_cnpj(xml, intermediario.cpf_cnpj)
							}
							xml.InscricaoMunicipal intermediario.inscricao_municipal if intermediario.inscricao_municipal.present?
						}
					end

					def tag_condicao_pagamento(xml, rps)
						return unless rps.condicao_pagamento
						xml.CondicaoPagamento{
							xml.Condicao   rps.condicao_pagamento.condicao
							if rps.condicao_pagamento.parcelas.size > 0
								xml.QtdParcela rps.condicao_pagamento.parcelas.size 
								rps.condicao_pagamento.parcelas.each_with_index do |parcela, i|
									xml.Parcelas{
										xml.Parcela        i+1
										xml.DataVencimento data_formatada(parcela[:vencimento])
										xml.Valor          parcela[:valor]
									}
								end
							end
						}
					end
				end
			end
		end
	end
end