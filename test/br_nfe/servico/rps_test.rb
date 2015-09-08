require 'test_helper'

describe BrNfe::Servico::Rps do
	subject { FactoryGirl.build(:br_nfe_rps) }
	let(:destinatario)  { FactoryGirl.build(:destinatario) }
	let(:intermediario) { FactoryGirl.build(:intermediario) }
	let(:condicao_pagamento) { FactoryGirl.build(:condicao_pagamento) }

	describe "#contem_substituicao?" do
		before do
			subject.assign_attributes(numero_substituicao: '1', serie_substituicao: '2', tipo_substituicao: '1')
		end
		it "true se numero_substituicao, serie_substituicao e tipo_substituicao tiver algum valor" do
			subject.contem_substituicao?.must_equal true
		end
		it "false se numero_substituicao não tiver valor" do
			subject.numero_substituicao = ''
			subject.contem_substituicao?.must_equal false
		end
		it "false se serie_substituicao não tiver valor" do
			subject.serie_substituicao = ''
			subject.contem_substituicao?.must_equal false
		end
		it "false se tipo_substituicao não tiver valor" do
			subject.tipo_substituicao = ''
			subject.contem_substituicao?.must_equal false
		end
	end


	describe "#destinatario" do
		it "sempre deve retornar um objeto BrNfe::Destinatario" do
			novo = BrNfe::Servico::Rps.new
			novo.destinatario.class.must_equal BrNfe::Destinatario
			novo.destinatario = nil
			novo.destinatario.class.must_equal BrNfe::Destinatario
			novo.destinatario = 'outro valor qualquer'
			novo.destinatario.class.must_equal BrNfe::Destinatario
		end

		it "a classe do destinatario deve segir a configuração de BrNfe.destinatario_class" do
			BrNfe.destinatario_class = BrNfe::Emitente
			
			novo = BrNfe::Servico::Rps.new
			novo.destinatario.class.must_equal BrNfe::Emitente
			novo.destinatario = nil
			novo.destinatario.class.must_equal BrNfe::Emitente
			novo.destinatario = 'outro valor qualquer'
			novo.destinatario.class.must_equal BrNfe::Emitente

			BrNfe.destinatario_class = BrNfe::Destinatario
		end

		it "atributos pode ser atribuidos em forma de bloco" do
			subject.destinatario do |dest|
				dest.cpf_cnpj = '12345678901234'
				dest.telefone = '33666633'
				dest.email    = 'mail@teste.com'
			end
			subject.destinatario.cpf_cnpj.must_equal '12345678901234'
			subject.destinatario.telefone.must_equal '33666633'
			subject.destinatario.email.must_equal 'mail@teste.com'
		end

		it "atributos pode ser atribuidos em forma de hash" do
			subject.destinatario = {
				cpf_cnpj: '999879879',
				telefone: '99999999',
				email:    'mail@teste.com'
			}
			subject.destinatario.cpf_cnpj.must_equal '999879879'
			subject.destinatario.telefone.must_equal '99999999'
			subject.destinatario.email.must_equal 'mail@teste.com'
		end

		it "pode modificar o objeto do atributo" do
			destinatario_old = subject.destinatario
			subject.destinatario.must_equal destinatario_old
			subject.destinatario.wont_equal destinatario
			
			subject.destinatario = destinatario
			subject.destinatario.wont_equal destinatario_old
			subject.destinatario.must_equal destinatario
		end
	end

	describe "#intermediario" do
		it "valor padrão é nil" do
			novo = BrNfe::Servico::Rps.new
			novo.intermediario.must_be_nil
			novo.intermediario = 'outro valor qualquer'
			novo.intermediario.must_be_nil
		end

		it "a classe do intermediario deve segir a configuração de BrNfe.intermediario_class" do
			BrNfe.intermediario_class = BrNfe::Emitente
			
			novo = BrNfe::Servico::Rps.new(intermediario: BrNfe::Emitente.new)
			novo.intermediario.class.must_equal BrNfe::Emitente
			
			novo.intermediario = nil
			novo.intermediario.must_be_nil
			
			novo.intermediario = 'outro valor qualquer'
			novo.intermediario.must_be_nil

			BrNfe.intermediario_class = BrNfe::Servico::Intermediario
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
			subject.intermediario = {cpf_cnpj: '123', razao_social: 'razao'}
			subject.intermediario.cpf_cnpj.must_equal '123'
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
			novo = BrNfe::Servico::Rps.new
			novo.condicao_pagamento.must_be_nil
			novo.condicao_pagamento = 'outro valor qualquer'
			novo.condicao_pagamento.must_be_nil
		end

		it "a classe do condicao_pagamento deve segir a configuração de BrNfe.condicao_pagamento_class" do
			BrNfe.condicao_pagamento_class = BrNfe::Emitente
			
			novo = BrNfe::Servico::Rps.new(condicao_pagamento: BrNfe::Emitente.new)
			novo.condicao_pagamento.class.must_equal BrNfe::Emitente
			
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

end