require 'test_helper'

describe BrNfe::Product::Operation::NfeInutilizacao do
	subject { FactoryGirl.build(:product_operation_nfe_inutilizacao) }
	let(:gateway) { FactoryGirl.build(:product_gateway_web_service_svrs) }
	
	before do
		subject.stubs(:gateway).returns(gateway)
	end

	describe '#aliases' do
		it { must_have_alias_attribute :Id,     :chave }
		it { must_have_alias_attribute :mod,    :modelo_nf }
		it { must_have_alias_attribute :nNFIni, :numero_nf_inicial }
		it { must_have_alias_attribute :nNFFin, :numero_nf_final }
		it { must_have_alias_attribute :xJust,  :justificativa }
	end

	describe 'Validations' do
		describe '#chave' do
			before { subject.stubs(:generate_key) }
			it { must validate_presence_of(:chave) }
			it { must validate_length_of(:chave).is_equal_to(43) }
		end
		describe '#ano' do
			it { must validate_presence_of(:ano) }
			it { must validate_length_of(:ano).is_equal_to(2) }
		end
		describe '#modelo_nf' do
			it { must validate_presence_of(:modelo_nf) }
			it { must validate_inclusion_of(:modelo_nf).in_array([55,65,'55','65']) }
		end
		describe '#serie' do
			it { must validate_presence_of(:serie) }
			it { must validate_numericality_of(:serie).only_integer }
			it { must validate_length_of(:serie).is_at_most(3) }
		end
		describe '#numero_nf_inicial' do
			it { must validate_presence_of(:numero_nf_inicial) }
			it { must validate_numericality_of(:numero_nf_inicial).only_integer }
			it { must validate_length_of(:numero_nf_inicial).is_at_most(9) }
		end
		describe '#numero_nf_final' do
			before { subject.numero_nf_inicial = nil }
			it { must validate_presence_of(:numero_nf_final) }
			it { must validate_numericality_of(:numero_nf_final).only_integer }
			it { must validate_length_of(:numero_nf_final).is_at_most(9) }
		end
		describe '#justificativa' do
			it { must validate_length_of(:justificativa).is_at_least(15).is_at_most(255) }
		end
	end

	it 'o método #wsdl deve pegar o valor do método wsdl_inutilizacao do gateway ' do
		gateway.expects(:wsdl_inutilizacao).returns('http://teste.wsdl_inutilizacao.com')
		subject.wsdl.must_equal 'http://teste.wsdl_inutilizacao.com'
	end

	it 'o método #method_wsdl deve pegar o valor do método operation_inutilizacao do gateway ' do
		gateway.expects(:operation_inutilizacao).returns(:operation_inutilizacao)
		subject.method_wsdl.must_equal :operation_inutilizacao
	end

	it 'o método #gateway_xml_version deve pegar o valor do método version_xml_inutilizacao do gateway ' do
		gateway.expects(:version_xml_inutilizacao).returns(:v3_20)
		subject.gateway_xml_version.must_equal :v3_20
	end

	it 'o método #url_xmlns deve pegar o valor do método url_xmlns_inutilizacao do gateway ' do
		gateway.expects(:url_xmlns_inutilizacao).returns('http://teste.url_xmlns_inutilizacao.com')
		subject.url_xmlns.must_equal 'http://teste.url_xmlns_inutilizacao.com'
	end

	it 'o método #ssl_version deve pegar o valor do método ssl_version_inutilizacao do gateway ' do
		gateway.expects(:ssl_version_inutilizacao).returns(:SSLv1)
		subject.ssl_version.must_equal :SSLv1
	end

	describe '#numero_nf_final' do
		it "se não setar um valor deve pegar o valor do :numero_nf_inicial" do
			subject.assign_attributes(numero_nf_inicial: 30, numero_nf_final: nil)
			subject.numero_nf_final.must_equal 30
		end
		it "se setar um valor manualmente não deve pegar o valor do :numero_nf_inicial" do
			subject.assign_attributes(numero_nf_inicial: 30, numero_nf_final: 40)
			subject.numero_nf_final.must_equal 40
		end
	end

	describe '#chave' do
		it "se não setar um chave manualmente deve gerar a chave da NF-e" do
			subject.assign_attributes(
				ano:  17,
				modelo_nf:  65,
				serie:  2,
				numero_nf_inicial:  7,
				numero_nf_final:  15,
				ibge_code_of_issuer_uf: 43,
				chave: '',
				emitente: {
					cnpj: '1234567890123'
				}

			)
			subject.chave.must_equal 'ID43170123456789012365002000000007000000015'
		end
		it "se já tiver uma chave setada não deve gerar novamente" do
			subject.chave = 'ID431701'
			subject.chave.must_equal 'ID431701'
		end
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
				nfe_must_be_valid_by_schema 'inutNFe_v2.00.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				nfe_must_be_valid_by_schema 'inutNFe_v2.00.xsd'
			end
		end
		describe 'for XML version 3.10' do
			before { subject.stubs(:gateway_xml_version).returns(:v3_10) }
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				nfe_must_be_valid_by_schema 'inutNFe_v3.10.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				nfe_must_be_valid_by_schema 'inutNFe_v3.10.xsd'
			end
		end
	end

	describe 'REQUEST MUST BE SET RESPONSE CORRECTLY' do
		let(:xml_success) { read_fixture('product/response/v3.10/nfe_inutilizacao/success.xml') } 
		let(:xml_fail)    { read_fixture('product/response/v3.10/nfe_inutilizacao/fail.xml') } 
		before do 
			savon.mock!
			stub_request(:get, subject.wsdl).to_return(status: 200, body: read_fixture('product/wsdl/nfeinutilizacao2.xml') )
		end
		after  { savon.unmock! }

		it "Quando a inutilização foi homologada" do
			savon.expects(subject.method_wsdl).returns(xml_success)
			subject.request
			response = subject.response

			response.environment.must_equal :test
			response.app_version.must_equal 'SVRS201601161002'
			response.processed_at.must_equal Time.parse('2017-01-17T14:30:49-02:00')
			response.protocol.must_equal '342170000033755'
			response.request_status.must_equal :success
			response.processing_status_code.must_equal '102'
			response.processing_status_motive.must_equal 'Inutilizacao de numero homologado'
			response.processing_status.must_equal :success

			response.uf.must_equal '42'
			
			response.year.must_equal '17'
			response.cnpj.must_equal '26231073000188'
			response.nf_model.must_equal '55'
			response.nf_series.must_equal '1'
			response.start_invoice_number.must_equal '6'
			response.end_invoice_number.must_equal '8'
		end

		it "Quando a inutilização não for homologada" do
			savon.expects(subject.method_wsdl).returns(xml_fail)
			subject.request
			response = subject.response

			response.environment.must_equal :test
			response.app_version.must_equal 'SVRS201601161002'
			response.processed_at.must_equal Time.parse('2017-01-17T14:30:49-02:00')
			response.protocol.must_equal ''
			response.request_status.must_equal :success
			response.processing_status_code.must_equal '256'
			response.processing_status_motive.must_equal 'Rejeicao: Uma NF-e da faixa ja esta inutilizada na Base de dados da SEFAZ'
			response.processing_status.must_equal :error

			response.uf.must_equal '42'

			response.year.must_equal '17'
			response.cnpj.must_equal '26231073000188'
			response.nf_model.must_equal '55'
			response.nf_series.must_equal '1'
			response.start_invoice_number.must_equal '6'
			response.end_invoice_number.must_equal '8'
		end
	end

end