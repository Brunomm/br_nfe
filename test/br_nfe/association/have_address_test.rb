require 'test_helper'

class HaveAddressTest < BrNfe::ActiveModelBase
	include BrNfe::Association::HaveAddress	
end
class NewClassEndereco < BrNfe::ActiveModelBase
end

describe HaveAddressTest do
	subject { HaveAddressTest.new(endereco: endereco) }
	let(:endereco) { BrNfe::Endereco.new } 

	it 'Já_inicia_com_um_endereco' do
		subject.class.new.endereco.class.must_equal BrNfe::Endereco
	end

	it 'Mesmo_setando_o_endereço_como_nil_retorna_um_novo_endereco' do
		subject.endereco = nil
		subject.endereco.must_be_kind_of BrNfe::Endereco
	end

	it 'deve_manter_o_objeto_endereco_se_ja_tiver' do
		subject.endereco.must_equal endereco
		endereco.cep = 'nova-www'
		subject.endereco.cep.must_equal 'nova-www'
	end

	it 'Se_setar_o_endereco_com_outra_class_deve_ignorar' do
		subject.endereco = 7777
		subject.endereco.must_equal endereco
	end

	it 'posso_setar_o_endereco_com_um_hash_com_os_parametros_do_endereço' do
		endereco.assign_attributes(cep: '123456', logradouro: :rua_1, uf: :sc)
		subject.endereco = {cep: '99999', logradouro: :rua_2, uf: :rs}
		subject.endereco.cep.must_equal '99999' 
		subject.endereco.logradouro.must_equal 'RUA_2'
		subject.endereco.uf.must_equal  :rs
	end

	it 'posso_setar_o_endereco_com_um_bloco' do
		endereco.assign_attributes(cep: '123456', logradouro: :rua_1, uf: :sc)
		subject.endereco do |address|
			address.cep =        '99999'
			address.logradouro = :rua_2
			address.uf =         :rs
		end
		subject.endereco.cep.must_equal '99999' 
		subject.endereco.logradouro.must_equal 'RUA_2'
		subject.endereco.uf.must_equal  :rs
	end

	it 'posso_mudar_o_objeto_endereco' do
		novo_endereco = FactoryGirl.build(:endereco)
		subject.endereco = novo_endereco
		subject.endereco.must_equal novo_endereco
	end

	it 'posso_modificar_a_class_do_address' do
		BrNfe.endereco_class = NewClassEndereco
		subject.endereco.class.must_equal NewClassEndereco
		BrNfe.endereco_class = BrNfe::Endereco
	end
end