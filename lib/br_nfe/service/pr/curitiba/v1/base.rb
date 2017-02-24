module BrNfe
	module Service
		module PR
			module Curitiba
				module V1
					class Base < BrNfe::Service::Base

						# Para Curitiba a autenticação via SSL é obrigatória
						def ssl_request?
							true
						end

						def wsdl
							# [4106902] Curitiba - PR
							if ibge_code_of_issuer_city == '4106902'
								if env == :test
									'http://pilotoisscuritiba.curitiba.pr.gov.br/nfse_ws/nfsews.asmx?wsdl'
								else
									'https://isscuritiba.curitiba.pr.gov.br/Iss.NfseWebService/nfsews.asmx?wsdl'
								end
							else # Default for tdd
								'http://pilotoisscuritiba.curitiba.pr.gov.br/nfse_ws/nfsews.asmx?wsdl'
							end
						end

						# Declaro que o método `render_xml` irá verificar os arquivos também presentes
						# no diretório especificado
						#
						# <b>Tipo de retorno: </b> _Array_
						#
						def xml_current_dir_path
							["#{BrNfe.root}/lib/br_nfe/service/pr/curitiba/v1/xml"]+super
						end

						def canonicalization_method_algorithm
							'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
						end

						def message_namespaces
							{'xmlns' => "http://isscuritiba.curitiba.pr.gov.br/iss/nfse.xsd"}
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
							dados =  "<#{soap_body_root_tag} xmlns=\"http://www.e-governeapps2.com.br/\">"
							dados << 	"#{xml_builder.html_safe}"
							dados << "</#{soap_body_root_tag}>"
							dados
						end
					end
				end
			end
		end
	end
end