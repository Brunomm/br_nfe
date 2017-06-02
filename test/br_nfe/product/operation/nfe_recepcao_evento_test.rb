require 'test_helper'

describe BrNfe::Product::Operation::NfeRecepcaoEvento do
	subject { FactoryGirl.build(:product_operation_nfe_recepcao_evento) }
	let(:evento_cancelamento) { FactoryGirl.build(:product_evento_cancelamento) } 

	describe '#aliases' do
		it { must_have_alias_attribute :idLote,  :numero_lote }
	end

	describe 'have one cancelamento' do
		it { must_have_one :cancelamento, BrNfe.cancelamento_product_class, {protocolo_nfe: '12345', justificativa: 'Justi'} }
		it { must_validate_have_one :cancelamento, BrNfe.cancelamento_product_class, :invalid_cancelamento }
	end

	describe 'Validations' do
		it { must validate_presence_of(:numero_lote) }
		it { must validate_length_of(:numero_lote).is_at_most(15) }
		it { must validate_numericality_of(:numero_lote).only_integer }
		it { must allow_value('123456789012345').for(:numero_lote) }
	end

	describe '#xml_builder' do
		it "Deve renderizar o XML e setar o valor na variavel @xml_builder" do
			subject.expects(:render_xml).returns('<xml>OK</xml>')
			
			subject.xml_builder.must_equal '<xml>OK</xml>'
			subject.instance_variable_get(:@xml_builder).must_equal '<xml>OK</xml>'
		end
		it "Se já houver valor setado na variavel @xml_builder não deve renderizar o xml novamente" do
			subject.instance_variable_set(:@xml_builder, '<xml>OK</xml>')
			subject.expects(:render_xml).never
			subject.xml_builder.must_equal '<xml>OK</xml>'
		end
	end
	
	context "CANCELAMENTO - Validações para versão do XML 1.00 e NF-e 3.10" do
		before do
			subject.cancelamento = evento_cancelamento
			subject.assign_attributes(nfe_version: :v3_10, ibge_code_of_issuer_uf: '42', env: :test)
		end
		describe "Validação do XML através do XSD" do
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				subject.valid?.must_equal true, "#{subject.errors.full_messages}"
				nfe_must_be_valid_by_schema 'envEventoCancNFe_v1.00.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				subject.valid?.must_equal true, "#{subject.errors.full_messages}"
				nfe_must_be_valid_by_schema 'envEventoCancNFe_v1.00.xsd'
			end
		end
		describe 'REQUEST MUST BE SET RESPONSE CORRECTLY' do
			let(:xml_success) { read_fixture('product/response/v3.10/nfe_recepcao_evento/cancelamento/success.xml') } 
			let(:xml_fail)    { read_fixture('product/response/v3.10/nfe_recepcao_evento/cancelamento/fail.xml') } 
			let(:expect_xml_success_result) { read_fixture('product/response/v3.10/nfe_recepcao_evento/cancelamento/xml_result_success_formatted.xml') } 
			let(:expect_xml_fail_result) { read_fixture('product/response/v3.10/nfe_recepcao_evento/cancelamento/xml_result_fail_formatted.xml') } 
			before do 
				evento_cancelamento.data_hora = Time.parse('2017-06-02T11:25:58-03:00')
				evento_cancelamento.chave = 'ID1101113513040726711800012055000000000123193923347101'
				savon.mock!
				stub_request(:get, subject.client_wsdl.globals[:wsdl]).to_return(status: 200, body: read_fixture('product/wsdl/RecepcaoEvento.xml') )
			end
			after  { savon.unmock! }

			it "Quando o cancelamento for autorizado" do
				savon.expects(subject.method_wsdl).returns(xml_success)
				subject.request
				response = subject.response


				response.environment.must_equal :test
				response.app_version.must_equal 'SVRS201601161016'
				response.request_status.must_equal :success
				response.processing_status_code.must_equal '128'
				response.processing_status_motive.must_equal 'Lote de Evento Processado'
				response.processing_status.must_equal :success
				response.xml.must_equal expect_xml_success_result

				response.codigo_orgao.must_equal '42'

				response.events.size.must_equal 1
				event = response.events[0]

				event.codigo_orgao.must_equal           '42'
				event.status_code.must_equal            '135'
				event.status_motive.must_equal          'Evento registrado e vinculado a NF-e'
				event.code.must_equal                   '110111'
				event.sequence.must_equal               1
				event.cpf_cnpj_destino.must_equal       '00090742403050'
				event.registred_at.must_equal           Time.parse('2017-01-03T08:55:05-02:00')
				event.authorization_protocol.must_equal '342170000000906'
				event.description.must_be_nil
				event.justification.must_be_nil
				event.correction_text.must_be_nil
			end

			it "Quando o cancelamento não for autorizado" do
				savon.expects(subject.method_wsdl).returns(xml_fail)
				subject.request
				response = subject.response


				response.environment.must_equal :test
				response.app_version.must_equal 'SVRS201601161025'
				response.request_status.must_equal :success
				response.processing_status_code.must_equal '128'
				response.processing_status_motive.must_equal 'Lote de Evento Processado'
				response.processing_status.must_equal :success
				response.codigo_orgao.must_equal '42'
				response.xml.must_equal expect_xml_fail_result

				response.events.size.must_equal 1
				event = response.events[0]

				event.codigo_orgao.must_equal           '42'
				event.status_code.must_equal            '501'
				event.status_motive.must_equal          'Rejeicao: Prazo de Cancelamento Superior ao Previsto na Legislacao'
				event.code.must_equal                   '110111'
				event.sequence.must_equal               1
				event.cpf_cnpj_destino.must_equal       ''
				event.registred_at.must_equal           Time.parse('2017-01-02T18:27:27-02:00')
				event.authorization_protocol.must_equal ''
				event.description.must_be_nil
				event.justification.must_be_nil
				event.correction_text.must_be_nil
			end
		end
	end
end