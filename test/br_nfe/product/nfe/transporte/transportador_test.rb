require 'test_helper'

describe BrNfe::Product::Nfe::Transporte::Transportador do
	subject { FactoryGirl.build(:product_transporte_transportador) }

	it "deve herdar de Person" do
		subject.class.superclass.must_equal BrNfe::Person
	end

	it "deve estar setado que a validação do regime triburio para que não seja validado" do
		subject.send(:validate_regime_tributario?).must_equal false
	end
end