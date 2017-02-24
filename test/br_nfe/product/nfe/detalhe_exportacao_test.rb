require 'test_helper'

describe BrNfe::Product::Nfe::DetalheExportacao do
	subject { FactoryGirl.build(:product_detalhe_exportacao) }

	describe "Alias attributes" do
		it { must_have_alias_attribute :nDraw,    :numero_drawback, '1' }
		it { must_have_alias_attribute :nRE,      :numero_registro, '1' }
		it { must_have_alias_attribute :chNFe,    :chave_nfe_recebida, '1' }
		it { must_have_alias_attribute :qExport,  :quantidade }
	end

	describe 'Validações' do
		before { MiniTest::Spec.string_for_validation_length = '1' }
		after  { MiniTest::Spec.string_for_validation_length = 'x' }
		it { must validate_length_of(:numero_drawback).is_at_least(9).is_at_most(12) }
		it { must validate_length_of(:numero_registro).is_equal_to(12) }
		it { must validate_length_of(:chave_nfe_recebida).is_equal_to(44) }
		it { must validate_numericality_of(:quantidade).is_greater_than(0.0).allow_nil }
	end
	describe '#numero_drawback' do
		it "deve aceitar apenas números" do
			subject.numero_drawback = 'ABC123DEF456G'
			subject.numero_drawback.must_equal '123456'
		end
		it "deve ignorar os espacos em branco" do
			subject.numero_drawback = ' 6546.546 '
			subject.numero_drawback.must_equal '6546546'
		end
	end
	describe '#numero_registro' do
		it "deve aceitar apenas números" do
			subject.numero_registro = 'ABC123DEF456G'
			subject.numero_registro.must_equal '123456'
		end
		it "deve ignorar os espacos em branco" do
			subject.numero_registro = ' 6546.546 '
			subject.numero_registro.must_equal '6546546'
		end
	end
	describe '#chave_nfe_recebida' do
		it "deve aceitar apenas números" do
			subject.chave_nfe_recebida = 'ABC123DEF456G'
			subject.chave_nfe_recebida.must_equal '123456'
		end
		it "deve ignorar os espacos em branco" do
			subject.chave_nfe_recebida = ' 6546.546 '
			subject.chave_nfe_recebida.must_equal '6546546'
		end
	end
	describe '#ignore?' do
		before do
			subject.assign_attributes(numero_drawback: '', numero_registro: nil,
			                       chave_nfe_recebida: '', quantidade: nil)
		end
		it "deve retornar true se todas as informaçẽos estiverem em branco" do
			subject.ignore?.must_equal true
		end
		it "deve retornar false se numero_drawback estiver preenchido" do
			subject.numero_drawback = '213456'
			subject.ignore?.must_equal false
		end
		it "deve retornar false se numero_registro estiver preenchido" do
			subject.numero_registro = '213456'
			subject.ignore?.must_equal false
		end
		it "deve retornar false se chave_nfe_recebida estiver preenchido" do
			subject.chave_nfe_recebida = '213456'
			subject.ignore?.must_equal false
		end
		it "deve retornar false se quantidade estiver preenchido" do
			subject.quantidade = 45.78
			subject.ignore?.must_equal false
		end
	end
	describe '#exportacao_indireta?' do
		before do
			subject.assign_attributes(numero_drawback: '123', numero_registro: nil,
			                       chave_nfe_recebida: '', quantidade: nil)
		end
		it "deve retornar false se nenhuma informação de exportação indireta for preenchida" do
			subject.exportacao_indireta?.must_equal false
		end
		it "deve retornar true se numero_registro estiver preenchido" do
			subject.numero_registro = '213456'
			subject.exportacao_indireta?.must_equal true
		end
		it "deve retornar true se chave_nfe_recebida estiver preenchido" do
			subject.chave_nfe_recebida = '213456'
			subject.exportacao_indireta?.must_equal true
		end
		it "deve retornar true se quantidade estiver preenchido" do
			subject.quantidade = 45.78
			subject.exportacao_indireta?.must_equal true
		end
	end
end