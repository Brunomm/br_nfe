require 'test_helper'

describe BrNfe::Service::Betha::V2::GeraNfse do
	subject        { FactoryGirl.build(:br_nfe_servico_betha_v2_gera_nfse, emitente: emitente, rps: rps, certificate_pkcs12: certificado) }
	let(:emitente) { FactoryGirl.build(:emitente) }
	let(:rps)      { FactoryGirl.build(:br_nfe_rps) }
	let(:certificado) { Certificado.new } 
	
	describe "inheritance class" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::V2::Gateway }
	end

	describe "validations" do

		context "validações do certificado" do
			before { subject.certificate_pkcs12 = nil }
			it { must validate_presence_of(:certificate) }
			it { must validate_presence_of(:certificate_key) }
		end
		context "deve validar o rps" do
			it "quando o rps for válido não deve setar nenhuma mensagem no objeto" do
				rps.stubs(:errors).returns(stub(full_messages: ["Erro rps"]))
				sequence_1 = sequence('sequence_1')
				rps.expects(:validar_recepcao_rps=).with(true).in_sequence(sequence_1)
				rps.expects(:invalid?).returns(false).in_sequence(sequence_1)
				subject.valid?.must_equal true
				subject.errors.full_messages.must_equal( [] )
			end
			it "quando o rps for inválido deve setar mensagem de erro no objeto" do
				rps.stubs(:errors).returns(stub(full_messages: ["Erro rps"]))
				sequence_1 = sequence('sequence_1')
				rps.expects(:validar_recepcao_rps=).with(true).in_sequence(sequence_1)
				rps.expects(:invalid?).returns(true).in_sequence(sequence_1)
				subject.valid?.must_equal false
				subject.errors.full_messages.must_equal( ["RPS: Erro rps"] )
			end
			
		end
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