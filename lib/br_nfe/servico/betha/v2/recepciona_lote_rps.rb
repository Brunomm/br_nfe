module BrNfe
	module Servico
		module Betha
			module V2
				class RecepcionaLoteRps < BrNfe::Servico::Betha::V2::Gateway
					def method_wsdl
						:recepcionar_lote_rps
					end

					def xml_builder
						xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
							xml.EnviarLoteRpsEnvio(xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws") {
								xml_lote_rps = lote_rps_xml.doc

								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( canonicalize(xml_lote_rps.root) )
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( assinatura_xml(xml_lote_rps.root.to_s, '#lote1654564') )
							}
						end.doc
						
						canonicalize(xml.root())
					end

					
					def lote_rps_xml
						xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
							xml.LoteRps("Id" => "lote#{numero_lote_rps}", versao: "2.02"){
								xml.NumeroLote numero_lote_rps
								xml.CpfCnpj {
									tag_cpf_cnpj(xml, emitente.cnpj)
								}
								# O Ambiente de homologação da Betha não aceita Inscrição Municipal (baita ambiente de homologação)
								xml.InscricaoMunicipal emitente.inscricao_municipal if env == :production

								xml.QuantidadeRps lote_rps.size
								xml.ListaRps {
									xml.Rps do |xml_rps|
										lote_rps.each do |rps|
											arps = rps_xml(rps).doc
											xml_rps.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( canonicalize(arps.root) ) 
											xml_rps.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( assinatura_xml( arps.root.to_s, "#rps#{rps.numero}" ) )
										end
									end
								}
							}						
						end
					end

					def rps_xml(rps)
						Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
							xml.InfDeclaracaoPrestacaoServico('Id' => "rps#{rps.numero}") {
								xml.Rps { 
									xml.IdentificacaoRps { 
										xml.Numero rps.numero
										xml.Serie  rps.serie
										xml.Tipo   rps.tipo
									}
									xml.DataEmissao data_formatada(rps.data_emissao)
									xml.Status rps.status
									# xml.RpsSubstituido{
										# xml.Numero '99999'
										# xml.Serie  '99999'
										# xml.Tipo   '99999'
									# }
								} 
								# Dia, mês e ano da prestação do serviço
								# Quando houver RPS, a nota será gerada com base na <DataEmissao> do RPS, caso contrário utilizará a <Competencia>
								xml.Competencia data_formatada(rps.competencia)

								xml.Servico {
									xml.Valores {
										xml.ValorServicos          "#{rps.valor_servicos}"
										xml.ValorDeducoes          "#{rps.valor_deducoes}"
										xml.ValorPis               "#{rps.valor_pis}"
										xml.ValorCofins            "#{rps.valor_cofins}"
										xml.ValorInss              "#{rps.valor_inss}"
										xml.ValorIr                "#{rps.valor_ir}"
										xml.ValorCsll              "#{rps.valor_csll}"
										xml.OutrasRetencoes        "#{rps.outras_retencoes}"
										xml.ValorIss               "#{rps.valor_iss}"
										xml.Aliquota               "#{rps.aliquota}"
										xml.DescontoIncondicionado "#{rps.desconto_incondicionado}"
										xml.DescontoCondicionado   "#{rps.desconto_condicionado}"
									}

									# xml.ResponsavelRetencao       '0'
									# xml.CodigoCnae                '6202300'
									# xml.CodigoPais                '0'
									# xml.NumeroProcesso            '0'

									xml.IssRetido                 rps.iss_retido
									xml.ItemListaServico          rps.item_lista_servico
									xml.CodigoTributacaoMunicipio rps.codigo_tributacao_municipio
									xml.Discriminacao             rps.discriminacao
									xml.CodigoMunicipio           rps.codigo_municipio
									xml.ExigibilidadeISS          '1'
									xml.MunicipioIncidencia       '4204202'
								}
								xml.Prestador { 
									xml.CpfCnpj { 
										tag_cpf_cnpj(xml, '18113831000135')
									}
									# O Ambiente de homologação da Betha não aceita Inscrição Municipal (baita ambiente de homologação)
									xml.InscricaoMunicipal '42615-6' if env == :production
								}
								xml.Tomador{
									xml.IdentificacaoTomador { 
										xml.CpfCnpj {
											tag_cpf_cnpj(xml, '18077391000108')
										}
										# xml.InscricaoMunicipal '00130320'
									}
									xml.RazaoSocial 'I9K SOLUCOES TECNOLOGICAS LTDA'
									xml.Endereco { 
										xml.Endereco        'R JERUSALEM'
										xml.Numero          '61'
										xml.Complemento     'E SALAS 06 E 07'
										xml.Bairro          'PASSO DOS FORTES'
										xml.CodigoMunicipio '4204202'
										xml.Uf              'SC'
										xml.CodigoPais      '1058'
										xml.Cep             '89805675'
									}
									xml.Contato { 
										xml.Telefone '4835220026'
										xml.Email    'luiz.alves@cxpostal.com'
									}
								}

								# xml.Intermediario{
								# 	xml.IdentificacaoIntermediario{
								# 		xml.CpfCnpj{
								# 			tag_cpf_cnpj(xml, '18077391000108')
								# 		}
								# 		xml.InscricaoMunicipal '0000'
								# 	}
								# 	xml.RazaoSocial '13'
								# }
								# xml.ConstrucaoCivil{
								# 	xml.CodigoObra '0'
								# 	xml.Art        '0'
								# }
								xml.OptanteSimplesNacional   '1' # (1)sim ----- (2)não
								xml.IncentivoFiscal          '2' # (1)sim ----- (2)não
								# xml.RegimeEspecialTributacao '1' # Código de identificação do regime especial de tributação: (1)Microempresa municipal, (2)Estimativa, (3)Sociedade de profissionais, (4)Cooperativa, (5)Microempresário Individual (MEI), (6)Microempresário e Empresa de Pequeno Porte (ME EPP) , 
								
							}
						end
					end
				end
			end
		end
	end
end