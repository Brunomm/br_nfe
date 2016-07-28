require 'test_helper'

describe BrNfe::Service::Simpliss::V1::RecepcaoLoteRps do
	subject        { FactoryGirl.build(:service_simpliss_v1_recepcao_lote_rps, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:emitente)   }
	
	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Simpliss::V1::Base }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::ConsultaNfsPorRps inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::RecepcaoLoteRps
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :recepcionar_lote_rps }
	end

	it "#response_path_module" do
		subject.response_path_module.must_equal BrNfe::Service::Response::Paths::V1::ServicoEnviarLoteRpsResposta
	end

	it "#response_root_path" do
		subject.response_root_path.must_equal [:recepcionar_lote_rps_response]
	end

	it "#body_xml_path" do
		subject.body_xml_path.must_equal []
	end

	it "#soap_body_root_tag" do
		subject.soap_body_root_tag.must_equal 'RecepcionarLoteRps'
	end
	
	describe "Validação do XML através do XSD" do
		let(:rps_basico) { FactoryGirl.build(:br_nfe_rps)              } 
		let(:rps_completo) { FactoryGirl.build(:br_nfe_rps, :completo) } 
		
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/simpliss/v1/xsd' }
		
		def validate_schema
			# Só assim para passar na validação XSD.
			# o XSD não consegue validar os namespaces pois estão declarados na
			# tag envelope.
			subject.stubs(:message_namespaces).returns({'xmlns' => "http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd"})
			subject.stubs(:namespace_identifier).returns(nil)
			subject.stubs(:namespace_for_tags).returns(nil)
			subject.stubs(:namespace_for_signature).returns(nil)
			
			Dir.chdir(schemas_dir) do
				schema = Nokogiri::XML::Schema(IO.read('nfse_3.xsd'))
				document = Nokogiri::XML(subject.xml_builder)
				errors = schema.validate(document)
				errors.must_be_empty
			end
		end
		it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
			subject.lote_rps = [rps_completo]
			validate_schema
		end
		it "Deve ser válido com 1 RPS com apenas as informações obrigatórias preenchidas" do
			subject.lote_rps = [rps_basico]
			validate_schema
		end
		it "Deve ser válido com vários RPS's - 1 rps completo e 1 parcial" do
			subject.assign_attributes(certificate_pkcs12_password: nil, certificate_pkcs12_path: nil, username: '23020443000140', password: '33161107')
			subject.lote_rps = [rps_completo, rps_basico]
			validate_schema
		end
	end
end

