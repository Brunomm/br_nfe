require 'test_helper'

describe BrNfe::Servico::Betha::V2::RecepcaoLoteRps do
	subject        { FactoryGirl.build(:br_nfe_servico_betha_v2_recepcao_lote_rps, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:emitente) }
	
	describe "inheritance class" do
		it { subject.class.superclass.must_equal BrNfe::Servico::Betha::V2::Gateway }
	end

	describe "validations" do
		it { must validate_presence_of(:numero_lote_rps) }
		it { must validate_presence_of(:certificado) }
		
		it "deve chamar o metodo validar_lote_rps" do
			subject.expects(:validar_lote_rps)
			subject.valid?
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :recepcionar_lote_rps }
	end

	describe "#xml_builder" do
		it "não ocorre erro" do
			subject.stubs(:assinatura_xml).returns('<Signature>signed</Signature>')
			subject.xml_builder.class.must_equal Nokogiri::XML::Builder
		end
		it "estrutura" do
			subject.numero_lote_rps = 88966
			lote_rps_xml = Nokogiri::XML::Builder.new{|x| x.LoteRps 'valor loterps'}
			subject.expects(:lote_rps_xml).returns(lote_rps_xml)
			subject.expects(:assinatura_xml).with(lote_rps_xml.doc.root.to_s, '#lote88966').returns('<Signature>signed</Signature>')
			xml = subject.xml_builder.doc

			xml.namespaces.must_equal({"xmlns"=>"http://www.betha.com.br/e-nota-contribuinte-ws"})
			xml.remove_namespaces!

			xml.xpath('EnviarLoteRpsEnvio/LoteRps').first.text.must_equal 'valor loterps'
			xml.xpath('EnviarLoteRpsEnvio/Signature').first.text.must_equal 'signed'
		end
	end

	describe "#lote_rps_xml" do
		let(:rps1) { FactoryGirl.build(:br_nfe_rps, numero: '1') } 
		let(:rps2) { FactoryGirl.build(:br_nfe_rps, numero: '2') } 

		before do
			subject.stubs(:assinatura_xml).returns('<Signature>signed</Signature>')
			subject.assign_attributes({
				numero_lote_rps: '5568'.ljust(50, '1'),
				emitente: {
					cnpj: '66.554.778/9654-12',
					inscricao_municipal: '6565498713134687984313868135798'
				},
				lote_rps: [rps1, rps2]
			})
		end
		
		it "estrutura com env = production" do
			subject.env = :production
			sequence1 = sequence('sequence1')
			subject.expects(:xml_rps_assinado).with(rps1).in_sequence(sequence1).returns(Nokogiri::XML::Builder.new{|x| x.Rps 'valor rps1'})
			subject.expects(:xml_rps_assinado).with(rps2).in_sequence(sequence1).returns(Nokogiri::XML::Builder.new{|x| x.Rps 'valor rps2'})
			
			xml = subject.send(:lote_rps_xml).doc

			xml.xpath('LoteRps').first.attr('Id').must_equal "lote#{'5568'.ljust(50, '1')}"
			xml.xpath('LoteRps').first.attr('versao').must_equal '2.02'

			xml.xpath('LoteRps/NumeroLote').first.text.must_equal '556811111111111'
			xml.xpath('LoteRps/CpfCnpj/Cnpj').first.text.must_equal '66554778965412'
			xml.xpath('LoteRps/InscricaoMunicipal').first.text.must_equal '656549871313468'
			xml.xpath('LoteRps/QuantidadeRps').first.text.must_equal '2'
			
			xml.xpath('LoteRps/ListaRps/Rps').first.text.must_equal 'valor rps1'
			xml.xpath('LoteRps/ListaRps/Rps').last.text.must_equal 'valor rps2'
		end

		it "estrutura com env = test" do
			subject.env = :test
			sequence1 = sequence('sequence1')
			subject.expects(:xml_rps_assinado).with(rps1).in_sequence(sequence1).returns(Nokogiri::XML::Builder.new{|x| x.Rps 'valor rps1'})
			subject.expects(:xml_rps_assinado).with(rps2).in_sequence(sequence1).returns(Nokogiri::XML::Builder.new{|x| x.Rps 'valor rps2'})
			
			xml = subject.send(:lote_rps_xml).doc

			xml.xpath('LoteRps').first.attr('Id').must_equal "lote#{'5568'.ljust(50, '1')}"
			xml.xpath('LoteRps').first.attr('versao').must_equal '2.02'

			xml.xpath('LoteRps/NumeroLote').first.text.must_equal '556811111111111'
			xml.xpath('LoteRps/CpfCnpj/Cnpj').first.text.must_equal '66554778965412'
			xml.xpath('LoteRps/InscricaoMunicipal').first.must_be_nil
			xml.xpath('LoteRps/QuantidadeRps').first.text.must_equal '2'
			
			xml.xpath('LoteRps/ListaRps/Rps').first.text.must_equal 'valor rps1'
			xml.xpath('LoteRps/ListaRps/Rps').last.text.must_equal 'valor rps2'
		end
	end
	

end