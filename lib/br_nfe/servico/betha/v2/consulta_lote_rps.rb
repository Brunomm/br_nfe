module BrNfe
	module Servico
		module Betha
			module V2
				class ConsultaLoteRps < BrNfe::Servico::Betha::V2::Gateway
					
					attr_accessor :protocolo

					validates :protocolo, presence: true

					def method_wsdl
						:consultar_lote_rps
					end

					def xml_builder
						xml = Nokogiri::XML::Builder.new do |xml|
							xml.ConsultarLoteRpsEnvio(xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws") {
								
								# Pestador / Emitente
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_prestador.doc.root.to_s )

								xml.Protocolo "#{protocolo}".max_size(50)
							}
						end
					end
				end
			end
		end
	end
end