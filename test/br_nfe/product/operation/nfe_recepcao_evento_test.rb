require 'test_helper'

describe BrNfe::Product::Operation::NfeRecepcaoEvento do
	subject { FactoryGirl.build(:product_operation_nfe_recepcao_evento) }

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
	
	describe "Validação do XML para o Cancelamento através do XSD" do
		context "Para emissores que utilizam a versão 1.00" do
			before do
				subject.assign_attributes(nfe_version: :v3_10, ibge_code_of_issuer_uf: '42', env: :test)
			end
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
	end

end