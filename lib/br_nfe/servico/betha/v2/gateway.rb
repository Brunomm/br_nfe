module BrNfe
	module Servico
		module Betha
			module V2
				class Gateway < BrNfe::Servico::Betha::Base
					
					attr_accessor :numero_nfse
					attr_accessor :codigo_cancelamento

					def namespaces
						{"xmlns:e" => "http://www.betha.com.br/e-nota-contribuinte-ws"}
					end

					def namespace_identifier
						:e
					end

					def version
						:v2
					end

					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/nfseWS?wsdl"
					end

					def request
						set_response( client_wsdl.call(method_wsdl, message: "#{cabecalho}#{content_xml}") )
					end

					def set_response(resp)
						method_response = (method_wsdl.to_s + "_response").to_sym
						@response = BrNfe::Servico::Betha::V2::Response.new(xml: resp.hash[:envelope][:body][method_response][:return], nfe_method: method_wsdl)
					end

					def cabecalho
						Nokogiri::XML::Builder.new do
							nfseCabecMsg do
								cdata(Nokogiri::XML::Builder.new do |xml|
									xml.cabecalho(xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws", versao: "2.02"){
										xml.versaoDados 2.02
									}
								end.doc.root)
							end
						end.doc.root.to_s.gsub(/\n/,'').gsub(/\t/,'')
					end

					def content_xml
						Nokogiri::XML::Builder.new do	
							nfseDadosMsg do
								cdata(xml_builder)
							end
						end.doc.root.to_s
					end
					
				private

					def format_data_xml_for_signature(data_xml)
						xml = Nokogiri::XML(data_xml.to_s, &:noblanks)
						node_name = xml.root.node_name
						xml = xml.root.xpath("//#{node_name}")
						xml.attr("xmlns", "http://www.betha.com.br/e-nota-contribuinte-ws")
						canonicalize xml.to_s
					end

					def tag_intermediario_servico(xml, intermediario)
						return unless intermediario
						xml.Intermediario{
							xml.IdentificacaoIntermediario{
								xml.CpfCnpj{
									tag_cpf_cnpj(xml, intermediario.cpf_cnpj)
								}
								xml.InscricaoMunicipal intermediario.inscricao_municipal unless intermediario.inscricao_municipal.blank?
							}
							xml.RazaoSocial intermediario.razao_social
						}
					end

					def tag_prestador(xml)
						xml.Prestador{ 
							xml.CpfCnpj{
								tag_cpf_cnpj(xml, emitente.cnpj)
							}
							xml.InscricaoMunicipal emitente.inscricao_municipal if !emitente.inscricao_municipal.blank? && env == :production
						}						
					end

					def tag_dados_servico(xml, rps)
						xml.Servico {
							xml.Valores {
								xml.ValorServicos          rps.valor_servicos
								xml.ValorDeducoes          rps.valor_deducoes          unless rps.valor_deducoes.blank?
								xml.ValorPis               rps.valor_pis               unless rps.valor_pis.blank?
								xml.ValorCofins            rps.valor_cofins            unless rps.valor_cofins.blank?
								xml.ValorInss              rps.valor_inss              unless rps.valor_inss.blank?
								xml.ValorIr                rps.valor_ir                unless rps.valor_ir.blank?
								xml.ValorCsll              rps.valor_csll              unless rps.valor_csll.blank?
								xml.OutrasRetencoes        rps.outras_retencoes        unless rps.outras_retencoes.blank?
								xml.ValorIss               rps.valor_iss               unless rps.valor_iss.blank?
								xml.Aliquota               rps.aliquota                unless rps.aliquota.blank?
								xml.DescontoIncondicionado rps.desconto_incondicionado unless rps.desconto_incondicionado.blank?
								xml.DescontoCondicionado   rps.desconto_condicionado   unless rps.desconto_condicionado.blank?
							}


							xml.IssRetido                 rps.iss_retido
							xml.ResponsavelRetencao       rps.responsavel_retencao        unless rps.responsavel_retencao.blank?
							xml.ItemListaServico          rps.item_lista_servico
							xml.CodigoCnae                rps.codigo_cnae                 unless rps.codigo_cnae.blank?
							xml.CodigoTributacaoMunicipio rps.codigo_tributacao_municipio unless rps.codigo_tributacao_municipio.blank?
							xml.Discriminacao             rps.discriminacao
							xml.CodigoMunicipio           rps.codigo_municipio
							# Não posso enviar o CodigoPais se a exigibilidade_iss não for 4 (exportação) - by bethagambis.com
							xml.CodigoPais                rps.codigo_pais          if !rps.codigo_pais.blank? && rps.exigibilidade_iss == '4'
							xml.ExigibilidadeISS          rps.exigibilidade_iss
							xml.MunicipioIncidencia       rps.municipio_incidencia unless rps.municipio_incidencia.blank?
							xml.NumeroProcesso            rps.numero_processo      unless rps.numero_processo.blank?
						}
					end

					def xml_inf_declaracao_prestacao_servico(rps)
						Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
							xml.InfDeclaracaoPrestacaoServico('Id' => "rps#{rps.numero}") {
								xml.Rps { 
									tag_identificacao_rps(xml, rps)

									xml.DataEmissao data_formatada(rps.data_emissao)
									xml.Status      rps.status

									tag_rps_substituido(xml, rps)									
								} 

								# Dia, mês e ano da prestação do serviço
								# Quando houver RPS, a nota será gerada com base na <DataEmissao> do RPS, caso contrário utilizará a <Competencia>
								xml.Competencia data_formatada(rps.competencia)

								tag_dados_servico(xml, rps)

								tag_prestador(xml)

								tag_dados_tomador(xml, rps.destinatario)

								tag_intermediario_servico(xml, rps.intermediario)
								
								tag_dados_construcao_civil(xml, rps)

								# Código de identificação do regime especial de tributação: (1)Microempresa municipal, (2)Estimativa, (3)Sociedade de profissionais, (4)Cooperativa, (5)Microempresário Individual (MEI), (6)Microempresário e Empresa de Pequeno Porte (ME EPP) , 
								xml.RegimeEspecialTributacao emitente.regime_especial_tributacao unless emitente.regime_especial_tributacao.blank? 
								
								xml.OptanteSimplesNacional   emitente.optante_simples_nacional # (1)sim ----- (2)não
								xml.IncentivoFiscal          emitente.incentivo_fiscal # (1)sim ----- (2)não
								
							}
						end
					end

					def xml_rps_assinado(rps)
						Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
							xml.Rps{
								arps = xml_inf_declaracao_prestacao_servico(rps).doc.root
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( arps.to_s )
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( assinatura_xml( arps.to_s, "#rps#{rps.numero}" ) )
							}
						end
					end

					def xml_pedido_cancelamento_assinado
						xml = Nokogiri::XML::Builder.new do |xml|
							xml.Pedido {
								inf_pedido_cancelamento = xml_inf_pedido_cancelamento.doc.root

								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( inf_pedido_cancelamento.to_s )
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( assinatura_xml(inf_pedido_cancelamento.to_s, "#nf#{numero_nfse}") )
							}							
						end						
					end

					def xml_inf_pedido_cancelamento
						Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
							xml.InfPedidoCancelamento(Id: "nf#{numero_nfse}"){
								xml.IdentificacaoNfse{
									xml.Numero numero_nfse
									xml.CpfCnpj{
										tag_cpf_cnpj(xml, emitente.cnpj)
									}
									xml.InscricaoMunicipal emitente.inscricao_municipal if emitente.inscricao_municipal.present? && env == :production
									xml.CodigoMunicipio    emitente.endereco.codigo_municipio
								}
								xml.CodigoCancelamento codigo_cancelamento								
							}
						end
					end

				end
			end
		end
	end
end