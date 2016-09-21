require 'test_helper'

class HaveRpsTest < BrNfe::ActiveModelBase
	include BrNfe::Service::Association::HaveRps	
end
class NewClassRps < BrNfe::Person
end

describe HaveRpsTest do
	subject { HaveRpsTest.new(rps: rps) }
	let(:rps) { BrNfe::Service::Rps.new }

	it 'Já_inicia_com_um_rps' do
		subject.class.new.rps.must_be_kind_of BrNfe::Service::Rps
	end

	it 'Mesmo_setando_o_endereço_como_nil_retorna_um_novo_rps' do
		subject.rps = nil
		subject.rps.must_be_kind_of BrNfe::Service::Rps
		subject.rps.class.wont_equal rps
	end

	it 'deve_manter_o_objeto_rps_se_ja_tiver' do
		subject.rps.must_equal rps
		rps.numero = 'nova-www'
		subject.rps.numero.must_equal 'nova-www'
	end

	it 'Se_setar_o_rps_com_outra_class_deve_ignorar' do
		subject.rps = 7777
		subject.rps.must_equal rps
	end

	it 'posso_setar_o_rps_com_um_hash_com_os_parametros_do_endereço' do
		rps.assign_attributes(numero: '123456', serie: 'SN')
		subject.rps = {numero: '99999', serie: 'sss'}
		subject.rps.numero.must_equal '99999' 
		subject.rps.serie.must_equal 'sss'
	end

	it 'posso_setar_o_rps_com_um_bloco' do
		rps.assign_attributes(numero: '123456', serie: 'SN')
		subject.rps do |obj_rps|
			obj_rps.numero =        '99999'
			obj_rps.serie = 'sss'
		end
		subject.rps.numero.must_equal '99999' 
		subject.rps.serie.must_equal 'sss'
	end

	it 'posso_mudar_o_objeto_rps' do
		novo_rps = FactoryGirl.build(:br_nfe_rps)
		subject.rps = novo_rps
		subject.rps.must_equal novo_rps
	end

	it 'posso_modificar_a_class_do_rps' do
		BrNfe.rps_class = NewClassRps
		subject.rps.must_be_kind_of NewClassRps
		BrNfe.rps_class = BrNfe::Service::Rps
	end
end