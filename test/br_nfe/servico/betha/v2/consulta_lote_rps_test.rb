require 'test_helper'

describe BrNfe::Servico::Betha::V2::ConsultaLoteRps do
	subject             { FactoryGirl.build(:br_nfe_servico_betha_v2_consulta_lote_rps, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:emitente) }
	
	describe "inheritance class" do
		it { subject.class.superclass.must_equal BrNfe::Servico::Betha::V2::Gateway }
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_lote_rps }
	end

	describe "#xml_builder" do
		it "não ocorre erro" do
			subject.stubs(:assinatura_xml).returns('<Signature>signed</Signature>')
			subject.xml_builder.class.must_equal Nokogiri::XML::Builder
		end
		it "estrutura" do
			subject.protocolo = '1'.rjust(100, '1')
			subject.expects(:xml_prestador).returns(Nokogiri::XML::Builder.new{|x| x.Pestador 'ok'} )
			xml = subject.xml_builder.doc

			xml.namespaces.must_equal({"xmlns"=>"http://www.betha.com.br/e-nota-contribuinte-ws"})
			xml.remove_namespaces!

			xml.xpath('ConsultarLoteRpsEnvio/Pestador').first.text.must_equal 'ok'
			xml.xpath('ConsultarLoteRpsEnvio/Protocolo').first.text.must_equal '1'.rjust(50, '1')
		end
	end
	

end