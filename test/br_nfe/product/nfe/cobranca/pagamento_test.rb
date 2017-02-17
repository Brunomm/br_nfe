require 'test_helper'

describe BrNfe::Product::Nfe::Cobranca::Pagamento do
	subject { FactoryGirl.build(:product_cobranca_pagamento) }

	describe "Alias attributes" do
		it { must_have_alias_attribute :tPag, :forma_pagamento }
		it { must_have_alias_attribute :vPag, :total }
		it { must_have_alias_attribute :CNPJ, :cartao_cnpj, '01234567890' }
		it { must_have_alias_attribute :tBand, :cartao_bandeira }
		it { must_have_alias_attribute :cAut, :cartao_autorizacao }
	end

	describe 'Validations' do
		it { must validate_presence_of(:forma_pagamento) }
		it { must validate_presence_of(:total) }
		it { must validate_inclusion_of(:forma_pagamento).in_array(BrNfe::Constants::FORMAS_PAGAMENTO) }
		it { must validate_numericality_of(:total).is_greater_than_or_equal_to(0.0) }

		context "validações para forma de pagaemtno com cartão" do
			describe "Quando o pagamento for com cartão" do
				before { subject.stubs(:cartao?).returns(true) }
				it { must validate_presence_of(:cartao_cnpj) }
				it { must validate_presence_of(:cartao_bandeira) }
				it { must validate_presence_of(:cartao_autorizacao) }
				it { must validate_length_of(:cartao_cnpj).is_at_most(14) }
				it { must validate_length_of(:cartao_autorizacao).is_at_most(20) }
				it { must validate_inclusion_of(:cartao_bandeira).in_array([1, 2, 3, 4, 99, '1', '2', '3', '4', '01', '02', '03', '04', '99']) }
			end
			describe "Quando o pagamento não for com cartão" do
				before { subject.stubs(:cartao?).returns(false) }
				it { wont validate_presence_of(:cartao_cnpj) }
				it { wont validate_presence_of(:cartao_bandeira) }
				it { wont validate_presence_of(:cartao_autorizacao) }
				it { wont validate_length_of(:cartao_cnpj).is_at_most(14) }
				it { wont validate_length_of(:cartao_autorizacao).is_at_most(20) }
				it { wont validate_inclusion_of(:cartao_bandeira).in_array([1, 2, 3, 4, 99, '1', '2', '3', '4', '01', '02', '03', '04', '99']) }
			end
		end
	end

	it "cartao_cnpj deve retornar apenas os números" do
		subject.cartao_cnpj = '012.345.55/0001-66'
		subject.cartao_cnpj.must_equal '01234555000166'
	end

	describe '#cartao?' do
		it "deve retornar true se a forma de pagamento for 3 ou 4" do
			subject.forma_pagamento = 3
			subject.cartao?.must_equal true
			subject.forma_pagamento = '3'
			subject.cartao?.must_equal true
			subject.forma_pagamento = '03'
			subject.cartao?.must_equal true
			subject.forma_pagamento = 4
			subject.cartao?.must_equal true
			subject.forma_pagamento = '4'
			subject.cartao?.must_equal true
			subject.forma_pagamento = '04'
			subject.cartao?.must_equal true
		end
		it "deve retornar false se a forma de pagamento não for 3 ou 4" do
			subject.forma_pagamento = 1
			subject.cartao?.must_equal false
			subject.forma_pagamento = '1'
			subject.cartao?.must_equal false
			subject.forma_pagamento = '01'
			subject.cartao?.must_equal false
			subject.forma_pagamento = 2
			subject.cartao?.must_equal false
			subject.forma_pagamento = '2'
			subject.cartao?.must_equal false
			subject.forma_pagamento = '02'
			subject.cartao?.must_equal false
			subject.forma_pagamento = 5
			subject.cartao?.must_equal false
			subject.forma_pagamento = '5'
			subject.cartao?.must_equal false
			subject.forma_pagamento = '05'
			subject.cartao?.must_equal false
			subject.forma_pagamento = 10
			subject.cartao?.must_equal false
			subject.forma_pagamento = '10'
			subject.cartao?.must_equal false
			subject.forma_pagamento = 11
			subject.cartao?.must_equal false
			subject.forma_pagamento = '11'
			subject.cartao?.must_equal false
			subject.forma_pagamento = 12
			subject.cartao?.must_equal false
			subject.forma_pagamento = '12'
			subject.cartao?.must_equal false
			subject.forma_pagamento = 13
			subject.cartao?.must_equal false
			subject.forma_pagamento = '13'
			subject.cartao?.must_equal false
			subject.forma_pagamento = 99
			subject.cartao?.must_equal false
			subject.forma_pagamento = '99'
			subject.cartao?.must_equal false
		end
	end
	

end