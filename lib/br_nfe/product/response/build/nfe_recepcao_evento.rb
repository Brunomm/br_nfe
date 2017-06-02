# o método original_xml deve ter o XML da NF-e
#
module BrNfe
	module Product
		module Response
			module Build
				class NfeRecepcaoEvento < Base
					def paths
						operation.gateway_settings[:xml_paths][:recepcao_evento][:return_paths]
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
						BrNfe::Product::Response::NfeRecepcaoEvento
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
							codigo_orgao:             body_xml.xpath( paths[:codigo_orgao],             paths[:namespaces]).text,
						}
						set_events!( attrs )
						attrs[:xml] = set_xml_events!
						attrs
					end

				private

					def ret_env_evento
						@ret_env_evento ||= parse_nokogiri_xml body_xml.xpath( paths[:ret_env_evento], paths[:namespaces]).to_xml
					end

					def set_xml_events!
						xml = '<?xml version="1.0" encoding="UTF-8"?>'
						xml += '<procEventoNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">'
						xml += operation.xml_builder
						xml += canonicalize( ret_env_evento.to_xml )
						xml += '</procEventoNFe>'
						xml
					end

					def set_events! attrs
						# É necessário duplicar para remover os namespaces para que não altere o objeto
						ret_env_evento_dup = ret_env_evento.dup 
						# É necessário remover os namespaces pois alguns eventos vem com o namespace e outros não
						ret_env_evento_dup.remove_namespaces!

						eventos = ret_env_evento_dup.xpath( paths[:ret_evento_without_namespaces] )
						attrs[:events] = []
						eventos.each do |event_node|
							doc_evento = parse_nokogiri_xml( event_node.to_xml )
							attrs[:events] << build_event_by_xml( doc_evento )
						end
					end

					def build_event_by_xml( doc_evento )
						BrNfe::Product::Response::Event.new do |event|
							event.codigo_orgao           = doc_evento.xpath( paths[:info_event_codigo_orgao] ).text
							event.status_code            = doc_evento.xpath( paths[:info_event_status_code] ).text
							event.status_motive          = doc_evento.xpath( paths[:info_event_status_motive] ).text
							event.code                   = doc_evento.xpath( paths[:info_event_code] ).text
							event.sequence               = doc_evento.xpath( paths[:info_event_sequence] ).text.to_i
							event.registred_at           = doc_evento.xpath( paths[:info_event_registred_at] ).text
							event.authorization_protocol = doc_evento.xpath( paths[:info_event_authorization_protocol] ).text
							if doc_evento.xpath(paths[:info_event_cnpj_destino]).present?
								event.cpf_cnpj_destino   = doc_evento.xpath(paths[:info_event_cnpj_destino]).text
							else
								event.cpf_cnpj_destino   = doc_evento.xpath(paths[:info_event_cpf_destino]).text
							end
						end
					end
				end
			end
		end
	end
end