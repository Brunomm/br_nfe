require 'test_helper'
require 'br_nfe/helper/have_rps'

describe BrNfe::Service::Betha::V1::ConsultaNfsPorRps do
	subject             { FactoryGirl.build(:servico_betha_consulta_nfs_por_rps, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:emitente) }
	let(:rps)           { subject.rps } 

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::V1::Gateway }
	end

	describe "#wsdl" do
		context "for env production" do
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/consultarNfsePorRps?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/consultarNfsePorRps?wsdl' }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_nfse_por_rps }
	end

	describe "rps" do
		include BrNfeTest::HelperTest::HaveRpsTest
	end

	describe "#xml_builder" do
		it "deve adicionar o valor do xml_inf_pedido_cancelamento e assinar o xml" do
			xml = subject.xml_builder.to_s
			xml = Nokogiri::XML xml

			xml.xpath('Temp/Prestador/Cnpj').first.text.must_equal               emitente.cnpj
			xml.xpath('Temp/Prestador/InscricaoMunicipal').first.text.must_equal emitente.inscricao_municipal
			
			xml.xpath('Temp/IdentificacaoRps/Numero').first.text.must_equal rps.numero.to_s
			xml.xpath('Temp/IdentificacaoRps/Serie').first.text.must_equal  rps.serie.to_s
			xml.xpath('Temp/IdentificacaoRps/Tipo').first.text.must_equal   rps.tipo.to_s
		end
	end

	describe "#set_response" do
		let(:hash_response)  { {envelope: {body: {consultar_nfse_por_rps_envio_response: 'valor_hash'} } } }
		let(:response)       { FactoryGirl.build(:response_default) } 
		let(:build_response) { FactoryGirl.build(:betha_v1_build_response) }

		it "deve instanciar um objeto response pelo build_response" do
			res = Object.new
			res.stubs(:hash).returns( hash_response )
			build_response.stubs(:response).returns(response)

			BrNfe::Service::Betha::V1::BuildResponse.expects(:new).
				with({hash: 'valor_hash', nfe_method: :consultar_nfse_rps}).
				returns(build_response)

			subject.instance_variable_get(:@response).must_be_nil
			
			subject.set_response(res).must_equal response
			subject.instance_variable_get(:@response).must_equal response
		end
	end

end