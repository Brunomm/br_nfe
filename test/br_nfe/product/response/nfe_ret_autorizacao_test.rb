require 'test_helper'

describe BrNfe::Product::Response::NfeRetAutorizacao do
	subject { FactoryGirl.build(:product_response_nfe_ret_autorizacao) }

	it "Deve Herdar de BrNfe::Product::Response::Base" do
		subject.class.superclass.must_equal BrNfe::Product::Response::Base
	end

	it "Deve ter um has_many para as notas fiscais" do
		must_have_many(:notas_fiscais, BrNfe.nota_fiscal_product_class, {codigo_nf: '1233', serie: '1'})
	end
	
end