require 'test_helper'

describe BrNfe::Service::Betha::V1::ConsultaLoteRps do
	subject             { FactoryGirl.build(:servico_betha_consulta_lote_rps, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::V1::Gateway }
	end

	describe "validations" do
		it { must validate_presence_of(:protocolo) }
	end

	describe "#wsdl" do
		context "for env production" do
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/consultarLoteRps?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/consultarLoteRps?wsdl' }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_lote_rps }
	end


	describe "#xml_builder" do
		it "deve adicionar o valor do xml_inf_pedido_cancelamento e assinar o xml" do
			subject.protocolo = '6654898765131'

			xml = subject.xml_builder.to_s
			xml = Nokogiri::XML xml

			xml.xpath('Temp/Prestador/Cnpj').first.text.must_equal emitente.cnpj
			xml.xpath('Temp/Prestador/InscricaoMunicipal').first.text.must_equal emitente.inscricao_municipal
			xml.xpath('Temp/Protocolo').first.text.must_equal '6654898765131'

		end
	end

end