require 'test_helper'

describe BrNfe::Service::Response::Paths::V1::ServicoConsultarSituacaoLoteRpsResposta do
	
	class ResponsePathsV1ServicoConsultarSituacaoLoteRpsRespostaTest
		include BrNfe::Service::Response::Paths::V1::ServicoConsultarSituacaoLoteRpsResposta
	end

	subject { ResponsePathsV1ServicoConsultarSituacaoLoteRpsRespostaTest.new } 

	it "deve estar incluso o module BrNfe::Service::Response::Paths::Base" do
		subject.class.included_modules.must_include BrNfe::Service::Response::Paths::Base
	end

	describe "métodos sobrescritos do module ..Base" do
		it 'valor do método lot_number_path' do
			subject.response_lot_number_path.must_equal [:consultar_situacao_lote_rps_resposta, :numero_lote] 
		end

		it 'valor do método situation_path' do
			subject.response_situation_path.must_equal [:consultar_situacao_lote_rps_resposta, :situacao] 
		end

		it 'valor do método message_errors_path' do
			subject.response_message_errors_path.must_equal [:consultar_situacao_lote_rps_resposta, :lista_mensagem_retorno, :mensagem_retorno]
		end

	end

end