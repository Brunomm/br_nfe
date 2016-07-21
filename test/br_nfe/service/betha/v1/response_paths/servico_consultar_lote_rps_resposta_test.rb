require 'test_helper'

describe  BrNfe::Service::Betha::V1::ResponsePaths::ServicoConsultarLoteRpsResposta do
	class ServicoConsultarLoteRpsRespostaTest
		include BrNfe::Service::Betha::V1::ResponsePaths::ServicoConsultarLoteRpsResposta
	end
	subject { ServicoConsultarLoteRpsRespostaTest.new } 
	
	it "deve estar incluso o module ..Response::Paths::V1::ServicoConsultarLoteRpsResposta" do
		subject.class.included_modules.must_include BrNfe::Service::Response::Paths::V1::ServicoConsultarLoteRpsResposta
	end

	it "metodo invoices_path sobrescrito com valor padrão" do
		subject.invoices_path.must_equal [:consultar_lote_rps_resposta, :lista_nfse, :compl_nfse]
	end
end