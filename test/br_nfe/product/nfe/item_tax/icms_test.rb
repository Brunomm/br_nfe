require 'test_helper'

describe BrNfe::Product::Nfe::ItemTax::Icms do
	subject { FactoryGirl.build(:product_item_tax_icms) }

	describe 'Alias attributes' do
		it { must_have_alias_attribute :orig,        :origem }
		it { must_have_alias_attribute :CST,         :codigo_cst, '01' }
		it { must_have_alias_attribute :CSOSN,       :codigo_cst, '01' }
		it { must_have_alias_attribute :modBC,       :modalidade_base_calculo }
		it { must_have_alias_attribute :pRedBC,      :reducao_base_calculo }
		it { must_have_alias_attribute :vBC,         :total_base_calculo }
		it { must_have_alias_attribute :pICMS,       :aliquota }
		it { must_have_alias_attribute :vICMS,       :total }
		it { must_have_alias_attribute :modBCST,     :modalidade_base_calculo_st }
		it { must_have_alias_attribute :pMVAST,      :mva_st }
		it { must_have_alias_attribute :pRedBCST,    :reducao_base_calculo_st }
		it { must_have_alias_attribute :vBCST,       :total_base_calculo_st }
		it { must_have_alias_attribute :pICMSST,     :aliquota_st }
		it { must_have_alias_attribute :vICMSST,     :total_st }
		it { must_have_alias_attribute :vICMSDeson,  :total_desoneracao }
		it { must_have_alias_attribute :motDesICMS,  :motivo_desoneracao }
		it { must_have_alias_attribute :vICMSOp,     :total_icms_operacao }
		it { must_have_alias_attribute :pDif,        :percentual_diferimento }
		it { must_have_alias_attribute :vICMSDif,    :total_icms_diferido }
		it { must_have_alias_attribute :vBCSTRet,    :total_base_calculo_st_retido }
		it { must_have_alias_attribute :vICMSSTRet,  :total_st_retido }
		it { must_have_alias_attribute :pCredSN,     :aliquota_credito_sn }
		it { must_have_alias_attribute :vCredICMSSN, :total_credito_sn }
	end

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
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
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
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
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
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
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
		context "CST 30" do
			before { subject.codigo_cst = '30' }
			it { wont validate_presence_of(:modalidade_base_calculo) }
			it { wont validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:aliquota) }
			it { must validate_presence_of(:modalidade_base_calculo_st) }
			it { must validate_inclusion_of(:modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { must validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0) }
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
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
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
		context "CST 40" do
			before { subject.codigo_cst = '40' }
			it { wont validate_presence_of(:modalidade_base_calculo) }
			it { wont validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:aliquota) }
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
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
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
					must validate_inclusion_of(:motivo_desoneracao).in_array([1,2,3,4,5,6,7,8,9,10,11])
					must allow_value('').for(:motivo_desoneracao)
				end
			end
		end
		context "CST 41" do
			before { subject.codigo_cst = '41' }
			it { wont validate_presence_of(:modalidade_base_calculo) }
			it { wont validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:aliquota) }
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
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
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
					must validate_inclusion_of(:motivo_desoneracao).in_array([1,2,3,4,5,6,7,8,9,10,11])
					must allow_value('').for(:motivo_desoneracao)
				end
			end
		end
		context "CST 50" do
			before { subject.codigo_cst = '50' }
			it { wont validate_presence_of(:modalidade_base_calculo) }
			it { wont validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:aliquota) }
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
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
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
					must validate_inclusion_of(:motivo_desoneracao).in_array([1,2,3,4,5,6,7,8,9,10,11])
					must allow_value('').for(:motivo_desoneracao)
				end
			end
		end
		context "CST 51" do
			before { subject.codigo_cst = '51' }
			it { wont validate_presence_of(:modalidade_base_calculo) }
			it { must allow_value('').for(:modalidade_base_calculo) }
			it { must validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:aliquota) }
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

			it { must validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
			end
		end
		context "CST 60" do
			before { subject.codigo_cst = '60' }
			describe "ICMS ST Retido" do
				context "Deve validar o total_st_retido se total_base_calculo_st_retido for > que zero" do
					before { subject.total_base_calculo_st_retido = 0.1 }
					it { must validate_numericality_of(:total_st_retido).is_greater_than_or_equal_to(0.0).allow_nil }
					it { must validate_presence_of(:total_st_retido) }
				end
				context "Não deve validar o total_st_retido se total_base_calculo_st_retido for zero" do
					before { subject.total_base_calculo_st_retido = 0.0 }
					it { wont validate_numericality_of(:total_st_retido).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(:total_st_retido) }
				end
				context "Não deve validar o total_st_retido se total_base_calculo_st_retido for nil" do
					before { subject.total_base_calculo_st_retido = nil }
					it { wont validate_numericality_of(:total_st_retido).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(:total_st_retido) }
				end
			end
			it { wont validate_presence_of(:modalidade_base_calculo) }
			it { wont validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(:aliquota) }
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

			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
			end
		end
		context "CST 70" do
			before { subject.codigo_cst = '70' }
			it { must validate_presence_of(:modalidade_base_calculo) }
			it { must validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { must validate_numericality_of(:reducao_base_calculo).
				is_greater_than_or_equal_to(0.0).
				is_less_than_or_equal_to(100.0).
				allow_nil
			}
			it { must validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :total_base_calculo) }
			it { must validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :aliquota) }
			it { must validate_presence_of(    :modalidade_base_calculo_st) }
			it { must validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { must validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_numericality_of(:reducao_base_calculo_st).
				is_greater_than_or_equal_to(0.0).
				is_less_than_or_equal_to(100.0).
				allow_nil
			}
			it { must validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :total_base_calculo_st) }
			it { must validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :aliquota_st) }
			it { must validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :total_st) }
			

			it { wont validate_presence_of(:reducao_base_calculo) }
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }

			context 'Deve aplicar as regras para desoneracao' do
				it { must validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it "motivo_desoneracao não deve ser obrigatório se não tiver total_desoneracao" do
					subject.total_desoneracao = ''
					must allow_value('').for(:motivo_desoneracao)
				end
				it "motivo_desoneracao deve ser obrigatório mesmo se tiver total_desoneracao" do
					subject.total_desoneracao = 50.0
					must validate_presence_of(:motivo_desoneracao)
				end
				it 'motivo_desoneracao deve validar os valores permitidos' do
					subject.total_desoneracao = nil
					must validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12])
				end
			end
		end
		context "CST 90" do
			before { subject.codigo_cst = '90' }
			it { must validate_presence_of(:modalidade_base_calculo) }
			it { must validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			
			it { must validate_numericality_of(:reducao_base_calculo).
				is_greater_than_or_equal_to(0.0).
				is_less_than_or_equal_to(100.0).
				allow_nil
			}
			it { must validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :total_base_calculo) }
			it { must validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :aliquota) }
			it { must validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_presence_of(    :aliquota_st) }
			describe "quando a aliquota_st for preenchida" do
				before { subject.aliquota_st = 7.5 }
				it { must validate_presence_of(    :modalidade_base_calculo_st) }
				it { must validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
				it { must validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0) }
				it { must validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
				it { must validate_presence_of(    :total_base_calculo_st) }
				it { must validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
				it { must validate_presence_of(    :total_st) }
			end
			describe "quando a aliquota_st não for preenchida" do
				before { subject.aliquota_st = nil }
				it { wont validate_presence_of(    :modalidade_base_calculo_st) }
				it { wont validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
				it { wont validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0) }
				it { wont validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
				it { wont validate_presence_of(    :total_base_calculo_st) }
				it { wont validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
				it { wont validate_presence_of(    :total_st) }
			end
			context 'Deve aplicar as regras para desoneracao' do
				it { must validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it "motivo_desoneracao não deve ser obrigatório se não tiver total_desoneracao" do
					subject.total_desoneracao = ''
					must allow_value('').for(:motivo_desoneracao)
				end
				it "motivo_desoneracao deve ser obrigatório mesmo se tiver total_desoneracao" do
					subject.total_desoneracao = 50.0
					must validate_presence_of(:motivo_desoneracao)
				end
				it 'motivo_desoneracao deve validar os valores permitidos' do
					subject.total_desoneracao = nil
					must validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12])
				end
			end
		end
		context "CST 101 - CSOSN" do
			before { subject.codigo_cst = '101' }
			it { must validate_numericality_of(:aliquota_credito_sn).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			it { must validate_numericality_of(:total_credito_sn).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_presence_of(:aliquota_credito_sn) }
			it { must validate_presence_of(:total_credito_sn) }

			it { wont validate_presence_of(:modalidade_base_calculo) }
			it { wont validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota) }
			it { wont validate_presence_of(    :modalidade_base_calculo_st) }
			it { wont validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { wont validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo_st) }
			it { wont validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota_st) }
			it { wont validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_st) }
			it { wont validate_presence_of(:reducao_base_calculo) }
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
			end
		end
		context "CST 102 - CSOSN" do
			before { subject.codigo_cst = '102' }
			it { wont validate_numericality_of(:aliquota_credito_sn).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			it { wont validate_numericality_of(:total_credito_sn).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_presence_of(:aliquota_credito_sn) }
			it { wont validate_presence_of(:total_credito_sn) }
			it { wont validate_presence_of(:modalidade_base_calculo) }
			it { wont validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota) }
			it { wont validate_presence_of(    :modalidade_base_calculo_st) }
			it { wont validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { wont validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo_st) }
			it { wont validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota_st) }
			it { wont validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_st) }
			it { wont validate_presence_of(:reducao_base_calculo) }
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
			end
		end
		context "CST 103 - CSOSN" do
			before { subject.codigo_cst = '103' }
			it { wont validate_numericality_of(:aliquota_credito_sn).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			it { wont validate_numericality_of(:total_credito_sn).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_presence_of(:aliquota_credito_sn) }
			it { wont validate_presence_of(:total_credito_sn) }
			it { wont validate_presence_of(:modalidade_base_calculo) }
			it { wont validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota) }
			it { wont validate_presence_of(    :modalidade_base_calculo_st) }
			it { wont validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { wont validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo_st) }
			it { wont validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota_st) }
			it { wont validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_st) }
			it { wont validate_presence_of(:reducao_base_calculo) }
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
			end
		end
		context "CST 300 - CSOSN" do
			before { subject.codigo_cst = '300' }
			it { wont validate_numericality_of(:aliquota_credito_sn).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			it { wont validate_numericality_of(:total_credito_sn).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_presence_of(:aliquota_credito_sn) }
			it { wont validate_presence_of(:total_credito_sn) }
			it { wont validate_presence_of(:modalidade_base_calculo) }
			it { wont validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota) }
			it { wont validate_presence_of(    :modalidade_base_calculo_st) }
			it { wont validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { wont validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo_st) }
			it { wont validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota_st) }
			it { wont validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_st) }
			it { wont validate_presence_of(:reducao_base_calculo) }
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
			end
		end
		context "CST 400 - CSOSN" do
			before { subject.codigo_cst = '400' }
			it { wont validate_numericality_of(:aliquota_credito_sn).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			it { wont validate_numericality_of(:total_credito_sn).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_presence_of(:aliquota_credito_sn) }
			it { wont validate_presence_of(:total_credito_sn) }
			it { wont validate_presence_of(:modalidade_base_calculo) }
			it { wont validate_inclusion_of(:modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota) }
			it { wont validate_presence_of(    :modalidade_base_calculo_st) }
			it { wont validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { wont validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo_st) }
			it { wont validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota_st) }
			it { wont validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_st) }
			it { wont validate_presence_of(:reducao_base_calculo) }
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
			end
		end
		context "CST 201 - CSOSN" do
			before { subject.codigo_cst = '201' }
			it { must validate_presence_of(    :modalidade_base_calculo_st) }
			it { must validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { must validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :total_base_calculo_st) }
			it { must validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :total_st) }
			it { must validate_numericality_of(:aliquota_credito_sn).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			it { must validate_presence_of(    :aliquota_credito_sn) }
			it { must validate_numericality_of(:total_credito_sn).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_presence_of(:total_credito_sn) }
			it { must validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :aliquota_st) }
			
			
			it { wont validate_presence_of(    :modalidade_base_calculo) }
			it { wont validate_inclusion_of(   :modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota) }
			it { wont validate_presence_of(:reducao_base_calculo) }
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
			end
		end
		context "CST 202 - CSOSN" do
			before { subject.codigo_cst = '202' }
			it { must validate_presence_of(    :modalidade_base_calculo_st) }
			it { must validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { must validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :total_base_calculo_st) }
			it { must validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :total_st) }
			it { must validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :aliquota_st) }
			
			
			it { wont validate_numericality_of(:aliquota_credito_sn).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			it { wont validate_presence_of(    :aliquota_credito_sn) }
			it { wont validate_numericality_of(:total_credito_sn).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_presence_of(:total_credito_sn) }
			it { wont validate_presence_of(    :modalidade_base_calculo) }
			it { wont validate_inclusion_of(   :modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota) }
			it { wont validate_presence_of(:reducao_base_calculo) }
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
			end
		end
		context "CST 203 - CSOSN" do
			before { subject.codigo_cst = '203' }
			it { must validate_presence_of(    :modalidade_base_calculo_st) }
			it { must validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { must validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :total_base_calculo_st) }
			it { must validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :total_st) }
			it { must validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0) }
			it { must validate_presence_of(    :aliquota_st) }
			
			
			it { wont validate_numericality_of(:aliquota_credito_sn).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			it { wont validate_presence_of(    :aliquota_credito_sn) }
			it { wont validate_numericality_of(:total_credito_sn).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_presence_of(:total_credito_sn) }
			it { wont validate_presence_of(    :modalidade_base_calculo) }
			it { wont validate_inclusion_of(   :modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota) }
			it { wont validate_presence_of(:reducao_base_calculo) }
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
			end
		end
		context "CST 500 - CSOSN" do
			before { subject.codigo_cst = '500' }
			describe "ICMS ST Retido" do
				context "Deve validar o total_st_retido se total_base_calculo_st_retido for > que zero" do
					before { subject.total_base_calculo_st_retido = 0.1 }
					it { must validate_numericality_of(:total_st_retido).is_greater_than_or_equal_to(0.0).allow_nil }
					it { must validate_presence_of(:total_st_retido) }
				end
				context "Não deve validar o total_st_retido se total_base_calculo_st_retido for zero" do
					before { subject.total_base_calculo_st_retido = 0.0 }
					it { wont validate_numericality_of(:total_st_retido).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(:total_st_retido) }
				end
				context "Não deve validar o total_st_retido se total_base_calculo_st_retido for nil" do
					before { subject.total_base_calculo_st_retido = nil }
					it { wont validate_numericality_of(:total_st_retido).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(:total_st_retido) }
				end
			end
			it { wont validate_presence_of(    :modalidade_base_calculo_st) }
			it { wont validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
			it { wont validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo_st) }
			it { wont validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_st) }
			it { wont validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota_st) }
			it { wont validate_numericality_of(:aliquota_credito_sn).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			it { wont validate_presence_of(    :aliquota_credito_sn) }
			it { wont validate_numericality_of(:total_credito_sn).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_presence_of(:total_credito_sn) }
			it { wont validate_presence_of(    :modalidade_base_calculo) }
			it { wont validate_inclusion_of(   :modalidade_base_calculo).in_array([0,1,2,3]) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :total_base_calculo) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0) }
			it { wont validate_presence_of(    :aliquota) }
			it { wont validate_presence_of(:reducao_base_calculo) }
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
			end
		end
		context "CST 900 - CSOSN" do
			before { subject.codigo_cst = '900' }
			describe "ICMS Normal" do
				it { must validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_presence_of(:aliquota) }
				context "Deve validar os dados do ICMS normal se aliquota for > que zero" do
					before { subject.aliquota = 0.1 }
					it { must validate_presence_of(    :modalidade_base_calculo) }
					it { must validate_inclusion_of(   :modalidade_base_calculo).in_array([0,1,2,3]) }
					it { must validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
					it { must validate_presence_of(    :total_base_calculo) }
					it { must validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
				end
				context "Deve validar os dados do ICMS normal se aliquota for zero" do
					before { subject.aliquota = 0.0 }
					it { wont validate_presence_of(    :modalidade_base_calculo) }
					it { wont validate_inclusion_of(   :modalidade_base_calculo).in_array([0,1,2,3]) }
					it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(    :total_base_calculo) }
					it { wont validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(    :total) }
				end
				context "Deve validar os dados do ICMS normal se aliquota for nil" do
					before { subject.aliquota = nil }
					it { wont validate_presence_of(    :modalidade_base_calculo) }
					it { wont validate_inclusion_of(   :modalidade_base_calculo).in_array([0,1,2,3]) }
					it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(    :total_base_calculo) }
					it { wont validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(    :total) }
				end
			end
			describe "ICMS ST" do
				it { must validate_numericality_of(:aliquota_st).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_presence_of(:aliquota_st) }
				context "Deve validar os dados do ICMS normal se aliquota_st for > que zero" do
					before { subject.aliquota_st = 0.1 }
					it { must validate_presence_of(    :modalidade_base_calculo_st) }
					it { must validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
					it { must validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0).allow_nil }
					it { must validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0).allow_nil }
					it { must validate_presence_of(    :total_base_calculo_st) }
					it { must validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0).allow_nil }
					it { must validate_presence_of(    :total_st) }
				end
				context "Deve validar os dados do ICMS normal se aliquota_st for zero" do
					before { subject.aliquota_st = 0.0 }
					it { wont validate_presence_of(    :modalidade_base_calculo_st) }
					it { wont validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
					it { wont validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(    :total_base_calculo_st) }
					it { wont validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(    :total_st) }
				end
				context "Deve validar os dados do ICMS normal se aliquota_st for nil" do
					before { subject.aliquota_st = nil }
					it { wont validate_presence_of(    :modalidade_base_calculo_st) }
					it { wont validate_inclusion_of(   :modalidade_base_calculo_st).in_array([0,1,2,3,4,5]) }
					it { wont validate_numericality_of(:mva_st).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_numericality_of(:total_base_calculo_st).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(    :total_base_calculo_st) }
					it { wont validate_numericality_of(:total_st).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(    :total_st) }
				end
			end

			describe "Aliquota de crédito" do
				it { must validate_numericality_of(:aliquota_credito_sn).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_presence_of(:aliquota_credito_sn) }
				context "Deve validar os dados do ICMS normal se aliquota_credito_sn for > que zero" do
					before { subject.aliquota_credito_sn = 0.1 }
					it { must validate_numericality_of(:total_credito_sn).is_greater_than_or_equal_to(0.0).allow_nil }
					it { must validate_presence_of(:total_credito_sn) }
				end
				context "Deve validar os dados do ICMS normal se aliquota_credito_sn for zero" do
					before { subject.aliquota_credito_sn = 0.0 }
					it { wont validate_numericality_of(:total_credito_sn).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(:total_credito_sn) }
				end
				context "Deve validar os dados do ICMS normal se aliquota_credito_sn for nil" do
					before { subject.aliquota_credito_sn = nil }
					it { wont validate_numericality_of(:total_credito_sn).is_greater_than_or_equal_to(0.0).allow_nil }
					it { wont validate_presence_of(:total_credito_sn) }
				end
			end
			it { wont validate_presence_of(:reducao_base_calculo) }
			it { wont validate_numericality_of(:total_icms_operacao).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:total_icms_diferido).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_numericality_of(:percentual_diferimento).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(100.0).allow_nil }
			context 'Não deve aplicar as regras para desoneracao' do
				it { wont validate_numericality_of(:total_desoneracao).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_inclusion_of(:motivo_desoneracao).in_array([3,9,12]) }
				it { wont validate_presence_of(:motivo_desoneracao) }
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