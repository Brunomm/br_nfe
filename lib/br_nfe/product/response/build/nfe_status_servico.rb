module BrNfe
	module Product
		module Response
			module Build
				class NfeStatusServico < Base

					def paths
						operation.gateway_settings[:xml_paths][:status_servico][:return_paths]
					end

					# Responsável por definir qual classe será instânciada para
					# setar os valores de retorno referentes a cada operação.
					#
					# <b>Type: </b> _Class_
					#
					def response_class
						BrNfe::Product::Response::NfeStatusServico
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
							
							environment:              body_xml.xpath( paths[:environment],  paths[:namespaces]).text,
							app_version:              body_xml.xpath( paths[:app_version],  paths[:namespaces]).text,
							processed_at:             body_xml.xpath( paths[:processed_at], paths[:namespaces]).text,
							uf:                       body_xml.xpath( paths[:uf],           paths[:namespaces]).text,
							average_time:             body_xml.xpath( paths[:average_time],  paths[:namespaces]).text.to_i,
							observation:              body_xml.xpath( paths[:observation],  paths[:namespaces]).text,
							return_prevision:         body_xml.xpath( paths[:return_prevision],   paths[:namespaces]).text,
							processing_status_code:   body_xml.xpath( paths[:processing_status_code],   paths[:namespaces]).text,
							processing_status_motive: body_xml.xpath( paths[:processing_status_motive], paths[:namespaces]).text,
							
						}
					end
				end
			end
		end
	end
end