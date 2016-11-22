require 'test_helper'

describe BrNfe::Product::Nfe::ItemTax::Icms do
	subject { FactoryGirl.build(:product_item_tax_icms) }

	describe 'Validations' do
		context '#origem' do
			it { wont allow_value(9).for(:origem) }
			it { must validate_inclusion_of(:origem).in_array([0, 1, 2, 3, 4, 5, 6, 7, 8]) }
		end
		context '#codigo_cst' do
			it { must validate_presence_of(:codigo_cst) }
			it { must validate_inclusion_of(:codigo_cst).in_array(%w[00 10 20 30 40 41 50 51 60 70 90 101 102 103 201 202 203 300 400 500 900]) }
		end
		context "CST 00" do
			before { subject.codigo_cst = '00' }
			it { must validate_presence_of(:modalidade_base_calculo) }
			it { must validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { must validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(:total_base_calculo) }
			it { must validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(:aliquota) }
			it { wont validate_presence_of(:modalidade_base_calculo_st) }
			it { wont validate_inclusion_of(:modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { wont validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_numericality_of(:reducao_base_calculo_st).
				is_greater_than_or_equal_to(0.0).
				is_less_than_or_equal_to(100.0).
				allow_nil
			}
			it { must validate_numericality_of(:reducao_base_calculo).
				is_greater_than_or_equal_to(0.0).
				is_less_than_or_equal_to(100.0).
				allow_nil
			}
			it { wont validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:total_base_calculo_st) }
			it { wont validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:aliquota_st) }
			it { wont validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:total_st) }
			it { wont validate_presence_of(:reducao_base_calculo) }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it "motivo_desoneracao não deve ser obrigatório se não tiver total_desoneracao" do
					subject.total_desoneracao = nil
					wont validate_presence_of(:motivo_desoneracao)
				end
				it "motivo_desoneracao não deve ser obrigatório mesmo se tiver total_desoneracao" do
					subject.total_desoneracao = 50.0
					wont validate_presence_of(:motivo_desoneracao)
				end
				it 'motivo_desoneracao não deve validar os valores permitidos' do
					wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12])
				end
			end
		end
		context "CST 10" do
			before { subject.codigo_cst = '10' }
			it { must validate_presence_of(:modalidade_base_calculo) }
			it { must validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { must validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(:total_base_calculo) }
			it { must validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(:aliquota) }
			it { must validate_presence_of(:modalidade_base_calculo_st) }
			it { must validate_inclusion_of(:modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { must validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_numericality_of(:reducao_base_calculo_st).
				is_greater_than_or_equal_to(0.0).
				is_less_than_or_equal_to(100.0).
				allow_nil
			}
			it { must validate_numericality_of(:reducao_base_calculo).
				is_greater_than_or_equal_to(0.0).
				is_less_than_or_equal_to(100.0).
				allow_nil
			}
			it { must validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(:total_base_calculo_st) }
			it { must validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(:aliquota_st) }
			it { must validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(:total_st) }
			it { wont validate_presence_of(:reducao_base_calculo) }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it "motivo_desoneracao não deve ser obrigatório se não tiver total_desoneracao" do
					subject.total_desoneracao = nil
					wont validate_presence_of(:motivo_desoneracao)
				end
				it "motivo_desoneracao não deve ser obrigatório mesmo se tiver total_desoneracao" do
					subject.total_desoneracao = 50.0
					wont validate_presence_of(:motivo_desoneracao)
				end
				it 'motivo_desoneracao não deve validar os valores permitidos' do
					wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12])
				end
			end
		end
		context "CST 20" do
			before { subject.codigo_cst = '20' }
			it { must validate_presence_of(:modalidade_base_calculo) }
			it { must validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { must validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(:total_base_calculo) }
			it { must validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(:aliquota) }
			it { wont validate_presence_of(:modalidade_base_calculo_st) }
			it { wont validate_inclusion_of(:modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { wont validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_numericality_of(:reducao_base_calculo_st).
				is_greater_than_or_equal_to(0.0).
				is_less_than_or_equal_to(100.0).
				allow_nil
			}
			it { must validate_numericality_of(:reducao_base_calculo).
				is_greater_than_or_equal_to(0.0).
				is_less_than_or_equal_to(100.0).
				allow_nil
			}
			it { wont validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:total_base_calculo_st) }
			it { wont validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:aliquota_st) }
			it { wont validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:total_st) }
			it { must validate_presence_of(:reducao_base_calculo) }
			context 'Deve aplicar as regras para desoneracao' do
				it { must validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it "motivo_desoneracao não deve ser obrigatório se não tiver total_desoneracao" do
					subject.total_desoneracao = nil
					wont validate_presence_of(:motivo_desoneracao)
				end
				it "motivo_desoneracao deve ser obrigatório mesmo se tiver total_desoneracao" do
					subject.total_desoneracao = 50.0
					must validate_presence_of(:motivo_desoneracao)
				end
				it 'motivo_desoneracao deve validar os valores permitidos' do
					subject.total_desoneracao = nil
					must validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12])
					must allow_value('').for(:motivo_desoneracao)
				end
			end
		end
	end

	describe '#origem' do
		it "se setar um valor nil deve retornar 0" do
			subject.origem = nil
			subject.origem.must_equal 0
		end
		it "deve sempre retornar um valor inteiro" do
			subject.origem = '1'
			subject.origem.must_equal 1
			subject.origem = '02'
			subject.origem.must_equal 2
			subject.origem = '04'
			subject.origem.must_equal 4
		end
	end

	describe '#motivo_desoneracao' do
		it "se setar um valor nil deve retornar nil" do
			subject.motivo_desoneracao = nil
			subject.motivo_desoneracao.must_be_nil
		end
		it "deve sempre retornar um valor inteiro" do
			subject.motivo_desoneracao = '1'
			subject.motivo_desoneracao.must_equal 1
			subject.motivo_desoneracao = '02'
			subject.motivo_desoneracao.must_equal 2
			subject.motivo_desoneracao = '04'
			subject.motivo_desoneracao.must_equal 4
		end
	end

	describe '#codigo_cst' do
		it "deve sempre retornar uam string" do
			subject.codigo_cst = 100
			subject.codigo_cst.must_equal '100'
		end
		it "deve ajustar o valor para 2 posições adicionando zeros" do
			subject.codigo_cst = 0
			subject.codigo_cst.must_equal '00'
		end
		it "se não tiver valor setado deve retornar nil" do
			subject.codigo_cst = ''
			subject.codigo_cst.must_be_nil
		end
	end

	describe '#total' do
		it "Se não setar um valor deve calcular automaticamente" do
			subject.assign_attributes(total_base_calculo: 171.58, aliquota: 18.0, total: nil)
			subject.instance_variable_get(:@total).must_be_nil
			subject.total.must_equal 30.88
			subject.instance_variable_get(:@total).must_equal 30.88
		end
		it "se tiver um valor setado manualmente não deve calcular" do
			subject.assign_attributes(total_base_calculo: 171.58, aliquota: 18.0, total: 20.0)
			subject.total.must_equal 20.0
		end
	end
	

end