module BrNfe
	module Service
		module Simpliss
			module V1
				class Base < BrNfe::Service::Base

					def url_wsdl
						if env == :test
							'http://wshomologacao.simplissweb.com.br/nfseservice.svc?wsdl'
						elsif ibge_code_of_issuer_city == '4202008' # Balneário Camboriú
							'http://wsbalneariocamboriu.simplissweb.com.br/nfseservice.svc?wsdl'
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