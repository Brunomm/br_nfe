module BrNfe
	module Servico
		module Betha
			class Base < BrNfe::Servico::Base

				def version					
				end
				
			private

				def tag_identificacao_rps(xml, rps)
					xml.IdentificacaoRps { 
						dados_identificacao_rps(xml, rps)
					}
				end

				def tag_rps_substituido(xml, rps)
					return unless rps.contem_substituicao?
					xml.RpsSubstituido{
						dados_identificacao_rps(xml, rps, true)
					}
				end

				def dados_identificacao_rps(xml, rps, substituicao = false)
					xml.Numero BrNfe::Helper.only_number((substituicao ? rps.numero_substituicao : rps.numero)).max_size(15)
					xml.Serie  "#{(substituicao ? rps.serie_substituicao  : rps.serie)}".max_size(5)
					xml.Tipo   "#{(substituicao ? rps.tipo_substituicao   : rps.tipo)}".max_size(1)
				end

				def tag_dados_tomador(xml, destinatario)
					xml.Tomador{
						xml.IdentificacaoTomador { 
							xml.CpfCnpj {
								tag_cpf_cnpj(xml, destinatario.cpf_cnpj)
							}
							xml.InscricaoMunicipal "#{destinatario.inscricao_municipal}".max_size(15) if destinatario.inscricao_municipal.present?
							xml.InscricaoEstadual  "#{destinatario.inscricao_estadual}".max_size(15)  if destinatario.inscricao_estadual.present? && version == :v1
						}
						xml.RazaoSocial "#{destinatario.razao_social}".max_size(115)

						tag_endereco(xml, destinatario.endereco)
						
						xml.Contato { 
							xml.Telefone BrNfe::Helper.only_number(destinatario.telefone).max_size(11) unless destinatario.telefone.blank?
							xml.Email    "#{destinatario.email}".max_size(80)                          unless destinatario.email.blank?
						}
					}
				end

				def tag_endereco(xml, endereco)
					xml.Endereco { 
						xml.Endereco        "#{endereco.logradouro}".max_size(125)
						xml.Numero          "#{endereco.numero}".max_size(10)
						xml.Complemento     "#{endereco.complemento}".max_size(60)
						xml.Bairro          "#{endereco.bairro}".max_size(60)
						xml.CodigoMunicipio "#{endereco.codigo_municipio}".max_size(7)
						xml.Uf              "#{endereco.uf}".max_size(2)
						xml.Cep             BrNfe::Helper.only_number(endereco.cep).max_size(8)
						# xml.CodigoPais      endereco.codigo_pais if version == :v2
					}
				end

				def tag_dados_construcao_civil(xml, rps)
					return if rps.codigo_obra.blank? || rps.codigo_art.blank?
					xml.ConstrucaoCivil{
						xml.CodigoObra "#{rps.codigo_obra}".max_size(15)
						xml.Art        "#{rps.codigo_art}".max_size(15)
					}
				end
				
			end
		end
	end
end