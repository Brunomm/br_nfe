require 'test_helper'

describe BrNfe::Helper::CpfCnpj do
	describe "when is a cnpj" do
		subject { BrNfe::Helper::CpfCnpj.new('64.147.776/0001-11') }

		it "#cpf?" do
			subject.cpf?.must_equal false
		end

		it "#cnpj?" do
			subject.cnpj?.must_equal true
		end

		it "#cpf_ou_cnpj?" do
			subject.cpf_ou_cnpj?.must_equal :cnpj
		end

		it "#sem_formatacao" do
			subject.sem_formatacao.must_equal '64147776000111'
		end

		it "#com_formatacao" do
			objeto = BrNfe::Helper::CpfCnpj.new('64147776000111')
			subject.com_formatacao.must_equal '64.147.776/0001-11'
		end

		it "#formatado_com_label" do
			subject.formatado_com_label.must_equal 'CNPJ 64.147.776/0001-11'
		end

	end
	describe "when is a cpf" do
		subject { BrNfe::Helper::CpfCnpj.new('845.076.668-05') }

		it "#cpf?" do
			subject.cpf?.must_equal true
		end

		it "#cnpj?" do
			subject.cnpj?.must_equal false
		end

		it "#cpf_ou_cnpj?" do
			subject.cpf_ou_cnpj?.must_equal :cpf
		end

		it "#sem_formatacao" do
			subject.sem_formatacao.must_equal '84507666805'
		end

		it "#com_formatacao" do
			objeto = BrNfe::Helper::CpfCnpj.new('84507666805')
			subject.com_formatacao.must_equal '845.076.668-05'
		end

		it "#formatado_com_label" do
			subject.formatado_com_label.must_equal 'CPF 845.076.668-05'
		end
	end
end