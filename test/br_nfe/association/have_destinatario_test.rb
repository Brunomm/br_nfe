require 'test_helper'

class HaveDestinatarioTest < BrNfe::ActiveModelBase
	include BrNfe::Association::HaveDestinatario	
end
class NewClassDestinatario < BrNfe::Person
end

describe HaveDestinatarioTest do
	subject { HaveDestinatarioTest.new(destinatario: destinatario) }
	let(:destinatario) { BrNfe::Person.new } 

	before do
		HaveDestinatarioTest.any_instance.stubs(:destinatario_class).returns(BrNfe::Person)
	end
	it 'Já_inicia_com_um_destinatario' do
		subject.class.new.destinatario.class.must_equal BrNfe::Person
	end

	it 'Mesmo_setando_o_destinatario_como_nil_retorna_um_novo_destinatario' do
		destinatario
		subject.destinatario = nil
		subject.destinatario.class.must_equal BrNfe::Person
		subject.destinatario.wont_equal destinatario
	end

	it 'deve_manter_o_objeto_destinatario_se_ja_tiver' do
		subject.destinatario.must_equal destinatario
		destinatario.cpf_cnpj = '1234567890'
		subject.destinatario.cpf_cnpj.must_equal '01234567890'
	end

	it 'Se_setar_o_destinatario_com_outra_class_deve_ignorar' do
		subject.destinatario = 7777
		subject.destinatario.must_equal destinatario
	end

	it 'posso_setar_o_destinatario_com_um_hash_com_os_parametros_do_destinatario' do
		destinatario.assign_attributes(cpf_cnpj: '12345678901', telefone: '123465', email: 'mail@mail.com')
		subject.destinatario = {cpf_cnpj: '12345678901', telefone: '654389', email: 'mail2'}
		subject.destinatario.cpf_cnpj.must_equal '12345678901' 
		subject.destinatario.telefone.must_equal '654389'
		subject.destinatario.email.must_equal  'mail2'
	end

	it 'posso_setar_o_destinatario_com_um_bloco' do
		destinatario.assign_attributes(cpf_cnpj: '12345678901', telefone: '11111', email: 'mail1')
		subject.destinatario do |address|
			address.cpf_cnpj =        '99999999999'
			address.telefone = '11111'
			address.email =         'mail1'
		end
		subject.destinatario.cpf_cnpj.must_equal '99999999999' 
		subject.destinatario.telefone.must_equal '11111'
		subject.destinatario.email.must_equal  'mail1'
	end

	it 'posso_mudar_o_objeto_destinatario' do
		novo_destinatario = FactoryGirl.build(:service_destinatario)
		subject.destinatario = novo_destinatario
		subject.destinatario.must_equal novo_destinatario
	end
	
	it 'posso_modificar_a_class_do_destinatario através do método destinatario_class' do		
		HaveDestinatarioTest.any_instance.stubs(:destinatario_class).returns(NewClassDestinatario)
		novo_objeto = subject.class.new
		novo_objeto.destinatario.class.must_equal NewClassDestinatario		
	end

	it "por padrão a class destinatario_class deve retornar uma exceção" do
		HaveDestinatarioTest.any_instance.unstub(:destinatario_class)
		assert_raises RuntimeError do
			subject.destinatario_class
		end
	end
end