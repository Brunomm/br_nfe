require 'test_helper'

describe BrNfe::Product::Operation::NfeRetAutorizacao do
	subject { FactoryGirl.build(:product_operation_nfe_ret_autorizacao) }
	let(:nota_fiscal) { FactoryGirl.build(:product_nota_fiscal) } 

	describe '#aliases' do
		it { must_have_alias_attribute :nRec,  :numero_recibo }
	end

	describe 'Validations' do
		it { must validate_presence_of(:numero_recibo) }
		it { must validate_length_of(:numero_recibo).is_at_most(15) }
		it { must validate_numericality_of(:numero_recibo).only_integer }
		it { must allow_value('123456789012345').for(:numero_recibo) }
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
		describe 'for XML version 2.00' do
			before { subject.stubs(:gateway_xml_version).returns(:v2_00) }
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				nfe_must_be_valid_by_schema 'consReciNFe_v2.00.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				nfe_must_be_valid_by_schema 'consReciNFe_v2.00.xsd'
			end
		end
	end
	context "Validações para NF-e versão 3.10" do
		before do
			subject.assign_attributes(nfe_version: :v3_10, ibge_code_of_issuer_uf: '42', env: :test)
		end
		describe "Validação do XML através do XSD" do
			before { subject.stubs(:gateway_xml_version).returns(:v3_10) }
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				nfe_must_be_valid_by_schema 'consReciNFe_v3.10.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				nfe_must_be_valid_by_schema 'consReciNFe_v3.10.xsd'
			end
		end
		describe 'REQUEST MUST BE SET RESPONSE CORRECTLY' do
			let(:original_xml_lot)     { read_fixture('product/response/v3.10/nfe_ret_autorizacao/original_xml/lot.xml') } 
			let(:original_xml_nfe)     { read_fixture('product/response/v3.10/nfe_ret_autorizacao/original_xml/nfe.xml') } 
			let(:original_xml_nfeProc) { read_fixture('product/response/v3.10/nfe_ret_autorizacao/original_xml/nfeProc.xml') } 
			before do 
				savon.mock!
				stub_request(:get, subject.client_wsdl.globals[:wsdl]).to_return(status: 200, body: read_fixture('product/wsdl/NFeRetAutorizacao.xml') )
			end
			after  { savon.unmock! }

			it "Quando o lote processou com erro deve setar o motivo e os demais valores" do
				subject.original_xml = original_xml_lot
				response_xml = read_fixture('product/response/v3.10/nfe_ret_autorizacao/lot_fail.xml')
				savon.expects(subject.method_wsdl).returns(response_xml)
				subject.request
				response = subject.response

				response.must_be_kind_of BrNfe::Product::Response::NfeRetAutorizacao
				
				response.environment.must_equal :test
				response.app_version.must_equal 'SVRS201611281548'
				response.processed_at.must_equal Time.parse('2016-12-20T16:11:28-02:00')
				response.protocol.must_equal '423002169484138'
				response.request_status.must_equal :success
				response.processing_status_code.must_equal '106'
				response.processing_status_motive.must_equal 'Lote não localizado'
				response.processing_status.must_equal :error
				response.notas_fiscais.must_be_empty
			end

			it "Deve instanciar a nota e setar os valores quando o lote processou porém a nota não foi autorizada" do
				subject.original_xml = original_xml_nfeProc
				response_xml = read_fixture('product/response/v3.10/nfe_ret_autorizacao/lot_ok_one_invoice_fail.xml')
				savon.expects(subject.method_wsdl).returns(response_xml)
				subject.request
				response = subject.response

				response.environment.must_equal :test
				response.app_version.must_equal 'SVRS201611281548'
				response.processed_at.must_equal Time.parse('2016-12-20T14:29:28-02:00')
				response.protocol.must_equal '423002169476281'
				response.request_status.must_equal :success
				response.processing_status_code.must_equal '104'
				response.processing_status_motive.must_equal 'Lote processado'
				response.processing_status.must_equal :success

				response.notas_fiscais.size.must_equal 1
				nf = response.notas_fiscais[0]

				# Não deve adicionar o protocolo no XML se deu erro
				nf.xml.must_equal read_fixture('product/response/v3.10/nfe_ret_autorizacao/nfe/nf_2_without_protocol.xml')

				nf.protocol.must_equal ''
				nf.digest_value.must_equal 'hBKuDGD3gRtlFDO5bT9VH/UWKBQ='
				nf.processed_at.must_equal Time.parse('2016-12-20T14:29:28-02:00')
				nf.status_code.must_equal '209'
				nf.status_motive.must_equal 'Rejeicao: IE do emitente invalida'
				nf.status.must_equal :error
			end

			it "Quando tiver mais de uma nota e 1 nota autorizou e a outra não eve setar os valores referentes a cada nota" do
				subject.original_xml = original_xml_lot
				response_xml = read_fixture('product/response/v3.10/nfe_ret_autorizacao/lot_ok_one_invoice_fail_and_one_ok.xml')
				savon.expects(subject.method_wsdl).returns(response_xml)
				subject.request
				response = subject.response

				response.environment.must_equal :test
				response.app_version.must_equal 'SVRS201611281548'
				response.processed_at.must_equal Time.parse('2016-12-23T15:02:01-02:00')
				response.protocol.must_equal '423002169623858'
				response.request_status.must_equal :success
				response.processing_status_code.must_equal '104'
				response.processing_status_motive.must_equal 'Lote processado'
				response.processing_status.must_equal :success

				response.notas_fiscais.size.must_equal 2
				
				nf1 = response.notas_fiscais[0]
				nf1.xml.must_equal read_fixture('product/response/v3.10/nfe_ret_autorizacao/nfe/nf_2_without_protocol.xml')
				nf1.protocol.must_equal ''
				nf1.digest_value.must_equal ''
				nf1.processed_at.must_equal Time.parse('2016-12-23T15:02:01-02:00')
				nf1.status_code.must_equal '209'
				nf1.status_motive.must_equal 'Rejeicao: IE do emitente invalida'
				nf1.status.must_equal :error

				nf2 = response.notas_fiscais[1]
				nf2.xml.must_equal read_fixture('product/response/v3.10/nfe_ret_autorizacao/nfe/nf_3_with_protocol.xml')
				nf2.protocol.must_equal '342160000820227'
				nf2.digest_value.must_equal 'eoBzPod21zF9/46jjOS2kLRyTPM='
				nf2.processed_at.must_equal Time.parse('2016-12-23T15:02:01-02:00')
				nf2.status_code.must_equal '100'
				nf2.status_motive.must_equal 'Autorizado o uso da NF-e'
				nf2.status.must_equal :success
			end
			it "Quando tiver apenas uma nota e estiver autorizada" do
				subject.original_xml = original_xml_nfe
				response_xml = read_fixture('product/response/v3.10/nfe_ret_autorizacao/lot_ok_one_invoice_ok.xml')
				savon.expects(subject.method_wsdl).returns(response_xml)
				subject.request
				response = subject.response

				response.environment.must_equal :test
				response.app_version.must_equal 'SVRS201611281548'
				response.processed_at.must_equal Time.parse('2016-12-20T16:11:28-02:00')
				response.protocol.must_equal '423002169484138'
				response.request_status.must_equal :success
				response.processing_status_code.must_equal '104'
				response.processing_status_motive.must_equal 'Lote processado'
				response.processing_status.must_equal :success

				response.notas_fiscais.size.must_equal 1
				
				nf1 = response.notas_fiscais[0]
				nf1.chave_de_acesso.must_equal '42161208897094000155550010000000021201601013'
				nf1.xml.must_equal read_fixture('product/response/v3.10/nfe_ret_autorizacao/nfe/nf_2_with_protocol.xml')
				nf1.protocol.must_equal '342160000785247'
				nf1.digest_value.must_equal 'AcoglfmS7KCjv/XaaYO0T9ohlqM='
				nf1.processed_at.must_equal Time.parse('2016-12-20T16:11:28-02:00')
				nf1.status_code.must_equal '100'
				nf1.status_motive.must_equal 'Autorizado o uso da NF-e'
				nf1.status.must_equal :success
			end

			it "Quando tiver duas notas rejeitadas" do
				subject.original_xml = original_xml_lot
				response_xml = read_fixture('product/response/v3.10/nfe_ret_autorizacao/lot_ok_two_invoice_fail.xml')
				savon.expects(subject.method_wsdl).returns(response_xml)
				subject.request
				response = subject.response

				response.environment.must_equal :test
				response.app_version.must_equal 'SVRS201611281548'
				response.processed_at.must_equal Time.parse('2016-12-23T15:02:01-02:00')
				response.protocol.must_equal '423002169623858'
				response.request_status.must_equal :success
				response.processing_status_code.must_equal '104'
				response.processing_status_motive.must_equal 'Lote processado'
				response.processing_status.must_equal :success

				response.notas_fiscais.size.must_equal 2
				
				nf1 = response.notas_fiscais[0]
				nf1.chave_de_acesso.must_equal '42161208897094000155550010000000021201601013'
				nf1.xml.must_equal read_fixture('product/response/v3.10/nfe_ret_autorizacao/nfe/nf_2_without_protocol.xml')
				nf1.protocol.must_equal ''
				nf1.digest_value.must_equal ''
				nf1.processed_at.must_equal Time.parse('2016-12-23T15:02:01-02:00')
				nf1.status_code.must_equal '209'
				nf1.status_motive.must_equal 'Rejeicao: IE do emitente invalida'
				nf1.status.must_equal :error

				nf2 = response.notas_fiscais[1]
				nf2.chave_de_acesso.must_equal '42161208897094000155550010000000031201601010'
				nf2.xml.must_equal read_fixture('product/response/v3.10/nfe_ret_autorizacao/nfe/nf_3_without_protocol.xml')
				nf2.protocol.must_equal ''
				nf2.digest_value.must_equal ''
				nf2.processed_at.must_equal Time.parse('2016-12-23T15:02:02-02:00')
				nf2.status_code.must_equal '216'
				nf2.status_motive.must_equal 'Rejeição: Chave de Acesso difere da cadastrada'
				nf2.status.must_equal :error
			end

			it "Quando tiver duas notas autorizadas" do
				subject.original_xml = original_xml_lot
				response_xml = read_fixture('product/response/v3.10/nfe_ret_autorizacao/lot_ok_two_invoice_ok.xml')
				savon.expects(subject.method_wsdl).returns(response_xml)
				subject.request
				response = subject.response

				response.environment.must_equal :test
				response.app_version.must_equal 'SVRS201611281548'
				response.processed_at.must_equal Time.parse('2016-12-23T15:02:01-02:00')
				response.protocol.must_equal '423002169623858'
				response.request_status.must_equal :success
				response.processing_status_code.must_equal '104'
				response.processing_status_motive.must_equal 'Lote processado'
				response.processing_status.must_equal :success

				response.notas_fiscais.size.must_equal 2
				
				nf1 = response.notas_fiscais[0]
				nf1.chave_de_acesso.must_equal '42161208897094000155550010000000021201601013'
				nf1.xml.must_equal read_fixture('product/response/v3.10/nfe_ret_autorizacao/nfe/nf_2_with_protocol.xml')
				nf1.protocol.must_equal '342160000785247'
				nf1.digest_value.must_equal 'AcoglfmS7KCjv/XaaYO0T9ohlqM='
				nf1.processed_at.must_equal Time.parse('2016-12-20T16:11:28-02:00')
				nf1.status_code.must_equal '100'
				nf1.status_motive.must_equal 'Autorizado o uso da NF-e'
				nf1.status.must_equal :success

				nf2 = response.notas_fiscais[1]
				nf2.xml.must_equal read_fixture('product/response/v3.10/nfe_ret_autorizacao/nfe/nf_3_with_protocol.xml')
				nf2.protocol.must_equal '342160000820227'
				nf2.digest_value.must_equal 'eoBzPod21zF9/46jjOS2kLRyTPM='
				nf2.processed_at.must_equal Time.parse('2016-12-23T15:02:01-02:00')
				nf2.status_code.must_equal '100'
				nf2.status_motive.must_equal 'Autorizado o uso da NF-e'
				nf2.status.must_equal :success
			end

			it "Se não Encontrar o XML da nota passada por parametro no original_xml não deve add um xml na nota" do
				#  Aqui é setado o 'XML' de uma nota que não está presente no protocolode autorização
				subject.original_xml =  '<?xml version="1.0" encoding="utf-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe"'
				subject.original_xml += ' versao="3.10"><NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe  Id="NFe421612088970940001555500100000000201234567890" versao="3.10"></NFe></nfeProc>'
				
				response_xml = read_fixture('product/response/v3.10/nfe_ret_autorizacao/lot_ok_one_invoice_ok.xml')
				savon.expects(subject.method_wsdl).returns(response_xml)
				subject.request
				response = subject.response

				response.environment.must_equal :test
				response.app_version.must_equal 'SVRS201611281548'
				response.processed_at.must_equal Time.parse('2016-12-20T16:11:28-02:00')
				response.protocol.must_equal '423002169484138'
				response.request_status.must_equal :success
				response.processing_status_code.must_equal '104'
				response.processing_status_motive.must_equal 'Lote processado'
				response.processing_status.must_equal :success

				response.notas_fiscais.size.must_equal 1
				response.notas_fiscais[0].xml.must_be_nil
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homnfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.ba.gov.br/webservices/NfeRetAutorizacao/NfeRetAutorizacao.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://hnfe.sefaz.ba.gov.br/webservices/NfeRetAutorizacao/NfeRetAutorizacao.asmx?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetAutorizacao?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRetAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal true
					client_wsdl.globals[:headers].must_equal( {:'Content-Type' => 'application/soap+xml; charset=utf-8'} )
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRetAutorizacao?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.ms.gov.br/producao/services2/NfeRetAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRetAutorizacao?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRetAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeRetAutorizacao?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.pr.gov.br/nfe/NFeRetAutorizacao3?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeRetAutorizacao3?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRetAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRetAutorizacao?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx?wsdl'
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
		client_wsdl.globals[:wsdl].must_equal 'https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.env = :test
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end
	def must_use_SVAN
		subject.env = :production
		client_wsdl.globals[:wsdl].must_equal 'https://www.sefazvirtual.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.env = :test
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://hom.sefazvirtual.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end

	def must_use_SVCAN_for_SVC_mode
		subject.assign_attributes(env: :production, tipo_emissao: :svc)
		client_wsdl.globals[:wsdl].must_equal 'https://www.svc.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.assign_attributes(env: :test, tipo_emissao: :svc)
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://hom.svc.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end

	def must_use_SVCRS_for_SVC_mode
		subject.assign_attributes(env: :production, tipo_emissao: :svc)
		client_wsdl.globals[:wsdl].must_equal 'https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.assign_attributes(env: :test, tipo_emissao: :svc)
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end
end