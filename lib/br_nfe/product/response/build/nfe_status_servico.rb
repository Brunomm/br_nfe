module BrNfe
	module Product
		module Response
			module Build
				class NfeStatusServico < Base

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
							environment:              body_xml.xpath('//ret:nfeStatusServicoNF2Result/nf:retConsStatServ/nf:tpAmb',    nf: nf_xmlns, ret: url_xmlns_retorno).text,
							app_version:              body_xml.xpath('//ret:nfeStatusServicoNF2Result/nf:retConsStatServ/nf:verAplic', nf: nf_xmlns, ret: url_xmlns_retorno).text,
							processed_at:             body_xml.xpath('//ret:nfeStatusServicoNF2Result/nf:retConsStatServ/nf:dhRecbto', nf: nf_xmlns, ret: url_xmlns_retorno).text,
							
							processing_status_code:   body_xml.xpath('//ret:nfeStatusServicoNF2Result/nf:retConsStatServ/nf:cStat',    nf: nf_xmlns, ret: url_xmlns_retorno).text,
							processing_status_motive: body_xml.xpath('//ret:nfeStatusServicoNF2Result/nf:retConsStatServ/nf:xMotivo',  nf: nf_xmlns, ret: url_xmlns_retorno).text,
							
							uf:               body_xml.xpath('//ret:nfeStatusServicoNF2Result/nf:retConsStatServ/nf:cUF',  nf: nf_xmlns, ret: url_xmlns_retorno).text,
							average_time:     body_xml.xpath('//ret:nfeStatusServicoNF2Result/nf:retConsStatServ/nf:tMed',  nf: nf_xmlns, ret: url_xmlns_retorno).text.to_i,
							observation:      body_xml.xpath('//ret:nfeStatusServicoNF2Result/nf:retConsStatServ/nf:xObs',  nf: nf_xmlns, ret: url_xmlns_retorno).text,
							return_prevision: body_xml.xpath('//ret:nfeStatusServicoNF2Result/nf:retConsStatServ/nf:dhRetorno',  nf: nf_xmlns, ret: url_xmlns_retorno).text,
						}
					end

				end
			end
		end
	end
end