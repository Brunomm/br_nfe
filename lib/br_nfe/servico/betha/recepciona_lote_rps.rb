module BrNfe
	module Servico
		module Betha
			class RecepcionaLoteRps < BrNfe::Servico::Betha::Gateway
				def method_wsdl
					:recepcionar_lote_rps
				end

				def xml_builder
					# (dados_xml.to_s.gsub("&","&amp;").gsub(">","&gt;").gsub("<","&lt;").gsub("\"","&quot;").gsub("'","&apos;")).gsub(/\n/,'')
					(assinar(dados_xml, '').to_s.gsub("&","&amp;").gsub(">","&gt;").gsub("<","&lt;").gsub("\"","&quot;").gsub("'","&apos;")).gsub(/\n/,'')
				end

				def dados_xml
					builder = Nokogiri::XML::Builder.new do |xml|
						xml.send("RecepcionaLoteRpsEnvio", xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws" ) {
							xml.LoteRps("Id" => "lote1", versao: "2.02"){
								xml.NumeroLote '2012048'
								xml.CpfCnpj {
									xml.Cnpj '45111111111100'
								}
								xml.InscricaoMunicipal "123498"
								xml.QuantidadeRps "1"
								xml.ListaRps {
									xml.Rps {
										rps_xml(xml)
										
										xml.cdata assinatura_node(
											Nokogiri::XML( 
												xml.to_xml( save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION ) 
											), 
											'#lote1'
										)
									}
								}
							}
						}
					end
					Nokogiri::XML( builder.to_xml( :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION ) )
				end

				def rps_xml(xml)
					xml.InfDeclaracaoPrestacaoServico('Id' => "rps1") {
						xml.Rps { 
							xml.IdentificacaoRps { 
								xml.Numero "43"
								xml.Serie  "A1"
								xml.Tipo   "1"
							}
							xml.DataEmissao '2014-12-06'
							xml.Status '1'
						} 
						xml.Competencia '2014-12-01'
						xml.Servico {
							xml.Valores {
								xml.ValorServicos          '100'
								xml.ValorDeducoes          '0'
								xml.ValorPis               '0'
								xml.ValorCofins            '0'
								xml.ValorInss              '0'
								xml.ValorIr                '0'
								xml.ValorCsll              '0'
								xml.OutrasRetencoes        '0'
								xml.DescontoIncondicionado '0'
								xml.DescontoCondicionado   '0'
							}
							xml.IssRetido                 '2'
							xml.ItemListaServico          '0702'
							xml.CodigoTributacaoMunicipio '2525'
							xml.Discriminacao             'Prog.'
							xml.CodigoMunicipio           '4204608'
							xml.ExigibilidadeISS          '1'
							xml.MunicipioIncidencia       '4204608'
						}
						xml.Prestador { 
							xml.CpfCnpj { 
								xml.Cnpj  '45111111111100'
							}
							xml.InscricaoMunicipal '123498'
						}
						xml.Tomador{
							xml.IdentificacaoTomador { 
								xml.CpfCnpj { 
									xml.Cnpj '83787494000123'
								}						
							}
							xml.RazaoSocial 'INSTITUICAO FINANCEIRA'
							xml.Endereco { 
								xml.Endereco        'AV. 7 DE SETEMBRO'
								xml.Numero          '1505'
								xml.Complemento     'AO LADO DO JOAO AUTOMOVEIS'
								xml.Bairro          'CENTRO'
								xml.CodigoMunicipio '4201406'
								xml.Uf              'SC'
								xml.Cep             '88900000'
							}
							xml.Contato { 
								xml.Telefone '4835220026'
								xml.Email    'luiz.alves@cxpostal.com'
							}
						}
						xml.Intermediario { 
							xml.IdentificacaoIntermediario {
								xml.CpfCnpj { 
									xml.Cnpj '06410987065144'
								}
								xml.InscricaoMunicipal '22252'
							}
							xml.RazaoSocial 'CONSTRUTORA TERRA FIRME'
						}
						xml.ConstrucaoCivil {
							xml.CodigoObra '142'
							xml.Art        '1/2014'
						}
						xml.RegimeEspecialTributacao '3'
						xml.OptanteSimplesNacional   '2'
						xml.IncentivoFiscal          '2'
					}
					xml
				end
				 
			end
		end
	end
end