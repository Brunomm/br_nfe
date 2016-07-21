require 'test_helper'

describe  BrNfe::Service::Betha::V1::ResponsePaths::ServicoConsultarNfseResposta do
	class ServicoConsultarNfseRespostaTest
		include BrNfe::Service::Betha::V1::ResponsePaths::ServicoConsultarNfseResposta
	end
	subject { ServicoConsultarNfseRespostaTest.new } 
	
	it "deve estar incluso o module ..Response::Paths::V1::ServicoConsultarNfseResposta" do
		subject.class.included_modules.must_include BrNfe::Service::Response::Paths::V1::ServicoConsultarNfseResposta
	end

	it "metodo invoices_path sobrescrito com valor padrão" do
		subject.invoices_path.must_equal [:consultar_nfse_resposta, :lista_nfse, :compl_nfse]
	end
end