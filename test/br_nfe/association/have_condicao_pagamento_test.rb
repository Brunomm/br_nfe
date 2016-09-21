require 'test_helper'

class HaveCondicaoPagamentoTest < BrNfe::ActiveModelBase
	include BrNfe::Association::HaveCondicaoPagamento	
end
class NewClassCondicaoPagamento < BrNfe::ActiveModelBase
	attr_accessor :condicao
end

describe HaveCondicaoPagamentoTest do
	subject { HaveCondicaoPagamentoTest.new(condicao_pagamento: condicao_pagamento) }
	let(:condicao_pagamento) { BrNfe::CondicaoPagamento.new }

	it 'deve_iniciar_o_condicao_pagamento_com_nil' do
		subject.class.new.condicao_pagamento.must_be_nil
	end

	it 'se_tiver_condicao_pagamento_posso_setalo_como_nil' do
		subject.condicao_pagamento.wont_be_nil
		subject.condicao_pagamento = nil
		subject.condicao_pagamento.must_be_nil
	end

	it 'deve_manter_o_objeto_condicao_pagamento_se_ja_tiver' do
		subject.condicao_pagamento.must_equal condicao_pagamento
		condicao_pagamento.condicao = 'nova-www'
		subject.condicao_pagamento.condicao.must_equal 'nova-www'
	end

	it 'Se_setar_o_condicao_pagamento_com_outra_class_deve_ignorar' do
		subject.condicao_pagamento = 7777
		subject.condicao_pagamento.must_equal condicao_pagamento
	end

	it 'posso_setar_o_condicao_pagamento_com_um_hash_com_os_parametros_do_condicao_pagamento' do
		condicao_pagamento.assign_attributes(condicao: '123456')
		subject.condicao_pagamento = {condicao: '99999'}
		subject.condicao_pagamento.condicao.must_equal '99999' 
	end

	it 'ao_setar_um_condicao_pagamento_com_um_hash_e_nao_tiver_um_condicao_pagamento_deve_instanciar_um_com_os_parametros' do
		subject.condicao_pagamento = nil
		subject.condicao_pagamento = {condicao: '99999'}
		subject.condicao_pagamento.condicao.must_equal '99999' 
	end

	it 'posso_setar_o_condicao_pagamento_com_um_bloco' do
		condicao_pagamento.assign_attributes(condicao: '123456')
		subject.condicao_pagamento do |address|
			address.condicao =        '99999'
		end
		subject.condicao_pagamento.condicao.must_equal '99999' 
	end

	it 'ao_setar_um_condicao_pagamento_com_um_bloco_e_nao_tiver_um_condicao_pagamento_deve_instanciar_um_com_os_parametros' do
		subject.condicao_pagamento = nil
		subject.condicao_pagamento do |address|
			address.condicao =        '99999'
		end
		subject.condicao_pagamento.condicao.must_equal '99999' 
	end

	it 'posso_mudar_o_objeto_condicao_pagamento' do
		novo_condicao_pagamento = FactoryGirl.build(:condicao_pagamento)
		subject.condicao_pagamento = novo_condicao_pagamento
		subject.condicao_pagamento.must_equal novo_condicao_pagamento
	end

	it 'posso_modificar_a_class_do_condicao_pagamento' do
		BrNfe.condicao_pagamento_class = NewClassCondicaoPagamento
		novo_objeto = subject.class.new(condicao_pagamento: {condicao: '123'})
		novo_objeto.condicao_pagamento.class.must_equal NewClassCondicaoPagamento
		BrNfe.condicao_pagamento_class = BrNfe::CondicaoPagamento
	end
end
