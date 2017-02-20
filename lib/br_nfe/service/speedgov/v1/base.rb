module BrNfe
	module Service
		module Speedgov
			module V1
				class Base < BrNfe::Service::Base

					def ssl_request?
						true
					end

					def get_wsdl_by_city
						{
							# Caculé - BA 
							'2905008' => 'http://www.speedgov.com.br/wscac/Nfes?wsdl',

							# Aquiraz - CE  
							'2301000' => 'http://www.speedgov.com.br/wsaqz/Nfes?wsdl',

							# Aracati - CE  
							'2301109' => 'http://www.speedgov.com.br/wsarc/Nfes?wsdl',

							# Barbalha - CE  
							'2301901' => 'http://www.speedgov.com.br/wsbar/Nfes?wsdl',

							# Beberibe - CE  
							'2302206' => 'http://www.speedgov.com.br/wsbeb/Nfes?wsdl',

							# Crateús - CE 
							'2304103' => 'http://www.speedgov.com.br/wscra/Nfes?wsdl',

							# Crato - CE 
							'2304202' => 'http://www.speedgov.com.br/wscrt/Nfes?wsdl',

							# Guaraciaba do Norte - CE 
							'2305001' => 'http://www.speedgov.com.br/wsgua/Nfes?wsdl',

							# Horizonte - CE 
							'2305233' => 'http://www.speedgov.com.br/wshor/Nfes?wsdl',

							# Itaitinga - CE 
							'2306256' => 'http://www.speedgov.com.br/wsita/Nfes?wsdl',

							# Jijoca - CE 
							'2307254' => 'http://www.speedgov.com.br/wsjij/Nfes?wsdl',

							# Juazeiro do Norte - CE 
							'2307304' => 'http://www.speedgov.com.br/wsjun/Nfes?wsdl',

							# Maracanaú - CE 
							'2307650' => 'http://www.speedgov.com.br/wsmar/Nfes?wsdl',

							# Pindoretama - CE 
							'2310852' => 'http://www.speedgov.com.br/wspin/Nfes?wsdl',

							# Quixadá  - CE 
							'2311306' => 'http://www.speedgov.com.br/wsqda/Nfes?wsdl',

							# Quixeramobim - CE 
							'2311405' => 'http://www.speedgov.com.br/wsqxb/Nfes?wsdl',

							# Tauá - CE 
							'2313302' => 'http://www.speedgov.com.br/wstau/Nfes?wsdl',

							# Tianguá - CE 
							'2313401' => 'http://www.speedgov.com.br/wstia/Nfes?wsdl',

							# Barra do Corda - MA 
							'2101608' => 'http://www.speedgov.com.br/wsbco/Nfes?wsdl',

							# Petrolina - PE 
							'2611101' => 'http://www.speedgov.com.br/wspet/Nfes?wsdl',
						}
					end


					def wsdl
						if env == :test
							'http://speedgov.com.br/wsmod/Nfes?wsdl'
						elsif gtw = get_wsdl_by_city[ibge_code_of_issuer_city]
							gtw
						else # Se não encontrar a cidade pega por padrão o WS de homologação
							'http://speedgov.com.br/wsmod/Nfes?wsdl'
						end
					end

					# Declaro que o método `render_xml` irá verificar os arquivos também presentes
					# no diretório especificado
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def xml_current_dir_path
						["#{BrNfe.root}/lib/br_nfe/service/speedgov/v1/xml"]+super
					end

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					def message_namespaces
						{'xmlns:p1'=> "http://ws.speedgov.com.br/tipos_v1.xsd",}
					end

					def namespace_identifier
						'p:'
					end

					def namespace_for_tags
						'p1:'
					end

					def soap_namespaces
						super.merge({
							'xmlns:nfse'  =>  "http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"
						})
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
						dados =  "<nfse:#{soap_body_root_tag}>"
						dados <<		'<header>'
						dados <<			'<![CDATA[<p:cabecalho versao="1" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:p="http://ws.speedgov.com.br/cabecalho_v1.xsd" xmlns:p1="http://ws.speedgov.com.br/tipos_v1.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://ws.speedgov.com.br/cabecalho_v1.xsd cabecalho_v1.xsd">'
						dados <<				'<versaoDados>1</versaoDados>'
						dados <<			'</p:cabecalho>]]>'
						dados <<		'</header>'
						dados <<		'<parameters>'
						dados << 		"<![CDATA[#{xml_builder.html_safe}]]>"
						dados <<		'</parameters>'
						dados << "</nfse:#{soap_body_root_tag}>"
						dados
					end

					# <nfse:ConsultarSituacaoLoteRps>
					#    <nfse:header>?</nfse:header>
					#    <nfse:parameters>?</nfse:parameters>
					# </nfse:ConsultarSituacaoLoteRps>

				end
			end
		end
	end
end