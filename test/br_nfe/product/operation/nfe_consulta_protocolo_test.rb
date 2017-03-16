require 'test_helper'

describe BrNfe::Product::Operation::NfeConsultaProtocolo do
	subject { FactoryGirl.build(:product_operation_nfe_consulta_protocolo) }

	let(:gateway) { FactoryGirl.build(:product_gateway_web_service_svrs) }
	
	before do
		subject.stubs(:gateway).returns(gateway)
	end

	describe '#aliases' do
		it { must_have_alias_attribute :chNFe, :chave_nfe }
	end

	describe 'Validations' do
		it { must validate_presence_of(:chave_nfe) }
		it { must validate_length_of(:chave_nfe).is_equal_to(44) }
	end

	it 'o método #wsdl deve pegar o valor do método wsdl_consulta_protocolo do gateway ' do
		gateway.expects(:wsdl_consulta_protocolo).returns('http://teste.wsdl_consulta_protocolo.com')
		subject.wsdl.must_equal 'http://teste.wsdl_consulta_protocolo.com'
	end
	
	it 'o método #method_wsdl deve pegar o valor do método operation_consulta_protocolo do gateway ' do
		gateway.expects(:operation_consulta_protocolo).returns(:operation_consulta_protocolo)
		subject.method_wsdl.must_equal :operation_consulta_protocolo
	end
	
	it 'o método #gateway_xml_version deve pegar o valor do método version_xml_consulta_protocolo do gateway ' do
		gateway.expects(:version_xml_consulta_protocolo).returns(:v3_20)
		subject.gateway_xml_version.must_equal :v3_20
	end

	it 'o método #url_xmlns deve pegar o valor do método url_xmlns_consulta_protocolo do gateway ' do
		gateway.expects(:url_xmlns_consulta_protocolo).returns('http://teste.url_xmlns_consulta_protocolo.com')
		subject.url_xmlns.must_equal 'http://teste.url_xmlns_consulta_protocolo.com'
	end

	it 'o método #ssl_version deve pegar o valor do método ssl_version_consulta_protocolo do gateway ' do
		gateway.expects(:ssl_version_consulta_protocolo).returns(:SSLv1)
		subject.ssl_version.must_equal :SSLv1
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

	describe "Validação do XML através do XSD" do
		context "for XML Version 2.01" do
			before { subject.stubs(:gateway_xml_version).returns(:v2_01) }
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				nfe_must_be_valid_by_schema 'consSitNFe_v2.01.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				nfe_must_be_valid_by_schema 'consSitNFe_v2.01.xsd'
			end
		end
		context "for XML Version 3.10" do
			before { subject.stubs(:gateway_xml_version).returns(:v3_10) }
			
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				nfe_must_be_valid_by_schema 'consSitNFe_v3.10.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				nfe_must_be_valid_by_schema 'consSitNFe_v3.10.xsd'
			end
		end
	end

	describe 'REQUEST MUST BE SET RESPONSE CORRECTLY' do
		let(:response_fail)                 { read_fixture('product/response/v3.10/nfe_consulta_protocolo/fail.xml') }
		let(:response_success_without_event){ read_fixture('product/response/v3.10/nfe_consulta_protocolo/success_without.xml') }
		let(:response_success_one_event)    { read_fixture('product/response/v3.10/nfe_consulta_protocolo/success_one.xml') }
		let(:response_success_many_events_without_cancel)  { read_fixture('product/response/v3.10/nfe_consulta_protocolo/success_many_without_cancel.xml') }
		let(:response_success_many_events_with_cancel)  { read_fixture('product/response/v3.10/nfe_consulta_protocolo/success_many_with_cancel.xml') }
		let(:xml_nfe_without_proc) { read_fixture('product/response/v3.10/nfe_consulta_protocolo/nfe_original/without_proc.xml') }
		let(:xml_nfe_with_proc) { read_fixture('product/response/v3.10/nfe_consulta_protocolo/nfe_original/with_proc.xml') }

		before do
			savon.mock!
			stub_request(:get, subject.wsdl).to_return(status: 200, body: read_fixture('product/wsdl/NfeConsulta2.xml') )
		end
		after  { savon.unmock! }

		it "Quando a resposta reotrnar com algum erro não deve instanciar os eventos" do
			subject.original_xml = xml_nfe_with_proc
			savon.expects(subject.method_wsdl).returns( response_fail )
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Product::Response::NfeConsultaProtocolo
			
			response.environment.must_equal :test
			response.app_version.must_equal 'SVRS201610061504'
			response.processed_at.must_equal Time.parse('2017-01-04T15:45:02-02:00')
			response.protocol.must_be_nil
			response.request_status.must_equal :success
			response.processing_status_code.must_equal '226'
			response.processing_status_motive.must_equal 'Rejeicao: Codigo da UF do Emitente diverge da UF autorizadora'
			response.processing_status.must_equal :error
			response.nota_fiscal.must_be_nil
			response.main_event.must_be_nil
			response.events.must_be_empty
		end

		it "Quando retornar apenas o protocolo da NF-e e não tiver nenhum evento deve apenas setar o protocolo no XML da NF-e" do
			subject.original_xml = xml_nfe_without_proc
			savon.expects(subject.method_wsdl).returns( response_success_without_event )
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Product::Response::NfeConsultaProtocolo
			
			response.environment.must_equal :test
			response.app_version.must_equal 'SVRS201610061504'
			response.processed_at.must_equal Time.parse('2017-01-03T08:56:39-02:00')
			response.protocol.must_be_nil
			response.request_status.must_equal :success
			response.processing_status_code.must_equal '100'
			response.processing_status_motive.must_equal 'Autorizado o uso da NF-e'
			response.processing_status.must_equal :success
			response.main_event.must_be_nil
			response.events.must_be_empty

			nf = response.nota_fiscal
			nf.wont_be_nil
			nf.processed_at.must_equal Time.parse('2017-01-03T08:53:13-02:00')
			nf.protocol.must_equal '342170000000903'
			nf.digest_value.must_equal '2N5tbfnT9V4oRxiesTyBLP9tAVE='
			nf.status_code.must_equal '100'
			nf.status_motive.must_equal 'Autorizado o uso da NF-e'
			nf.chave_de_acesso.must_equal '42170108897094000155550010000000051201601010'
			nf.situation.must_equal :authorized
			nf.xml.must_equal xml_nfe_with_proc, "Deveria adicionar o protocolo da NF-e e a NF dentro da tag nfeProc"
		end

		it "Quando retornar apenas 1 evento deve seta-lo como o evento principal e também adicionar na lista de eventos" do
			subject.original_xml = xml_nfe_with_proc
			savon.expects(subject.method_wsdl).returns( response_success_one_event )
			subject.request
			response = subject.response

			response.environment.must_equal :test
			response.app_version.must_equal 'SVRS201610061504'
			response.processed_at.must_equal Time.parse('2017-01-03T08:56:39-02:00')
			response.protocol.must_be_nil
			response.request_status.must_equal :success
			response.processing_status_code.must_equal '135'
			response.processing_status_motive.must_equal 'Evento registrado e vinculado a NF-e'
			response.processing_status.must_equal :success
			response.main_event.wont_be_nil
			response.events.size.must_equal 1

			response.main_event.must_equal response.events[0]

			event = response.main_event
			event.codigo_orgao.must_equal '35'
			event.status_code.must_equal '135'
			event.status_motive.must_equal 'Evento registrado e vinculado a NF-e'
			event.code.must_equal '110110'
			event.sequence.must_equal 1
			event.cpf_cnpj_destino.must_equal '04962355000112'
			event.sent_at.must_equal Time.parse('2014-02-05T16:06:30-02:00')
			event.registred_at.must_equal Time.parse('2014-02-05T16:06:32-02:00')
			event.event_protocol.must_equal ''
			event.ret_event_protocol.must_equal '135140000457555'
			event.xml.must_equal read_fixture('product/response/v3.10/nfe_consulta_protocolo/event_xml/one_event.xml')

			nf = response.nota_fiscal
			nf.processed_at.must_equal Time.parse('2017-01-03T08:53:13-02:00')
			nf.protocol.must_equal '342170000000903'
			nf.digest_value.must_equal '2N5tbfnT9V4oRxiesTyBLP9tAVE='
			nf.status_code.must_equal '100'
			nf.status_motive.must_equal 'Autorizado o uso da NF-e'
			nf.chave_de_acesso.must_equal '42170108897094000155550010000000051201601010'
			nf.situation.must_equal :adjusted
			nf.xml.must_equal xml_nfe_with_proc, "Não deve duplicar os protocolos se já houver algum protocolo em nfeProc"
		end

		it "Quando tem mais de um evento e não tiver Cancelamneto deve setar todos os eventos na lista e setar o de maior sequencia no evento principal" do
			subject.original_xml = xml_nfe_with_proc
			savon.expects(subject.method_wsdl).returns( response_success_many_events_without_cancel )
			subject.request
			response = subject.response

			response.environment.must_equal :production
			response.app_version.must_equal 'SVRS201610061505'
			response.processed_at.must_equal Time.parse('2017-01-03T08:56:39-02:00')
			response.protocol.must_be_nil
			response.request_status.must_equal :success
			response.processing_status_code.must_equal '101'
			response.processing_status_motive.must_equal 'Cancelamento de NF-e homologado'
			response.processing_status.must_equal :success
			response.main_event.wont_be_nil
			response.events.size.must_equal 3

			events = response.events.sort_by{|e| [e.sequence.to_i, (e.registred_at||Time.current)] }
			response.main_event.must_equal events[2]

			events[0].codigo_orgao.must_equal '35'
			events[0].status_code.must_equal '135'
			events[0].status_motive.must_equal 'Evento registrado e vinculado a NF-e'
			events[0].code.must_equal '110110'
			events[0].sequence.must_equal 1
			events[0].cpf_cnpj_destino.must_equal '04962355000112'
			events[0].sent_at.must_equal Time.parse('2014-02-05T16:06:30-02:00')
			events[0].registred_at.must_equal Time.parse('2014-02-05T16:06:32-02:00')
			events[0].event_protocol.must_equal ''
			events[0].ret_event_protocol.must_equal '135140000457555'
			events[0].description.must_equal 'Carta de Correcao'
			events[0].justification.must_equal ''
			events[0].correction_text.must_equal 'teste de consulta de nfe corrigida primeira coorecao para consulta de nota'
			events[0].xml.must_equal read_fixture('product/response/v3.10/nfe_consulta_protocolo/event_xml/event_1.xml')

			events[1].codigo_orgao.must_equal '35'
			events[1].status_code.must_equal '135'
			events[1].status_motive.must_equal 'Evento registrado e vinculado a NF-e'
			events[1].code.must_equal '110110'
			events[1].sequence.must_equal 2
			events[1].cpf_cnpj_destino.must_equal '04962355000112'
			events[1].sent_at.must_equal Time.parse('2014-02-05T16:06:30-02:00')
			events[1].registred_at.must_equal Time.parse('2014-02-05T16:06:32-02:00')
			events[1].event_protocol.must_equal ''
			events[1].ret_event_protocol.must_equal '135140000457416'
			events[1].description.must_equal 'Carta de Correcao'
			events[1].justification.must_equal ''
			events[1].correction_text.must_equal 'teste de consulta de nfe corrigida segunda coorecao para consulta de nota'
			events[1].xml.must_equal read_fixture('product/response/v3.10/nfe_consulta_protocolo/event_xml/event_2.xml')

			events[2].codigo_orgao.must_equal '35'
			events[2].status_code.must_equal '135'
			events[2].status_motive.must_equal 'Evento registrado e vinculado a NF-e'
			events[2].code.must_equal '110110'
			events[2].sequence.must_equal 3
			events[2].cpf_cnpj_destino.must_equal '04962355000112'
			events[2].sent_at.must_equal Time.parse('2014-02-05T16:06:30-02:00')
			events[2].registred_at.must_equal Time.parse('2014-02-05T16:06:32-02:00')
			events[2].event_protocol.must_equal ''
			events[2].ret_event_protocol.must_equal '135140000457417'
			events[2].description.must_equal 'Carta de Correcao'
			events[2].justification.must_equal ''
			events[2].correction_text.must_equal 'teste de consulta de nfe corrigida terceiro coorecao para consulta de nota'
			events[2].xml.must_equal read_fixture('product/response/v3.10/nfe_consulta_protocolo/event_xml/event_3.xml')

			nf = response.nota_fiscal
			nf.processed_at.must_equal Time.parse('2017-01-03T08:53:13-02:00')
			nf.protocol.must_equal '342170000000903'
			nf.digest_value.must_equal '2N5tbfnT9V4oRxiesTyBLP9tAVE='
			nf.status_code.must_equal '100'
			nf.status_motive.must_equal 'Autorizado o uso da NF-e'
			nf.chave_de_acesso.must_equal '42170108897094000155550010000000051201601010'
			nf.situation.must_equal :adjusted
			nf.xml.must_equal xml_nfe_with_proc, "Não deve duplicar os protocolos se já houver algum protocolo em nfeProc"
		end

		it "Quando tem mais de um evento e tem um evento de Cancelamento, sempre deve ser o principal" do
			subject.original_xml = xml_nfe_with_proc
			savon.expects(subject.method_wsdl).returns( response_success_many_events_with_cancel )
			subject.request
			response = subject.response

			response.environment.must_equal :production
			response.app_version.must_equal 'SVRS201610061505'
			response.processed_at.must_equal Time.parse('2017-01-03T08:56:39-02:00')
			response.protocol.must_be_nil
			response.request_status.must_equal :success
			response.processing_status_code.must_equal '101'
			response.processing_status_motive.must_equal 'Cancelamento de NF-e homologado'
			response.processing_status.must_equal :success
			response.main_event.wont_be_nil
			response.events.size.must_equal 3

			events = response.events.sort_by{|e| [e.sequence.to_i, (e.registred_at||Time.current)] }
			response.main_event.must_equal events[1]

			events[0].codigo_orgao.must_equal '35'
			events[0].status_code.must_equal '135'
			events[0].status_motive.must_equal 'Evento registrado e vinculado a NF-e'
			events[0].code.must_equal '110110'
			events[0].sequence.must_equal 1
			events[0].cpf_cnpj_destino.must_equal '04962355000112'
			events[0].sent_at.must_equal Time.parse('2014-02-05T16:06:30-02:00')
			events[0].registred_at.must_equal Time.parse('2014-02-05T16:06:32-02:00')
			events[0].event_protocol.must_equal ''
			events[0].ret_event_protocol.must_equal '135140000457555'
			events[0].description.must_equal 'Carta de Correcao'
			events[0].justification.must_equal ''
			events[0].correction_text.must_equal 'teste de consulta de nfe corrigida primeira coorecao para consulta de nota'
			events[0].xml.must_equal read_fixture('product/response/v3.10/nfe_consulta_protocolo/event_xml/event_1.xml')

			events[2].codigo_orgao.must_equal '35'
			events[2].status_code.must_equal '135'
			events[2].status_motive.must_equal 'Evento registrado e vinculado a NF-e'
			events[2].code.must_equal '110110'
			events[2].sequence.must_equal 2
			events[2].cpf_cnpj_destino.must_equal '04962355000112'
			events[2].sent_at.must_equal Time.parse('2014-02-05T16:06:30-02:00')
			events[2].registred_at.must_equal Time.parse('2014-02-05T16:06:32-02:00')
			events[2].event_protocol.must_equal ''
			events[2].ret_event_protocol.must_equal '135140000457416'
			events[2].description.must_equal 'Carta de Correcao'
			events[2].justification.must_equal ''
			events[2].correction_text.must_equal 'teste de consulta de nfe corrigida segunda coorecao para consulta de nota'
			events[2].xml.must_equal read_fixture('product/response/v3.10/nfe_consulta_protocolo/event_xml/event_2.xml')

			events[1] = response.main_event
			events[1].codigo_orgao.must_equal '42'
			events[1].status_code.must_equal '135'
			events[1].status_motive.must_equal 'Evento registrado e vinculado a NF-e'
			events[1].code.must_equal '110111'
			events[1].sequence.must_equal 1
			events[1].cpf_cnpj_destino.must_equal '00090742403050'
			events[1].sent_at.must_equal Time.parse('2017-01-03T08:54:58-02:00')
			events[1].registred_at.must_equal Time.parse('2017-01-03T08:55:05-02:00')
			events[1].event_protocol.must_equal '342170000000903'
			events[1].ret_event_protocol.must_equal '342170000000906'
			events[1].description.must_equal 'Cancelamento'
			events[1].justification.must_equal 'Cancelamento para teste'
			events[1].correction_text.must_equal ''
			events[1].xml.must_equal read_fixture('product/response/v3.10/nfe_consulta_protocolo/event_xml/event_cancel.xml')

			nf = response.nota_fiscal
			nf.processed_at.must_equal Time.parse('2017-01-03T08:53:13-02:00')
			nf.protocol.must_equal '342170000000903'
			nf.digest_value.must_equal '2N5tbfnT9V4oRxiesTyBLP9tAVE='
			nf.status_code.must_equal '100'
			nf.status_motive.must_equal 'Autorizado o uso da NF-e'
			nf.chave_de_acesso.must_equal '42170108897094000155550010000000051201601010'
			nf.situation.must_equal :canceled
			nf.xml.must_equal xml_nfe_with_proc, "Não deve duplicar os protocolos se já houver algum protocolo em nfeProc"
		end
	end
end