module BrNfe
	module Service
		module Webiss
			module V1
				class Base < BrNfe::Service::Base

					def ssl_request?
						true
					end

					def gateway
						{

							# AL - Alagoas
								# Teotônio Vilela - AL  - '2709152' => "",  (Usa versão 2.2)
								#

							# BA - Bahia
								# Brumado - BA
								'2904605' => "https://www7.webiss.com.br/brumadoba_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Candeias - BA
								'2906501' => "https://www4.webiss.com.br/candeiasba_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Feira de Santana - BA
								'2910800' => "https://feiradesantanaba.webiss.com.br/servicos/wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Guanambi - BA
								'2911709' => "https://www4.webiss.com.br/guanambiba_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Itapetinga - BA
								'2916401' => "https://www5.webiss.com.br/itapetingaba_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Luis Eduardo Magalhães - BA
								'2919553' => "https://www4.webiss.com.br/luiseduardomagalhaesba_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Vitória da Conquista - BA
								'2933307' => "https://www4.webiss.com.br/vitoriadaconquistaba_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								#
								# Ibicaraí - BA  -  '2912103' => "", (Usa versão 2.2)

							# ES - Espírito Santo
								# Cariacica - ES  -  '3201308' => "", (Usa versão 2.2)
								# Viana - ES      -  '3205101' => "", (Não possui integração com WebService)

							# GO - Goiás
								# Caldas Novas - GO
								'5204508' => "https://www3.webiss.com.br/caldasnovasgo_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Planaltina - GO
								'5217609' => "https://www.webiss.com.br/planaltinago_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								#
								# Edealina - GO   - '5207352' => "",  (Usa versão 2.2)

							# PI - Piauí
								# Valença do Piauí - PI - '2211308' => "",  (Não possui integração com WebService)
								#

							# MA - Maranhão
								# Santa Luzia  - '2110005' => "", (Sistema indisponível)
								#

							# MG - Minas Gerais
								# Além Paraiba - MG
								'3101508' => "https://www4.webiss.com.br/alemparaibamg_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Arcos - MG
								'3104205' => "https://www1.webiss.com.br/arcosmg_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Barbacena - MG
								'3105608' => "https://www.webiss.com.br/mgbarbacena_wsNFSe#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Barroso - MG
								'3105905' => "https://www1.webiss.com.br/barrosomg_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Bom Despacho - MG
								'3107406' => "https://www4.webiss.com.br/bomdespachomg_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Camanducaia - MG
								'3110509' => "https://www1.webiss.com.br/camanducaiamg_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Campo Belo - MG
								'3111200' => "https://www1.webiss.com.br/campobelomg_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Campos Altos - MG
								'3111507' => "https://www7.webiss.com.br/camposaltosmg_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Cássia - MG
								'3115102' => "https://www7.webiss.com.br/cassiamg_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Coronel Fabriciano - MG
								'3119401' => "https://www.webiss.com.br/Fabriciano_wsNFSe#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Extrema - MG
								'3125101' => "https://www.webiss.com.br/extremamg_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Formiga - MG
								'3126109' => "https://www1.webiss.com.br/formigamg_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Frutal - MG
								'3127107' => "https://www.webiss.com.br/mgfrutal_wsNFSe#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Jaboticatubas - MG
								'3134608' => "https://www4.webiss.com.br/jaboticatubasmg_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Matozinhos - MG
								'3141108' => "https://www4.webiss.com.br/matozinhosmg_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Nova Serrana - MG
								'3145208' => "https://www1.webiss.com.br/novaserranamg_wsnfse#{'_homolog' if env == :test}/nfseservices.svc?wsdl",
								
								# Passos - MG
								'3147907' => "https://www5.webiss.com.br/passosmg_wsnfse#{'_homolog' if env == :test}/nfseservices.svc?wsdl",
								
								# Prudente de Morais - MG
								'3153608' => "https://www4.webiss.com.br/prudentedemoraismg_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Rio Piracicaba - MG
								'3155702' => "https://www5.webiss.com.br/rioPiracicabaMG_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Santa Bárbara - MG
								'3157203' => "https://www5.webiss.com.br/santabarbaramg_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Santa Rita do Sapucaí - MG
								'3159605' => "https://www.webiss.com.br/santaritadosapucai_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# São Lourenço - MG
								'3163706' => "https://www7.webiss.com.br/saolourencomg_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Uberaba - MG
								'3170107' => "https://www1.webiss.com.br/Uberaba_wsNFSe#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								#
								# Água Comprida               - MG  - '3100708' => "",  (Usa versão 2.2)
								# Baldim                      - MG  - '3105004' => "",  (Usa versão 2.2)
								# Córrego Fundo               - MG  - '3119955' => "",  (Usa versão 2.2)
								# Florestal                   - MG  - '3125101' => "",  (Usa versão 2.2)
								# São Gonçalo do Pará         - MG  - '3161809' => "",  (Usa versão 2.2)
								# Cajuri                      - MG  - '3110202' => "",  (Não possui integração com WebService)
								# Igaratinga                  - MG  - '3130200' => "",  (Não possui integração com WebService)
								# Santana do Riacho           - MG  - '3159001' => "",  (Não possui integração com WebService)
								# São Gonçalo do Rio Abaixo   - MG  - '3161908' => "",  (Não possui integração com WebService)
								# São Gotardo                 - MG  - '3162104' => "",  (Não possui integração com WebService)
								# Verissimo                   - MG  - '3171105' => "",  (Não possui integração com WebService)
								# Porto Firme                 - MG  - '3152303' => "",  (Sistema indisponível)
								# Tiradentes                  - MG  - '3168804' => "",  (Sistema indisponível)
							
							# MT - Mato Grosso
								# Itanhangá - MT
								'5104542' => "https://www7.webiss.com.br/itanhangamt_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Lucas do Rio Verde - MT
								'5105259' => "https://www1.webiss.com.br/LucasDoRioVerdeMT_wsNFSe#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# São José do Rio Claro - MT
								'5107305' => "https://www5.webiss.com.br/saojosedorioclaromt_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Tangará da Serra - MT
								'5107958' => "https://www4.webiss.com.br/tangaradaserramt_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
							# RO - Rondônia
								# Cacoal - RO
								'1100049' => "https://www4.webiss.com.br/cacoalro_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Cerejeiras - RO
								'1100056' => "https://www5.webiss.com.br/cerejeirasro_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Machadinho D' Oeste - RO
								'1100130' => "https://www7.webiss.com.br/machadinhodoestero_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Nova Brasilândia D' Oeste - RO
								'1100148' => "https://www7.webiss.com.br/novabrasilandiadoestero_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Vilhena - RO
								'1100304' => "https://vilhenaro.webiss.com.br/servicos/wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								#
								# Rolim de Moura - RO         - '1100288' => "", (Usa versão 2.2)
								# São Miguel do Guaporé - RO  - '1100320' => "", (Não possui integração com WebService)
								# Urupá - RO                  - '1101708' => "", (Não possui integração com WebService)

							# RJ - Rio de Janeiro
								# Mesquita - RJ
								'3302858' => "https://www5.webiss.com.br/mesquitarj_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Niterói - RJ
								'3303302' => "https://www3.webiss.com.br/rjniteroi_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Queimados - RJ
								'3304144' => "https://www1.webiss.com.br/queimadosrj_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",								
								
								# Silva Jardim - RJ
								'3305604' => "https://www3.webiss.com.br/silvajardimrj_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Teresópolis - RJ
								'3305802' => "https://www1.webiss.com.br/rjteresopolis_wsNFSe#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								#
								# Barra do Piraí - RJ         -  '3300308' => "", (Usa versão 2.2)
								# Cordeiro - RJ               -  '3301504' => "", (Usa versão 2.2)
								# Santa Maria Madalena - RJ   -  '3304607' => "", (Usa versão 2.2)
								# São Sebastião do Alto - RJ  -  '3305307' => "", (Usa versão 2.2)
								# Trajano de Moraes - RJ      -  '3305901' => "", (Usa versão 2.2)
								# Miguel Pereira - RJ         -  '3302908' => "", (Não possui integração com WebService)
								# Paty do Alferes - RJ        -  '3303856' => "", (Não possui integração com WebService)

							# RS - Rio Grande do Sul
								# Bagé - RS
								'4301602' => "https://www1.webiss.com.br/BageRS_wsNFSe#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
							# SC - Santa Catarina
								# Içara - SC
								'4207007' => "https://www.webiss.com.br/icarasc_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Irineópolis - SC
								'4207908' => "https://www5.webiss.com.br/irineopolissc_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Lauro Muller - SC
								'4209607' => "https://www4.webiss.com.br/lauromullersc_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl", 
								
								# Mafra - SC
								'4210100' => "https://www5.webiss.com.br/mafrasc_wsnfse#{'_homolog' if env == :test}/nfseservices.svc?wsdl",
								
								# Papanduva - SC
								'4212205' => "https://www5.webiss.com.br/papanduvasc_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Siderópolis - SC
								'4217600' => "https://www7.webiss.com.br/sideropolissc_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								#
								# Monte Castelo- SC - '4211108' (Não possui integração com WebService)
									
							# SE - Sergipe
								# Aracaju - SE
								'2800308' => "https://aracajuse.webiss.com.br/servicos/wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Estância - SE
								'2802106' => "https://www7.webiss.com.br/estanciase_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Itabaiana - SE
								'2802908' => "https://www.webiss.com.br/itabaianase_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Lagarto - SE
								'2803500' => "https://www3.webiss.com.br/lagartose_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# São Cristóvão - SE
								'2806701' => "https://www.webiss.com.br/saocristovaose_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								#
								# Campo do Brito - SE  - '2801009' => "",  (Não possui integração com WebService)
								# Japaratuba - SE      - '2803302' => "",  (Não possui integração com WebService)
								# Riachuelo - SE       - '2805901' => "",  (Não possui integração com WebService)
								# Siriri - SE          - '2807204' => "",  (Não possui integração com WebService)

							# TO - Tocantins
								# Gurupi - TO
								'1709500' => "https://www.webiss.com.br/gurupito_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
								
								# Palmas - TO
								'1721000' => "https://www5.webiss.com.br/palmasto_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl",
								
								# Porto Nacional - TO
								'1718204' => "https://www7.webiss.com.br/portonacionalto_wsnfse#{'_homolog' if env == :test}/nfseServices.svc?wsdl",
						}
					end

					def get_wsdl_by_city
						if gtw = gateway[ibge_code_of_issuer_city]
							gtw
						else # Default for tdd
							"https://www4.webiss.com.br/lauromullersc_wsnfse#{'_homolog' if env == :test}/NfseServices.svc?wsdl"
						end
					end

					def wsdl
						get_wsdl_by_city
					end

					# Declaro que o método `render_xml` irá verificar os arquivos também presentes
					# no diretório especificado
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					# def xml_current_dir_path
					# 	["#{BrNfe.root}/lib/br_nfe/service/simpliss/v1/xml"]+super
					# end

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					def message_namespaces
						{
							"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", 
							"xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
							xmlns: 'http://www.abrasf.org.br/nfse'
						}
					end

					def soap_namespaces
						{
							'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
							'xmlns:xsd'     => 'http://www.w3.org/2001/XMLSchema',
							'xmlns:xsi'     => 'http://www.w3.org/2001/XMLSchema-instance',
							'xmlns:SOAP-ENC' => "http://schemas.xmlsoap.org/soap/encoding/",
							'xmlns:ns4301' => "http://tempuri.org"
						}
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

					# Método é sobrescrito para atender o padrão do órgão emissor.
					# 
					# <b><Tipo de retorno: /b> _String_ XML
					#
					def content_xml
						dados =  "<#{soap_body_root_tag} xmlns=\"http://tempuri.org/\">"
						dados <<   "<cabec></cabec>"
						dados <<   '<msg>'
						# dados <<   '<![CDATA[<CancelarNfseEnvio xmlns="http://www.abrasf.org.br/nfse" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Pedido><InfPedidoCancelamento><IdentificacaoNfse><Numero>201600000000005</Numero><Cnpj>08897094000155</Cnpj><InscricaoMunicipal>135408</InscricaoMunicipal><CodigoMunicipio>4207007</CodigoMunicipio></IdentificacaoNfse><CodigoCancelamento>E506</CodigoCancelamento></InfPedidoCancelamento><Signature xmlns="http://www.w3.org/2000/09/xmldsig#"><SignedInfo xmlns="http://www.w3.org/2000/09/xmldsig#"><CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"></CanonicalizationMethod><SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"></SignatureMethod><Reference URI=""><Transforms><Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"></Transform><Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"></Transform></Transforms><DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"></DigestMethod><DigestValue>p648t3VsUmEpwWp038+R8t2kV9o=</DigestValue></Reference></SignedInfo><SignatureValue>QJsiNGPxp7kfNqn+mN+SZJ8rWhe/iZJOVSXYtp6UHUHI+WXNEH/C+aUxZ+z9011yr1TVl/J+11TQqG1bdMnjYZ9GrTCtVaQmkSwnUVH/e0FgrHkqKJh5IbqrwylkAWBj0ycQKssLVXyr7+ZaFf6Y2LWi5vsBSAPhGr4Yepn1QYX5fruanRn/SWtwFhtj1Jt8vvT86/qxnhRNql1FZu8xtg0S0xVt5TP1OllHw2DSm75DzwpefROa6ctirS8mqM2ySpvMizU4JABPyoPEP2yOw8jjepkZMJqwnSesIuArC9Y6DYS06BmNtrf4BJcHBqPwjMP5Q6n4n6BsY5m/y1xYhw==</SignatureValue><KeyInfo><X509Data><X509Certificate>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</X509Certificate></X509Data></KeyInfo></Signature></Pedido></CancelarNfseEnvio>]]>'
						dados <<     "<![CDATA[#{xml_builder.html_safe}]]>"
						dados <<   '</msg>'
						dados << "</#{soap_body_root_tag}>"
						dados
					end
				end
			end
		end
	end
end