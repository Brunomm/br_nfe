require 'test_helper'

describe BrNfe::Product::Nfe::Transporte::Base do
	subject { FactoryGirl.build(:product_transporte_base) }
	let(:veiculo) { FactoryGirl.build(:product_transporte_veiculo) } 
	let(:volume)  { FactoryGirl.build(:product_transporte_volume) } 

	describe "Alias attributes" do
		it { must_have_alias_attribute :modFrete,   :modalidade_frete }
		it { must_have_alias_attribute :vServ,      :retencao_valor_sevico }
		it { must_have_alias_attribute :vBCRet,     :retencao_base_calculo_icms }
		it { must_have_alias_attribute :pICMSRet,   :retencao_aliquota }
		it { must_have_alias_attribute :vICMSRet,   :retencao_valor_icms }
		it { must_have_alias_attribute :CFOP,       :retencao_cfop }
		it { must_have_alias_attribute :cMunFG,     :retencao_codigo_municipio }
		it { must_have_alias_attribute :veicTransp, :veiculo, BrNfe.veiculo_product_class.new }
		it { must_have_alias_attribute :balsa,      :identificacao_balsa }
		it { must_have_alias_attribute :vagao,      :identificacao_vagao }
		it { must_have_alias_attribute :vol,        :volumes, [BrNfe.volume_transporte_product_class.new] }
		it { must_have_alias_attribute :transporta, :transportador, BrNfe.transportador_product_class.new }
	end

	describe "#default_values" do
		it '#modalidade_frete deve ter o padrão 9' do
			subject.class.new.modalidade_frete.must_equal 9
		end
		it '#forma_transporte deve ter o padrão :veiculo' do
			subject.class.new.forma_transporte.must_equal :veiculo
		end
	end
	
	describe '#Validations' do
		it { must validate_inclusion_of(:modalidade_frete).in_array([0, '0', 1, '1', 2, '2', 9, '9']) }
		it { must validate_inclusion_of(:forma_transporte).in_array([:veiculo, :balsa, :vagao]) }
		it { must validate_presence_of(:forma_transporte) }

		describe 'Reteção de ICMS' do
			context "quando retencao_icms? for true" do
				before { subject.stubs(:retencao_icms?).returns(true) }
				it { must validate_presence_of(:retencao_codigo_municipio) }
				it { must validate_presence_of(:retencao_cfop) }
				it { must validate_numericality_of(:retencao_base_calculo_icms).allow_nil }
				it { must validate_numericality_of(:retencao_aliquota).is_less_than(100).allow_nil }
				it { must validate_numericality_of(:retencao_valor_icms).allow_nil }
			end
			context "quando retencao_icms? for false" do
				before { subject.stubs(:retencao_icms?).returns(false) }
				it { wont validate_presence_of(:retencao_codigo_municipio) }
				it { wont validate_presence_of(:retencao_cfop) }
				it { wont validate_numericality_of(:retencao_base_calculo_icms) }
				it { wont validate_numericality_of(:retencao_aliquota) }
				it { wont validate_numericality_of(:retencao_valor_icms) }
			end
		end
		context "Quando a forma_transporte for :veiculo" do
			before { subject.forma_transporte = :veiculo }
			it { must validate_presence_of(:veiculo) }
			it { wont validate_presence_of(:identificacao_balsa) }
			it { wont validate_presence_of(:identificacao_vagao) }
		end
		context "Quando a forma_transporte for :balsa" do
			before { subject.forma_transporte = :balsa }
			it { wont validate_presence_of(:veiculo) }
			it { must validate_presence_of(:identificacao_balsa) }
			it { wont validate_presence_of(:identificacao_vagao) }
		end
		context "Quando a forma_transporte for :vagao" do
			before { subject.forma_transporte = :vagao }
			it { wont validate_presence_of(:veiculo) }
			it { wont validate_presence_of(:identificacao_balsa) }
			it { must validate_presence_of(:identificacao_vagao) }
		end
	end

	describe '#retencao_icms? method' do
		it "deve retornar true se o valor setado em retencao_valor_sevico for maior que zero" do
			subject.retencao_valor_sevico = 0.1
			subject.retencao_icms?.must_equal true

			subject.retencao_valor_sevico = 20
			subject.retencao_icms?.must_equal true
		end

		it "deve retornar false se o valor setado em retencao_valor_sevico for nil, zero ou menor" do
			subject.retencao_valor_sevico = nil
			subject.retencao_icms?.must_equal false

			subject.retencao_valor_sevico = 0.0
			subject.retencao_icms?.must_equal false

			subject.retencao_valor_sevico = -1
			subject.retencao_icms?.must_equal false
		end
	end

	describe '#veiculo' do
		let(:alias_msg_erro) { 'Veículo: ' } 
		let(:msg_erro_1) { 'Erro 1' } 
		let(:msg_erro_2) { 'Erro 2' } 
		it "deve ignorar valores que não são da class de veiculo" do
			subject.veiculo = nil
			subject.veiculo = 123
			subject.veiculo.must_be_nil
			subject.veiculo = 'aaaa'
			subject.veiculo.must_be_nil
			subject.veiculo = BrNfe.veiculo_product_class.new
			subject.veiculo.must_be_kind_of BrNfe.veiculo_product_class
		end
		it "deve instanciar um veiculo com os atributos se setar um Hash " do
			subject.veiculo = nil
			subject.veiculo = {placa: 'LOG', rntc: 'NR', uf: "SP"}
			subject.veiculo.must_be_kind_of BrNfe.veiculo_product_class

			subject.veiculo.placa.must_equal 'LOG'
			subject.veiculo.rntc.must_equal  'NR'
			subject.veiculo.uf.must_equal    'SP'
		end
		it "deve instanciar um veiculo setar os atributos em forma de Block " do
			subject.veiculo = nil
			subject.veiculo do |e| 
				e.placa = 'PLACA'
				e.rntc  = 'RNTC'
				e.uf    = 'MG'
			end

			subject.veiculo.must_be_kind_of BrNfe.veiculo_product_class
			subject.veiculo.placa.must_equal 'PLACA'
			subject.veiculo.rntc.must_equal  'RNTC'
			subject.veiculo.uf.must_equal    'MG'
		end
		it "deve ser possível limpar o atributo" do
			subject.veiculo = {rntc: 'LOG'}
			subject.veiculo.must_be_kind_of BrNfe.veiculo_product_class

			subject.veiculo = nil
			subject.veiculo.must_be_nil
		end
			
		it "deve validar o veiculo se for preenchido e se a forma_transporte for veiculo" do
			subject.forma_transporte = :veiculo
			veiculo = BrNfe.veiculo_product_class.new
			veiculo.errors.add :base, msg_erro_1
			veiculo.errors.add :base, msg_erro_2
			veiculo.expects(:invalid?).returns(true)
			subject.veiculo = veiculo
			
			must_be_message_error :base, :invalid_veiculo, {error_message: msg_erro_1}
			must_be_message_error :base, :invalid_veiculo, {error_message: msg_erro_2}, false # Para não executar mais o valid?
		end

		it "não deve validar o veiculo se a forma_transporte for balsa" do
			subject.forma_transporte = :balsa
			veiculo = BrNfe.veiculo_product_class.new
			veiculo.errors.add :base, msg_erro_1
			veiculo.errors.add :base, msg_erro_2
			veiculo.stubs(:invalid?).returns(true)
			subject.veiculo = veiculo
			
			wont_be_message_error :base, :invalid_veiculo, {error_message: msg_erro_1}
			wont_be_message_error :base, :invalid_veiculo, {error_message: msg_erro_2}, false # Para não executar mais o valid?
		end

		it "não deve validar o veiculo se a forma_transporte for vagao" do
			subject.forma_transporte = :vagao
			veiculo = BrNfe.veiculo_product_class.new
			veiculo.errors.add :base, msg_erro_1
			veiculo.errors.add :base, msg_erro_2
			veiculo.stubs(:invalid?).returns(true)
			subject.veiculo = veiculo
			
			wont_be_message_error :base, :invalid_veiculo, {error_message: msg_erro_1}
			wont_be_message_error :base, :invalid_veiculo, {error_message: msg_erro_2}, false # Para não executar mais o valid?
		end
	end

	describe '#reboques' do
		it { must_validate_length_has_many(:reboques, BrNfe.veiculo_product_class, {maximum: 5})  }
		it { must_validates_has_many(:reboques, BrNfe.veiculo_product_class, :invalid_reboque) }
		it { must_have_many(:reboques, BrNfe.veiculo_product_class, {placa: 'XXL9999', rntc: '223'})  }
	end

	describe '#volumes' do
		it { must_validates_has_many(:volumes, BrNfe.volume_transporte_product_class, :invalid_volume) }
		it { must_have_many(:volumes, BrNfe.volume_transporte_product_class, {marca: 'QUIPO', quantidade: 223})  }
	end

	describe '#CÁLCULOS AUTOMÁTICOS' do
		describe '#retencao_valor_icms' do
			it "deve calcular o valor a partir dos atributos 'retencao_base_calculo_icms' e 'retencao_aliquota' se estiver nil " do
				subject.retencao_valor_icms = nil

				subject.assign_attributes(retencao_base_calculo_icms: 150.0, retencao_aliquota: 5.5)
				subject.retencao_valor_icms.must_equal 8.25

				subject.assign_attributes(retencao_base_calculo_icms: 1_000.0, retencao_aliquota: 10)
				subject.retencao_valor_icms.must_equal 100.0

				subject.assign_attributes(retencao_base_calculo_icms: nil, retencao_aliquota: nil)
				subject.retencao_valor_icms.must_equal 0.0
			end

			it "deve manter o valor setado manualmente mesmo que o calculo entre os atributos 'retencao_base_calculo_icms' e 'retencao_aliquota' sejam diferentes" do
				subject.retencao_valor_icms = 57.88
				
				subject.assign_attributes(retencao_base_calculo_icms: 150.0, retencao_aliquota: 5.5)
				subject.retencao_valor_icms.must_equal 57.88

				subject.assign_attributes(retencao_base_calculo_icms: 1_000.0, retencao_aliquota: 10)
				subject.retencao_valor_icms.must_equal 57.88
			end
		end
	end

	describe '#transportador' do
		it { must_have_one(:transportador, 
				BrNfe.transportador_product_class,  
				{nome_fantasia: 'LOG', razao_social: 'NR', endereco_uf: "SP"}
		)}
		it { must_validate_have_one(:transportador, BrNfe.transportador_product_class, :invalid_transportador) }
	end
end