module BrNfe
	module Service
		module Tiplan
			module V1
				class Base < BrNfe::Service::Base

					# Para o provedor TIPLAN a autenticação via SSL é obrigatória
					def ssl_request?
						true
					end

					def get_wsdl_by_city
						{
							# Angra dos Reis - RJ
							'3300100' => "https://www.spe.angra.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl",

							# Duque de Caxias - RJ
							'3301702' => "https://spe.duquedecaxias.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl",

							# Itaguaí - RJ
							'3302007' => "https://spe.itaguai.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl",

							# Macaé - RJ
							'3302403' => "https://spe.macae.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl",

							# Mangaratiba - RJ
							'3302601' => "https://spe.mangaratiba.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl",

							# Piraí - RJ
							'3304003' => "https://nfse.pirai.rj.gov.br/WSNacional/nfse.asmx?wsdl",

							# Resende - RJ
							'3304201' => "https://spe.resende.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl",

							# Rio das Ostras - RJ
							'3304524' => "https://spe.riodasostras.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl",

							# Americana - SP
							'3501608' => "https://nfse.americana.sp.gov.br/nfse/WSNacional/nfse.asmx?wsdl",
						}
					end

					def wsdl
						if env == :test
							unknow_env_test
						else
							if gtw = get_wsdl_by_city[ibge_code_of_issuer_city]
								gtw
							else # Default for tdd
								"https://spe.duquedecaxias.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl"
							end
						end
					end

					# Declaro que o método `render_xml` irá verificar os arquivos também presentes
					# no diretório especificado
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def xml_current_dir_path
						["#{BrNfe.root}/lib/br_nfe/service/tiplan/v1/xml"]+super
					end

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					def message_namespaces
						{'xmlns' => "http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd",}
					end

					# def soap_namespaces
					# 	super.merge({
					# 		'xmlns:soap12'  =>  "http://www.w3.org/2003/05/soap-envelope"
					# 	})
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
						dados =  "<#{soap_body_root_tag} xmlns=\"http://www.nfe.com.br/\">"
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