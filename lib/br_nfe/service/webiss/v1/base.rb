module BrNfe
	module Service
		module Webiss
			module V1
				class Base < BrNfe::Service::Base

					def ssl_request?
						true
					end

					def wsdl
						'https://www1.webiss.com.br/camanducaiamg_wsnfse_homolog/NfseServices.svc?wsdl'
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