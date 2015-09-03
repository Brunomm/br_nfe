require 'test_helper'

describe BrNfe::CondicaoPagamento do
	subject { FactoryGirl.build(:condicao_pagamento) }
	
	describe "#parcelas" do
		it "deve inicializar como um vetor vazio" do
			subject.class.new.parcelas.must_equal []
		end

		it "posso utilizar o << para adicionar valores" do
			subject.parcelas << {valor: '1'}
			subject.parcelas << {valor: '2'}
			subject.parcelas.must_equal [{valor: '1'}, {valor: '2'}]
		end

		it "sempre retorna um array" do
			subject.parcelas = {valor: '2'}
			subject.parcelas.must_equal [{valor: '2'}]
		end

	end
end