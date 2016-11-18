require 'test_helper'

describe BrNfe::Product::Nfe::Cobranca::Fatura do
	subject { FactoryGirl.build(:product_cobranca_fatura) }
	let(:duplicata) { FactoryGirl.build(:product_cobranca_duplicata) } 

	describe "Validations" do
		describe '#duplicatas' do
			it 'Deve ter no máximo 5 duplicatas' do 
				MiniTest::Spec.string_for_validation_length = [BrNfe.duplicata_product_class.new]
				must validate_length_of(:duplicatas).is_at_most(120) 
				MiniTest::Spec.string_for_validation_length = 'x'
			end

			it "Se tiver mais que 1 duplicata e pelo menos 1 deles não for válido deve adiiconar o erro do duplicata no objeto" do
				duplicata.stubs(:valid?).returns(true)
				duplicata2 = duplicata.dup
				duplicata2.errors.add(:base, 'Erro do duplicata 2')
				duplicata2.stubs(:valid?).returns(false)
				duplicata3 = duplicata.dup
				duplicata3.errors.add(:base, 'Erro do duplicata 3')
				duplicata3.stubs(:valid?).returns(false)
				subject.duplicatas = [duplicata, duplicata2, duplicata3]

				must_be_message_error :base, :invalid_duplicata, {index: 2, error_message: 'Erro do duplicata 2'}
				must_be_message_error :base, :invalid_duplicata, {index: 3, error_message: 'Erro do duplicata 3'}, false
			end
		end
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

	describe '#duplicatas' do
		it "deve inicializar o objeto com um Array" do
			subject.class.new.duplicatas.must_be_kind_of Array
		end
		it "deve aceitar apenas objetos da class Hash ou Veiculo" do
			dup_hash = {numero_duplicata: 'XXL9877', total: 15.47}
			subject.duplicatas = [duplicata, 1, 'string', nil, {}, [], :symbol, dup_hash, true]
			subject.duplicatas.size.must_equal 2
			subject.duplicatas[0].must_equal duplicata

			subject.duplicatas[1].numero_duplicata.must_equal 'XXL9877'
			subject.duplicatas[1].total.must_equal 15.47
		end
		it "posso adicionar notas fiscais  com <<" do
			new_object = subject.class.new
			new_object.duplicatas << duplicata
			new_object.duplicatas << 1
			new_object.duplicatas << nil
			new_object.duplicatas << {numero_duplicata: 'XXL9999', total: 22.30}
			new_object.duplicatas << {numero_duplicata: 'XXL1111', total: 80.0}

			new_object.duplicatas.size.must_equal 3
			new_object.duplicatas[0].must_equal duplicata

			new_object.duplicatas[1].numero_duplicata.must_equal 'XXL9999'
			new_object.duplicatas[1].total.must_equal 22.30
			new_object.duplicatas[2].numero_duplicata.must_equal 'XXL1111'
			new_object.duplicatas[2].total.must_equal 80.0
		end
	end
end