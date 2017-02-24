module BrNfe
	module Service
		module Dbseller
			module V1
				class Base < BrNfe::Service::Base


					def get_wsdl_by_city
						{

							# Alegrete - RS
							'4300406' => "http://nfse.alegrete.rs.gov.br/webservice/index/#{env == :test ? 'homologacao' : 'producao'}",

							# Alvorada - RS
							'4300604' => "http://nfse.alvorada.rs.gov.br/webservice/index/#{env == :test ? 'homologacao' : 'producao'}",

							# Carazinho - RS
							'4304705' => "http://nfse.carazinho.rs.gov.br/webservice/index/#{env == :test ? 'homologacao' : 'producao'}",

							# Charqueadas - RS
							'4305355' => "http://nfse.charqueadas.rs.gov.br/webservice/index/#{env == :test ? 'homologacao' : 'producao'}",

							# Itaqui - RS
							'4310603' => "http://nfse.itaqui.rs.gov.br/webservice/index/#{env == :test ? 'homologacao' : 'producao'}",

							# Osorio - RS
							'4313508' => "http://nfse.osorio.rs.gov.br#{env == :test ? ':26000' : ':81'}/webservice/index/#{env == :test ? 'homologacao' : 'producao'}",

							# Taquari - RS
							'4321303' => "http://nfse.taquari.rs.gov.br/webservice/index/#{env == :test ? 'homologacao' : 'producao'}",

						}
					end

					def wsdl
						if gtw = get_wsdl_by_city[ibge_code_of_issuer_city]
							"#{gtw}?wsdl"
						else # Default for tdd
							"http://nfse.alegrete.rs.gov.br/webservice/index/#{env == :test ? 'homologacao' : 'producao'}?wsdl"
						end
					end
					# Declaro que o método `render_xml` irá verificar os arquivos também presentes
					# no diretório especificado
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def xml_current_dir_path
						["#{BrNfe.root}/lib/br_nfe/service/dbseller/v1/xml"]+super
					end

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					def message_namespaces
						{
							# 'xmlns' => "http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd",
							'xmlns' => "http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd",
						}
					end
					
					# # Assinatura através da gem signer
					# def signature_type
					# 	:method_sign
					# end

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
						dados =  "<#{soap_body_root_tag} xmlns=\"#{get_wsdl_by_city[ibge_code_of_issuer_city]}\">"
						dados <<		'<xml xmlns="">'
						dados << 		"<![CDATA[<?xml version=\"1.0\" encoding=\"UTF-8\"?>#{xml_builder.html_safe}]]>"
						dados <<		'</xml>'
						dados << "</#{soap_body_root_tag}>"
						dados
					end
				end
			end
		end
	end
end