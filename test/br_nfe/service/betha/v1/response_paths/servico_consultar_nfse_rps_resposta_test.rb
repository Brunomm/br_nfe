require 'test_helper'

describe  BrNfe::Service::Betha::V1::ResponsePaths::ServicoConsultarNfseRpsResposta do
	class ServicoConsultarNfseRpsRespostaTest
		include BrNfe::Service::Betha::V1::ResponsePaths::ServicoConsultarNfseRpsResposta
	end
	subject { ServicoConsultarNfseRpsRespostaTest.new } 
	
	it "deve estar incluso o module ..Response::Paths::V1::ServicoConsultarNfseRpsResposta" do
		subject.class.included_modules.must_include BrNfe::Service::Response::Paths::V1::ServicoConsultarNfseRpsResposta
	end

	it "metodo invoices_path sobrescrito com valor padrão" do
		subject.invoices_path.must_equal [:consultar_nfse_rps_resposta, :compl_nfse]
	end
end