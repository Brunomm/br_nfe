require 'test_helper'

describe BrNfe::Servico::Betha::V1::CancelamentoNfs do
	subject             { FactoryGirl.build(:servico_betha_cancelamento_nfs, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Servico::Betha::V1::Gateway }
	end

	describe "#wsdl" do
		context "for env production" do
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/cancelarNfseV02?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/cancelarNfseV02?wsdl' }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :cancelar_nfse }
	end


	describe "#xml_inf_pedido_cancelamento" do
		it "estrutura" do
			xml = subject.send(:xml_inf_pedido_cancelamento).doc

			xml.xpath('InfPedidoCancelamento/CodigoCancelamento').first.text.must_equal subject.codigo_cancelamento
			
			xml.xpath('InfPedidoCancelamento/IdentificacaoNfse/Numero').first.text.must_equal   subject.numero_nfse
			
			xml.xpath('InfPedidoCancelamento/IdentificacaoNfse/Cnpj').first.text.must_equal   emitente.cnpj
			xml.xpath('InfPedidoCancelamento/IdentificacaoNfse/InscricaoMunicipal').first.text.must_equal   emitente.inscricao_municipal
			xml.xpath('InfPedidoCancelamento/IdentificacaoNfse/CodigoMunicipio').first.text.must_equal   emitente.endereco.codigo_municipio
		end
	end


	describe "#xml_builder" do
		let(:info_pedido) do
			Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
				xml.InfPedidoCancelamento 'Valor'
			end
		end

		it "deve adicionar o valor do xml_inf_pedido_cancelamento e assinar o xml" do
			subject.stubs(:xml_inf_pedido_cancelamento).returns(info_pedido)
			subject.expects(:assinatura_xml).with(info_pedido.doc.root.to_s).returns("<Signature>Val</Signature>")
			xml = subject.xml_builder
			xml = Nokogiri::XML xml

			xml.xpath('Pedido/InfPedidoCancelamento').first.text.must_equal 'Valor'
			xml.xpath('Pedido/Signature').first.text.must_equal 'Val'

		end
	end

end