FactoryGirl.define do
	factory :br_nfe_base, class:  BrNfe::Base do
		emitente { FactoryGirl.build(:emitente) } 
	end
end