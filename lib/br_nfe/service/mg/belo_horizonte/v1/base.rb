module BrNfe
	module Service
		module MG
			module BeloHorizonte
				module V1
					class Base < BrNfe::Service::Base
						def certificado_obrigatorio?
							true
						end

						def ssl_request?
							true
						end

						def wsdl
							if env == :test
								'https://bhisshomologa.pbh.gov.br/bhiss-ws/nfse?wsdl'
							else
								'https://bhissdigital.pbh.gov.br/bhiss-ws/nfse?wsdl'
							end
						end

						def xml_current_dir_path
							["#{BrNfe.root}/lib/br_nfe/service/mg/belo_horizonte/v1/xml"]+super
						end

						def message_namespaces
							{'xmlns' => "http://www.abrasf.org.br/nfse.xsd"}
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

						def tag_id
							:Id # <- I maiúsculo
						end

						# Método é sobrescrito para atender o padrão do órgão emissor.
						# 
						# <b><Tipo de retorno: /b> _String_ XML
						#
						def content_xml
							dados = "<ns2:#{soap_body_root_tag} xmlns:ns2=\"http://ws.bhiss.pbh.gov.br\">"
								dados += '<nfseCabecMsg>'
									dados += '<![CDATA['
									dados += '<?xml version="1.0" encoding="UTF-8"?>'
									dados += '<cabecalho xmlns="http://www.abrasf.org.br/nfse.xsd" versao="1.00">'
										dados += '<versaoDados>1.00</versaoDados>'
									dados += '</cabecalho>'
									dados += ']]>'
								dados += '</nfseCabecMsg>'
								dados += '<nfseDadosMsg>'
									dados += '<![CDATA['
									dados += '<?xml version="1.0" encoding="UTF-8"?>'
									dados += xml_builder.html_safe
									dados += ']]>'
								dados += '</nfseDadosMsg>'
							dados += "</ns2:#{soap_body_root_tag}>"
							dados
						end
					end
				end
			end
		end
	end
end