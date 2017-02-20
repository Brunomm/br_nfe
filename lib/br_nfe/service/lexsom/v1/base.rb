module BrNfe
	module Service
		module Lexsom
			module V1
				class Base < BrNfe::Service::Base

					def get_wsdl_by_city
						{
							# Araucária - PR
							'4101804' => "http://#{'homologa.' if env == :test}nfse.araucaria.pr.gov.br/nfsews/nfse.asmx?wsdl",

							# Foz Do Iguaçu - PR
							'4108304' => "http://#{'homologa.' if env == :test}nfse.pmfi.pr.gov.br/nfsews/nfse.asmx?wsdl",
						}
					end

					def wsdl
						if gtw = get_wsdl_by_city[ibge_code_of_issuer_city]
							gtw
						else # Default for tdd
							"http://homologa.nfse.pmfi.pr.gov.br/nfsews/nfse.asmx?wsdl"
						end
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
						{'xmlns' => "http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd",}
					end

					def soap_namespaces
						super.merge({
							'xmlns:soap12'  =>  "http://www.w3.org/2003/05/soap-envelope"
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
						dados =  "<#{soap_body_root_tag} xmlns=\"http://tempuri.org/\">"
						dados <<   '<xml>'
						dados <<     "#{xml_builder.html_safe}"
						dados <<   '</xml>'
						dados << "</#{soap_body_root_tag}>"
						dados
					end
				end
			end
		end
	end
end