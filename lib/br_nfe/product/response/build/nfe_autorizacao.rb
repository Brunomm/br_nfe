module BrNfe
	module Product
		module Response
			module Build
				class NfeAutorizacao < Base

					def paths
						operation.gateway_settings[:xml_paths][:autorizacao][:return_paths]
					end
					
					def notas_fiscais
						operation.notas_fiscais
					end

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
							environment:              body_xml.xpath(paths[:ambiente],    paths[:namespaces]).text,
							app_version:              body_xml.xpath(paths[:app_version], paths[:namespaces]).text,
							processed_at:             request_processed_at,
							processing_status_code:   get_processing_status_code,
							processing_status_motive: get_processing_status_motive,
						}

						if async_protocol.present?
							# Se entrar aqui é porque o lote é assíncrono e tem um protocolo
							attrs[:protocol]     = async_protocol
							attrs[:average_time] = body_xml.xpath(paths[:average_time], paths[:namespaces]).text
						end

						manage_invoices!
						attrs[:notas_fiscais] = notas_fiscais

						# Notas fiscais sincronas só podem ter uma nota fiscal no lote
						# então o protocolo da resposta é igual ao da nota fiscal
						#
						if async_protocol.blank? && notas_fiscais.size == 1
							attrs[:protocol] ||= notas_fiscais.first.protocol
						end

						attrs
					end

					def async_protocol
						@async_protocol ||= body_xml.xpath(paths[:async_protocol], paths[:namespaces]).text
					end

					def node_prot_nfe
						body_xml.xpath(paths[:prot_nfe], paths[:namespaces])
					end

					def manage_invoices!
						if async_protocol.present?
							notas_fiscais.each do |nf| 
								nf.protocol      = async_protocol
								nf.processed_at  = request_processed_at
								nf.status_code   = get_processing_status_code
								nf.status_motive = get_processing_status_motive
							end
						elsif node_prot_nfe.present?
							notas_fiscais.each do |nfe|
								prot_nfe = parse_nokogiri_xml( node_prot_nfe.to_xml )
								set_invoice_protocol!(nfe, prot_nfe)
							end
						end
					end

					# Seta na nota fiscal os valores presentes no protocolo de autorização
					# Quando a nota fiscal for autorizada, também adiciona o protocolo de
					# autorização no XML da nota fiscal
					#
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
						@request_processed_at ||= body_xml.xpath(paths[:processed_at], paths[:namespaces]).text
					end

					def get_processing_status_code
						@get_processing_status_code   ||= body_xml.xpath(paths[:processing_status_code],   paths[:namespaces]).text
					end
					def get_processing_status_motive
						@get_processing_status_motive ||= body_xml.xpath(paths[:processing_status_motive], paths[:namespaces]).text
					end
				end
			end
		end
	end
end