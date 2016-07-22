require 'test_helper'

describe BrNfe::Service::Betha::Base do
	subject { FactoryGirl.build(:br_nfe_servico_betha_base) }
	
	it "deve herdar de BrNfe::Service::Base" do
		subject.class.superclass.must_equal BrNfe::Service::Base
	end
end