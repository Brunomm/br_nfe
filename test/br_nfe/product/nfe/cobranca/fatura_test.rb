require 'test_helper'

describe BrNfe::Product::Nfe::Cobranca::Fatura do
	subject { FactoryGirl.build(:product_cobranca_fatura) }
	let(:duplicata) { FactoryGirl.build(:product_cobranca_duplicata) } 

	describe '#duplicatas' do
		it { must_validate_length_has_many(:duplicatas, BrNfe.duplicata_product_class, {maximum: 120})  }
		it { must_validates_has_many(:duplicatas, BrNfe.duplicata_product_class, :invalid_duplicata) }
		it { must_have_many(:duplicatas, BrNfe.duplicata_product_class, {numero_duplicata: 'XXL9999', total: 500.10})  }
	end

	describe '#valor_liquido' do
		it "se setar um valor deve manter esse valor e não calcula automaticamente" do
			subject.assign_attributes(valor_original: 100, valor_desconto: 10)
			subject.valor_liquido = 5_000.0
			subject.valor_liquido.must_equal 5_000
		end
		it "deve calcular o total liquido se o valor estiver nil" do
			subject.assign_attributes(valor_original: 100, valor_desconto: 10)
			subject.valor_liquido = nil
			subject.valor_liquido.must_equal 90.0
		end
	end
end