module BrNfe
	module Product
		module Response
			module Build
				class NfeInutilizacao < Base

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
						@info_xml ||= parse_nokogiri_xml( body_xml.xpath('//ret:nfeInutilizacaoNF2Result/nf:retInutNFe/nf:infInut',  nf: nf_xmlns, ret: url_xmlns_retorno).to_xml )
					end

					# Responsável por setar os atributos específicos para
					# cada tipo de operação.
					# Nesse caso irá setar as informações da homologação da inutilização.
					#
					# <b>Type: </b> _Hash_
					#
					def specific_attributes
						{
							environment:              info_xml.xpath('//infInut/tpAmb').text,
							app_version:              info_xml.xpath('//infInut/verAplic').text,
							processed_at:             info_xml.xpath('//infInut/dhRecbto').text,
							protocol:                 info_xml.xpath('//infInut/nProt').text,
							
							processing_status_code:   info_xml.xpath('//infInut/cStat').text,
							processing_status_motive: info_xml.xpath('//infInut/xMotivo').text,
							
							uf:                   info_xml.xpath('//infInut/cUF').text,
							year:                 info_xml.xpath('//infInut/ano').text,
							cnpj:                 info_xml.xpath('//infInut/CNPJ').text,
							nf_model:             info_xml.xpath('//infInut/mod').text,
							nf_series:            info_xml.xpath('//infInut/serie').text,
							start_invoice_number: info_xml.xpath('//infInut/nNFIni').text,
							end_invoice_number:   info_xml.xpath('//infInut/nNFFin').text,
						}
					end
				end
			end
		end
	end
end