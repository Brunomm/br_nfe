require 'test_helper'

describe BrNfe::Service::Betha::V1::ConsultaLoteRps do
	subject             { FactoryGirl.build(:servico_betha_consulta_lote_rps, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::V1::Gateway }
	end

	describe "validations" do
		it { must validate_presence_of(:protocolo) }
	end

	describe "#wsdl" do
		context "for env production" do
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/consultarLoteRps?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/consultarLoteRps?wsdl' }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_lote_rps_envio }
	end

	describe "#response_path_module" do
		it "deve ter um module" do
			subject.response_path_module.must_equal BrNfe::Service::Betha::V1::ResponsePaths::ServicoConsultarLoteRpsResposta
		end
	end

	it "#response_root_path" do
		subject.response_root_path.must_equal [:consultar_lote_rps_envio_response]
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/betha/v1/xsd' }
				
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('servico_consultar_lote_rps_envio_v01.xsd'))
					document = Nokogiri::XML(subject.content_xml)
					errors = schema.validate(document)
					errors.must_be_empty
				end
			end
		end
	end
end