module BrNfe
	module Service
		module Simpliss
			module V1
				class Base < BrNfe::Service::Base

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					def message_namespaces
						{'xmlns' => "http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd"}
					end

					def soap_namespaces
						super.merge({
							'xmlns:ns1' => "http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd",
							'xmlns:ns2' => "http://www.w3.org/2000/09/xmldsig#",
							'xmlns:ns3' => "http://www.sistema.com.br/Sistema.Ws.Nfse",
							'xmlns:ns4' => "http://www.sistema.com.br/Sistema.Ws.Nfse.Cn"
						})
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