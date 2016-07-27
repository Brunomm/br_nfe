module BrNfe
	module Service
		module Betha
			module V2
				class CancelamentoNfs < BrNfe::Service::Betha::V2::Gateway

					validates :numero_nfse, :codigo_cancelamento, presence: true

					def certificado_obrigatorio?
						true
					end

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