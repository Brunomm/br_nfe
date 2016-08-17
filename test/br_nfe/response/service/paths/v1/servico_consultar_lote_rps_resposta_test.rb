require 'test_helper'

describe BrNfe::Service::Response::Paths::V1::ServicoConsultarLoteRpsResposta do
	
	class ResponsePathsV1ServicoConsultarLoteRpsRespostaTest
		include BrNfe::Service::Response::Paths::V1::ServicoConsultarLoteRpsResposta
	end

	subject { ResponsePathsV1ServicoConsultarLoteRpsRespostaTest.new } 

	it "deve estar incluso o module BrNfe::Service::Response::Paths::Base" do
		subject.class.included_modules.must_include BrNfe::Service::Response::Paths::Base
	end

	it "deve estar incluso o module BrNfe::Service::Response::Paths::V1::TcNfse" do
		subject.class.included_modules.must_include BrNfe::Service::Response::Paths::V1::TcNfse
	end

	describe "métodos sobrescritos do module ..Base" do
		it 'valor do método message_errors_path' do
			subject.response_message_errors_path.must_equal [:consultar_lote_rps_resposta, :lista_mensagem_retorno, :mensagem_retorno]
		end

		it 'valor do método invoices_path' do
			subject.response_invoices_path.must_equal [:consultar_lote_rps_resposta, :lista_nfse, :comp_nfse]
		end

	end

end