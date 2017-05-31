require 'test_helper'

describe BrNfe::Product::Operation::NfeDownloadNf do
	subject { FactoryGirl.build(:product_operation_nfe_download_nf) }

	describe '#aliases' do
		it { must_have_alias_attribute :chNFe, :chave_nfe }
	end

	describe 'Validations' do
		describe '#chave_nfe' do
			before { subject.stubs(:generate_key) }
			it { must validate_presence_of(:chave_nfe) }
			it { must validate_length_of(:chave_nfe).is_equal_to(44) }
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
		it "Deve ser válido em ambiente de produção" do
			subject.env = :production
			nfe_must_be_valid_by_schema 'downloadNFe_v1.00.xsd'
		end
		it "Deve ser válido em ambiente de homologação" do
			subject.env = :test
			nfe_must_be_valid_by_schema 'downloadNFe_v1.00.xsd'
		end
	end
end