require 'test_helper'

describe BrNfe::Service::Thema::V1::ConsultaNfse do
	subject             { FactoryGirl.build(:service_thema_v1_consulta_nfse, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:emitente) }
	let(:rps)           { subject.rps } 

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Thema::V1::Base }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::ConsultaNfsPorRps inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::ConsultaNfse
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_nfse }
	end

	it "#response_path_module" do
		subject.response_path_module.must_equal BrNfe::Service::Response::Paths::V1::ServicoConsultarNfseResposta
	end

	it "#response_root_path" do
		subject.response_root_path.must_equal []
	end
	it "#body_xml_path" do
		subject.body_xml_path.must_equal [:consultar_nfse_response, :return]
	end

	it "#soap_body_root_tag" do
		subject.soap_body_root_tag.must_equal 'consultarNfse'
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/thema/v1/xsd' }
				
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('nfse.xsd'))
					document = Nokogiri::XML(subject.xml_builder)
					errors = schema.validate(document)
					errors.must_be_empty
				end
			end
		end
	end

end