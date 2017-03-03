require 'test_helper'

describe BrNfe::Service::Rps do
	subject { FactoryGirl.build(:br_nfe_rps) }
	let(:destinatario)  { FactoryGirl.build(:service_destinatario) }
	let(:intermediario) { FactoryGirl.build(:intermediario) }
	let(:condicao_pagamento) { FactoryGirl.build(:condicao_pagamento) }
	let(:item_1) { FactoryGirl.build(:service_item) } 
	let(:item_2) { FactoryGirl.build(:service_item) } 

	describe "validations" do
		it { must validate_presence_of(:numero) }
		it { must validate_presence_of(:serie) }
		it { must validate_presence_of(:tipo) }
		context "Quando #validate_rps? for false os valores de RPS não devem ser obrigatórios" do
			before { subject.stubs(:validate_rps?).returns(false) }
			it { wont validate_presence_of(:numero) }
			it { wont validate_presence_of(:serie) }
			it { wont validate_presence_of(:tipo) }
		end

		describe "option validar_recepcao_rps" do
			context "quando for true" do
				before { subject.validar_recepcao_rps = true }
				it { must validate_presence_of(:data_emissao) }
				it { must validate_presence_of(:item_lista_servico) }
				it { must validate_presence_of(:description) }
				it { must validate_presence_of(:codigo_municipio) }
				it { must validate_numericality_of(:valor_total_servicos).is_greater_than(0) }
				it { must validate_numericality_of(:base_calculo).is_greater_than(0) }
				
				it { must validate_numericality_of(:valor_total_servicos) }
				it { must validate_numericality_of(:deducoes) }
				it { must validate_numericality_of(:valor_pis) }
				it { must validate_numericality_of(:valor_cofins) }
				it { must validate_numericality_of(:valor_inss) }
				it { must validate_numericality_of(:valor_ir) }
				it { must validate_numericality_of(:valor_csll) }
				it { must validate_numericality_of(:outras_retencoes) }
				it { must validate_numericality_of(:total_iss) }
				it { must validate_numericality_of(:iss_aliquota) }
				it { must validate_numericality_of(:base_calculo) }
				it { must validate_numericality_of(:desconto_incondicionado) }
				it { must validate_numericality_of(:desconto_condicionado) }

				it "deve validar o intermediario" do
					subject.expects(:validar_intermediario)
					subject.valid?
				end

				it "deve validar o intermediario" do
					subject.expects(:validar_destinatario)
					subject.valid?
				end

				describe "option iss_retido?" do
					context "quando for true" do
						before { subject.stubs(:iss_retido?).returns(true) }
						it { wont validate_presence_of(:total_iss) }
						it { wont validate_presence_of(:iss_aliquota) }
					end
					context "quando for false" do
						before do 
							subject.items = []
							subject.stubs(:iss_retido?).returns(false)
						end
						it { must validate_presence_of(:total_iss) }
						it { must validate_presence_of(:iss_aliquota) }
					end
				end
			end

			context "quando for false" do
				before { subject.validar_recepcao_rps = false }
				it { wont validate_presence_of(:data_emissao) }
				it { wont validate_presence_of(:item_lista_servico) }
				it { wont validate_presence_of(:description) }
				it { wont validate_presence_of(:codigo_municipio) }
				it { wont validate_numericality_of(:valor_total_servicos).is_greater_than(0) }
				it { wont validate_numericality_of(:base_calculo).is_greater_than(0) }
				
				it { wont validate_numericality_of(:valor_total_servicos) }
				it { wont validate_numericality_of(:deducoes) }
				it { wont validate_numericality_of(:valor_pis) }
				it { wont validate_numericality_of(:valor_cofins) }
				it { wont validate_numericality_of(:valor_inss) }
				it { wont validate_numericality_of(:valor_ir) }
				it { wont validate_numericality_of(:valor_csll) }
				it { wont validate_numericality_of(:outras_retencoes) }
				it { wont validate_numericality_of(:total_iss) }
				it { wont validate_numericality_of(:iss_aliquota) }
				it { wont validate_numericality_of(:base_calculo) }
				it { wont validate_numericality_of(:desconto_incondicionado) }
				it { wont validate_numericality_of(:desconto_condicionado) }

				it "deve validar o intermediario" do
					subject.expects(:validar_intermediario).never
					subject.valid?
				end

				it "deve validar o intermediario" do
					subject.expects(:validar_destinatario).never
					subject.valid?
				end

				describe "option iss_retido?" do
					context "quando for true" do
						before { subject.stubs(:iss_retido?).returns(true) }
						it { wont validate_presence_of(:total_iss) }
						it { wont validate_presence_of(:iss_aliquota) }
					end
					context "quando for false" do
						before { subject.stubs(:iss_retido?).returns(false) }
						it { wont validate_presence_of(:total_iss) }
						it { wont validate_presence_of(:iss_aliquota) }
					end
				end
			end
		end
	end
	
	describe "#condicao_pagamento" do
		it "deve ter incluso o module BrNfe::Association::HaveCondicaoPagamento" do
			subject.class.included_modules.must_include BrNfe::Association::HaveCondicaoPagamento
		end
	end

	describe "#replace_invoice?" do
		before do
			subject.assign_attributes(numero_substituicao: '1', serie_substituicao: '2', tipo_substituicao: '1')
		end
		it "true se numero_substituicao, serie_substituicao e tipo_substituicao tiver algum valor" do
			subject.replace_invoice?.must_equal true
		end
		it "false se numero_substituicao não tiver valor" do
			subject.numero_substituicao = ''
			subject.replace_invoice?.must_equal false
		end
		it "false se serie_substituicao não tiver valor" do
			subject.serie_substituicao = ''
			subject.replace_invoice?.must_equal false
		end
		it "false se tipo_substituicao não tiver valor" do
			subject.tipo_substituicao = ''
			subject.replace_invoice?.must_equal false
		end
	end

	describe "#destinatario" do
		class OtherClassDestinatario < BrNfe::ActiveModelBase
		end
		it "deve ter incluso o module HaveDestinatario" do
			subject.class.included_modules.must_include BrNfe::Association::HaveDestinatario
		end
		it "o método #destinatario_class deve ter por padrão a class BrNfe::Service::Destinatario" do
			subject.destinatario.must_be_kind_of BrNfe::Service::Destinatario
			subject.send(:destinatario_class).must_equal BrNfe::Service::Destinatario
		end
		it "a class do destinatario pode ser modificada através da configuração destinatario_service_class" do
			BrNfe.destinatario_service_class = OtherClassDestinatario
			subject.destinatario.must_be_kind_of OtherClassDestinatario
			subject.send(:destinatario_class).must_equal OtherClassDestinatario

			# É necessário voltar a configuração original para não falhar outros testes
			BrNfe.destinatario_service_class = BrNfe::Service::Destinatario
		end
	end

	describe "#intermediario" do
		it "valor padrão é nil" do
			novo = BrNfe::Service::Rps.new
			novo.intermediario.must_be_nil
			novo.intermediario = 'outro valor qualquer'
			novo.intermediario.must_be_nil
		end

		it "a classe do intermediario deve segir a configuração de BrNfe.intermediario_service_class" do
			BrNfe.intermediario_service_class = BrNfe::Service::Emitente
			
			novo = BrNfe::Service::Rps.new(intermediario: BrNfe::Service::Emitente.new)
			novo.intermediario.class.must_equal BrNfe::Service::Emitente
			
			novo.intermediario = nil
			novo.intermediario.must_be_nil
			
			novo.intermediario = 'outro valor qualquer'
			novo.intermediario.must_be_nil

			BrNfe.intermediario_service_class = BrNfe::Service::Intermediario
		end

		it "atributos pode ser atribuidos em forma de bloco" do
			subject.intermediario do |dest|
				dest.cpf_cnpj            = '12345678901234'
				dest.inscricao_municipal = '3549-5'
				dest.razao_social        = 'razao_social'
			end
			subject.intermediario.cpf_cnpj.must_equal            '12345678901234'
			subject.intermediario.inscricao_municipal.must_equal '3549-5'
			subject.intermediario.razao_social.must_equal        'RAZAO_SOCIAL'
		end

		it "atributos pode ser modificados em forma de bloco" do
			subject.intermediario = {cpf_cnpj: '00000000123', razao_social: 'razao'}
			subject.intermediario.cpf_cnpj.must_equal '00000000123'
			subject.intermediario.razao_social.must_equal 'RAZAO'
			
			subject.intermediario do |dest|
				dest.cpf_cnpj            = '12345678901234'
			end
			subject.intermediario.cpf_cnpj.must_equal     '12345678901234'
			subject.intermediario.razao_social.must_equal 'RAZAO'
		end

		it "atributos pode ser atribuidos em forma de hash" do
			subject.intermediario = {
				cpf_cnpj:            '12345678901234',
				inscricao_municipal: '3549-5',
				razao_social:        'razao_social'
			}
			subject.intermediario.cpf_cnpj.must_equal            '12345678901234'
			subject.intermediario.inscricao_municipal.must_equal '3549-5'
			subject.intermediario.razao_social.must_equal        'RAZAO_SOCIAL'
		end

		it "pode modificar o objeto do atributo" do
			intermediario_old = subject.intermediario
			subject.intermediario.must_equal intermediario_old
			subject.intermediario.wont_equal intermediario
			
			subject.intermediario = intermediario
			subject.intermediario.wont_equal intermediario_old
			subject.intermediario.must_equal intermediario
		end
	end

	describe "#condicao_pagamento" do
		it "valor padrão é nil" do
			novo = BrNfe::Service::Rps.new
			novo.condicao_pagamento.must_be_nil
			novo.condicao_pagamento = 'outro valor qualquer'
			novo.condicao_pagamento.must_be_nil
		end

		it "a classe do condicao_pagamento deve segir a configuração de BrNfe.condicao_pagamento_class" do
			BrNfe.condicao_pagamento_class = BrNfe::Service::Emitente
			
			novo = BrNfe::Service::Rps.new(condicao_pagamento: BrNfe::Service::Emitente.new)
			novo.condicao_pagamento.class.must_equal BrNfe::Service::Emitente
			
			novo.condicao_pagamento = nil
			novo.condicao_pagamento.must_be_nil
			
			novo.condicao_pagamento = 'outro valor qualquer'
			novo.condicao_pagamento.must_be_nil

			BrNfe.condicao_pagamento_class = BrNfe::CondicaoPagamento
		end

		it "atributos pode ser atribuidos em forma de bloco" do
			subject.condicao_pagamento do |dest|
				dest.condicao            = 'A_VISTA'
			end
			subject.condicao_pagamento.condicao.must_equal 'A_VISTA'
		end

		it "atributos pode ser modificados em forma de bloco" do
			subject.condicao_pagamento = {condicao: 'A_PRAZO', parcelas: {valor: '1'} }
			subject.condicao_pagamento do |dest|
				dest.condicao = 'A_VISTA'
			end
			subject.condicao_pagamento.condicao.must_equal 'A_VISTA'
			subject.condicao_pagamento.parcelas.must_equal([{valor: '1'}])
		end

		it "atributos pode ser atribuidos em forma de hash" do
			subject.condicao_pagamento = {
				condicao: 'A_PRAZO'
			}
			subject.condicao_pagamento.condicao.must_equal 'A_PRAZO'
		end

		it "pode modificar o objeto do atributo" do
			condicao_pagamento_old = subject.condicao_pagamento
			subject.condicao_pagamento.must_equal condicao_pagamento_old
			subject.condicao_pagamento.wont_equal condicao_pagamento
			
			subject.condicao_pagamento = condicao_pagamento
			subject.condicao_pagamento.wont_equal condicao_pagamento_old
			subject.condicao_pagamento.must_equal condicao_pagamento
		end
	end

	describe "#validar_intermediario" do
		it "se não tiver intermediario deve retornar true" do
			subject.intermediario = nil
			subject.send(:validar_intermediario).must_equal true
		end
		it "se tiver intermediario e o mesmo for válido, não adiciona as mensagens de erro" do
			intermediario.stubs(:errors).returns(stub(full_messages: ['msg 1']) )
			intermediario.expects(:invalid?).returns(false)
			subject.intermediario = intermediario
			subject.send(:validar_intermediario).must_be_nil
			subject.errors.full_messages.must_equal([])
		end
		it "se tiver intermediario e o mesmo for inválido, deve adicionar as mensagens de erro" do
			intermediario.stubs(:errors).returns(stub(full_messages: ['msg 1']) )
			intermediario.expects(:invalid?).returns(true)
			subject.intermediario = intermediario
			subject.send(:validar_intermediario)
			subject.errors.full_messages.must_equal(['Intermediário: msg 1'])
		end
	end

	describe "#validar_destinatario" do
		it "se destinatario for válido, não adiciona as mensagens de erro" do
			destinatario.stubs(:errors).returns(stub(full_messages: ['msg 1']) )
			destinatario.expects(:invalid?).returns(false)
			subject.destinatario = destinatario
			subject.send(:validar_destinatario).must_be_nil
			subject.errors.full_messages.must_equal([])
		end
		it "se destinatario for inválido, deve adicionar as mensagens de erro" do
			destinatario.stubs(:errors).returns(stub(full_messages: ['msg 1']) )
			destinatario.expects(:invalid?).returns(true)
			subject.destinatario = destinatario
			subject.send(:validar_destinatario)
			subject.errors.full_messages.must_equal(['Destinatário: msg 1'])
		end
	end

	describe "#items" do
		it "deve inicializar como um vetor vazio" do
			subject.class.new.items.must_equal []
		end

		it "posso utilizar o << para adicionar valores" do
			subject.items = item_1
			subject.items << item_2
			subject.items.must_equal [item_1,item_2]
		end

		it "sempre retorna um array" do
			subject.items = item_2
			subject.items.must_equal [item_2]
		end

		it "não permite adicionar outro objeto a não ser o definido pela class BrNfe.service_item_class" do
			class CustomClass
			end
			c_class_1 = CustomClass.new
			c_class_2 = CustomClass.new
			BrNfe.service_item_class = CustomClass

			subject.items << c_class_1
			subject.items << c_class_2
			subject.items << item_1
			subject.items.must_equal [c_class_1, c_class_2]

			subject.items = 'item_2'
			subject.items.must_equal []

			BrNfe.service_item_class = BrNfe::Service::Item
		end
	end

	describe "#valor_total_servicos" do
		it "se não setar valor em valor_total_servicos deve somar o valor_total de todos os items" do
			subject.valor_total_servicos = nil
			item_1.valor_total = 55.70
			item_2.valor_total = 40.35
			subject.items = [item_1, item_2]

			subject.valor_total_servicos.must_equal 96.05
		end
		it "se não houver itens e nem um valor setado deve retornar zero" do
			subject.valor_total_servicos = nil
			subject.items = []

			subject.valor_total_servicos.must_equal 0.0
		end
		it "se setar um valor deve retornar esse valor e não pode somar dos itens" do
			subject.valor_total_servicos = 47.0
			item_1.valor_total = 55.70
			item_2.valor_total = 40.35
			subject.items = [item_1, item_2]

			subject.valor_total_servicos.must_equal 47.0
		end
	end

	describe "#base_calculo" do
		it "se não setar valor em base_calculo deve subtratir o valor_total_servicos com deducoes" do
			subject.assign_attributes({
				base_calculo: nil,
				valor_total_servicos: 100.0,
				deducoes: 4.500000555
			})

			subject.base_calculo.must_equal 95.5
		end
		it "deve retornar zero se não houver valor em base_calculo e nem em valor_total_servicos ou deducoes" do
			subject.assign_attributes({
				base_calculo: nil,
				valor_total_servicos:   nil,
				deducoes:       nil,
				items:            []
			})

			subject.base_calculo.must_equal 0.0
		end
		it "se setar um valor deve retornar esse valor e não pode celcular o valor_total_servicos subtraindo as deducoes" do
			subject.assign_attributes({
				base_calculo: 200,
				valor_total_servicos:   100,
				deducoes:       50
			})

			subject.base_calculo.must_equal 200
		end
	end

	describe "#iss_aliquota" do
		it "deve pegar o valor de iss_aliquota do primeiro item se não houver valor setado em iss_aliquota do RPS" do
			subject.iss_aliquota = nil
			item_1.iss_aliquota = 0.3
			item_2.iss_aliquota = 0.4
			subject.items = [item_2, item_1]

			subject.iss_aliquota.must_equal 0.4
		end
		it "Deve retornar nil se não houver itens e nem um valor setado" do
			subject.iss_aliquota = nil
			subject.items = []

			subject.iss_aliquota.must_be_nil
		end
		it "se setar um valor deve retornar esse valor e não pode pegar dos itens" do
			subject.iss_aliquota = 0.4
			item_1.valor_total = 0.1
			item_2.valor_total = 0.2
			subject.items = [item_1, item_2]

			subject.iss_aliquota.must_equal 0.4
		end
	end

	describe "#cnae_code" do
		it "deve pegar o valor de cnae_code do primeiro item se não houver valor setado em cnae_code do RPS" do
			subject.cnae_code = nil
			item_1.cnae_code = '11111'
			item_2.cnae_code = '22222'
			subject.items = [item_2, item_1]

			subject.cnae_code.must_equal '22222'
		end
		it "Deve retornar nil se não houver itens e nem um valor setado" do
			subject.cnae_code = nil
			subject.items = []

			subject.cnae_code.must_be_nil
		end
		it "se setar um valor deve retornar esse valor e não pode pegar dos itens" do
			subject.cnae_code  = '2'
			item_1.valor_total = '3'
			item_2.valor_total = '4'
			subject.items = [item_1, item_2]

			subject.cnae_code.must_equal '2'
		end
	end

	describe "#valor_liquido" do
		it "Se setar um valor deve retornar o valor setado" do
			subject.assign_attributes(valor_total_servicos: 10.00, valor_liquido: 9_999.55)
			subject.valor_liquido.must_equal 9_999.55
		end
		it "se não tiver valor setado manualmente em valor_liquido deve realizar o calcula automaticamente" do
			subject.assign_attributes({valor_total_servicos: 100.00, valor_pis: 1.5, valor_cofins: 1.0,
				valor_inss: 0.5, valor_ir: 0.0, valor_csll: 2.0, outras_retencoes: 3.0,
				total_iss_retido: 4.0, desconto_incondicionado: 5.0, desconto_condicionado: 6.0,
				valor_liquido: nil
			})
			subject.valor_liquido.must_equal 77.00
		end
		it "se todos os valores para o calculo estiverem nil não deve dar erro e retorna zero" do
			subject.items = []
			subject.assign_attributes({valor_total_servicos: nil, valor_pis: nil, valor_cofins: nil,
				valor_inss: nil, valor_ir: nil, valor_csll: nil, outras_retencoes: nil,
				total_iss_retido: nil, desconto_incondicionado: nil, desconto_condicionado: nil,
				valor_liquido: nil
			})
			subject.valor_liquido.must_equal 0.0
		end
		it "se alguns dos valores para o calculo estiverem nil não deve dar erro e considera esse valor como zero" do
			subject.assign_attributes({valor_total_servicos: 100.00, valor_pis: nil, valor_cofins: nil,
				valor_inss: nil, valor_ir: 0.0, valor_csll: 2.0, outras_retencoes: 3.0,
				total_iss_retido: 4.0, desconto_incondicionado: 5.0, desconto_condicionado: 6.0,
				valor_liquido: nil
			})
			subject.valor_liquido.must_equal 80.0
		end
	end

end