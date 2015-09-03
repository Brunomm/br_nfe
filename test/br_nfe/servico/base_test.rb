require 'test_helper'

describe BrNfe::Servico::Base do
	subject { FactoryGirl.build(:br_nfe_servico_base) }
		
	describe "#lote_rps" do
		it "deve inicializar como um vetor vazio" do
			subject.class.new.lote_rps.must_equal []
		end

		it "posso utilizar o << para adicionar valores" do
			subject.lote_rps << 'v1'
			subject.lote_rps << 'v2'
			subject.lote_rps.must_equal ['v1','v2']
		end

		it "sempre retorna um array" do
			subject.lote_rps = {valor: '2'}
			subject.lote_rps.must_equal [{valor: '2'}]
		end

	end
end