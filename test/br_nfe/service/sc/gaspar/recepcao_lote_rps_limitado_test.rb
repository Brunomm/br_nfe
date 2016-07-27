require 'test_helper'

describe BrNfe::Service::SC::Gaspar::RecepcaoLoteRpsLimitado do
	subject { FactoryGirl.build(:service_sc_gaspar_recepcao_lote_rps_limitado, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:emitente, natureza_operacao: 51) } 
	
	it "A classe deve herdar de BrNfe::Service::Thema::V1::RecepcaoLoteRpsLimitado" do
		subject.must_be_kind_of BrNfe::Service::Thema::V1::RecepcaoLoteRpsLimitado
	end

	describe "#wsdl" do
		context "for env production" do
			it { subject.wsdl.must_equal 'http://nfse.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl' }
		end
	end
end