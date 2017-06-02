require 'test_helper'

describe BrNfe::Product::Operation::NfeConsultaProtocolo do
	subject { FactoryGirl.build(:product_operation_nfe_consulta_protocolo) }

	describe '#aliases' do
		it { must_have_alias_attribute :chNFe, :chave_nfe }
	end

	describe 'Validations' do
		it { must validate_presence_of(:chave_nfe) }
		it { must validate_length_of(:chave_nfe).is_equal_to(44) }
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

	context "Validações para NF-e versão 2.01" do
		before do
			subject.assign_attributes(nfe_version: :v2_01, ibge_code_of_issuer_uf: '42', env: :test)
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
		end
	end
	context "Validações para NF-e versão 3.10" do
		before do
			subject.assign_attributes(nfe_version: :v3_10, ibge_code_of_issuer_uf: '42', env: :test)
		end
		describe "Validação do XML através do XSD" do
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
				stub_request(:get, subject.client_wsdl.globals[:wsdl]).to_return(status: 200, body: read_fixture('product/wsdl/NfeConsulta2.xml') )
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
				event.authorization_protocol.must_equal '135140000457555'
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
				events[0].authorization_protocol.must_equal '135140000457555'
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
				events[1].authorization_protocol.must_equal '135140000457416'
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
				events[2].authorization_protocol.must_equal '135140000457417'
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
				events[0].authorization_protocol.must_equal '135140000457555'
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
				events[2].authorization_protocol.must_equal '135140000457416'
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
				events[1].authorization_protocol.must_equal '342170000000906'
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
		describe 'Configurações por UF dos parametros para instanciar o client Soap' do
			let(:client_wsdl) { subject.client_wsdl } 
			describe 'UF 12 - Acre' do
				before { subject.ibge_code_of_issuer_uf = '12' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 27 - Alagoas' do
				before { subject.ibge_code_of_issuer_uf = '27' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 16 - Amapá' do
				before { subject.ibge_code_of_issuer_uf = '16' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 13 - Amazonas' do
				before { subject.ibge_code_of_issuer_uf = '13' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.am.gov.br/services2/services/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homnfe.sefaz.am.gov.br/services2/services/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 29 - Bahia' do
				before { subject.ibge_code_of_issuer_uf = '29' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.ba.gov.br/webservices/NfeConsulta/NfeConsulta.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://hnfe.sefaz.ba.gov.br/webservices/NfeConsulta/NfeConsulta.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 23 - Ceará' do
				before { subject.ibge_code_of_issuer_uf = '23' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 53 - Distrito Federal' do
				before { subject.ibge_code_of_issuer_uf = '53' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 32 - Espírito Santo' do
				before { subject.ibge_code_of_issuer_uf = '32' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 52 - Goiás' do
				before { subject.ibge_code_of_issuer_uf = '52' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal true
					client_wsdl.globals[:headers].must_equal( {:'Content-Type' => 'application/soap+xml; charset=utf-8'} )
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal true
					client_wsdl.globals[:headers].must_equal( {:'Content-Type' => 'application/soap+xml; charset=utf-8'} )
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 21 - Maranhão' do
				before { subject.ibge_code_of_issuer_uf = '21' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVAN
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 51 - Mato Grosso' do
				before { subject.ibge_code_of_issuer_uf = '51' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 50 - Mato Grosso do Sul' do
				before { subject.ibge_code_of_issuer_uf = '50' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.ms.gov.br/producao/services2/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 31 - Minas Gerais' do
				before { subject.ibge_code_of_issuer_uf = '31' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 15 - Pará' do
				before { subject.ibge_code_of_issuer_uf = '15' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVAN
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 25 - Paraíba' do
				before { subject.ibge_code_of_issuer_uf = '25' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 41 - Paraná' do
				before { subject.ibge_code_of_issuer_uf = '41' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.pr.gov.br/nfe/NFeConsulta3?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeConsulta3?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 26 - Pernambuco' do
				before { subject.ibge_code_of_issuer_uf = '26' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 22 - Piauí' do
				before { subject.ibge_code_of_issuer_uf = '22' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 33 - Rio de Janeiro' do
				before { subject.ibge_code_of_issuer_uf = '33' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 24 - Rio Grande do Norte' do
				before { subject.ibge_code_of_issuer_uf = '24' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 43 - Rio Grande do Sul' do
				before { subject.ibge_code_of_issuer_uf = '43' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 11 - Rondônia' do
				before { subject.ibge_code_of_issuer_uf = '11' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 14 - Roraima' do
				before { subject.ibge_code_of_issuer_uf = '14' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 42 - Santa Catarina' do
				before { subject.ibge_code_of_issuer_uf = '42' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 35 - São Paulo' do
				before { subject.ibge_code_of_issuer_uf = '35' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 28 - Sergipe' do
				before { subject.ibge_code_of_issuer_uf = '28' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 17 - Tocantins' do
				before { subject.ibge_code_of_issuer_uf = '17' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
		end
	end
private
	def must_use_SVRS
		subject.env = :production
		client_wsdl.globals[:wsdl].must_equal 'https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.env = :test
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end
	def must_use_SVAN
		subject.env = :production
		client_wsdl.globals[:wsdl].must_equal 'https://www.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.env = :test
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://hom.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end

	def must_use_SVCAN_for_SVC_mode
		subject.assign_attributes(env: :production, tipo_emissao: :svc)
		client_wsdl.globals[:wsdl].must_equal 'https://www.svc.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.assign_attributes(env: :test, tipo_emissao: :svc)
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://hom.svc.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end

	def must_use_SVCRS_for_SVC_mode
		subject.assign_attributes(env: :production, tipo_emissao: :svc)
		client_wsdl.globals[:wsdl].must_equal 'https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.assign_attributes(env: :test, tipo_emissao: :svc)
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end
end