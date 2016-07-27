require 'test_helper'

describe BrNfe::Service::SC::Gaspar::ConsultaSituacaoLoteRps do
	subject { FactoryGirl.build(:service_sc_gaspar_consulta_situacao_lote_rps) }
	
	it "A classe deve herdar de BrNfe::Service::Thema::V1::ConsultaSituacaoLoteRps" do
		subject.must_be_kind_of BrNfe::Service::Thema::V1::ConsultaSituacaoLoteRps
	end

	describe "#wsdl" do
		context "for env production" do
			it { subject.wsdl.must_equal 'http://nfse.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl' }
		end
	end
end