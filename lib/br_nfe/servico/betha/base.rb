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
					xml.Numero (substituicao ? rps.numero_substituicao : rps.numero)
					xml.Serie  (substituicao ? rps.serie_substituicao  : rps.serie)
					xml.Tipo   (substituicao ? rps.tipo_substituicao   : rps.tipo)
				end

				def tag_dados_tomador(xml, destinatario)
					xml.Tomador{
						xml.RazaoSocial destinatario.razao_social
						
						xml.IdentificacaoTomador { 
							xml.CpfCnpj {
								tag_cpf_cnpj(xml, destinatario.cpf_cnpj)
							}
							xml.InscricaoMunicipal destinatario.inscricao_municipal if destinatario.inscricao_municipal.present?
							xml.InscricaoEstadual  destinatario.inscricao_estadual  if destinatario.inscricao_estadual.present? && version == :v1
						}

						tag_endereco(xml, destinatario.endereco)
						
						xml.Contato { 
							xml.Telefone destinatario.telefone
							xml.Email    destinatario.email
						}
					}
				end

				def tag_endereco(xml, endereco)
					xml.Endereco { 
						xml.Endereco        endereco.logradouro
						xml.Numero          endereco.numero
						xml.Complemento     endereco.complemento
						xml.Bairro          endereco.bairro
						xml.CodigoMunicipio endereco.codigo_municipio
						xml.Uf              endereco.uf
						xml.Cep             endereco.cep
						xml.CodigoPais      endereco.codigo_pais if version == :v2
					}
				end

				def tag_dados_construcao_civil(xml, rps)
					return if rps.codigo_obra.blank? || rps.codigo_art.blank?
					xml.ConstrucaoCivil{
						xml.CodigoObra rps.codigo_obra
						xml.Art        rps.codigo_art
					}
				end
				
			end
		end
	end
end