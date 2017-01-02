module BrNfe
	module Product
		module Response
			module Build
				class NfeRetAutorizacao < Base

					# Responsável por definir qual classe será instânciada para
					# setar os valores de retorno referentes a cada operação.
					#
					# <b>Type: </b> _Class_
					#
					def response_class
						BrNfe::Product::Response::NfeRetAutorizacao
					end
					
					# Responsável por setar os atributos específicos para
					# cada tipo de operação.
					# Nesse caso irá setar as notas fiscais com seus respectivos
					# XMLs.
					#
					# <b>Type: </b> _Hash_
					#
					def specific_attributes
						{
							environment:              body_xml.xpath('//ret:nfeRetAutorizacaoLoteResult/nf:retConsReciNFe/nf:tpAmb',    nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text,
							app_version:              body_xml.xpath('//ret:nfeRetAutorizacaoLoteResult/nf:retConsReciNFe/nf:verAplic', nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text,
							processed_at:             body_xml.xpath('//ret:nfeRetAutorizacaoLoteResult/nf:retConsReciNFe/nf:dhRecbto', nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text,
							protocol:                 body_xml.xpath('//ret:nfeRetAutorizacaoLoteResult/nf:retConsReciNFe/nf:nRec',     nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text,

							processing_status_code:   body_xml.xpath('//ret:nfeRetAutorizacaoLoteResult/nf:retConsReciNFe/nf:cStat',    nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text,
							processing_status_motive: body_xml.xpath('//ret:nfeRetAutorizacaoLoteResult/nf:retConsReciNFe/nf:xMotivo',  nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text,

							notas_fiscais:            get_invoices
						}
					end

					# Responsável por buscar os protocolos no XML da resposta.
					#
					# <b>Type: </b> _Nokogiri::XML::NodeSet_
					#
					def protocol_nfe_nodes
						@protocol_nfe_nodes ||= body_xml.xpath('//ret:nfeRetAutorizacaoLoteResult/nf:retConsReciNFe/nf:protNFe', nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno)
					end

					# Responsável por instânciar as notas fiscais presentes na resposta
					# a partir das tags de resposta do xml (protNFe).
					# Também irá ajustar e setar o xml atualizado na nota fiscal, já com o protocolo
					# incluso. Irá setar a tag nfeProc como raiz do XML.
					# 
					# <b>Type: </b> _Array_
					#
					def get_invoices
						invoices = []
						protocol_nfe_nodes.each do |prot_nfe|
							prot_nfe = parse_nokogiri_xml(prot_nfe.to_xml)
							invoices << build_invoice(prot_nfe)
						end
						invoices
					end

					# Rsponsável por instânciar uma nota fiscal a partir da tag protNFe.
					# Também vai setar o atributo xml específico da nota fiscal a partir
					# do valor setado em :original_xml
					# 
					# <b>Type: </b> _BrNfe.nota_fiscal_product_class_
					#
					def build_invoice prot_nfe
						invoice = BrNfe.nota_fiscal_product_class.new do |nfe|
							nfe.processed_at    = get_processed_at_from_prot_nfe(  prot_nfe )
							nfe.protocol        = get_protocol_from_prot_nfe(      prot_nfe )
							nfe.digest_value    = get_digest_value_from_prot_nfe(  prot_nfe )
							nfe.status_code     = get_status_code_from_prot_nfe(   prot_nfe )
							nfe.status_motive   = get_status_motive_from_prot_nfe( prot_nfe )
							nfe.chave_de_acesso = get_access_key_from_prot_nfe(    prot_nfe )
						end
						# 1° - Seta os valores possíveis encontrados na chave de acesso da NF-e
						set_values_by_access_key!( invoice )

						# 2° - Seta o XML da respectiva NF-e no objeto já com a tag <nfeProc>
						#      e a tag do protocolo(<protNFe>)
						set_invoice_xml_with_prot_nfe!( invoice, prot_nfe )
						invoice
					end

				private

					def get_protocol_from_prot_nfe prot_nfe
						prot_nfe.xpath('//protNFe/infProt/nProt').text
					end

					def get_digest_value_from_prot_nfe prot_nfe
						prot_nfe.xpath('//protNFe/infProt/digVal').text
					end

					def get_processed_at_from_prot_nfe prot_nfe
						prot_nfe.xpath('//protNFe/infProt/dhRecbto').text
					end

					def get_status_code_from_prot_nfe prot_nfe
						prot_nfe.xpath('//protNFe/infProt/cStat').text
					end

					def get_status_motive_from_prot_nfe prot_nfe
						prot_nfe.xpath('//protNFe/infProt/xMotivo').text
					end

					def get_access_key_from_prot_nfe prot_nfe
						prot_nfe.xpath('//protNFe/infProt/chNFe').text
					end


					# Seta os valores que estão concatenados na chave da NF-e
					# como o número da nota fiscal, cnpj do emitente, entre outros 
					# valores.
					#
					def set_values_by_access_key!(invoice)
						if invoice.chave_de_acesso.present?
							invoice.emitente.cnpj = invoice.chave_de_acesso[6..19]
							invoice.modelo_nf = invoice.chave_de_acesso[20..21]
							invoice.serie     = invoice.chave_de_acesso[22..24]
							invoice.numero_nf = invoice.chave_de_acesso[25..33].to_i
							invoice.codigo_nf = invoice.chave_de_acesso[35..42].to_i
						end
					end

					# Responsável por criar a tag <nfeProc> e adicionar o conteúdo 
					# passado por parâmetro dentro da tag.
					# Deve ser passado o xml em forma de String.
					#
					# <b>Type: </b> _String_
					#
					def create_proc_tag nfe_xml
						xml = "<nfeProc xmlns=\"http://www.portalfiscal.inf.br/nfe\" versao=\"#{xml_version_str}\">"
						xml << nfe_xml
						xml << '</nfeProc>'
						xml
					end

					# Responsável por buscar a tag <NFe> no XML passado em :original_xml
					# e adicioanr o XML da nota dentro da tag <nfeProc>.
					# Caso a nfe já esteja dentro da tag <nfeProc>, irá utilizar a mesma tag,
					# para que não perca outros protocolos caso já estejam setados.
					# Sempre vai retornar o xml onde a tag raiz é a <nfeProc>.
					#
					# <b>Type: </b> _Nokogiri::XML::Document_
					# 
					def find_invoice_xml_by_access_key invoice
						if node = parse_nokogiri_xml(original_xml).search("NFe/infNFe[@Id*=\"#{invoice.chave_de_acesso}\"]").first
							if doc_original_xml.xpath('/*').first.try(:name) == 'nfeProc'
								doc_original_xml
							else
								parse_nokogiri_xml( create_proc_tag( node.parent.to_s ) )
							end
						end
					end

					# Responsável por adicionar a tag <protNFe> dentro da tag <nfeProc>
					# mantendo os demais protocolos.
					# Também irá setar o XMl atualizado no attr :xml da nota fiscal
					#
					def set_invoice_xml_with_prot_nfe!(invoice, prot_nfe)
						if nfeProc = find_invoice_xml_by_access_key( invoice )
							if invoice.status == :success
								nfeProc.xpath('//nf:nfeProc', nf: "http://www.portalfiscal.inf.br/nfe").
								        children.last.try(:add_next_sibling, prot_nfe.root.to_xml )
							end

							invoice.xml = '<?xml version="1.0" encoding="UTF-8"?>'+canonicalize( nfeProc.to_xml )
						end
					end
				end
			end
		end
	end
end