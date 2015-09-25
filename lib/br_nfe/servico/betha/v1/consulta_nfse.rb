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

					validates :data_inicial, :data_final, presence: true


					def data_inicial
						value_date(@data_inicial)
					end

					def data_final
						value_date(@data_final)
					end


					def method_wsdl
						:consultar_nfse
					end

					def xml_builder
						Nokogiri::XML::Builder.new do |xml|
							xml.Temp {
								
								# Pestador / Emitente
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_prestador.doc.root.to_s )
								
								xml.NumeroNfse BrNfe::Helper.only_number(numero_nfse).max_size(15) if !numero_nfse.blank?
								xml.PeriodoEmissao {
									xml.DataInicial data_inicial
									xml.DataFinal   data_final
								}
							}
						end.doc.root
					end

				end
			end
		end
	end
end