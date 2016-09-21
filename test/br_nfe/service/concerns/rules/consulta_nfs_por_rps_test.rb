require 'test_helper'


describe BrNfe::Service::Concerns::Rules::ConsultaNfsPorRps do
	class RuleConsultaNfsPorRpsTest < BrNfe::Service::Base
		include BrNfe::Service::Concerns::Rules::ConsultaNfsPorRps
	end

	subject { RuleConsultaNfsPorRpsTest.new(rps: rps, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:service_emitente, endereco: endereco) }
	let(:endereco) { FactoryGirl.build(:endereco) } 
	let(:rps) { FactoryGirl.build(:br_nfe_rps) } 

	it "deve ter o o helper HaveRps incluido" do
		subject.class.included_modules.must_include BrNfe::Service::Association::HaveRps
	end

	describe "#validate_rps" do
		it "se o RPS for inválido deve add os erros do RPS no registro" do
			rps.stubs(:errors).returns(stub(full_messages: ["Erro rps"]))
			rps.stubs(:valid?).returns(false)
			subject.valid?.must_equal false
			subject.errors.full_messages.must_include( "Rps Erro rps" )
		end
		it "se o RPS for válido o registro também será valido" do
			rps.stubs(:valid?).returns(true)
			subject.valid?.must_equal true
			subject.errors.must_be_empty
		end
	end
end