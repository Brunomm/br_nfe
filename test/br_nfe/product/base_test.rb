require 'test_helper'

describe BrNfe::Product::Base do
	subject { FactoryGirl.build(:product_base) }
	
	describe "Validations" do
		it do
			subject.certificate_pkcs12_path = nil
			must validate_presence_of(:certificate) 
		end
	end

	it '#ssl_request? deve ser true' do
		subject.ssl_request?.must_equal true
	end

	describe '#gateway' do
		context "Estados que usam o servidor SVRS" do
			let(:env) { SecureRandom.hex(5) } 
			it 'AC 12 - Acre' do
				subject.assign_attributes ibge_code_of_issuer_uf: '12', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end

			it 'AL 27 - Alagoas' do
				subject.assign_attributes ibge_code_of_issuer_uf: '27', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end

			it 'AP 16 - Amapá ' do
				subject.assign_attributes ibge_code_of_issuer_uf: '16', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end

			it 'DF 53 - Distrito Federal' do
				subject.assign_attributes ibge_code_of_issuer_uf: '53', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end

			it 'ES 32 - Espírito Santo' do
				subject.assign_attributes ibge_code_of_issuer_uf: '32', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end

			it 'PB 25 - Paraíba' do
				subject.assign_attributes ibge_code_of_issuer_uf: '25', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end

			it 'RJ 33 - Rio de Janeiro' do
				subject.assign_attributes ibge_code_of_issuer_uf: '33', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end

			it 'RN 24 - Rio Grande do Norte' do
				subject.assign_attributes ibge_code_of_issuer_uf: '24', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end

			it 'RN 43 - Rio Grande do Sul' do
				subject.assign_attributes ibge_code_of_issuer_uf: '43', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end

			it 'RO 11 - Rondônia' do
				subject.assign_attributes ibge_code_of_issuer_uf: '11', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end

			it 'RR 14 - Roraima' do
				subject.assign_attributes ibge_code_of_issuer_uf: '14', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end

			it 'SC 42 - Santa Catarina' do
				subject.assign_attributes ibge_code_of_issuer_uf: '42', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end

			it 'SE 28 - Sergipe' do
				subject.assign_attributes ibge_code_of_issuer_uf: '28', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
				subject.gateway.env.must_equal env
			end

			it 'TO 17 - Tocantins' do
				subject.assign_attributes ibge_code_of_issuer_uf: '17', env: env
				subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
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

end