require 'test_helper'

describe BrNfe::Service::SC::Gaspar::CancelaNfse do
	subject { FactoryGirl.build(:service_sc_gaspar_cancela_nfse) }
	
	it "A classe deve herdar de BrNfe::Service::Thema::V1::CancelaNfse" do
		subject.must_be_kind_of BrNfe::Service::Thema::V1::CancelaNfse
	end

	describe "#wsdl" do
		context "for env production" do
			it { subject.wsdl.must_equal 'http://nfse.gaspar.sc.gov.br/nfse/services/NFSEcancelamento?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEcancelamento?wsdl' }
		end
	end
end