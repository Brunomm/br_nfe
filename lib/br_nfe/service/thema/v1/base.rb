module BrNfe
	module Service
		module Thema
			module V1
				class Base < BrNfe::Service::Base
					
					def gateway
						{
							'4205902' => { # Gaspar-SC
								send:    "http://nfse#{'hml' if env == :test}.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl",
								consult: "http://nfse#{'hml' if env == :test}.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl",
								cancel:  "http://nfse#{'hml' if env == :test}.gaspar.sc.gov.br/nfse/services/NFSEcancelamento?wsdl"
								# Documentação: http://gpm.fecam.org.br/gaspar/cms/pagina/ver/codMapaItem/24571#.UukfYD1TtR0
							}, 

							'4303103' => { # Cachoeirinha-RS 
								send:    "http://nfse#{'homologacao' if env == :test}.cachoeirinha.rs.gov.br/nfse/services/NFSEremessa?wsdl",
								consult: "http://nfse#{'homologacao' if env == :test}.cachoeirinha.rs.gov.br/nfse/services/NFSEconsulta?wsdl",
								cancel:  "http://nfse#{'homologacao' if env == :test}.cachoeirinha.rs.gov.br/nfse/services/NFSEcancelamento?wsdl"
								# Documentação: http://www.cachoeirinha.rs.gov.br/portal/index.php/desenvolvedores
							},

							'4307708' => { # Esteio-RS 
								send:    "http://grp.esteio.rs.gov.br/nfse#{'hml' if env == :test}/services/NFSEremessa?wsdl",
								consult: "http://grp.esteio.rs.gov.br/nfse#{'hml' if env == :test}/services/NFSEconsulta?wsdl",
								cancel:  "http://grp.esteio.rs.gov.br/nfse#{'hml' if env == :test}/services/NFSEcancelamento?wsdl"
								# Documentação: https://www.esteio.rs.gov.br/index.php?option=com_content&view=article&id=4500&Itemid=292
							},

							'4311403' => { # Lajeado-RS 
								send:    "http://nfse#{'hml' if env == :test}.lajeado.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl",
								consult: "http://nfse#{'hml' if env == :test}.lajeado.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl",
								cancel:  "http://nfse#{'hml' if env == :test}.lajeado.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl"
								# Documentação: http://www.lajeado.rs.gov.br/?titulo=Desenvolvedores&template=hotSite&categoria=956&codigoCategoria=956&tipoConteudo=INCLUDE_MOSTRA_CONTEUDO&idConteudo=3486
							},

							'4312401' => { # Montenegro-RS 
								send:    "https://#{env == :test ? 'nfsehml' : 'nfe'}.montenegro.rs.gov.br/#{env == :test ? 'nfsehml' : 'thema-nfse'}/services/NFSEremessa?wsdl",
								consult: "https://#{env == :test ? 'nfsehml' : 'nfe'}.montenegro.rs.gov.br/#{env == :test ? 'nfsehml' : 'thema-nfse'}/services/NFSEconsulta?wsdl",
								cancel:  "https://#{env == :test ? 'nfsehml' : 'nfe'}.montenegro.rs.gov.br/#{env == :test ? 'nfsehml' : 'thema-nfse'}/services/NFSEcancelamento?wsdl"
								# Documentação: http://www.montenegro.rs.gov.br/home/pagina.asp?titulo=WSDL&categoria=NFSe&codigoCategoria=869&imagemCategoria=topoNotaFiscal.jpg&INC=includes/show_texto.asp&conteudo=2532&servico=
							},

							'4312658' => { # Não-Me-Toque-RS
								send:    "http://nfse.naometoquers.com.br/thema-nfse/services/NFSEremessa?wsdl",
								consult: "http://nfse.naometoquers.com.br/thema-nfse/services/NFSEconsulta?wsdl",
								cancel:  "http://nfse.naometoquers.com.br/thema-nfse/services/NFSEcancelamento?wsdl"
								# NÃO APRESENTA O LINK DA BASE DE HOMOLOGAÇÃO NA DOCUMENTAÇÃO
								# Documentação: http://naometoquers.com.br/servicos/nfse/desenvolvedores/
							},

							'4314100' => { # Passo Fundo-RS 
								send:    "http://nfse#{'homologacao' if env == :test}.pmpf.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl",
								consult: "http://nfse#{'homologacao' if env == :test}.pmpf.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl",
								cancel:  "http://nfse#{'homologacao' if env == :test}.pmpf.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl"
								# Documentação: http://www.pmpf.rs.gov.br/nfse/secao.php?p=90&a=1&pm=1
							},

							'4316808' => { # Santa Cruz do Sul-RS 
								send:    "http://#{env == :test ? 'grphml' : 'nfse'}.santacruz.rs.gov.br/thema-nfse#{'-hml' if env == :test}/services/NFSEremessa?wsdl",
								consult: "http://#{env == :test ? 'grphml' : 'nfse'}.santacruz.rs.gov.br/thema-nfse#{'-hml' if env == :test}/services/NFSEconsulta?wsdl",
								cancel:  "http://#{env == :test ? 'grphml' : 'nfse'}.santacruz.rs.gov.br/thema-nfse#{'-hml' if env == :test}/services/NFSEcancelamento?wsdl"
								# Documentação: http://www.santacruz.rs.gov.br/conteudo/suporte-tecnico
							},

							'4317608' => { # Santo Antônio da Patrulha-RS 
								send:    "http://nfse#{'homologacao' if env == :test}.pmsap.com.br/nfse#{'hml' if env == :test}/services/NFSEremessa?wsdl",
								consult: "http://nfse#{'homologacao' if env == :test}.pmsap.com.br/nfse#{'hml' if env == :test}/services/NFSEconsulta?wsdl",
								cancel:  "http://nfse#{'homologacao' if env == :test}.pmsap.com.br/nfse#{'hml' if env == :test}/services/NFSEcancelamento?wsdl"
								# Documentação: http://www.santoantoniodapatrulha.rs.gov.br/pmsap/NFS-e
							},

							'4318705' => { # São Leopoldo-RS 
								send:    "http://nfe#{'homologacao' if env == :test}.saoleopoldo.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl",
								consult: "http://nfe#{'homologacao' if env == :test}.saoleopoldo.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl",
								cancel:  "http://nfe#{'homologacao' if env == :test}.saoleopoldo.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl"
								# Documentação: http://www.saoleopoldo.rs.gov.br/?titulo=WSDL&template=hotSite&categoria=386&codigoCategoria=386&tipoConteudo=INCLUDE_MOSTRA_CONTEUDO&idConteudo=1825
							},

							'4321204' => { # Taquara-RS 
								send:    "http://nfse#{'homologacao' if env == :test}.taquara.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl",
								consult: "http://nfse#{'homologacao' if env == :test}.taquara.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl",
								cancel:  "http://nfse#{'homologacao' if env == :test}.taquara.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl"
								# Documentação: http://www.taquara.rs.gov.br/?titulo=Desenvolvedores&template=hotSite&categoria=859&codigoCategoria=859&tipoConteudo=INCLUDE_MOSTRA_CONTEUDO&idConteudo=3010
							},

							'4322608' => { # Venâncio Aires-RS 
								send:    "http://nfe#{'hml' if env == :test}.venancioaires.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl",
								consult: "http://nfe#{'hml' if env == :test}.venancioaires.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl",
								cancel:  "http://nfe#{'hml' if env == :test}.venancioaires.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl"
								# Documentação: http://portal.venancioaires.rs.gov.br/index.xhtml?pageId=41
							},
						}
					end

					def get_wsdl_by_city
						if gtw = gateway[ibge_code_of_issuer_city]
							gtw
						else # Default for tdd
							{
								send:    "http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl",
								consult: "http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl",
								cancel:  "http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEcancelamento?wsdl"
							}
						end
						
					end

					# Assinatura através da gem signer
					def signature_type
						:method_sign
					end

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					def message_namespaces
						{"xmlns" => "http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"}
					end

					def soap_namespaces
						super.merge({"xmlns:ns1" => "http://server.nfse.thema.inf.br"})
					end

					# Setado manualmente em content_xml
					#
					def namespace_identifier
					end

					# Método que deve ser sobrescrito em cada subclass.
					# É utilizado para saber qual a tag root de cada requisição
					# 
					# <b><Tipo de retorno: /b> _String_
					#
					def soap_body_root_tag
						# 'recepcionarLoteRps' < Exemplo
						raise "Deve ser sobrescrito nas subclasses"
					end

					def response_encoding
						'ISO-8859-1'
					end

					def nfse_xml_path
						'//*' #Começa o XMl a partir do body e pega a tag ConsultarNfseResposta
					end

					# Método é sobrescrito para atender o padrão do órgão emissor.
					# Deve ser enviado o XML da requsiução dentro da tag CDATA
					# seguindo a estrutura requerida.
					# 
					# <b><Tipo de retorno: /b> _String_ XML
					#
					def content_xml
						xml_signed = xml_builder.html_safe

						dados = "<ns1:#{soap_body_root_tag}>"
						dados += '<ns1:xml>'
						dados += '<![CDATA['
						dados += '<?xml version="1.0" encoding="ISO-8859-1"?>' unless xml_signed.include?('<?xml')
						dados += xml_signed
						dados += ']]>'
						dados += '</ns1:xml>'
						dados += "</ns1:#{soap_body_root_tag}>"
						dados
					end

					# Alíquota. Valor percentual.
					#  Formato: 0.XXXX
					#  Ex: 1% = 0.01
					#  25,5% = 0.255
					#  100% = 1.0
					# Irá receber o valor decimal do percentual da aliquota
					# e irá dividir por 100 conforme indicado na documentação.
					#
					def ts_aliquota value
						value = value.to_f/100
						value_monetary(value, 4)
					end

				end
			end
		end
	end
end