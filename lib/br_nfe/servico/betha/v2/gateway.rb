module BrNfe
	module Servico
		module Betha
			module V2
				class Gateway < BrNfe::Servico::Betha::Base
					def namespaces
						{"xmlns:e" => "http://www.betha.com.br/e-nota-contribuinte-ws"}
					end

					def namespace_identifier
						:e
					end

					def version
						:v2
					end

					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/nfseWS?wsdl"
					end

					def request
						set_response( client_wsdl.call(method_wsdl, message: "#{cabecalho}#{content_xml}") )
					end

					def set_response(resp)
						method_response = (method_wsdl.to_s + "_response").to_sym
						@response = BrNfe::Servico::Betha::V2::Response.new(xml: resp.hash[:envelope][:body][method_response][:return], nfe_method: method_wsdl)
					end

					def cabecalho
						Nokogiri::XML::Builder.new do
							nfseCabecMsg do
								cdata(Nokogiri::XML::Builder.new do |xml|
									xml.cabecalho(xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws", versao: "2.02"){
										xml.versaoDados 2.02
									}
								end.doc.root)
							end
						end.doc.root.to_s.gsub(/\n/,'').gsub(/\t/,'')
					end

					def content_xml
						Nokogiri::XML::Builder.new do	
							nfseDadosMsg do
								cdata(xml_builder)
							end
						end.doc.root.to_s
					end
					
				private

					def format_data_xml_for_signature(data_xml)
						xml = Nokogiri::XML(data_xml.to_s, &:noblanks)
						node_name = xml.root.node_name
						xml = xml.root.xpath("//#{node_name}")
						xml.attr("xmlns", "http://www.betha.com.br/e-nota-contribuinte-ws")
						canonicalize xml.to_s
					end

					def tag_prestador(xml)
						xml.Prestador{ 
							xml.CpfCnpj{
								tag_cpf_cnpj(xml, emitente.cnpj)
							}
							xml.InscricaoMunicipal emitente.inscricao_municipal unless emitente.inscricao_municipal.blank?
						}						
					end

				end
			end
		end
	end
end