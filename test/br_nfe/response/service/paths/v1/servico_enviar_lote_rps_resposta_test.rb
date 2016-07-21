require 'test_helper'

describe BrNfe::Service::Response::Paths::V1::ServicoEnviarLoteRpsResposta do
	
	class ResponsePathsV1ServicoEnviarLoteRpsRespostaTest
		include BrNfe::Service::Response::Paths::V1::ServicoEnviarLoteRpsResposta
	end

	subject { ResponsePathsV1ServicoEnviarLoteRpsRespostaTest.new } 

	it "deve estar incluso o module BrNfe::Service::Response::Paths::Base" do
		subject.class.included_modules.must_include BrNfe::Service::Response::Paths::Base
	end

	describe "métodos sobrescritos do module ..Base" do
		it 'valor do método lot_number_path' do
			subject.lot_number_path.must_equal([:enviar_lote_rps_resposta, :numero_lote] )
		end

		it 'valor do método protocol_path' do
			subject.protocol_path.must_equal([:enviar_lote_rps_resposta, :protocolo] )
		end

		it 'valor do método received_date_path' do
			subject.received_date_path.must_equal([:enviar_lote_rps_resposta, :data_recebimento] )
		end

		it 'valor do método message_errors_path' do
			subject.message_errors_path.must_equal([:enviar_lote_rps_resposta, :lista_mensagem_retorno, :mensagem_retorno])
		end

	end

end