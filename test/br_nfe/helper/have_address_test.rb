
module BrNfeTest
	module HelperTest
		module HaveAddressTest
			class Address < BrNfe::Endereco
			end

			def test_HaveAddressTest_Já_inicia_com_um_endereco
				subject.class.new.endereco.class.must_equal BrNfe::Endereco
			end

			def test_HaveAddressTest_Mesmo_setando_o_endereço_como_nil_retorna_um_novo_endereco
				subject.endereco = nil
				subject.endereco.class.must_equal BrNfe::Endereco
				subject.endereco.class.wont_equal endereco
			end

			def test_HaveAddressTest_deve_manter_o_objeto_endereco_se_ja_tiver
				subject.endereco.must_equal endereco
				endereco.cep = 'nova-www'
				subject.endereco.cep.must_equal 'nova-www'
			end

			def test_HaveAddressTest_Se_setar_o_endereco_com_outra_class_deve_ignorar
				subject.endereco = 7777
				subject.endereco.must_equal endereco
			end

			def test_HaveAddressTest_posso_setar_o_endereco_com_um_hash_com_os_parametros_do_endereço
				endereco.assign_attributes(cep: '123456', logradouro: :rua_1, uf: :sc)
				subject.endereco = {cep: '99999', logradouro: :rua_2, uf: :rs}
				subject.endereco.cep.must_equal '99999' 
				subject.endereco.logradouro.must_equal 'RUA_2'
				subject.endereco.uf.must_equal  :rs
			end

			def test_HaveAddressTest_posso_setar_o_endereco_com_um_bloco
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

			def test_HaveAddressTest_posso_mudar_o_objeto_endereco
				novo_endereco = FactoryGirl.build(:endereco)
				subject.endereco = novo_endereco
				subject.endereco.must_equal novo_endereco
			end

			def test_HaveAddressTest_posso_modificar_a_class_do_address
				BrNfe.endereco_class = Address
				subject.endereco.class.must_equal Address
				BrNfe.endereco_class = BrNfe::Endereco
			end			
		end
	end
end