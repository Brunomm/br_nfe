module BrNfe
	module Service
		module Ginfes
			module V1
				class Base < BrNfe::Service::Base

					def ssl_request?
						true
					end

					def wsdl
						if env == :test
							'https://homologacao.ginfes.com.br/ServiceGinfesImpl?wsdl'
						else 
							'https://producao.ginfes.com.br/ServiceGinfesImpl?wsdl'
						end
					end

					# Declaro que o método `render_xml` irá verificar os arquivos também presentes
					# no diretório especificado
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def xml_current_dir_path
						["#{BrNfe.root}/lib/br_nfe/service/ginfes/v1/xml"]+super
					end

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					def message_namespaces
						{'xmlns:ns4' =>  "http://www.ginfes.com.br/tipos_v03.xsd",}
					end

					def namespace_identifier
						'ns3:'
					end

					def namespace_for_tags
						'ns4:'
					end

					def soap_namespaces
						super.merge({
							'xmlns:soap' =>  "http://schemas.xmlsoap.org/wsdl/soap/",
							'xmlns:tns'  =>  "http://#{env == :test ? 'homologacao' : 'producao'}.ginfes.com.br"
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
						dados =  "<xs:#{soap_body_root_tag} xmlns:xs=\"http://#{env == :test ? 'homologacao' : 'producao'}.ginfes.com.br\">"
						dados <<		'<arg0>'
						dados <<			'<cabec:cabecalho xmlns:cabec="http://www.ginfes.com.br/cabecalho_v03.xsd" versao="3">'
						dados <<			'<versaoDados>3</versaoDados>'
						dados <<			'</cabec:cabecalho>'
						dados <<		'</arg0>'
						dados << 	'<arg1>'
						dados << 		"#{xml_builder.html_safe}"
						dados << 	'</arg1>'
						dados << "</xs:#{soap_body_root_tag}>"
						dados
					end
				end
			end
		end
	end
end