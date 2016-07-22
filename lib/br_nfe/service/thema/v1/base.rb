module BrNfe
	module Service
		module Thema
			module V1
				class Base < BrNfe::Service::Base

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

					# Método é sobrescrito para atender o padrão do órgão emissor.
					# Deve ser enviado o XML da requsiução dentro da tag CDATA
					# seguindo a estrutura requerida.
					# 
					# <b><Tipo de retorno: /b> _String_ XML
					#
					def content_xml
						dados = "<ns1:#{soap_body_root_tag}>"
						dados += '<ns1:xml>'
						dados += '<![CDATA[<?xml version="1.0" encoding="ISO-8859-1"?>'
						dados += xml_builder.html_safe
						dados += ']]>'
						dados += '</ns1:xml>'
						dados += "</ns1:#{soap_body_root_tag}>"
						dados
					end

				end
			end
		end
	end
end