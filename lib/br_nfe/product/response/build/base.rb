module BrNfe
	module Product
		module Response
			module Build
				class Base < BrNfe::ActiveModelBase
					attr_accessor :savon_response
					attr_accessor :original_xml
					
					# Responsável por instanciar o objeto de resposta contendo os valores
					# pertinentes a cada operação.
					#
					def response
						return @response if @response
						@response = response_class.new({
							soap_xml: savon_response.try(:xml).try(:force_encoding, 'UTF-8'),
							request_status: :success
						})
						@response.assign_attributes(specific_attributes)
						@response
					end

					# Responsável por definir a classe da resposta que será instânciada
					# para cada operação.
					# Esse método deve ser sobrescrito para cada operação.
					#
					# <b>Type: </b> _Class_
					#
					def response_class
						BrNfe::Product::Response::Base
					end

					# É utilizado para setar os atributos específicos para
					# o retorno de cada operação.
					# É útil para evitar sobrescrever e duplicar código do 
					# método response
					#
					# <b>Type: </b> _Hash_
					#
					def specific_attributes
						{}
					end

					# Responsável por identificar o xmlns principal da resposta.
					# Esse valor é utilizado para dar o Start para encontrar o conteúdo
					# na arvore de tags xml.
					#
					# <b>Type: </b> _String_
					#
					def url_xmlns_retorno
						@url_xmlns_retorno ||= header_xml.collect_namespaces['xmlns']
					end

					# Responsável por trazer qual a versão do layout o XML da resposta
					# foi feito.
					# Irá converter a versão em Symbol e alterar o ponto(.) em underline(_).
					# Também irá acrescentar um 'v' na frente da versão.
					# Irá pegar a versão a partir da tag 'versaoDados' presente no Header 
					# da requisição Soap.
					# É útil para saber como pegar as informações do XML, pois como cada
					#  versão pode ter uma estrutura diferente, o conteúdo desse método
					#  irá auxiliar na decisão de como buscar o conteúdo.
					#
					# Exemplos:
					#  Versão do XML      Retorno
					#      '1.00'     =>    :v1_00
					#      '2.01'     =>    :v2_01
					#      '3.10'     =>    :v3_10
					#
					# # <b>Type: </b> _Symbol_
					#
					def xml_version
						return @xml_version if @xml_version
						version = header_xml.xpath('//nf:nfeCabecMsg/nf:versaoDados', nf: url_xmlns_retorno).text
						@xml_version = "v#{version.gsub('.','_')}".to_sym
					end

					# Responsável por pegar o conteúdo presente dentro da tag
					# Body da resposta Soap.
					# É útil para facilitar a busca e manupilação do XML presente
					# dentro do Body da resposta Soap
					# 
					# # <b>Type: </b> _Nokogiri::XML::Document_
					#
					def body_xml
						@body_xml ||= parse_nokogiri_xml( response_xml.xpath('//soap:Envelope/soap:Body', 'xmlns:soap' => "http://www.w3.org/2003/05/soap-envelope").try(:children).try(:to_xml) )
					end

					# Responsável por pegar o conteúdo presente dentro da tag
					# Header da resposta Soap.
					# É útil para facilitar a busca e manupilação do XML presente
					# dentro do Header da resposta Soap
					# 
					# # <b>Type: </b> _Nokogiri::XML::Document_
					#
					def header_xml
						@header_xml ||= parse_nokogiri_xml( response_xml.xpath('//soap:Envelope/soap:Header', 'xmlns:soap' => "http://www.w3.org/2003/05/soap-envelope").try(:children).try(:to_xml) )
					end

					# Responsável por converter a string xml a ser modificado
					# em um Nokogiri::XML::Document
					# É útil para evitar ficar dando o parse no xml toda vez que precisa
					# ser utilizado.
					# 
					# # <b>Type: </b> _Nokogiri::XML::Document_
					#
					def doc_original_xml
						@doc_original_xml ||= parse_nokogiri_xml( original_xml )
					end

					# Contém o XML completo da resposta Soap.
					# É útil para evitar ficar dando o parse no xml toda vez que precisa
					# ser utilizado.
					#
					# # <b>Type: </b> _Nokogiri::XML::Document_
					#
					def response_xml
						@response_xml ||= parse_nokogiri_xml(savon_response&.xml)
					end

				private

					# Reponsável por converter uma string(XML) em um elemento 
					# da classe Nokogiri::XML::Document.
					#
					def parse_nokogiri_xml str_xml
						if str_xml.include?('<?xml')
							Nokogiri::XML(str_xml)
						else
							Nokogiri::XML('<?xml version="1.0" encoding="UTF-8"?>'+str_xml)
						end
					end
				end
			end
		end
	end
end