require 'test_helper'

describe BrNfe::Product::Base do
	subject { FactoryGirl.build(:product_base) }
	let(:nota_fiscal) { FactoryGirl.build(:product_nota_fiscal) } 
	
	describe "Validations" do
		it do
			subject.certificate_pkcs12_path = nil
			must validate_presence_of(:certificate) 
		end
		it { must validate_inclusion_of(:tipo_emissao).in_array([:normal, :svc]) }

		describe '#inicio_contingencia' do
			context "Quando estiver em contingência" do
				before { subject.stubs(:contingencia?).returns(true) }
				it { must validate_presence_of(:inicio_contingencia) }
				it { must validate_length_of(:motivo_contingencia).is_at_least(15).is_at_most(256) }
			end
			context "Quando não estiver em contingência" do
				before { subject.stubs(:contingencia?).returns(false) }
				it { wont validate_presence_of(:inicio_contingencia) }
				it { wont validate_length_of(:motivo_contingencia).is_at_least(15).is_at_most(256) }
			end
		end
	end

	describe '#default_values' do
		it "tipo_emissao deve ser normal" do
			subject.class.new.tipo_emissao.must_equal :normal
		end
	end

	it '#ssl_request? deve ser true' do
		subject.ssl_request?.must_equal true
	end

	describe '#xml_current_dir_path' do
		let(:path_v1_00) { "#{BrNfe.root}/lib/br_nfe/product/xml/v1_00" } 
		let(:path_v1_10) { "#{BrNfe.root}/lib/br_nfe/product/xml/v1_10" } 
		let(:path_v2_00) { "#{BrNfe.root}/lib/br_nfe/product/xml/v2_00" } 
		let(:path_v3_10) { "#{BrNfe.root}/lib/br_nfe/product/xml/v3_10" } 
		let(:product_default_path) { "#{BrNfe.root}/lib/br_nfe/product/xml" } 

		it "se a versão da operação for 1.0 deve pegar apenas o path da versão 1" do
			subject.stubs(:gateway_xml_version).returns(:v1_00)
			subject.xml_current_dir_path[0].must_equal path_v1_00
			subject.xml_current_dir_path[1].must_equal product_default_path

			subject.xml_current_dir_path.wont_include path_v1_10
			subject.xml_current_dir_path.wont_include path_v2_00
			subject.xml_current_dir_path.wont_include path_v3_10
		end

		it "se a versão da operação for 1.10 deve pegar apenas o path da versão 1 e 1.1" do
			subject.stubs(:gateway_xml_version).returns(:v1_10)
			subject.xml_current_dir_path[0].must_equal path_v1_10
			subject.xml_current_dir_path[1].must_equal path_v1_00
			subject.xml_current_dir_path[2].must_equal product_default_path

			subject.xml_current_dir_path.wont_include path_v2_00
			subject.xml_current_dir_path.wont_include path_v3_10
		end

		it "se a versão da operação for 2.00 deve pegar apenas o path da versão 2.0, 1.1 e 1" do
			subject.stubs(:gateway_xml_version).returns(:v2_00)
			subject.xml_current_dir_path[0].must_equal path_v2_00
			subject.xml_current_dir_path[1].must_equal path_v1_10
			subject.xml_current_dir_path[2].must_equal path_v1_00
			subject.xml_current_dir_path[3].must_equal product_default_path

			subject.xml_current_dir_path.wont_include path_v3_10
		end

		it "se a versão da operação for 3.10 deve pegar apenas os paths da versões 3.1, 2.0, 1.1 e 1" do
			subject.stubs(:gateway_xml_version).returns(:v3_10)
			subject.xml_current_dir_path[0].must_equal path_v3_10
			subject.xml_current_dir_path[1].must_equal path_v2_00
			subject.xml_current_dir_path[2].must_equal path_v1_10
			subject.xml_current_dir_path[3].must_equal path_v1_00
			subject.xml_current_dir_path[4].must_equal product_default_path
		end
	end

	describe '#gateway' do
		let(:env) { SecureRandom.hex(5) }
		describe 'UF: 12 - Acre/AC' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '12', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '12', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 27 - Alagoas/AL' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '27', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '27', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 16 - Amapá/AP' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '16', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '16', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 13 - Amazonas/AM' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '13', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceAM
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '13', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcRS
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 29 - Bahia/BA' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '29', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceBA
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '29', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcRS
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 23 - Ceará/CE' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '23', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceCE
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '23', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcRS
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 53 - Distrito Federal/DF' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '53', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '53', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 32 - Espírito Santo/ES' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '32', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '32', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 52 - Goiás/GO' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '52', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceGO
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '52', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcRS
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 21 - Maranhão/MA' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '21', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVAN
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '21', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcRS
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 51 - Mato Grosso/MT' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '51', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceMT
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '51', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcRS
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 50 - Mato Grosso do Sul/MS' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '50', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceMS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '50', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcRS
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 31 - Minas Gerais/MG' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '31', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceMG
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '31', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 15 - Pará/PA' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '15', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVAN
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '15', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcRS
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 25 - Paraíba/PB' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '25', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '25', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 41 - Paraná/PR' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '41', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServicePR
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '41', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcRS
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 26 - Pernambuco/PE' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '26', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServicePE
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '26', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcRS
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 22 - Piauí/PI' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '22', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVAN
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '22', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcRS
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 33 - Rio de Janeiro/RJ' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '33', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '33', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 24 - Rio Grande do Norte/RN' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '24', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '24', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 43 - Rio Grande do Sul/RS' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '43', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '43', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 11 - Rondônia/RO' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '11', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '11', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 14 - Roraima/RR' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '14', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '14', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 42 - Santa Catarina/SC' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '42', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '42', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 35 - São Paulo/SP' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '35', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSP
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '35', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 28 - Sergipe/SE' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '28', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '28', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end

		describe 'UF: 17 - Tocantins/TO' do
			it "Para tipo de emissão :normal" do
				subject.assign_attributes ibge_code_of_issuer_uf: '17', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end
			it "Para tipo de emissão :svc" do
				subject.assign_attributes ibge_code_of_issuer_uf: '17', env: env, tipo_emissao: :svc
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSvcAN
				subject.gateway.env.must_equal env
			end
		end
	end

	describe 'Métodos que devem ser sobrescritos' do
		it '#url_xmlns' do
			assert_raises RuntimeError do
				subject.url_xmlns
			end
		end
		it '#gateway_xml_version' do
			assert_raises RuntimeError do
				subject.gateway_xml_version
			end
		end
	end

	describe '#xml_version - deve converter a versão em valor usável no XML' do
		it "Para versão :v3_10" do
			subject.stubs(:gateway_xml_version).returns(:v3_10)
			subject.xml_version.must_equal '3.10'
		end
		it "Para versão :v2_00" do
			subject.stubs(:gateway_xml_version).returns(:v2_00)
			subject.xml_version.must_equal '2.00'
		end
	end

	describe "#emitente" do
		class OtherClassEmitente < BrNfe::ActiveModelBase
		end
		it "deve ter incluso o module HaveEmitente" do
			subject.class.included_modules.must_include BrNfe::Association::HaveEmitente
		end
		it "o método #emitente_class deve ter por padrão a class BrNfe::Product::Emitente" do
			subject.emitente.must_be_kind_of BrNfe::Product::Emitente
			subject.send(:emitente_class).must_equal BrNfe::Product::Emitente
		end
		it "a class do emitente pode ser modificada através da configuração emitente_product_class" do
			BrNfe.emitente_product_class = OtherClassEmitente
			subject.emitente.must_be_kind_of OtherClassEmitente
			subject.send(:emitente_class).must_equal OtherClassEmitente

			# É necessário voltar a configuração original para não falhar outros testes
			BrNfe.emitente_product_class = BrNfe::Product::Emitente
		end
	end

	describe '#contingencia?' do
		it "se o tipo_emissao for normal deve retornar false" do
			subject.tipo_emissao = :normal
			subject.contingencia?.must_equal false
		end
		it "se o tipo_emissao for svc deve retornar true" do
			subject.tipo_emissao = :svc
			subject.contingencia?.must_equal true
		end
	end

	describe '#codigo_tipo_emissao' do
		it "se a nfe for uma NFC-e deve retornar 9" do
			nota_fiscal.modelo_nf = 65
			subject.tipo_emissao = :normal
			subject.codigo_tipo_emissao(nota_fiscal).must_equal 9
			subject.tipo_emissao = :svc
			subject.codigo_tipo_emissao(nota_fiscal).must_equal 9
		end
		it "se a emissão da nfe for normal deve retornar o código 1" do
			subject.tipo_emissao = :normal
			subject.codigo_tipo_emissao(nota_fiscal).must_equal 1
		end
		it "se a emissão da nfe for :svc e o estado usa o SVC-RS deve retornar 7" do
			subject.tipo_emissao = :svc
			subject.ibge_code_of_issuer_uf = 13
			subject.codigo_tipo_emissao(nota_fiscal).must_equal 7
		end
		it "se a emissão da nfe for :svc e o estado usa o SVC-AN deve retornar 6" do
			subject.tipo_emissao = :svc
			subject.ibge_code_of_issuer_uf = 42
			subject.codigo_tipo_emissao(nota_fiscal).must_equal 6
		end
	end

	describe '#inicio_contingencia' do
		it "deve fazer parse para Time se passar qualquer valor" do
			subject.inicio_contingencia = '05/06/2018 03:35'
			subject.inicio_contingencia.must_be_close_to Time.zone.parse('05/06/2018 03:35')

			subject.inicio_contingencia = now = DateTime.current
			subject.inicio_contingencia.must_be_close_to now.to_time.in_time_zone
		end
		it "se passar um valor Time deve retornar o mesmo valor" do
			subject.inicio_contingencia = now = Time.current
			subject.inicio_contingencia.to_s.must_equal now.in_time_zone.to_s
		end
		it "deve retornar nil se passar um valor inválido" do
			subject.inicio_contingencia = '77777777777'
			subject.inicio_contingencia.must_be_nil
		end
	end

end