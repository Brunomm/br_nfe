module BrNfe
	module Service
		module Ciga
			module V1
				class Base < BrNfe::Service::Base

					def wsdl
						if env == :test
							'https://nfse-testes.ciga.sc.gov.br/webservice/v1'
						else
							'https://nfse.ciga.sc.gov.br/webservice/v1'
						end
					end

					# Declaro que o método `render_xml` irá verificar os arquivos também presentes
					# no diretório especificado
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def xml_current_dir_path
						["#{BrNfe.root}/lib/br_nfe/service/ciga/v1/xml"]+super
					end

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					def message_namespaces
						{'xmlns' => "http://www.abrasf.org.br/nfse.xsd",}
					end

					def soap_namespaces
						super.merge({
							'xmlns:nfse'  =>  "http://nfse.abrasf.org.br"
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
						dados =  "<nfse:#{soap_body_root_tag}>"
						dados <<		'<nfseCabecMsg>'
						dados <<			'<![CDATA[<versaoDados>1.00</versaoDados>]]>'
						dados <<		'</nfseCabecMsg>'
						dados <<		'<nfseDadosMsg>'
						dados << 		"<![CDATA[#{xml_builder.html_safe}]]>"
						dados <<		'</nfseDadosMsg>'
						dados << "</nfse:#{soap_body_root_tag}>"
						dados
					end

					# dados <<			'<![CDATA[<cabecalho versao="1.00" xmlns="http://www.abrasf.org.br/nfse.xsd">'
					# dados <<				'<versaoDados>1.00</versaoDados>'
					# dados <<			'</cabecalho>]]>'

				end
			end
		end
	end
end