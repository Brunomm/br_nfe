module BrNfe
	module Servico
		module Betha
			class Base < BrNfe::Servico::Base

				def version					
				end
				
			private

				def xml_identificacao_rps(rps)
					Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
						xml.IdentificacaoRps { 
							dados_identificacao_rps(xml, rps)
						}
					end
				end

				def xml_rps_substituido(rps)
					return Nokogiri::XML::Builder.new unless rps.replace_invoice?
					Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
						xml.RpsSubstituido { 
							dados_identificacao_rps(xml, rps, true)
						}
					end
				end

				def dados_identificacao_rps(xml, rps, substituicao = false)
					xml.Numero BrNfe::Helper.only_number((substituicao ? rps.numero_substituicao : rps.numero)).max_size(15)
					xml.Serie  "#{(substituicao ? rps.serie_substituicao  : rps.serie)}".max_size(5)
					xml.Tipo   "#{(substituicao ? rps.tipo_substituicao   : rps.tipo)}".max_size(1)
				end

				def xml_dados_tomador(destinatario)
					Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
						xml.Tomador{
							xml.IdentificacaoTomador { 
								xml.CpfCnpj {
									tag_cpf_cnpj(xml, destinatario.cpf_cnpj)
								}
								xml.InscricaoMunicipal "#{destinatario.inscricao_municipal}".max_size(15) if destinatario.inscricao_municipal.present?
								xml.InscricaoEstadual  "#{destinatario.inscricao_estadual}".max_size(15)  if destinatario.inscricao_estadual.present? && version == :v1
							}
							xml.RazaoSocial "#{destinatario.razao_social}".max_size(115)

							# endereço
							xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_endereco(destinatario.endereco).doc.root.to_s )
							
							xml.Contato { 
								xml.Telefone BrNfe::Helper.only_number(destinatario.telefone).max_size(11) unless destinatario.telefone.blank?
								xml.Email    "#{destinatario.email}".max_size(80)                          unless destinatario.email.blank?
							}
						}
					end
				end

				def xml_endereco(endereco, cod_pais=false)
					Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
						xml.Endereco { 
							xml.Endereco        "#{endereco.logradouro}".max_size(125)
							xml.Numero          "#{endereco.numero}".max_size(10)
							xml.Complemento     "#{endereco.complemento}".max_size(60)
							xml.Bairro          "#{endereco.bairro}".max_size(60)
							xml.CodigoMunicipio BrNfe::Helper.only_number(endereco.codigo_municipio).max_size(7)
							xml.Uf              "#{endereco.uf}".max_size(2)
							xml.Cep             BrNfe::Helper.only_number(endereco.cep).max_size(8)
							xml.CodigoPais      BrNfe::Helper.only_number(endereco.codigo_pais).max_size(4) if version == :v2 && cod_pais
						}
					end
				end

				def xml_dados_construcao_civil(rps)
					return Nokogiri::XML::Builder.new if rps.codigo_obra.blank? || rps.codigo_art.blank?
					Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
						xml.ConstrucaoCivil{
							xml.CodigoObra "#{rps.codigo_obra}".max_size(15)
							xml.Art        "#{rps.codigo_art}".max_size(15)
						}
					end
				end
				
			end
		end
	end
end