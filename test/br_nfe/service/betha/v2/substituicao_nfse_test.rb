require 'test_helper'

describe BrNfe::Service::Betha::V2::SubstituicaoNfse do
	subject        { FactoryGirl.build(:br_nfe_servico_betha_v2_substituicao_nfse, emitente: emitente, rps: rps) }
	let(:emitente) { FactoryGirl.build(:emitente) }
	let(:rps)      { FactoryGirl.build(:br_nfe_rps) }
	
	describe "inheritance class" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::V2::Gateway }
	end

	describe "validations" do
		context "validações do certificado" do
			before do
				subject.certificate_pkcs12 = nil
				subject.certificate_pkcs12_value = nil
				subject.certificate_pkcs12_password = nil
			end
			it { must validate_presence_of(:certificate) }
			it { must validate_presence_of(:certificate_key) }
		end
		it { must validate_presence_of(:numero_nfse) }
		it { must validate_presence_of(:codigo_cancelamento) }
		
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