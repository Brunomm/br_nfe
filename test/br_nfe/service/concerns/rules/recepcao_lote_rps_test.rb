require 'test_helper'

class RuleRecepcaoLoteRpsTest < BrNfe::Service::Base
	include BrNfe::Service::Concerns::Rules::RecepcaoLoteRps
end

describe BrNfe::Service::Concerns::Rules::RecepcaoLoteRps do
	subject { RuleRecepcaoLoteRpsTest.new(numero_lote_rps: 545, operacao: '1', emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:service_emitente, endereco: endereco) }
	let(:endereco) { FactoryGirl.build(:endereco) } 
	let(:rps) { FactoryGirl.build(:br_nfe_rps) } 

	it { must validate_presence_of(:numero_lote_rps) }

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

	describe "#validar_lote_rps" do
		it "se não houver nenhum rps, deve add um erro" do
			subject.lote_rps = []
			subject.errors.full_messages.must_equal( [] )
			subject.valid?.must_equal false
			subject.errors.full_messages.must_equal( ["Deve conter ao menos 1 RPS"] )
		end
		context "deve validar o rps setando a opcao validar_recepcao_rps" do
			before { subject.lote_rps = [rps] }
			it "quando o rps for válido não deve setar nenhuma mensagem no objeto" do
				rps.stubs(:errors).returns(stub(full_messages: ["Erro rps"]))
				sequence_1 = sequence('sequence_1')
				rps.expects(:validar_recepcao_rps=).with(true).in_sequence(sequence_1)
				rps.expects(:invalid?).returns(false).in_sequence(sequence_1)
				subject.send(:validar_lote_rps)
				subject.errors.full_messages.must_equal( [] )
			end
			it "quando o rps for inválido deve setar mensagem de erro no objeto" do
				rps.stubs(:errors).returns(stub(full_messages: ["Erro rps"]))
				sequence_1 = sequence('sequence_1')
				rps.expects(:validar_recepcao_rps=).with(true).in_sequence(sequence_1)
				rps.expects(:invalid?).returns(true).in_sequence(sequence_1)
				subject.send(:validar_lote_rps)
				subject.errors.full_messages.must_equal( ["RPS 1: Erro rps"] )
			end
		end
	end
end