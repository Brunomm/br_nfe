require 'test_helper'

describe BrNfe::Service::Betha::V1::ConsultaNfse do
	subject             { FactoryGirl.build(:servico_betha_consulta_nfse, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::V1::Gateway }
	end

	describe "validations" do
		it { must validate_presence_of(:data_inicial) }
		it { must validate_presence_of(:data_final) }
	end

	context "data inicial e final sempre deve retornar uma data na formatação adequada" do
		it "data_inicial" do
			subject.data_inicial = '12/05/2015'
			subject.data_inicial.must_equal '2015-05-12'
		end

		it "data_final" do
			subject.data_inicial = Date.parse '12/05/2010'
			subject.data_inicial.must_equal '2010-05-12'
		end
	end

	describe "#wsdl" do
		context "for env production" do
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/consultarNfse?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/consultarNfse?wsdl' }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_nfse }
	end

	describe "#xml_builder" do
		before do
			subject.assign_attributes(data_inicial: Date.parse('01/09/2015'), data_final: Date.parse('10/09/2015'))
		end
		it "estrutura com numero da nfse" do
			xml = subject.xml_builder.to_s
			xml = Nokogiri::XML xml

			xml.xpath('Temp/Prestador/Cnpj').first.text.must_equal               emitente.cnpj
			xml.xpath('Temp/Prestador/InscricaoMunicipal').first.text.must_equal emitente.inscricao_municipal
			
			xml.xpath('Temp/NumeroNfse').first.text.must_equal subject.numero_nfse
			xml.xpath('Temp/PeriodoEmissao/DataInicial').first.text.must_equal '2015-09-01'
			xml.xpath('Temp/PeriodoEmissao/DataFinal').first.text.must_equal   '2015-09-10'
		end

		it "estrutura sem numero da nfse" do
			subject.numero_nfse = ''

			xml = subject.xml_builder.to_s
			xml = Nokogiri::XML xml

			xml.xpath('Temp/Prestador/Cnpj').first.text.must_equal               emitente.cnpj
			xml.xpath('Temp/Prestador/InscricaoMunicipal').first.text.must_equal emitente.inscricao_municipal
			
			xml.xpath('Temp/NumeroNfse').first.must_be_nil
			xml.xpath('Temp/PeriodoEmissao/DataInicial').first.text.must_equal '2015-09-01'
			xml.xpath('Temp/PeriodoEmissao/DataFinal').first.text.must_equal   '2015-09-10'
		end
	end
end