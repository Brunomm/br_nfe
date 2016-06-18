require 'test_helper'
require 'br_nfe/helper/have_emitente_test'
require 'br_nfe/helper/have_destinatario_test'
require 'br_nfe/helper/have_intermediario_test'
require 'br_nfe/helper/have_condicao_pagamento_test'

describe BrNfe::Service::Response::NotaFiscal do
	subject { FactoryGirl.build(:response_nota_fiscal, emitente: emitente) }
	let(:emitente)           { FactoryGirl.build(:emitente) } 
	let(:destinatario)       { subject.destinatario } 
	let(:intermediario)      { subject.intermediario } 
	let(:condicao_pagamento) { subject.condicao_pagamento } 

	describe "#emitente" do
		include BrNfeTest::HelperTest::HaveEmitenteTest
	end

	describe "#destinatario" do
		include BrNfeTest::HelperTest::HaveDestinatarioTest
	end

	describe "#intermediario" do
		include BrNfeTest::HelperTest::HaveIntermediarioTest
	end

	describe "#condicao_pagamento" do
		include BrNfeTest::HelperTest::HaveCondicaoPagamentoTest
	end

	describe "#substituida?" do
		it "quando tem valor em nfe_substituidora" do
			subject.nfe_substituidora = '666'
			subject.substituida?.must_equal true
		end

		it "quando não tem valor na nfe_substituidora" do
			subject.nfe_substituidora = ''
			subject.substituida?.must_equal false
		end
	end
end