require 'test_helper'

describe BrNfe::Product::Nfe::ItemTax::IcmsUfDestino do
	subject { FactoryGirl.build(:product_item_tax_icms_uf_destino) }

	describe 'Alias attributes' do
		it { must_have_alias_attribute :vBCUFDest,      :total_base_calculo }
		it { must_have_alias_attribute :pFCPUFDest,     :percentual_fcp }
		it { must_have_alias_attribute :pICMSUFDest,    :aliquota_interna_uf_destino }
		it { must_have_alias_attribute :pICMSInter,     :aliquota_interestadual }
		it { must_have_alias_attribute :pICMSInterPart, :percentual_partilha_destino }
		it { must_have_alias_attribute :vFCPUFDest,     :total_fcp_destino }
		it { must_have_alias_attribute :vICMSUFDest,    :total_destino }
		it { must_have_alias_attribute :vICMSUFRemet,   :total_origem }
	end

	describe 'Validations' do
		describe '#total_base_calculo' do
			it { must validate_presence_of(:total_base_calculo) }
			it { must validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe '#aliquota_interna_uf_destino' do
			it { must validate_presence_of(:aliquota_interna_uf_destino) }
			it { must validate_numericality_of(:aliquota_interna_uf_destino).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe '#aliquota_interestadual' do
			it { must validate_presence_of(:aliquota_interestadual) }
			it { must validate_numericality_of(:aliquota_interestadual).
				is_greater_than_or_equal_to(0.0).
				is_less_than_or_equal_to(99.99).
				allow_nil 
			}
		end
		describe '#percentual_partilha_destino' do
			it { must validate_numericality_of(:percentual_partilha_destino).
				is_greater_than_or_equal_to(0.0).
				is_less_than_or_equal_to(100.0).
				allow_nil 
			}
		end
		describe '#percentual_fcp' do
			it { must validate_numericality_of(:percentual_fcp).
				is_greater_than_or_equal_to(0.0).
				is_less_than_or_equal_to(2.0).
				allow_nil 
			}
		end
		describe '#total_fcp_destino' do
			it { must validate_numericality_of(:total_fcp_destino).
				is_greater_than_or_equal_to(0.0).
				allow_nil 
			}
		end
		describe '#total_destino' do
			it { must validate_presence_of(:total_destino) }
			it { must validate_numericality_of(:total_destino).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe '#total_origem' do
			it { must validate_presence_of(:total_origem) }
			it { must validate_numericality_of(:total_origem).is_greater_than_or_equal_to(0.0).allow_nil }
		end
	end

	describe '#percentual_partilha_destino' do
		it "se for setado um valor, deve considerar esse valor" do
			subject.percentual_partilha_destino = 77.00
			subject.percentual_partilha_destino.must_equal 77.00
		end
		context "quando o valor estiver nil" do
			before { subject.percentual_partilha_destino = nil }
			it "se o ano for 2016 deve retornar 40%" do
				date = Date.parse('31/12/2016')
				Date.stubs(:current).returns(date)
				subject.percentual_partilha_destino.must_equal 40.0
			end
			it "se o ano for 2017 deve retornar 60%" do
				date = Date.parse('31/12/2017')
				Date.stubs(:current).returns(date)
				subject.percentual_partilha_destino.must_equal 60.0
			end
			it "se o ano for 2018 deve retornar 80%" do
				date = Date.parse('31/12/2018')
				Date.stubs(:current).returns(date)
				subject.percentual_partilha_destino.must_equal 80.0
			end
			it "se o ano for 2019 deve retornar 100%" do
				date = Date.parse('31/12/2019')
				Date.stubs(:current).returns(date)
				subject.percentual_partilha_destino.must_equal 100.0
			end
			it "se o ano for maior que 2019 deve retornar 100%" do
				date = Date.parse('31/12/2020')
				Date.stubs(:current).returns(date)
				subject.percentual_partilha_destino.must_equal 100.0
			end

		end
	end
end