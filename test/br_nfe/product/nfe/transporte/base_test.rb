require 'test_helper'

describe BrNfe::Product::Nfe::Transporte::Base do
	subject { FactoryGirl.build(:product_transporte_base) }
	let(:veiculo) { FactoryGirl.build(:product_transporte_veiculo) } 
	let(:volume)  { FactoryGirl.build(:product_transporte_volume) } 

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
		describe '#reboques' do
			it 'Deve ter no máximo 5 reboques' do 
				# Como só aceita objetos de Veiculo então sobrescrevo o método
				# para setar os valores em `reboques`
				class Shoulda::Matchers::ActiveModel::ValidateLengthOfMatcher
					def string_of_length(length)
						[BrNfe.veiculo_product_class.new] * length
					end
				end
				
				must validate_length_of(:reboques).is_at_most(5) 
				
				# Volto a alteração que fiz no método para outros testes
				# Funcionarem adequadamente
				class Shoulda::Matchers::ActiveModel::ValidateLengthOfMatcher
					def string_of_length(length)
						'x' * length
					end
				end
			end

			it "Se tiver mais que 1 reboque e pelo menos 1 deles não for válido deve adiiconar o erro do reboque no objeto" do
				veiculo.stubs(:valid?).returns(true)
				veiculo2 = veiculo.dup
				veiculo2.errors.add(:base, 'Erro do reboque 2')
				veiculo2.stubs(:valid?).returns(false)
				veiculo3 = veiculo.dup
				veiculo3.errors.add(:base, 'Erro do reboque 3')
				veiculo3.stubs(:valid?).returns(false)
				subject.reboques = [veiculo, veiculo2, veiculo3]

				must_be_message_error :base, :invalid_reboque, {index: 2, error_message: 'Erro do reboque 2'}
				must_be_message_error :base, :invalid_reboque, {index: 3, error_message: 'Erro do reboque 3'}, false
			end

		end
		describe '#volumes' do
			it "Se tiver mais que 1 volume e pelo menos 1 deles não for válido deve adiiconar o erro do volume no objeto" do
				volume.stubs(:valid?).returns(true)
				volume2 = volume.dup
				volume2.errors.add(:base, 'Erro do volume 2')
				volume2.stubs(:valid?).returns(false)
				volume3 = volume.dup
				volume3.errors.add(:base, 'Erro do volume 3')
				volume3.stubs(:valid?).returns(false)
				subject.volumes = [volume, volume2, volume3]

				must_be_message_error :base, :invalid_volume, {index: 2, error_message: 'Erro do volume 2'}
				must_be_message_error :base, :invalid_volume, {index: 3, error_message: 'Erro do volume 3'}, false
			end
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
			
			must_be_message_error :base, "#{alias_msg_erro}#{msg_erro_1}"
			must_be_message_error :base, "#{alias_msg_erro}#{msg_erro_2}", {}, false # Para não executar mais o valid?
		end

		it "não deve validar o veiculo se a forma_transporte for balsa" do
			subject.forma_transporte = :balsa
			veiculo = BrNfe.veiculo_product_class.new
			veiculo.errors.add :base, msg_erro_1
			veiculo.errors.add :base, msg_erro_2
			veiculo.stubs(:invalid?).returns(true)
			subject.veiculo = veiculo
			
			wont_be_message_error :base, "#{alias_msg_erro}#{msg_erro_1}"
			wont_be_message_error :base, "#{alias_msg_erro}#{msg_erro_2}", {}, false # Para não executar mais o valid?
		end

		it "não deve validar o veiculo se a forma_transporte for vagao" do
			subject.forma_transporte = :vagao
			veiculo = BrNfe.veiculo_product_class.new
			veiculo.errors.add :base, msg_erro_1
			veiculo.errors.add :base, msg_erro_2
			veiculo.stubs(:invalid?).returns(true)
			subject.veiculo = veiculo
			
			wont_be_message_error :base, "#{alias_msg_erro}#{msg_erro_1}"
			wont_be_message_error :base, "#{alias_msg_erro}#{msg_erro_2}", {}, false # Para não executar mais o valid?
		end
	end

	describe '#reboques' do
		it "deve inicializar o objeto com um Array" do
			subject.class.new.reboques.must_be_kind_of Array
		end
		it "deve aceitar apenas objetos da class Hash ou Veiculo" do
			nf_hash = {placa: 'XXL-9877', rntc: '1146'}
			subject.reboques = [veiculo, 1, 'string', nil, {}, [], :symbol, nf_hash, true]
			subject.reboques.size.must_equal 2
			subject.reboques[0].must_equal veiculo

			subject.reboques[1].placa.must_equal 'XXL9877'
			subject.reboques[1].rntc.must_equal '1146'
		end
		it "posso adicionar notas fiscais  com <<" do
			new_object = subject.class.new
			new_object.reboques << veiculo
			new_object.reboques << 1
			new_object.reboques << nil
			new_object.reboques << {placa: 'XXL-9999', rntc: '223'}
			new_object.reboques << {placa: 'XXL1111', rntc: '800'}

			new_object.reboques.size.must_equal 3
			new_object.reboques[0].must_equal veiculo

			new_object.reboques[1].placa.must_equal 'XXL9999'
			new_object.reboques[1].rntc.must_equal '223'
			new_object.reboques[2].placa.must_equal 'XXL1111'
			new_object.reboques[2].rntc.must_equal '800'
		end
	end

	describe '#volumes' do
		it "deve inicializar o objeto com um Array" do
			subject.class.new.volumes.must_be_kind_of Array
		end
		it "deve aceitar apenas objetos da class Hash ou Veiculo" do
			nf_hash = {marca: 'COCA', quantidade: 1146}
			subject.volumes = [volume, 1, 'string', nil, {}, [], :symbol, nf_hash, true]
			subject.volumes.size.must_equal 2
			subject.volumes[0].must_equal volume

			subject.volumes[1].marca.must_equal 'COCA'
			subject.volumes[1].quantidade.must_equal 1146
		end
		it "posso adicionar notas fiscais  com <<" do
			new_object = subject.class.new
			new_object.volumes << volume
			new_object.volumes << 1
			new_object.volumes << nil
			new_object.volumes << {marca: 'QUIPO', quantidade: 223}
			new_object.volumes << {marca: 'XIRÚ',  quantidade: 800}

			new_object.volumes.size.must_equal 3
			new_object.volumes[0].must_equal volume

			new_object.volumes[1].marca.must_equal 'QUIPO'
			new_object.volumes[1].quantidade.must_equal 223
			new_object.volumes[2].marca.must_equal 'XIRÚ'
			new_object.volumes[2].quantidade.must_equal 800
		end
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
		let(:alias_msg_erro) { 'Veículo: ' } 
		let(:msg_erro_1) { 'Erro 1' } 
		let(:msg_erro_2) { 'Erro 2' } 
		it "deve ignorar valores que não são da class de transportador" do
			subject.transportador = nil
			subject.transportador = 123
			subject.transportador.must_be_nil
			subject.transportador = 'aaaa'
			subject.transportador.must_be_nil
			subject.transportador = BrNfe.transportador_product_class.new
			subject.transportador.must_be_kind_of BrNfe.transportador_product_class
		end
		it "deve instanciar um transportador com os atributos se setar um Hash " do
			subject.transportador = nil
			subject.transportador = {nome_fantasia: 'LOG', razao_social: 'NR', endereco_uf: "SP"}
			subject.transportador.must_be_kind_of BrNfe.transportador_product_class

			subject.transportador.nome_fantasia.must_equal 'LOG'
			subject.transportador.razao_social.must_equal  'NR'
			subject.transportador.endereco_uf.must_equal   'SP'
		end
		it "deve instanciar um transportador setar os atributos em forma de Block " do
			subject.transportador = nil
			subject.transportador do |e| 
				e.nome_fantasia = 'PLACA'
				e.razao_social  = 'RNTC'
				e.endereco_uf   = 'MG'
			end

			subject.transportador.must_be_kind_of BrNfe.transportador_product_class
			subject.transportador.nome_fantasia.must_equal 'PLACA'
			subject.transportador.razao_social.must_equal  'RNTC'
			subject.transportador.endereco_uf.must_equal   'MG'
		end
		it "deve ser possível limpar o atributo" do
			subject.transportador = {razao_social: 'LOG'}
			subject.transportador.must_be_kind_of BrNfe.transportador_product_class

			subject.transportador = nil
			subject.transportador.must_be_nil
		end
			
		it "deve validar o transportador se for preenchido" do
			transportador = BrNfe.transportador_product_class.new
			transportador.errors.add :base, msg_erro_1
			transportador.errors.add :base, msg_erro_2
			transportador.expects(:invalid?).returns(true)
			subject.transportador = transportador
			
			must_be_message_error(:base, :invalid_transportador, {error_message: msg_erro_1})
			must_be_message_error(:base, :invalid_transportador, {error_message: msg_erro_2}, false) # Para não executar mais o valid?
		end
	end
end