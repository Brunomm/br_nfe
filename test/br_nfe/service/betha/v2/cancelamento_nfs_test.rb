require 'test_helper'

describe BrNfe::Service::Betha::V2::CancelamentoNfs do
	subject             { FactoryGirl.build(:br_nfe_servico_betha_v2_cancelamento_nfs, emitente: emitente) }
	let(:rps)           { FactoryGirl.build(:br_nfe_rps, :completo) }
	let(:emitente)      { FactoryGirl.build(:emitente) }
	let(:intermediario) { FactoryGirl.build(:intermediario) }

	describe "inheritance class" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::V2::Gateway }
	end

	describe "validations" do
		it { must validate_presence_of(:numero_nfse) }
		it { must validate_presence_of(:codigo_cancelamento) }
		context "validações do certificado" do
			before do
				subject.certificate_pkcs12 = nil
				subject.certificate_pkcs12_value = nil
				subject.certificate_pkcs12_password = nil
			end
			it { must validate_presence_of(:certificate) }
			it { must validate_presence_of(:certificate_key) }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :cancelar_nfse }
	end

	describe "#xml_builder" do
		it "não ocorre erro" do
			subject.stubs(:assinatura_xml).returns('<Signature>signed</Signature>')
			subject.xml_builder.class.must_equal Nokogiri::XML::Builder
		end
		it "estrutura" do
			subject.expects(:xml_pedido_cancelamento_assinado).returns(Nokogiri::XML::Builder.new{|x| x.Cancelamento 'ok'} )
			xml = subject.xml_builder.doc

			xml.namespaces.must_equal({"xmlns"=>"http://www.betha.com.br/e-nota-contribuinte-ws"})
			xml.remove_namespaces!

			xml.xpath('CancelarNfseEnvio/Cancelamento').first.text.must_equal 'ok'
		end
	end
	

end