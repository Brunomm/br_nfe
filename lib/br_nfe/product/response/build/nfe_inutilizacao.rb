module BrNfe
	module Product
		module Response
			module Build
				class NfeInutilizacao < Base

					def paths
						operation.gateway_settings[:xml_paths][:inutilizacao][:return_paths]
					end

					# Responsável por definir qual classe será instânciada para
					# setar os valores de retorno referentes a cada operação.
					#
					# <b>Type: </b> _Class_
					#
					def response_class
						BrNfe::Product::Response::NfeInutilizacao
					end

					# Responsável por pegar a tag XML principal que contém os dados da homologação.
					# Utilizado para facilitar a codificação e para não repetir o
					# código ao buscar as informações da homologação.
					#
					def info_xml
						@info_xml ||= parse_nokogiri_xml( body_xml.xpath( paths[:inf_inut], paths[:namespaces] ).to_xml )
					end

					# Responsável por setar os atributos específicos para
					# cada tipo de operação.
					# Nesse caso irá setar as informações da homologação da inutilização.
					#
					# <b>Type: </b> _Hash_
					#
					def specific_attributes
						{
							environment:              info_xml.xpath( paths[:environment]).text,
							app_version:              info_xml.xpath( paths[:app_version]).text,
							processed_at:             info_xml.xpath( paths[:processed_at]).text,
							protocol:                 info_xml.xpath( paths[:protocol]).text,
							processing_status_code:   info_xml.xpath( paths[:processing_status_code]).text,
							processing_status_motive: info_xml.xpath( paths[:processing_status_motive]).text,
							uf:                       info_xml.xpath( paths[:uf]).text,
							year:                     info_xml.xpath( paths[:year]).text,
							cnpj:                     info_xml.xpath( paths[:cnpj]).text,
							nf_model:                 info_xml.xpath( paths[:nf_model]).text,
							nf_series:                info_xml.xpath( paths[:nf_series]).text,
							start_invoice_number:     info_xml.xpath( paths[:start_invoice_number]).text.to_i,
							end_invoice_number:       info_xml.xpath( paths[:end_invoice_number]).text.to_i,
						}
					end
				end
			end
		end
	end
end