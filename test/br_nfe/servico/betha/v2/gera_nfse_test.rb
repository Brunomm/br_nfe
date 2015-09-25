require 'test_helper'

describe BrNfe::Servico::Betha::V2::GeraNfse do
	subject        { FactoryGirl.build(:br_nfe_servico_betha_v2_gera_nfse, emitente: emitente, rps: rps) }
	let(:emitente) { FactoryGirl.build(:emitente) }
	let(:rps)      { FactoryGirl.build(:br_nfe_rps) }
	
	describe "inheritance class" do
		it { subject.class.superclass.must_equal BrNfe::Servico::Betha::V2::Gateway }
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :gerar_nfse }
	end

	describe "#xml_builder" do
		it "não ocorre erro" do
			subject.stubs(:assinatura_xml).returns('<Signature>signed</Signature>')
			subject.xml_builder.class.must_equal Nokogiri::XML::Builder
		end
		it "estrutura" do
			subject.expects(:xml_rps_assinado).returns( Nokogiri::XML::Builder.new{|x| x.RpsAssinado 'valor rps assinado'} )
			xml = subject.xml_builder.doc

			xml.namespaces.must_equal({"xmlns"=>"http://www.betha.com.br/e-nota-contribuinte-ws"})
			xml.remove_namespaces!

			xml.xpath('GerarNfseEnvio/RpsAssinado').first.text.must_equal 'valor rps assinado'
		end
	end
	

end