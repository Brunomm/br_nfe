require 'test_helper'

describe BrNfe::Service::Betha::V2::EnvioLoteRpsSincrono do
	subject        { FactoryGirl.build(:br_nfe_servico_betha_v2_envio_lote_rps_sincrono, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:emitente) }
	
	# describe "inheritance class" do
	# 	it { subject.class.superclass.must_equal BrNfe::Service::Betha::V2::RecepcaoLoteRps }
	# end

	# describe "validations" do
	# 	it { must validate_presence_of(:numero_lote_rps) }
		
	# 	context "validações do certificado" do
	# 		before do
	# 			subject.certificate_pkcs12 = nil
	# 			subject.certificate_pkcs12_value = nil
	# 			subject.certificate_pkcs12_password = nil
	# 		end
	# 		it { must validate_presence_of(:certificate) }
	# 		it { must validate_presence_of(:certificate_key) }
	# 	end
		
	# 	it "deve chamar o metodo validar_lote_rps" do
	# 		subject.expects(:validar_lote_rps)
	# 		subject.valid?
	# 	end
	# end

	# describe "#method_wsdl" do
	# 	it { subject.method_wsdl.must_equal :recepcionar_lote_rps_sincrono }
	# end

	# describe "#xml_builder" do
	# 	it "não ocorre erro" do
	# 		subject.stubs(:assinatura_xml).returns('<Signature>signed</Signature>')
	# 		subject.xml_builder.class.must_equal Nokogiri::XML::Builder
	# 	end
	# 	it "estrutura" do
	# 		subject.numero_lote_rps = 88966
	# 		lote_rps_xml = Nokogiri::XML::Builder.new{|x| x.LoteRps 'valor loterps'}
	# 		subject.expects(:lote_rps_xml).returns(lote_rps_xml)
	# 		subject.expects(:assinatura_xml).with(lote_rps_xml.doc.root.to_s, '#lote88966').returns('<Signature>signed</Signature>')
	# 		xml = subject.xml_builder.doc

	# 		xml.namespaces.must_equal({"xmlns"=>"http://www.betha.com.br/e-nota-contribuinte-ws"})
	# 		xml.remove_namespaces!

	# 		xml.xpath('EnviarLoteRpsSincronoEnvio/LoteRps').first.text.must_equal 'valor loterps'
	# 		xml.xpath('EnviarLoteRpsSincronoEnvio/Signature').first.text.must_equal 'signed'
	# 	end
	# end
	

end