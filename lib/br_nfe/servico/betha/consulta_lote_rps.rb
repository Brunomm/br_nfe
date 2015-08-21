module BrNfe
	module Servico
		module Betha
			class ConsultaLoteRps < BrNfe::Servico::Betha::Gateway
				def method_wsdl
					:consultar_lote_rps
				end

				def xml_builder
					(transform_xml(dados_xml).to_s.gsub("&","&amp;").gsub(">","&gt;").gsub("<","&lt;").gsub("\"","&quot;").gsub("'","&apos;")).gsub(/\n/,'')
				end

				def dados_xml
					builder = Nokogiri::XML::Builder.new do |xml|
						xml.send("ConsultarLoteRpsEnvio", xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws" ) {
							xml.Prestador {
								xml.CpfCnpj {
									xml.Cnpj '45111111111100'
								}
							}							
							xml.Protocolo '141542179222170'
						}
					end
					Nokogiri::XML( builder.to_xml( :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION ) )
				end
				 

				 def transform_xml(xml)
				 	xml = Nokogiri::XML(xml.to_s, &:noblanks)

					xml_canon = xml.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
					xml_digest = Base64.encode64(OpenSSL::Digest::SHA1.digest(xml_canon)).strip

					xml.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
				 end
			end
		end
	end
end