
module BrNfeTest
	module HelperTest
		module HaveRpsTest
			class NewRps < BrNfe::Service::Rps
			end

			def test_HaveRpsTest_Já_inicia_com_um_rps
				subject.class.new.rps.class.must_equal BrNfe::Service::Rps
			end

			def test_HaveRpsTest_Mesmo_setando_o_endereço_como_nil_retorna_um_novo_rps
				subject.rps = nil
				subject.rps.class.must_equal BrNfe::Service::Rps
				subject.rps.class.wont_equal rps
			end

			def test_HaveRpsTest_deve_manter_o_objeto_rps_se_ja_tiver
				subject.rps.must_equal rps
				rps.numero = 'nova-www'
				subject.rps.numero.must_equal 'nova-www'
			end

			def test_HaveRpsTest_Se_setar_o_rps_com_outra_class_deve_ignorar
				subject.rps = 7777
				subject.rps.must_equal rps
			end

			def test_HaveRpsTest_posso_setar_o_rps_com_um_hash_com_os_parametros_do_endereço
				rps.assign_attributes(numero: '123456', serie: 'SN')
				subject.rps = {numero: '99999', serie: 'sss'}
				subject.rps.numero.must_equal '99999' 
				subject.rps.serie.must_equal 'sss'
			end

			def test_HaveRpsTest_posso_setar_o_rps_com_um_bloco
				rps.assign_attributes(numero: '123456', serie: 'SN')
				subject.rps do |obj_rps|
					obj_rps.numero =        '99999'
					obj_rps.serie = 'sss'
				end
				subject.rps.numero.must_equal '99999' 
				subject.rps.serie.must_equal 'sss'
			end

			def test_HaveRpsTest_posso_mudar_o_objeto_rps
				novo_rps = FactoryGirl.build(:br_nfe_rps)
				subject.rps = novo_rps
				subject.rps.must_equal novo_rps
			end

			def test_HaveRpsTest_posso_modificar_a_class_do_rps
				BrNfe.rps_class = NewRps
				subject.rps.class.must_equal NewRps
				BrNfe.rps_class = BrNfe::Service::Rps
			end
		end
	end
end