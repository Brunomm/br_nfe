require 'test_helper'

describe BrNfe::Service::Response::NotaFiscal do
	subject { FactoryGirl.build(:response_service_nota_fiscal, emitente: emitente) }
	let(:emitente)           { FactoryGirl.build(:service_emitente) } 
	let(:destinatario)       { subject.destinatario } 
	let(:intermediario)      { subject.intermediario } 
	let(:condicao_pagamento) { subject.condicao_pagamento } 

	describe "#emitente" do
		it "deve conter o module HaveEmitente" do
			subject.class.included_modules.must_include BrNfe::Association::HaveEmitente
		end
	end

	describe "#destinatario" do
		class OtherClassDestinatario < BrNfe::ActiveModelBase
		end
		it "deve ter incluso o module HaveDestinatario" do
			subject.class.included_modules.must_include BrNfe::Association::HaveDestinatario
		end
		it "o método #destinatario_class deve ter por padrão a class BrNfe::Service::Destinatario" do
			subject.destinatario.must_be_kind_of BrNfe::Service::Destinatario
			subject.send(:destinatario_class).must_equal BrNfe::Service::Destinatario
		end
		it "a class do destinatario pode ser modificada através da configuração destinatario_service_class" do
			BrNfe.destinatario_service_class = OtherClassDestinatario
			subject.destinatario.must_be_kind_of OtherClassDestinatario
			subject.send(:destinatario_class).must_equal OtherClassDestinatario

			# É necessário voltar a configuração original para não falhar outros testes
			BrNfe.destinatario_service_class = BrNfe::Service::Destinatario
		end
	end

	describe "#intermediario" do
		it "deve ter incluso o module BrNfe::Association::HaveIntermediario" do
			subject.class.included_modules.must_include BrNfe::Service::Association::HaveIntermediario
		end
	end

	describe "#condicao_pagamento" do
		it "deve ter incluso o module BrNfe::Association::HaveCondicaoPagamento" do
			subject.class.included_modules.must_include BrNfe::Association::HaveCondicaoPagamento
		end
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