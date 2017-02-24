module BrNfe
	module Service
		module Simpliss
			module V1
				class Base < BrNfe::Service::Base

					def get_wsdl_by_city
						{
							# Balneário Camboriú-SC
							'4202008' => 'http://wsbalneariocamboriu.simplissweb.com.br/nfseservice.svc?wsdl',	


							# Andirá-PR
							'4101101' => 'http://wsandira.simplissweb.com.br/nfseservice.svc?wsdl',

							# Astorga-PR
							'4102109' => 'http://wsastorga.simplissweb.com.br/nfseservice.svc?wsdl',
							
							# Bandeirantes-PR
							'4102406' => 'http://wsbandeirantes.simplissweb.com.br/nfseservice.svc?wsdl',

							# Colorado-PR
							'4105904' => 'http://wscolorado.simplissweb.com.br/nfseservice.svc?wsdl',

							# Nova Londrina-PR
							'4117107' => 'http://wsnovalondrina.simplissweb.com.br/nfseservice.svc?wsdl',

							# Porecatu-PR
							'4120002' => 'http://wsporecatu.simplissweb.com.br/nfseservice.svc?wsdl',

							# Sertanópolis-PR
							'4126504' => 'http://wssertanopolis.simplissweb.com.br/nfseservice.svc?wsdl',



							# Bambuí-MG
							'3105103' => 'http://wsbambui.simplissweb.com.br/nfseservice.svc?wsdl',

							# Iguatama-MG
							'3130309' => 'http://wsiguatama.simplissweb.com.br/nfseservice.svc?wsdl',

							# João Monlevade-MG
							'3136207' => 'http://wsjoaomonlevade.simplissweb.com.br/nfseservice.svc?wsdl',

							# Patrocinio-MG
							'3148103' => 'http://wspatrocinio.simplissweb.com.br/nfseservice.svc?wsdl',



							# Volta Redonda-RJ
							'3306305' => 'http://wsvoltaredonda.simplissweb.com.br/nfseservice.svc?wsdl',



							# Alfredo Marcondes-SP
							'3500808' => 'http://wsalfredomarcondes.simplissweb.com.br/nfseservice.svc?wsdl',

							# Araras-SP
							'3503307' => 'http://189.56.68.34:8080/ws_araras/nfseservice.svc?wsdl',

							# Carapicuíba-SP
							'3510609' => 'http://wscarapicuiba.simplissweb.com.br/nfseservice.svc?wsdl',

							# Casa Branca-SP
							'3510807' => 'http://wscasabranca.simplissweb.com.br/nfseservice.svc?wsdl',

							# Dois Córregos-SP
							'3514106' => 'http://wsdoiscorregos.simplissweb.com.br/nfseservice.svc?wsdl',

							# Embu das Artes-SP
							'3515004' => 'http://wsembudasartes.simplissweb.com.br/nfseservice.svc?wsdl',

							# Espirito Santo do Pinhal-SP
							'3515186' => 'http://wsespiritosantodopinhal.simplissweb.com.br/nfseservice.svc?wsdl',

							# Herculandia-SP
							'3519006' => 'http://wsherculandia.simplissweb.com.br/nfseservice.svc?wsdl',

							# Indiana-SP
							'3520608' => 'http://wsindiana.simplissweb.com.br/nfseservice.svc?wsdl',

							# Iracemápolis-SP
							'3521408' => 'http://wsiracemapolis.simplissweb.com.br/nfseservice.svc?wsdl',

							# Mirante Do Paranapanema-SP
							'3530201' => 'http://wsmirantedoparanapanema.simplissweb.com.br/nfseservice.svc?wsdl',

							# Osvaldo Cruz-SP
							'3534609' => 'http://wsosvaldocruz.simplissweb.com.br/nfseservice.svc?wsdl',

							# Piracicaba-SP
							'3538709' => 'http://sistemas.pmp.sp.gov.br/semfi/simpliss/ws_nfse/nfseservice.svc?wsdl',

							# Presidente Prudente-SP
							'3541406' => 'http://issprudente.sp.gov.br/ws_nfse/nfseservice.svc?wsdl',

							# Santa Cruz das Palmeiras-SP
							'3546306' => 'http://wssantacruzdaspalmeiras.simplissweb.com.br/nfseservice.svc?wsdl',

							# São João da Boa Vista-SP
							'3549102' => 'http://wssaojoao.simplissweb.com.br/nfseservice.svc?wsdl',

							# São José do Rio Pardo-SP
							'3549706' => 'http://wssaojosedoriopardo.simplissweb.com.br/nfseservice.svc?wsdl',

							# Tupã-SP
							'3555000' => 'http://wstupa.simplissweb.com.br/nfseservice.svc?wsdl',

							# Vargem Grande do Sul-SP
							'3556404' => 'http://wsvargemgrandedosul.simplissweb.com.br/nfseservice.svc?wsdl',
						}
					end

					def wsdl
						if env == :test
							'http://wshomologacao.simplissweb.com.br/nfseservice.svc?wsdl'
						elsif gtw = get_wsdl_by_city[ibge_code_of_issuer_city]
							gtw
						else # Se não encontrar a cidade pega por padrão o WS de homologação
							'http://wshomologacao.simplissweb.com.br/nfseservice.svc?wsdl'
						end
					end

					# Declaro que o método `render_xml` irá verificar os arquivos também presentes
					# no diretório especificado
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def xml_current_dir_path
						["#{BrNfe.root}/lib/br_nfe/service/simpliss/v1/xml"]+super
					end

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					def message_namespaces
						{}
					end

					def soap_namespaces
						super.merge({
							'xmlns:ns1' => "http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd",
							'xmlns:ns2' => "http://www.w3.org/2000/09/xmldsig#",
							'xmlns:ns3' => "http://www.sistema.com.br/Sistema.Ws.Nfse",
							'xmlns:ns4' => "http://www.sistema.com.br/Sistema.Ws.Nfse.Cn"
						})
					end

					def namespace_identifier
						'ns3:'
					end

					def namespace_for_tags
						'ns1:'
					end

					def namespace_for_signature
						'ns2:'
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
					# Deve ser enviado o XML da requsiução dentro da tag CDATA
					# seguindo a estrutura requerida.
					# 
					# <b><Tipo de retorno: /b> _String_ XML
					#
					def content_xml
						dados = "<ns3:#{soap_body_root_tag}>"
						dados += xml_builder.html_safe
						dados += "</ns3:#{soap_body_root_tag}>"
						dados
					end
				end
			end
		end
	end
end