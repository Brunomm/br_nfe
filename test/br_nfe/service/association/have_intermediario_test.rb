require 'test_helper'

class HaveIntermediarioTest < BrNfe::ActiveModelBase
	include BrNfe::Service::Association::HaveIntermediario	
end
class NewClassIntermediario < BrNfe::Person
end

describe HaveIntermediarioTest do
	subject { HaveIntermediarioTest.new(intermediario: intermediario) }
	let(:intermediario) { BrNfe::Intermediario.new } 

	it 'deve_iniciar_o_intermediario_com_nil' do
		subject.class.new.intermediario.must_be_nil
	end

	it 'se_tiver_intermediario_posso_setalo_como_nil' do
		subject.intermediario.wont_be_nil
		subject.intermediario = nil
		subject.intermediario.must_be_nil
	end

	it 'deve_manter_o_objeto_intermediario_se_ja_tiver' do
		subject.intermediario.must_equal intermediario
		intermediario.cpf_cnpj = '00888888812345'
		subject.intermediario.cpf_cnpj.must_equal '00888888812345'
	end

	it 'Se_setar_o_intermediario_com_outra_class_deve_ignorar' do
		subject.intermediario = 7777
		subject.intermediario.must_equal intermediario
	end

	it 'posso_setar_o_intermediario_com_um_hash_com_os_parametros_do_intermediario' do
		intermediario.assign_attributes(cpf_cnpj: '123456', razao_social: '123465')
		subject.intermediario = {cpf_cnpj: '12345678901', razao_social: '654389'}
		subject.intermediario.cpf_cnpj.must_equal '12345678901' 
		subject.intermediario.razao_social.must_equal '654389'
	end

	it 'ao_setar_um_intermediario_com_um_hash_e_nao_tiver_um_intermediario_deve_instanciar_um_com_os_parametros' do
		subject.intermediario = nil
		subject.intermediario = {cpf_cnpj: '12345678901234', razao_social: '654389'}
		subject.intermediario.cpf_cnpj.must_equal '12345678901234' 
		subject.intermediario.razao_social.must_equal '654389'
	end

	it 'posso_setar_o_intermediario_com_um_bloco' do
		intermediario.assign_attributes(cpf_cnpj: '123456', razao_social: '11111')
		subject.intermediario do |address|
			address.cpf_cnpj =        '12345678901234'
			address.razao_social = '11111'
		end
		subject.intermediario.cpf_cnpj.must_equal '12345678901234' 
		subject.intermediario.razao_social.must_equal '11111'
	end

	it 'ao_setar_um_intermediario_com_um_bloco_e_nao_tiver_um_intermediario_deve_instanciar_um_com_os_parametros' do
		subject.intermediario = nil
		subject.intermediario do |address|
			address.cpf_cnpj =        '12345678901234'
			address.razao_social = '11111'
		end
		subject.intermediario.cpf_cnpj.must_equal '12345678901234' 
		subject.intermediario.razao_social.must_equal '11111'
	end

	it 'posso_mudar_o_objeto_intermediario' do
		novo_intermediario = FactoryGirl.build(:intermediario)
		subject.intermediario = novo_intermediario
		subject.intermediario.must_equal novo_intermediario
	end

	it 'posso_modificar_a_class_do_intermediario' do
		BrNfe.intermediario_service_class = NewClassIntermediario
		novo_objeto = subject.class.new(intermediario: {cpf_cnpj: '123'})
		novo_objeto.intermediario.class.must_equal NewClassIntermediario
		BrNfe.intermediario_service_class = BrNfe::Service::Intermediario
	end
end