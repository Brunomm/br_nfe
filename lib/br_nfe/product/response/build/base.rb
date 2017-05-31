module BrNfe
	module Product
		module Response
			module Build
				class Base < BrNfe::ActiveModelBase
					attr_accessor :savon_response
					attr_accessor :operation

					def original_xml
						@original_xml ||= operation.original_xml || operation.xml_builder
					end

					def nfe_settings
						operation.nfe_settings
					end
					
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
						@url_xmlns_retorno ||= header_xml.collect_namespaces['xmlns'] || operation.url_xmlns
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
					# Versão do XML em forma de String
					# ex: '3.10'
					def xml_version_str
						return @xml_version_str if @xml_version_str
						@xml_version_str = header_xml.xpath('//nf:nfeCabecMsg/nf:versaoDados', nf: url_xmlns_retorno).text
					end

					# Responsável por pegar o conteúdo presente dentro da tag
					# Body da resposta Soap.
					# É útil para facilitar a busca e manupilação do XML presente
					# dentro do Body da resposta Soap
					# 
					# # <b>Type: </b> _Nokogiri::XML::Document_
					#
					def body_xml
						@body_xml ||= parse_nokogiri_xml( response_xml.xpath(
							paths[:body_xml][:path], 
							paths[:body_xml][:namespaces]
						).try(:children).try(:to_xml) )
					end

					# Responsável por pegar o conteúdo presente dentro da tag
					# Header da resposta Soap.
					# É útil para facilitar a busca e manupilação do XML presente
					# dentro do Header da resposta Soap
					# 
					# # <b>Type: </b> _Nokogiri::XML::Document_
					#
					def header_xml
						@header_xml ||= parse_nokogiri_xml( response_xml.xpath(
							paths[:header_xml][:path], 
							paths[:header_xml][:namespaces]
						).try(:children).try(:to_xml) )
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
						@response_xml ||= parse_nokogiri_xml(savon_response.try(:xml))
					end

					# XMLNS PADRÃO DA NOTA FISCAL
					#
					def nf_xmlns
						'http://www.portalfiscal.inf.br/nfe'
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

					# Rsponsável por instânciar uma nota fiscal a partir da tag protNFe.
					# Também vai setar o atributo xml específico da nota fiscal a partir
					# do valor setado em :original_xml
					#
					# Deve ser passado por parâmetro um objeto da class Nokogiri::XML::Document
					# com a estrutura do protocolo da NFE. EX:
					#   <protNFe versao="3.10">
					#     <infProt>
					#       <tpAmb>2</tpAmb>
					#       <verAplic>SVRS201611281548</verAplic>
					#       <chNFe>42161208897094000155550010000000031201601010</chNFe>
					#       <dhRecbto>2016-12-23T15:02:01-02:00</dhRecbto>
					#       <nProt>342160000820227</nProt>
					#       <digVal>eoBzPod21zF9/46jjOS2kLRyTPM=</digVal>
					#       <cStat>100</cStat>
					#       <xMotivo>Autorizado o uso da NF-e</xMotivo>
					#     </infProt>
					#   </protNFe>
					# 
					# <b>Type: </b> _BrNfe.nota_fiscal_product_class_
					#
					def build_invoice_by_prot_nfe prot_nfe
						invoice = BrNfe.nota_fiscal_product_class.new do |nfe|
							nfe.processed_at    = get_processed_at_from_prot_nfe(  prot_nfe )
							nfe.protocol        = get_protocol_from_prot_nfe(      prot_nfe )
							nfe.digest_value    = get_digest_value_from_prot_nfe(  prot_nfe )
							nfe.status_code     = get_status_code_from_prot_nfe(   prot_nfe )
							nfe.status_motive   = get_status_motive_from_prot_nfe( prot_nfe )
							nfe.chave_de_acesso = get_access_key_from_prot_nfe(    prot_nfe )
						end
						# 1° - Seta os valores possíveis encontrados na chave de acesso da NF-e
						set_invoice_values_by_access_key!( invoice )

						# 2° - Seta o XML da respectiva NF-e no objeto já com a tag <nfeProc>
						#      e a tag do protocolo(<protNFe>)
						set_invoice_xml_with_prot_nfe!( invoice, prot_nfe )
						invoice
					end

					def get_processed_at_from_prot_nfe prot_nfe
						prot_nfe.xpath( nfe_settings[:prot_nfe_paths][:processed_at]).text
					end
					def get_protocol_from_prot_nfe prot_nfe
						prot_nfe.xpath( nfe_settings[:prot_nfe_paths][:protocol]).text
					end
					def get_digest_value_from_prot_nfe prot_nfe
						prot_nfe.xpath( nfe_settings[:prot_nfe_paths][:digest_value]).text
					end
					def get_status_code_from_prot_nfe prot_nfe
						prot_nfe.xpath( nfe_settings[:prot_nfe_paths][:status_code]).text
					end
					def get_status_motive_from_prot_nfe prot_nfe
						prot_nfe.xpath( nfe_settings[:prot_nfe_paths][:status_motive]).text
					end
					def get_access_key_from_prot_nfe prot_nfe
						prot_nfe.xpath( nfe_settings[:prot_nfe_paths][:access_key]).text
					end

					# Seta os valores que estão concatenados na chave da NF-e
					# como o número da nota fiscal, cnpj do emitente, entre outros 
					# valores.
					#
					def set_invoice_values_by_access_key!(invoice)
						if invoice.chave_de_acesso.present?
							invoice.emitente.cnpj = invoice.chave_de_acesso[6..19]
							invoice.modelo_nf = invoice.chave_de_acesso[20..21]
							invoice.serie     = invoice.chave_de_acesso[22..24]
							invoice.numero_nf = invoice.chave_de_acesso[25..33].to_i
							invoice.codigo_nf = invoice.chave_de_acesso[35..42].to_i
						end
					end

					# Responsável por adicionar a tag <protNFe> dentro da tag <nfeProc>.
					# Também irá setar o XMl atualizado no attr :xml da nota fiscal
					#
					def set_invoice_xml_with_prot_nfe!(invoice, prot_nfe)
						if nfeProc = find_or_create_nfeProc_of_invoice_xml_by_access_key( invoice )
							# Só adiciona o protocolo se a nota foi emitida com sucesso
							if invoice.status == :success 
								add_prot_nfe_into_nfe_proc( nfeProc, prot_nfe )
							end

							invoice.xml = '<?xml version="1.0" encoding="UTF-8"?>'+canonicalize( nfeProc.to_xml )
						end
					end

					# Responsável por adicionar o protocolo da NFe dentro da tag nfeProc
					# a baixo da tag NFe.
					# Caso já exista a tag protNFe não irá adiciona-lo novamente.
					#
					def add_prot_nfe_into_nfe_proc nfe_proc, prot_nfe
						if nfe_proc.xpath('//nf:nfeProc/nf:protNFe', nf: nf_xmlns).blank?
							nfe_proc.xpath('//nf:nfeProc', nf: nf_xmlns).
							        children.last.try(:add_next_sibling, prot_nfe.root.to_xml )
						end
					end

					# Responsável por Encontrar ou Criar a estrutura nfeProc de uma
					# Determinada nota fiscal.
					# 1° Verifica se existe algum XML setado no objeto da nota, e se existir,
					#    irá montar a nfeProc da nota e retornar o documento XML
					# 2° Caso não encontre o xml direto na NF, irá procurar o xml através
					#    do método original_xml.
					# 
					# Estrutura de retorno:
					#   <nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="3.10">
					#     <NFe>...</NFe>
					#   </nfeProc>
					# 
					# <b>Type: </b> _Nokogiri::XML::Document_
					#
					def find_or_create_nfeProc_of_invoice_xml_by_access_key invoice
						doc_nf = "#{invoice.xml}".strip.present? ? parse_nokogiri_xml("#{invoice.xml}") : parse_nokogiri_xml(original_xml)
						if node = doc_nf.search("NFe/infNFe[@Id*=\"#{invoice.chave_de_acesso}\"]").first
							if doc_nf.xpath('/*').first.try(:name) == 'nfeProc'
								doc_nf
							else
								parse_nokogiri_xml( create_proc_tag( node.parent.to_s ) )
							end
						end
					end

					# Responsável por criar a tag <nfeProc> e adicionar o conteúdo 
					# passado por parâmetro dentro da tag.
					# Deve ser passado o xml em forma de String.
					#
					# <b>Type: </b> _String_
					#
					def create_proc_tag nfe_xml
						xml = "<nfeProc xmlns=\"#{nf_xmlns}\" versao=\"#{xml_version_str}\">"
						xml << nfe_xml
						xml << '</nfeProc>'
						xml
					end
				end
			end
		end
	end
end