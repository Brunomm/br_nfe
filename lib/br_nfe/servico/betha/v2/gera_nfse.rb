module BrNfe
	module Servico
		module Betha
			module V2
				class GeraNfse < BrNfe::Servico::Betha::V2::Gateway
					include BrNfe::Helper::HaveRps

					def method_wsdl
						:gerar_nfse
					end

					def xml_builder
						xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
							xml.GerarNfseEnvio(xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws") {
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_rps_assinado(rps).doc.root.to_s)
							}
						end.doc.root
						
						canonicalize xml
					end
				end
			end
		end
	end
end