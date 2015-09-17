module BrNfe
	module Servico
		module Betha
			module V2
				class ConsultaNfsePorRps < BrNfe::Servico::Betha::V2::Gateway
					include BrNfe::Helper::HaveRps
					
					def method_wsdl
						:consultar_nfse_por_rps
					end

					def xml_builder
						xml = Nokogiri::XML::Builder.new do |xml|
							xml.ConsultarNfseRpsEnvio(xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws") {
								tag_identificacao_rps(xml, rps)

								tag_prestador(xml)
							}
						end.doc.root

						canonicalize xml
					end
				end
			end
		end
	end
end