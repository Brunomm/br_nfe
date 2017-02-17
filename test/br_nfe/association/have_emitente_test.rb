require 'test_helper'

class HaveEmitenteTest < BrNfe::ActiveModelBase
	include BrNfe::Association::HaveEmitente	
end
class NewClassEmitente < BrNfe::Person
end

describe HaveEmitenteTest do
	subject { HaveEmitenteTest.new(emitente: emitente) }
	let(:emitente) { BrNfe::Person.new } 

	before do
		HaveEmitenteTest.any_instance.stubs(:emitente_class).returns(BrNfe::Person)
	end

	it 'por padrão Já_inicia_com_um_emitente' do
		subject.class.new.emitente.must_be_kind_of BrNfe::Person
	end

	it 'Mesmo_setando_o_emitente_como_nil_retorna_um_novo_emitente' do
		subject.emitente = nil
		subject.emitente.must_be_kind_of BrNfe::Person
		subject.emitente.wont_equal emitente
	end

	it 'deve_manter_o_objeto_emitente_se_ja_tiver' do
		subject.emitente.must_equal emitente
		emitente.cnpj = '99999999999'
		subject.emitente.cnpj.must_equal '99999999999'
	end

	it 'Se_setar_o_emitente_com_outra_class_deve_ignorar' do
		subject.emitente = 7777
		subject.emitente.must_equal emitente
	end

	it 'posso_setar_o_emitente_com_um_hash_com_os_parametros_do_emitente' do
		emitente.assign_attributes(razao_social: 'JOAO', cnpj: '123456', telefone: '123465', email: 'mail@mail.com')
		subject.emitente = {cnpj: '33664455778899', telefone: '654389', email: 'mail2'}
		subject.emitente.cnpj.must_equal '33664455778899' 
		subject.emitente.telefone.must_equal '654389'
		subject.emitente.email.must_equal  'mail2'
		subject.emitente.razao_social.must_equal  'JOAO'
	end

	it 'posso_setar_o_emitente_com_um_bloco' do
		emitente.assign_attributes(razao_social: 'JOAO', cnpj: '123456', telefone: '11111', email: 'mail1')
		subject.emitente do |address|
			address.cnpj =        '99999999999'
			address.telefone = '11111'
			address.email =         'mail1'
		end
		subject.emitente.cnpj.must_equal '99999999999' 
		subject.emitente.telefone.must_equal '11111'
		subject.emitente.email.must_equal  'mail1'
		subject.emitente.razao_social.must_equal  'JOAO'
	end

	it 'posso_mudar_o_objeto_emitente' do
		subject.emitente.wont_be_nil
		novo_emitente = BrNfe::Person.new
		subject.emitente = novo_emitente
		subject.emitente.must_equal novo_emitente
	end

	it 'posso_modificar_a_class_do_emitente através do método emitente_class' do		
		HaveEmitenteTest.any_instance.stubs(:emitente_class).returns(NewClassEmitente)
		novo_objeto = subject.class.new
		novo_objeto.emitente.class.must_equal NewClassEmitente		
	end

	it "por padrão a class emitente_class deve retornar uma exceção" do
		HaveEmitenteTest.any_instance.unstub(:emitente_class)
		assert_raises RuntimeError do
			subject.emitente_class
		end
	end
	
end