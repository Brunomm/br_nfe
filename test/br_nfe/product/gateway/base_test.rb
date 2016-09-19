require 'test_helper'

describe BrNfe::Product::Gateway::Base do
	subject { FactoryGirl.build(:product_gateway_base) }
	
	describe '#env_production?' do
		it "se env for igual a :production deve ser true" do
			subject.env = :production
			subject.env_production?.must_equal true
		end
		it "deve ser false se env for diferente a :production" do
			subject.env = :test
			subject.env_production?.must_equal false
		end
	end
end