module BrNfe
	module Servico
		module Betha
			module V1
				class ConsultaNfse < BrNfe::Servico::Betha::V1::Gateway

					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/consultarNfse?wsdl"
					end
					
					attr_accessor :numero_nfse
					attr_accessor :data_inicial
					attr_accessor :data_final


					def method_wsdl
						:consultar_nfse
					end

					def xml_builder
						Nokogiri::XML::Builder.new do |xml|
							xml.Temp {
								
								tag_prestador(xml)

								xml.NumeroNfse numero_nfse if numero_nfse.present?
								xml.PeriodoEmissao {
									xml.DataInicial data_formatada data_inicial
									xml.DataFinal   data_formatada data_final
								}
							}
						end.doc.root
					end
				end
			end
		end
	end
end