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
					rescue Savon::SOAPFault => error
						return @response = BrNfe::Servico::Response::Default.new(success: false, error_messages: [error.message])
					end

					def set_response(resp)
						method_response = (method_wsdl.to_s + "_envio_response").to_sym
						@response = BrNfe::Servico::Betha::V1::BuildResponse.new(hash: resp.hash[:envelope][:body][method_response], nfe_method: method_wsdl).response
					end

					def content_xml
						canonicalize(xml_builder).gsub('<Temp>','').gsub('</Temp>','')
					end

				private

					def tag_dados_servico(xml, rps)
						xml.Servico {
							xml.ItemListaServico          "#{rps.item_lista_servico}".rjust(4,'0').max_size(4)
							xml.CodigoCnae                BrNfe::Helper.only_number(rps.codigo_cnae).max_size(7) unless rps.codigo_cnae.blank?
							xml.CodigoTributacaoMunicipio rps.codigo_tributacao_municipio unless rps.codigo_tributacao_municipio.blank?
							xml.Discriminacao             "#{rps.discriminacao}".max_size(2_000).remove_accents
							xml.CodigoMunicipio           "#{rps.codigo_municipio}".max_size(7)

							xml.Valores {
								xml.ValorServicos    value_monetary(rps.valor_servicos,   4) # Valores obrigatórios
								xml.IssRetido        value_true_false(rps.iss_retido?)       # Valores obrigatórios
								xml.BaseCalculo      value_monetary(rps.base_calculo,     4) # Valores obrigatórios								
								xml.ValorDeducoes    value_monetary(rps.valor_deducoes,   4) unless rps.valor_deducoes.blank?
								xml.ValorPis         value_monetary(rps.valor_pis,        4) unless rps.valor_pis.blank?
								xml.ValorCofins      value_monetary(rps.valor_cofins,     4) unless rps.valor_cofins.blank?
								xml.ValorInss        value_monetary(rps.valor_inss,       4) unless rps.valor_inss.blank?
								xml.ValorIr          value_monetary(rps.valor_ir,         4) unless rps.valor_ir.blank?
								xml.ValorCsll        value_monetary(rps.valor_csll,       4) unless rps.valor_csll.blank?
								xml.ValorIss         value_monetary(rps.valor_iss,        4) unless rps.valor_iss.blank?
								xml.OutrasRetencoes  value_monetary(rps.outras_retencoes, 4) unless rps.outras_retencoes.blank?
								xml.Aliquota         value_monetary(rps.aliquota,         4) unless rps.aliquota.blank?
							}
						}
					end

					def tag_prestador(xml)
						xml.Prestador { 
							tag_cpf_cnpj(xml, emitente.cnpj)
							xml.InscricaoMunicipal "#{emitente.inscricao_municipal}".max_size(15) if !emitente.inscricao_municipal.blank? && env == :production
						}
					end
					
					def tag_intermediario_servico(xml, intermediario)
						return unless intermediario
						xml.IntermediarioServico{
							xml.RazaoSocial "#{intermediario.razao_social}".max_size(115)
							xml.CpfCnpj{
								tag_cpf_cnpj(xml, intermediario.cpf_cnpj)
							}
							xml.InscricaoMunicipal "#{intermediario.inscricao_municipal}".max_size(15) unless intermediario.inscricao_municipal.blank?
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
										xml.DataVencimento value_date(parcela[:vencimento])
										xml.Valor          value_monetary(parcela[:valor], 4)
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