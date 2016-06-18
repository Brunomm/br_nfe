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
						@builder =  BrNfe::Servico::Betha::V1::BuildResponse.new(hash: resp.hash[:envelope][:body][method_response], nfe_method: method_wsdl)
						@original_response = @builder.messages
						@response          = @builder.response
					end

					def content_xml
						canonicalize(xml_builder).gsub('<Temp>','').gsub('</Temp>','')
					end

				private

					def xml_dados_servico(rps)
						Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
							xml.Servico {
								xml.ItemListaServico          BrNfe::Helper.only_number(rps.item_lista_servico).rjust(4,'0').max_size(4)
								xml.CodigoCnae                BrNfe::Helper.only_number(rps.cnae_code).max_size(7) unless rps.cnae_code.blank?
								xml.CodigoTributacaoMunicipio rps.codigo_tributacao_municipio unless rps.codigo_tributacao_municipio.blank?
								xml.Discriminacao             "#{rps.description}".max_size(2_000).remove_accents
								xml.CodigoMunicipio           "#{rps.codigo_municipio}".max_size(7)

								xml.Valores {
									xml.ValorServicos    value_monetary(rps.total_services,   4) # Valores obrigatórios
									xml.IssRetido        value_true_false(rps.iss_retained?)       # Valores obrigatórios
									xml.BaseCalculo      value_monetary(rps.base_calculation, 4) # Valores obrigatórios								
									xml.ValorDeducoes    value_monetary(rps.deductions,       4) unless rps.deductions.blank?
									xml.ValorPis         value_monetary(rps.valor_pis,        4) unless rps.valor_pis.blank?
									xml.ValorCofins      value_monetary(rps.valor_cofins,     4) unless rps.valor_cofins.blank?
									xml.ValorInss        value_monetary(rps.valor_inss,       4) unless rps.valor_inss.blank?
									xml.ValorIr          value_monetary(rps.valor_ir,         4) unless rps.valor_ir.blank?
									xml.ValorCsll        value_monetary(rps.valor_csll,       4) unless rps.valor_csll.blank?
									xml.ValorIss         value_monetary(rps.total_iss,        4) unless rps.total_iss.blank?
									xml.OutrasRetencoes  value_monetary(rps.outras_retencoes, 4) unless rps.outras_retencoes.blank?
									xml.Aliquota         value_monetary(rps.iss_tax_rate,     4) unless rps.iss_tax_rate.blank?
								}
							}
						end
					end

					def xml_prestador
						Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
							xml.Prestador { 
								tag_cpf_cnpj(xml, emitente.cnpj)
								xml.InscricaoMunicipal "#{emitente.inscricao_municipal}".max_size(15) if !emitente.inscricao_municipal.blank? && env == :production
							}
						end
					end
					
					def xml_intermediario_servico(intermediario)
						return Nokogiri::XML::Builder.new unless intermediario
						Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
							xml.IntermediarioServico{
								xml.RazaoSocial "#{intermediario.razao_social}".max_size(115)
								xml.CpfCnpj{
									tag_cpf_cnpj(xml, intermediario.cpf_cnpj)
								}
								xml.InscricaoMunicipal "#{intermediario.inscricao_municipal}".max_size(15) unless intermediario.inscricao_municipal.blank?
							}
						end
					end

					def xml_condicao_pagamento(rps)
						return Nokogiri::XML::Builder.new unless rps.condicao_pagamento
						Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
							xml.CondicaoPagamento{
								xml.Condicao   rps.condicao_pagamento.condicao
								if rps.condicao_pagamento.parcelas.size > 0
									xml.QtdParcela rps.condicao_pagamento.parcelas.size 
									rps.condicao_pagamento.parcelas.each_with_index do |parcela, i|
										#
										# Aqui há uma ressalva:
										# Na documentação diz que a DataVencimento deve ser do tipo DateTime
										# Porém não é nem do tipo DateTime e nem do tipo Date, mas sim uma String
										# no formato DD/MM/YYYY <- by bethagambis.com
										#
										vencimento = get_date(parcela[:vencimento])
										xml.Parcelas{
											xml.Parcela        i+1
											xml.DataVencimento "#{vencimento.day.to_s.rjust(2, '0')}/#{vencimento.month.to_s.rjust(2, '0')}/#{vencimento.year}" if vencimento
											xml.Valor          value_monetary(parcela[:valor], 4)
										}
									end
								end
							}
						end
					end

					def get_date(value)
						Date.parse(value.to_s)
					rescue
					end
				end
			end
		end
	end
end