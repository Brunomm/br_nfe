module BrNfe
	module Service
		module Betha
			module V1
				class CancelamentoNfs < BrNfe::Service::Betha::V1::Gateway
					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/cancelarNfseV02?wsdl"
					end
					
					def method_wsdl
						:cancelar_nfse
					end

					def certificado_obrigatorio?
						true
					end

					attr_accessor :numero_nfse
					attr_accessor :codigo_cancelamento

					validates :numero_nfse, :codigo_cancelamento, presence: true

					def xml_builder
						xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
							xml.Pedido {
								inf_pedido_cancelamento = xml_inf_pedido_cancelamento.doc.root
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( canonicalize(inf_pedido_cancelamento) )
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( assinatura_xml(inf_pedido_cancelamento.to_s) )
							}
						end.doc
						
						canonicalize(xml.root())
					end
					
					def xml_inf_pedido_cancelamento
						Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
							xml.InfPedidoCancelamento{
								xml.IdentificacaoNfse{
									xml.Numero BrNfe::Helper.only_number(numero_nfse).max_size(15)
									tag_cpf_cnpj(xml, emitente.cnpj)
									xml.InscricaoMunicipal "#{emitente.inscricao_municipal}".max_size(15) if !emitente.inscricao_municipal.blank? && env == :production
									xml.CodigoMunicipio    "#{emitente.endereco.codigo_municipio}".max_size(7) 
								}
								xml.CodigoCancelamento "#{codigo_cancelamento}".max_size(4)
							}
						end
					end
				end
			end
		end
	end
end