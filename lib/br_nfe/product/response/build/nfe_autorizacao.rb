module BrNfe
	module Product
		module Response
			module Build
				class NfeAutorizacao < NfeRetAutorizacao
					has_many :notas_fiscais, 'BrNfe.nota_fiscal_product_class'

					# Responsável por definir qual classe será instânciada para
					# setar os valores de retorno referentes a cada operação.
					#
					# <b>Type: </b> _Class_
					#
					def response_class
						BrNfe::Product::Response::NfeAutorizacao
					end
					
					# Responsável por setar os atributos específicos para
					# cada tipo de operação.
					#
					# <b>Type: </b> _Hash_
					#
					def specific_attributes
						attrs = {
							environment:              body_xml.xpath('//ret:nfeAutorizacaoLoteResult/nf:retEnviNFe/nf:tpAmb',    nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text,
							app_version:              body_xml.xpath('//ret:nfeAutorizacaoLoteResult/nf:retEnviNFe/nf:verAplic', nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text,
							processed_at:             request_processed_at,

							processing_status_code:   get_processing_status_code,
							processing_status_motive: get_processing_status_motive,
						}

						if async_protocol.present?
							# Se entrar aqui é porque o lote é assíncrono e tem um protocolo
							attrs[:protocol]    = async_protocol
							attrs[:tempo_medio] = body_xml.xpath('//ret:nfeAutorizacaoLoteResult/nf:retEnviNFe/nf:infRec/nf:tMed', nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text
						else
							attrs[:protocol] = body_xml.xpath('//ret:nfeAutorizacaoLoteResult/nf:retEnviNFe/nf:protNFe/nf:infProt/nf:nProt', nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text
						end

						manage_invoices!
						attrs[:notas_fiscais] = notas_fiscais

						attrs
					end

					def async_protocol
						@async_protocol ||= body_xml.xpath('//ret:nfeAutorizacaoLoteResult/nf:retEnviNFe/nf:infRec/nf:nRec', nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text
					end

					def node_prot_nfe
						body_xml.xpath('//ret:nfeAutorizacaoLoteResult/nf:retEnviNFe/nf:protNFe', nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno)
					end

					def manage_invoices!
						if async_protocol.present?
							notas_fiscais.each do |nf| 
								nf.protocol = async_protocol
								nf.processed_at = request_processed_at
								nf.status_code = get_processing_status_code
								nf.status_motive = get_processing_status_motive
							end
						elsif node_prot_nfe.present?
							notas_fiscais.each do |nfe|
								prot_nfe = parse_nokogiri_xml( node_prot_nfe.to_xml )
								set_invoice_protocol!(nfe, prot_nfe)
							end
						end
					end

					def set_invoice_protocol! invoice, prot_nfe
						invoice.processed_at    = get_processed_at_from_prot_nfe(  prot_nfe )
						invoice.protocol        = get_protocol_from_prot_nfe(      prot_nfe )
						invoice.digest_value    = get_digest_value_from_prot_nfe(  prot_nfe )
						invoice.status_code     = get_status_code_from_prot_nfe(   prot_nfe )
						invoice.status_motive   = get_status_motive_from_prot_nfe( prot_nfe )
						invoice.chave_de_acesso = get_access_key_from_prot_nfe(    prot_nfe )
						
						# Seta o XML da respectiva NF-e no objeto já com a tag <nfeProc>
						# e a tag do protocolo(<protNFe>)
						set_invoice_xml_with_prot_nfe!( invoice, prot_nfe ) if invoice.status == :success
					end

				private

					def request_processed_at
						@request_processed_at ||= body_xml.xpath('//ret:nfeAutorizacaoLoteResult/nf:retEnviNFe/nf:dhRecbto', nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text
					end

					def get_processing_status_code
						@get_processing_status_code ||= body_xml.xpath('//ret:nfeAutorizacaoLoteResult/nf:retEnviNFe/nf:cStat',    nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text
					end
					def get_processing_status_motive
						@get_processing_status_motive ||= body_xml.xpath('//ret:nfeAutorizacaoLoteResult/nf:retEnviNFe/nf:xMotivo',  nf: "http://www.portalfiscal.inf.br/nfe", ret: url_xmlns_retorno).text
					end

					# Responsável montar o XML da tag <nfeProc>, aplicar o XMl da nfe
					# dentro e adicionar o protocolo.
					#
					# Primeiro irá verificar se existe algum XML setado na própria NF-e
					# e se tiver, irá utilizar esse XML para criar a estrutura da <nfeProc>.
					# Caso a NF-e não tenha o XML, irá buscar o XML da nfe através do atributo
					# :original_xml.
					#
					# <b>Type: </b> _Nokogiri::XML::Document_
					# 
					def find_invoice_xml_by_access_key invoice
						doc_nf = parse_nokogiri_xml("#{invoice.xml}")
						if node = doc_nf.search("NFe/infNFe[@Id*=\"#{invoice.chave_de_acesso}\"]").first
							if doc_nf.xpath('/*').first.try(:name) == 'nfeProc'
								doc_nf
							else
								parse_nokogiri_xml( create_proc_tag( node.parent.to_s ) )
							end
						else
							super
						end
					end
				end
			end
		end
	end
end