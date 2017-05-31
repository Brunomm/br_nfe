module BrNfe
	module Service
		module Thema
			module V1
				class RecepcaoLoteRps < BrNfe::Service::Thema::V1::Base
					include BrNfe::Service::Concerns::Rules::RecepcaoLoteRps
					
					def url_wsdl
						get_wsdl_by_city[:send]
					end

					def certificado_obrigatorio?
						true
					end

					def method_wsdl
						:recepcionar_lote_rps
					end
					
					# Tag root da requisição
					#
					def soap_body_root_tag
						'recepcionarLoteRps'
					end

					def xml_builder
						xml = render_xml 'servico_enviar_lote_rps_envio'
						sign_nodes = [
							{
								node_path: "//nf:EnviarLoteRpsEnvio/nf:LoteRps/nf:ListaRps/nf:Rps/nf:InfRps", 
								node_namespaces: {nf: 'http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd'},
								node_ids: lote_rps.map{|rps| "R#{rps.numero}"}
							},
							{
								node_path: "//nf:EnviarLoteRpsEnvio/nf:LoteRps", 
								node_namespaces: {nf: 'http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd'},
								node_ids: ["L#{numero_lote_rps}"]
							}
						]
						sign_xml('<?xml version="1.0" encoding="ISO-8859-1"?>'+xml, sign_nodes)
					end

				private	
					def response_class
						BrNfe::Service::Response::RecepcaoLoteRps
					end

					def set_response
						@response = BrNfe::Service::Response::Build::RecepcaoLoteRps.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							keys_root_path: [],
							body_xml_path:  [:recepcionar_lote_rps_response, :return],
							xml_encode:     response_encoding, # Codificação do xml de resposta
						).response
					end
				end
			end
		end
	end
end