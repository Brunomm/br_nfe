require 'test_helper'

class RuleConsultaNfseTest < BrNfe::Service::Base
	include BrNfe::Service::Concerns::Rules::ConsultaNfse
end

describe BrNfe::Service::Concerns::Rules::ConsultaNfse do
	subject { RuleConsultaNfseTest.new(nfe_number: '554', start_date: 1.month.ago, end_date: Time.now, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:service_emitente, endereco: endereco) }
	let(:endereco) { FactoryGirl.build(:endereco) } 
	let(:rps) { FactoryGirl.build(:br_nfe_rps) } 

	it "deve ter o o helper HaveDestinatario incluido" do
		subject.class.included_modules.must_include BrNfe::Association::HaveDestinatario
	end

	it "deve ter o o helper HaveIntermediario incluido" do
		subject.class.included_modules.must_include BrNfe::Service::Association::HaveIntermediario
	end

	describe "#start_date" do
		it "o get do start_date deve retornar uma data no formato YYYY-MM-DD" do
			subject.start_date = '20/05/2010'
			subject.start_date.must_equal '2010-05-20'
		end
		it "se start_date for nil o get deve retornar em branco" do
			subject.start_date = nil
			subject.start_date.must_equal ''
		end
	end

	describe "#end_date" do
		it "o get do end_date deve retornar uma data no formato YYYY-MM-DD" do
			subject.end_date = '20/08/2015'
			subject.end_date.must_equal '2015-08-20'
		end
		it "se end_date for nil o get deve retornar em branco" do
			subject.end_date = nil
			subject.end_date.must_equal ''
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

end