module BrNfe
	module Service
		module Betha
			module V2
				class SubstituicaoNfse < BrNfe::Service::Betha::V2::Gateway
					include BrNfe::Helper::HaveRps
					
					validate :valida_rps_recepcao
					validates :numero_nfse, :codigo_cancelamento, presence: true

					def certificado_obrigatorio?
						true
					end

					def method_wsdl
						:substituir_nfse
					end

					def xml_builder
						xml = Nokogiri::XML::Builder.new do |xml|
							xml.SubstituirNfseEnvio(xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws") {
								xml_substituicao = xml_substituicao_nfse.doc.root
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_substituicao.to_s )
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( assinatura_xml(xml_substituicao.to_s, "#substituicao") )
							}
						end
					end

					def xml_substituicao_nfse
						Nokogiri::XML::Builder.new do |xml|
							xml.SubstituicaoNfse(Id: "substituicao") {
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_pedido_cancelamento_assinado.doc.root.to_s )
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_rps_assinado(rps).doc.root.to_s )
							}
						end						
					end

					
				end
			end
		end
	end
end