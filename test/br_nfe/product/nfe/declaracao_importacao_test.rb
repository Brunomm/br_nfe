require 'test_helper'

describe BrNfe::Product::Nfe::DeclaracaoImportacao do
	subject { FactoryGirl.build(:product_declaracao_importacao) }

	describe "Alias attributes" do
		it { must_have_alias_attribute :nDI,          :numero_documento }
		it { must_have_alias_attribute :dDI,          :data_registro, Date.current }
		it { must_have_alias_attribute :xLocDesemb,   :local_desembaraco }
		it { must_have_alias_attribute :UFDesemb,     :uf_desembaraco }
		it { must_have_alias_attribute :dDesemb,      :data_desembaraco, Date.current }
		it { must_have_alias_attribute :tpViaTransp,  :via_transporte }
		it { must_have_alias_attribute :vAFRMM,       :valor_afrmm }
		it { must_have_alias_attribute :tpIntermedio, :tipo_intermediacao }
		it { must_have_alias_attribute :CNPJ,         :cnpj_adquirente, '01234567890' }
		it { must_have_alias_attribute :UFTerceiro,   :uf_terceiro }
		it { must_have_alias_attribute :cExportador,  :codigo_exportador }
		it { must_have_alias_attribute :nAdicao,      :adicoes, [BrNfe.adicao_importacao_product_class.new] }
	end
	describe "Default values" do
		it "for via_transporte" do
			subject.class.new.via_transporte.must_equal 1
		end
	end
	
	describe 'Validações' do
		it { must validate_presence_of(:numero_documento) }
		it { must validate_length_of(:numero_documento).is_at_most(12) }
		it { must validate_presence_of(:data_registro) }
		it { must validate_presence_of(:local_desembaraco) }
		it { must validate_length_of(:local_desembaraco).is_at_most(60) }
		it { must validate_presence_of(:uf_desembaraco) }
		it { must validate_inclusion_of(:uf_desembaraco).in_array(BrNfe::Constants::SIGLAS_UF) }
		it { must validate_presence_of(:via_transporte) }
		it { must validate_inclusion_of(:via_transporte).in_array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]) }
		it { must validate_presence_of(:tipo_intermediacao) }
		it { must validate_inclusion_of(:tipo_intermediacao).in_array([1, 2, 3]) }
		it { must validate_presence_of(:codigo_exportador) }
		it { must validate_length_of(:codigo_exportador).is_at_most(60) }

		describe '#valor_afrmm' do
			it "deve ser obrigatório se a via_transporte for 1" do
				subject.via_transporte = 1
				must validate_presence_of(:valor_afrmm)
			end
			it "não deve ser obrigatório se a via_transporte for diferente de 1" do
				subject.via_transporte = 2
				wont validate_presence_of(:valor_afrmm)
				subject.via_transporte = 3
				wont validate_presence_of(:valor_afrmm)
				subject.via_transporte = 12
				wont validate_presence_of(:valor_afrmm)
			end
		end

		describe '#cnpj_adquirente' do
			it "Não deve ser obrigatório se o tipo_intermediacao for 1" do
				subject.tipo_intermediacao = 1
				wont validate_presence_of(:cnpj_adquirente)
			end
			it "Deve ser obrigatório se o tipo_intermediacao for 2" do
				subject.tipo_intermediacao = 2
				must validate_presence_of(:cnpj_adquirente)
			end
			it "Deve ser obrigatório se o tipo_intermediacao for 3" do
				subject.tipo_intermediacao = 3
				must validate_presence_of(:cnpj_adquirente)
			end
		end
		describe '#uf_terceiro' do
			it { must validate_inclusion_of(:uf_terceiro).in_array(BrNfe::Constants::SIGLAS_UF-['EX']) }
			it { wont allow_value('EX').for(:uf_terceiro) }

			it "Não deve ser obrigatório se o tipo_intermediacao for 1" do
				subject.tipo_intermediacao = 1
				wont validate_presence_of(:uf_terceiro)
			end
			it "Deve ser obrigatório se o tipo_intermediacao for 2" do
				subject.tipo_intermediacao = 2
				must validate_presence_of(:uf_terceiro)
			end
			it "Deve ser obrigatório se o tipo_intermediacao for 3" do
				subject.tipo_intermediacao = 3
				must validate_presence_of(:uf_terceiro)
			end
		end
	end

	describe '#adicoes' do
		it { must_validate_length_has_many(:adicoes, BrNfe.adicao_importacao_product_class, {in: 1..100})  }
		it { must_validates_has_many(:adicoes, BrNfe.adicao_importacao_product_class, :invalid_adicao) }
		it { must_have_many(:adicoes, BrNfe.adicao_importacao_product_class, {numero_adicao: 'NR123', sequencial: '1'})  }
	end

	describe '#via_transporte' do
		it "sempre deve converter o valor para inteiro" do
			subject.via_transporte = '123'
			subject.via_transporte.must_equal 123
			subject.via_transporte = '7'
			subject.via_transporte.must_equal 7
		end
		it "se via_transporte não tiver valor setado deve retornar nil" do
			subject.via_transporte = ''
			subject.via_transporte.must_be_nil
			subject.via_transporte = nil
			subject.via_transporte.must_be_nil
		end
	end

	describe "cnpj_adquirente" do
		it "Deve retornar apenas os numeros" do
			subject.cnpj_adquirente = '012.345.55/0001-66'
			subject.cnpj_adquirente.must_equal '01234555000166'
		end
	end
end