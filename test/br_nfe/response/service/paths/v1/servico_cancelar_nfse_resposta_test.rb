require 'test_helper'

describe BrNfe::Service::Response::Paths::V1::ServicoCancelarNfseResposta do
	
	class ResponsePathsV1ServicoCancelarNfseRespostaTest
		include BrNfe::Service::Response::Paths::V1::ServicoCancelarNfseResposta
	end

	subject { ResponsePathsV1ServicoCancelarNfseRespostaTest.new } 

	it "deve estar incluso o module BrNfe::Service::Response::Paths::Base" do
		subject.class.included_modules.must_include BrNfe::Service::Response::Paths::Base
	end

	describe "métodos sobrescritos do module ..Base" do
		it 'valor do método message_errors_path' do
			subject.message_errors_path.must_equal [:cancelar_nfse_resposta, :lista_mensagem_retorno, :mensagem_retorno]
		end

		it 'valor do método cancelation_date_time_path' do
			subject.cancelation_date_time_path.must_equal [:cancelar_nfse_resposta, :cancelamento, :confirmacao, :inf_confirmacao_cancelamento, :data_hora]
		end
	end

end