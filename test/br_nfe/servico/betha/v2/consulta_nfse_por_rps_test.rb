require 'test_helper'

describe BrNfe::Servico::Betha::V2::ConsultaNfsePorRps do
	subject        { FactoryGirl.build(:br_nfe_servico_betha_v2_consulta_nfse_por_rps, emitente: emitente, rps: rps) }
	let(:emitente) { FactoryGirl.build(:emitente) }
	let(:rps)      { FactoryGirl.build(:br_nfe_rps) }
	
	describe "inheritance class" do
		it { subject.class.superclass.must_equal BrNfe::Servico::Betha::V2::Gateway }
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_nfse_por_rps }
	end

	describe "#xml_builder" do
		it "não ocorre erro" do
			subject.stubs(:assinatura_xml).returns('<Signature>signed</Signature>')
			subject.xml_builder.class.must_equal Nokogiri::XML::Builder
		end
		it "estrutura" do
			sequence_1 = sequence('sequence1')
			subject.expects(:xml_identificacao_rps).with(rps).returns(Nokogiri::XML::Builder.new{|x| x.IdentificacaoRps 'valor ident rps'} ).in_sequence(sequence_1)
			subject.expects(:xml_prestador).returns(Nokogiri::XML::Builder.new{|x| x.Pestador 'dados prestador'} ).in_sequence(sequence_1)
			xml = subject.xml_builder.doc

			xml.namespaces.must_equal({"xmlns"=>"http://www.betha.com.br/e-nota-contribuinte-ws"})
			xml.remove_namespaces!

			xml.xpath('ConsultarNfseRpsEnvio/IdentificacaoRps').first.text.must_equal 'valor ident rps'
			xml.xpath('ConsultarNfseRpsEnvio/Pestador').first.text.must_equal 'dados prestador'
		end
	end
	

end