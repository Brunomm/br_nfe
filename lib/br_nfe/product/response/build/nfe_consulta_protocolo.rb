# o método original_xml deve ter o XML da NF-e
#
module BrNfe
	module Product
		module Response
			module Build
				class NfeConsultaProtocolo < Base
					def paths
						operation.gateway_settings[:xml_paths][:consulta_protocolo][:return_paths]
					end

					def evento_request_paths
						nfe_settings[:evento_request_paths]
					end
					def evento_return_paths
						nfe_settings[:evento_return_paths]
					end

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
							environment:              body_xml.xpath( paths[:environment],              paths[:namespaces]).text,
							app_version:              body_xml.xpath( paths[:app_version],              paths[:namespaces]).text,
							processed_at:             body_xml.xpath( paths[:processed_at],             paths[:namespaces]).text,
							processing_status_code:   body_xml.xpath( paths[:processing_status_code],   paths[:namespaces]).text,
							processing_status_motive: body_xml.xpath( paths[:processing_status_motive], paths[:namespaces]).text,
							vers:                     xml_version
						}
						set_events!( attrs )
						attrs[:nota_fiscal] = build_invoice_by_prot_nfe( prot_nfe_doc ) if prot_nfe_doc
						set_invoice_situation!( attrs )
						attrs
					end

				private

					def prot_nfe_doc
						return @prot_nfe_doc if @prot_nfe_doc
						if prot_nfe = body_xml.xpath( paths[:prot_nfe], paths[:namespaces] ).first
							@prot_nfe_doc = parse_nokogiri_xml( prot_nfe.to_xml )
						end
					end

					# Responsável por instanciar e setar os eventos através do XML
					# Percore todas as tags de eventos, instancia o evento e seta o 
					# valor na chave do evento
					#
					def set_events! attrs
						attrs[:events] = []
						body_xml.xpath( paths[:proc_evento_nfe], paths[:namespaces]).each do |event_node|
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
							event.codigo_orgao           = doc_evento.xpath( evento_return_paths[:codigo_orgao] ).text
							event.status_code            = doc_evento.xpath( evento_return_paths[:status_code] ).text
							event.status_motive          = doc_evento.xpath( evento_return_paths[:status_motive] ).text
							event.code                   = doc_evento.xpath( evento_return_paths[:code] ).text
							event.sequence               = doc_evento.xpath( evento_return_paths[:sequence] ).text.to_i
							event.registred_at           = doc_evento.xpath( evento_return_paths[:registred_at] ).text
							event.authorization_protocol = doc_evento.xpath( evento_return_paths[:authorization_protocol] ).text
							if doc_evento.xpath(evento_return_paths[:cnpj_destino]).present?
								event.cpf_cnpj_destino   = doc_evento.xpath(evento_return_paths[:cnpj_destino]).text
							else
								event.cpf_cnpj_destino   = doc_evento.xpath(evento_return_paths[:cpf_destino]).text
							end

							event.sent_at            = doc_evento.xpath( evento_request_paths[:sent_at] ).text
							event.event_protocol     = doc_evento.xpath( evento_request_paths[:event_protocol] ).text
							event.description        = doc_evento.xpath( evento_request_paths[:description] ).text
							event.justification      = doc_evento.xpath( evento_request_paths[:justification] ).text
							event.correction_text    = doc_evento.xpath( evento_request_paths[:correction_text] ).text
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