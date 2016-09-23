require 'test_helper'

describe BrNfe::Service::Item do
	subject { FactoryGirl.build(:service_item) }
	
	describe "#default_values" do
		context "#quantidade" do
			it "valor padrão deve ser 1" do
				subject.class.new.quantidade.must_equal 1
			end
			it "posso modificar o valor" do
				subject.class.new(quantidade: 50.88).quantidade.must_equal 50.88			
			end			
		end
	end

	describe "#valor_total" do
		it "se não for setado nenhum valor deve sempre retornar a multiplicação entre a quantidade e o valor unitário" do
			subject.valor_total = nil
			subject.assign_attributes(quantidade: 3.5, valor_unitario: 10.0)
			subject.valor_total.must_equal 35.0
		end
		it "se setar um valor em valor_total não deve multiplicar a quantidade com o valor unitário" do
			subject.valor_total = 66.0
			subject.assign_attributes(quantidade: 3.5, valor_unitario: 10.0)
			subject.valor_total.must_equal 66.0
		end
		it "se quantidade ou valor unitário forem nil deve retornar zero" do
			subject.valor_total = nil
			subject.assign_attributes(quantidade: nil, valor_unitario: nil)
			subject.valor_total.must_equal 0.0
		end
	end
end