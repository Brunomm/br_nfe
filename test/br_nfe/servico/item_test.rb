require 'test_helper'

describe BrNfe::Servico::Item do
	subject { FactoryGirl.build(:service_item) }
	
	describe "#default_values" do
		context "#quantity" do
			it "valor padrão deve ser 1" do
				subject.class.new.quantity.must_equal 1
			end
			it "posso modificar o valor" do
				subject.class.new(quantity: 50.88).quantity.must_equal 50.88			
			end			
		end
	end

	describe "#total_value" do
		it "se não for setado nenhum valor deve sempre retornar a multiplicação entre a quantidade e o valor unitário" do
			subject.total_value = nil
			subject.assign_attributes(quantity: 3.5, unit_value: 10.0)
			subject.total_value.must_equal 35.0
		end
		it "se setar um valor em total_value não deve multiplicar a quantidade com o valor unitário" do
			subject.total_value = 66.0
			subject.assign_attributes(quantity: 3.5, unit_value: 10.0)
			subject.total_value.must_equal 66.0
		end
		it "se quantidade ou valor unitário forem nil deve retornar zero" do
			subject.total_value = nil
			subject.assign_attributes(quantity: nil, unit_value: nil)
			subject.total_value.must_equal 0.0
		end
	end
end