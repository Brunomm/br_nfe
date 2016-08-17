require 'test_helper'

describe BrNfe::Service::Betha::Base do
	subject { FactoryGirl.build(:br_nfe_servico_betha_base) }
	
	it "deve herdar de BrNfe::Service::Base" do
		subject.class.superclass.must_equal BrNfe::Service::Base
	end

	describe "#ts_item_lista_servico" do
		it "deve retornar apenas numeros sem pontuação" do
			subject.ts_item_lista_servico('12.44').must_equal '1244'
		end
		it "Deve sempre retornar 4 caracteres" do
			subject.ts_item_lista_servico('2.44').must_equal '0244'
		end
	end
end