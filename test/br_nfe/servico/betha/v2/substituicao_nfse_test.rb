require 'test_helper'

describe BrNfe::Servico::Betha::V2::SubstituicaoNfse do
	subject        { FactoryGirl.build(:br_nfe_servico_betha_v2_substituicao_nfse, emitente: emitente, rps: rps) }
	let(:emitente) { FactoryGirl.build(:emitente) }
	let(:rps)      { FactoryGirl.build(:br_nfe_rps) }
	
	describe "inheritance class" do
		it { subject.class.superclass.must_equal BrNfe::Servico::Betha::V2::Gateway }
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :substituir_nfse }
	end

	describe "#xml_builder" do
		it "não ocorre erro" do
			subject.stubs(:assinatura_xml).returns('<Signature>signed</Signature>')
			subject.xml_builder.class.must_equal Nokogiri::XML::Builder
		end
		it "estrutura" do
			xml_substituicao = Nokogiri::XML::Builder.new{|x| x.Substituicao 'valor subs'}
			subject.expects(:xml_substituicao_nfse).returns(xml_substituicao)
			subject.expects(:assinatura_xml).with(xml_substituicao.doc.root.to_s, '#substituicao').returns('<Signature>signed</Signature>')
			xml = subject.xml_builder.doc

			xml.namespaces.must_equal({"xmlns"=>"http://www.betha.com.br/e-nota-contribuinte-ws"})
			xml.remove_namespaces!

			xml.xpath('SubstituirNfseEnvio/Substituicao').first.text.must_equal 'valor subs'
			xml.xpath('SubstituirNfseEnvio/Signature').first.text.must_equal 'signed'
		end
	end

	describe "#xml_substituicao_nfse" do
		it "não ocorre erro" do
			subject.stubs(:assinatura_xml).returns('<Signature>signed</Signature>')
			subject.xml_substituicao_nfse.class.must_equal Nokogiri::XML::Builder
		end
		it "estrutura" do
			sequence1 = sequence('sequence1')
			subject.expects(:xml_pedido_cancelamento_assinado).in_sequence(sequence1).returns(Nokogiri::XML::Builder.new{|x| x.Pedido 'valor pedido'})
			subject.expects(:xml_rps_assinado).with(rps).in_sequence(sequence1).returns(Nokogiri::XML::Builder.new{|x| x.Rps 'valor rps'})
			xml = subject.xml_substituicao_nfse.doc

			xml.xpath('SubstituicaoNfse').first.attr('Id').must_equal 'substituicao'
			xml.xpath('SubstituicaoNfse/Pedido').first.text.must_equal 'valor pedido'
			xml.xpath('SubstituicaoNfse/Rps').first.text.must_equal 'valor rps'
		end
	end
	

end