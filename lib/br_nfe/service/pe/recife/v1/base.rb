module BrNfe
	module Service
		module PE
			module Recife
				module V1
					class Base < BrNfe::Service::Base

						# Para Recife a autenticação via SSL é obrigatória
						def ssl_request?
							true
						end

						def wsdl
							# [2611606] Recife - PE
							if ibge_code_of_issuer_city == '2611606'
								if env == :test
									unknow_env_test
								else
									'https://nfse.recife.pe.gov.br/WSNacional/nfse_v01.asmx?wsdl'
								end
							else
								raise "Código IBGE não corresponde à cidade de Recife - PE"
							end
						end

						# Declaro que o método `render_xml` irá verificar os arquivos também presentes
						# no diretório especificado
						#
						# <b>Tipo de retorno: </b> _Array_
						#
						def xml_current_dir_path
							["#{BrNfe.root}/lib/br_nfe/service/pe/recife/v1/xml"]+super
						end

						def canonicalization_method_algorithm
							'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
						end

						def message_namespaces
							{'xmlns' => "http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"}
						end

						# def soap_namespaces
						# 	super.merge({})
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
							dados =  "<#{soap_body_root_tag} xmlns=\"http://nfse.recife.pe.gov.br/\">"
							dados <<   '<inputXML>'
							dados <<     "<![CDATA[#{xml_builder.html_safe}]]>"
							dados <<   '</inputXML>'
							dados << "</#{soap_body_root_tag}>"
							dados
						end
					end
				end
			end
		end
	end
end