# o método original_xml deve ter o XML da NF-e
#
module BrNfe
	module Product
		module Response
			module Build
				class NfeConsultaProtocolo < Base
					# Responsável por definir qual classe será instânciada para
					# setar os valores de retorno referentes a cada operação.
					#
					# <b>Type: </b> _Class_
					#
					def response_class
						BrNfe::Product::Response::NfeConsultaProtocolo
					end

					# Responsável por setar os atributos específicos para
					# cada tipo de operação.
					#
					# <b>Type: </b> _Hash_
					#
					def specific_attributes
						attrs = {
							environment:              body_xml.xpath('//ret:nfeConsultaNF2Result/nf:retConsSitNFe/nf:tpAmb',    nf: nf_xmlns, ret: url_xmlns_retorno).text,
							app_version:              body_xml.xpath('//ret:nfeConsultaNF2Result/nf:retConsSitNFe/nf:verAplic', nf: nf_xmlns, ret: url_xmlns_retorno).text,
							processed_at:             request_processed_at,
							processing_status_code:   get_processing_status_code,
							processing_status_motive: get_processing_status_motive,
						}

						set_events!( attrs )

						attrs[:nota_fiscal] = build_invoice_by_prot_nfe( prot_nfe_doc ) if prot_nfe_doc

						set_invoice_situation!( attrs )

						attrs
					end

				private

					def prot_nfe_doc
						return @prot_nfe_doc if @prot_nfe_doc
						if prot_nfe = body_xml.xpath('//ret:nfeConsultaNF2Result/nf:retConsSitNFe/nf:protNFe', nf: nf_xmlns, ret: url_xmlns_retorno).first
							@prot_nfe_doc = parse_nokogiri_xml( prot_nfe.to_xml )
						end
					end

					def request_processed_at
						@request_processed_at ||= body_xml.xpath('//ret:nfeConsultaNF2Result/nf:retConsSitNFe/nf:dhRecbto', nf: nf_xmlns, ret: url_xmlns_retorno).text
					end
					def get_processing_status_code
						@get_processing_status_code ||= body_xml.xpath('//ret:nfeConsultaNF2Result/nf:retConsSitNFe/nf:cStat',    nf: nf_xmlns, ret: url_xmlns_retorno).text
					end
					def get_processing_status_motive
						@get_processing_status_motive ||= body_xml.xpath('//ret:nfeConsultaNF2Result/nf:retConsSitNFe/nf:xMotivo',  nf: nf_xmlns, ret: url_xmlns_retorno).text
					end

					# Responsável por instanciar e setar os eventos através do XML
					# Percore todas as tags de eventos, instancia o evento e seta o 
					# valor na chave do evento
					#
					def set_events! attrs
						attrs[:events] = []
						body_xml.xpath('//ret:nfeConsultaNF2Result/nf:retConsSitNFe/nf:procEventoNFe', nf: nf_xmlns, ret: url_xmlns_retorno).each do |event_node|
							doc_evento = parse_nokogiri_xml( event_node.to_xml )
							attrs[:events] << build_event_by_xml( doc_evento )
						end
						set_main_event!(attrs)
					end

					# Responsável por setar o evento principal.
					# O evento principal é o que tem a maior sequência. Exceto se
					# tiver algum evento de cancelamento, pois o evento de cancelamento
					# é sempre o último evento, e após o cancelamento não é mais 
					# possível registrar eventos.
					#
					def set_main_event!(attrs)
						#                                           CÓDIGO DE CANCELAMENTO
						if ev_cancel = attrs[:events].select{|e| e.code == '110111' }.last
							attrs[:main_event] = ev_cancel
						else
							attrs[:main_event] = attrs[:events].sort_by{|e| [e.sequence.to_i, (e.registred_at||Time.current)] }.last
						end
					end

					def build_event_by_xml( doc_evento )
						# É feito o dup para setar no evento o XMl com os namespaces
						doc_evento_with_namespaces = doc_evento.dup

						# Os namespaces são removidos pois as vezes pode vir com namespace
						# e as vezes não.
						doc_evento.remove_namespaces!

						BrNfe::Product::Response::Event.new do |event|
							event.codigo_orgao       = doc_evento.xpath('//procEventoNFe/retEvento/infEvento/cOrgao').text
							event.status_code        = doc_evento.xpath('//procEventoNFe/retEvento/infEvento/cStat').text
							event.status_motive      = doc_evento.xpath('//procEventoNFe/retEvento/infEvento/xMotivo').text
							event.code               = doc_evento.xpath('//procEventoNFe/retEvento/infEvento/tpEvento').text
							event.sequence           = doc_evento.xpath('//procEventoNFe/retEvento/infEvento/nSeqEvento').text.to_i
							
							if doc_evento.xpath('//procEventoNFe/retEvento/infEvento/CNPJDest').present?
								event.cpf_cnpj_destino   = doc_evento.xpath('//procEventoNFe/retEvento/infEvento/CNPJDest').text
							else
								event.cpf_cnpj_destino   = doc_evento.xpath('//procEventoNFe/retEvento/infEvento/CPFDest').text
							end
							
							event.sent_at            = doc_evento.xpath('//procEventoNFe/evento/infEvento/dhEvento').text
							event.registred_at       = doc_evento.xpath('//procEventoNFe/retEvento/infEvento/dhRegEvento').text
							event.event_protocol     = doc_evento.xpath('//procEventoNFe/evento/infEvento/detEvento/nProt').text
							event.ret_event_protocol = doc_evento.xpath('//procEventoNFe/retEvento/infEvento/nProt').text
							event.description        = doc_evento.xpath('//procEventoNFe/evento/infEvento/detEvento/descEvento').text
							event.justification      = doc_evento.xpath('//procEventoNFe/evento/infEvento/detEvento/xJust').text
							event.correction_text    = doc_evento.xpath('//procEventoNFe/evento/infEvento/detEvento/xCorrecao').text
							event.xml                = '<?xml version="1.0" encoding="UTF-8"?>'+canonicalize( doc_evento_with_namespaces.to_xml )
						end
					end

					def set_invoice_situation!( attrs )
						if attrs[:nota_fiscal].present? && attrs[:main_event].present?
							case attrs[:main_event].code.to_i
							when 110111
								attrs[:nota_fiscal].situation = :canceled
							when 110110
								attrs[:nota_fiscal].situation = :adjusted
							end
						end
					end
				end
			end
		end
	end
end