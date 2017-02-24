module BrNfe
	module Service
		module Issnet
			module V1
				class Base < BrNfe::Service::Base

					def get_wsdl_by_city
						{
							# Anápolis - GO
							'5201108' => "http://www.issnetonline.com.br/webserviceabrasf/anapolis/servicos.asmx?wsdl",

							# Aparecida de Goiânia - GO
							'5201405' => "http://www.issnetonline.com.br/webserviceabrasf/aparecidadegoiania/servicos.asmx?wsdl",

							# Mantena - MG
							'3139607' => "http://www.issnetonline.com.br/webserviceabrasf/mantena/servicos.asmx?wsdl",

							# Três Corações - MG
							'3169307' => "http://www.issnetonline.com.br/webserviceabrasf/trescoracoes/servicos.asmx?wsdl",

							# Anaurilândia - MS
							'5000807' => "http://www.issnetonline.com.br/webserviceabrasf/anaurilandia/servicos.asmx?wsdl",

							# Angélica - MS
							'5000856' => "http://www.issnetonline.com.br/webserviceabrasf/angelica/servicos.asmx?wsdl",

							# Bodoquena - MS 
							# '5002159' => "", # Atualmente o município não utiliza o WSDL

							# Bonito - MS
							'5002209' => "http://www.issnetonline.com.br/webserviceabrasf/bonito/servicos.asmx?wsdl",

							# Deodápolis - MS
							'5003454' => "http://www.issnetonline.com.br/webserviceabrasf/deodapolis/servicos.asmx?wsdl",

							# Dourados - MS
							'5003702' => "http://www.issnetonline.com.br/webserviceabrasf/dourados/servicos.asmx?wsdl",

							# Eldorado - MS
							'5003751' => "http://www.issnetonline.com.br/webserviceabrasf/eldorado/servicos.asmx?wsdl",

							# Itaporã - MS
							'5004502' => "http://www.issnetonline.com.br/webserviceabrasf/itapora/servicos.asmx?wsdl",

							# Paranaíba - MS
							'5006309' => "http://www.issnetonline.com.br/webserviceabrasf/paranaiba/servicos.asmx?wsdl",

							# Porto Murtinho - MS
							'5006903' => "http://www.issnetonline.com.br/webserviceabrasf/portomurtinho/servicos.asmx?wsdl",

							# Rio Brilhante - MS
							'5007208' => "http://www.issnetonline.com.br/webserviceabrasf/riobrilhante/servicos.asmx?wsdl",

							# Sidrolândia - MS
							'5007901' => "http://www.issnetonline.com.br/webserviceabrasf/sidrolandia/servicos.asmx?wsdl",

							# Cuiabá - MT
							'5103403' => "http://www.issnetonline.com.br/webserviceabrasf/cuiaba/servicos.asmx?wsdl",

							# Abaetetuba - PA
							'1500107' => "http://www.issnetonline.com.br/webserviceabrasf/abaetetuba/servicos.asmx?wsdl",

							# Cascavel - PR
							'4104808' => "http://www.issnetonline.com.br/webserviceabrasf/cascavel/servicos.asmx?wsdl",

							# Cruz Alta - RS
							'4306106' => "http://www.issnetonline.com.br/webserviceabrasf/cruzalta/servicos.asmx?wsdl",

							# Novo Hamburgo - RS
							'4313409' => "http://www.issnetonline.com.br/webserviceabrasf/novohamburgo/servicos.asmx?wsdl",

							# Santa Maria - RS
							'4316907' => "http://www.issnetonline.com.br/webserviceabrasf/santamaria/servicos.asmx?wsdl",

							# Aparecida - SP
							'3502507' => "http://www.issnetonline.com.br/webserviceabrasf/aparecida/servicos.asmx?wsdl",

							# Jacareí - SP 
							'3524402' => "http://www.issnetonline.com.br/webserviceabrasf/jacarei/servicos.asmx?wsdl",

							# Jaguariuna - SP
							'3524709' => "http://www.issnetonline.com.br/webserviceabrasf/jaguariuna/servicos.asmx?wsdl",

							# Mogi das Cruzes - SP
							'3530607' => "http://www.issnetonline.com.br/webserviceabrasf/mogidascruzes/servicos.asmx?wsdl",

							# Praia Grande - SP
							'3541000' => "http://www.issnetonline.com.br/webserviceabrasf/praiagrande/servicos.asmx?wsdl",

							# São Vicente - SP
							'3551009' => "http://www.issnetonline.com.br/webserviceabrasf/saovicente/servicos.asmx?wsdl",

							# Serrana - SP
							'3551504' => "http://www.issnetonline.com.br/webserviceabrasf/serrana/servicos.asmx?wsdl",

							# Presidente Venceslau - SP
							'3541505' => "http://www.issnetonline.com.br/webserviceabrasf/presidentevenceslau/servicos.asmx?wsdl",

						}
					end

					def wsdl
						if env == :test
							'http://www.issnetonline.com.br/webserviceabrasf/homologacao/servicos.asmx?wsdl'
						elsif gtw = get_wsdl_by_city[ibge_code_of_issuer_city]
							gtw
						else # Se não encontrar a cidade pega por padrão o WS de homologação
							'http://www.issnetonline.com.br/webserviceabrasf/homologacao/servicos.asmx?wsdl'
						end
					end

					# Declaro que o método `render_xml` irá verificar os arquivos também presentes
					# no diretório especificado
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def xml_current_dir_path
						["#{BrNfe.root}/lib/br_nfe/service/issnet/v1/xml"]+super
					end

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					# def soap_namespaces
					# 	super.merge({
					# 		'xmlns:ns1' => "http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd",
					# 		'xmlns:ns2' => "http://www.w3.org/2000/09/xmldsig#",
					# 	})
					# end
					
					def message_namespaces
						{'xmlns:ns3' => "http://www.issnetonline.com.br/webserviceabrasf/vsd/tipos_complexos.xsd",}
					end

					def namespace_identifier
						'ns2:'
					end

					def namespace_for_tags
						'ns3:'
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
						dados =  "<nfd:#{soap_body_root_tag} xmlns:nfd=\"http://www.issnetonline.com.br/webservice/nfd\">"
						dados <<    '<nfd:xml>'
						dados <<      "<![CDATA[#{xml_builder.html_safe}]]>"
						dados <<    '</nfd:xml>'
						dados << "</nfd:#{soap_body_root_tag}>"
						dados
					end

				end
			end
		end
	end
end