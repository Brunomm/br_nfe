module BrNfe
	module Servico
		module Betha
			module V2
				class CancelamentoNfs < BrNfe::Servico::Betha::V2::Gateway
					def method_wsdl
						:cancelar_nfse
					end

					def xml_builder
						xml = Nokogiri::XML::Builder.new do |xml|
							xml.CancelarNfseEnvio(xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws") {
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_pedido_cancelamento_assinado.doc.root.to_s )
							}
						end
					end

					
				end
			end
		end
	end
end