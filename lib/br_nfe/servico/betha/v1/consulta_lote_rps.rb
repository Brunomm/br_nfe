module BrNfe
	module Servico
		module Betha
			module V1
				class ConsultaLoteRps < BrNfe::Servico::Betha::V1::Gateway

					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/consultarLoteRps?wsdl"
					end
					
					attr_accessor :protocolo

					validates :protocolo, presence: true

					def method_wsdl
						:consultar_lote_rps
					end

					def xml_builder
						Nokogiri::XML::Builder.new do |xml|
							xml.Temp {
								tag_prestador(xml)								
								xml.Protocolo protocolo
							}
						end.doc.root
					end
				end
			end
		end
	end
end