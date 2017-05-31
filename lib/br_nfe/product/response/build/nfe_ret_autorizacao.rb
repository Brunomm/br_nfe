module BrNfe
	module Product
		module Response
			module Build
				class NfeRetAutorizacao < Base

					def paths
						operation.gateway_settings[:xml_paths][:retorno_autorizacao][:return_paths]
					end

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
							environment:              body_xml.xpath(paths[:environment],  paths[:namespaces]).text,
							app_version:              body_xml.xpath(paths[:app_version],  paths[:namespaces]).text,
							processed_at:             body_xml.xpath(paths[:processed_at], paths[:namespaces]).text,
							protocol:                 body_xml.xpath(paths[:protocol],     paths[:namespaces]).text,

							processing_status_code:   body_xml.xpath(paths[:processing_status_code],   paths[:namespaces]).text,
							processing_status_motive: body_xml.xpath(paths[:processing_status_motive], paths[:namespaces]).text,

							notas_fiscais:            get_invoices
						}
					end

					# Responsável por buscar os protocolos no XML da resposta.
					#
					# <b>Type: </b> _Nokogiri::XML::NodeSet_
					#
					def protocol_nfe_nodes
						@protocol_nfe_nodes ||= body_xml.xpath(paths[:prot_nfe], paths[:namespaces] )
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
							invoices << build_invoice_by_prot_nfe(prot_nfe)
						end
						invoices
					end
				end
			end
		end
	end
end