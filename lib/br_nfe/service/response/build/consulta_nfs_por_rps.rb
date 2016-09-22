#encoding UTF-8
module BrNfe
	module Service
		module Response
			module Build
				class ConsultaNfsPorRps  < BrNfe::Service::Response::Build::InvoiceBuild
					def response
						@response ||= BrNfe::Service::Response::ConsultaNfsPorRps.new({
							original_xml:     savon_response.xml.force_encoding('UTF-8'),
							error_messages:   get_message_for_path(message_errors_path),
							notas_fiscais:    get_invoices,
						})
					end
				end
			end
		end
	end
end