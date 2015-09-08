
module BrNfeTest
	module HelperTest
		module HaveIntermediarioTest
			class NewClassIntermediario < BrNfe::Servico::Intermediario
			end

			def test_HaveIntermediarioTest_deve_iniciar_o_intermediario_com_nil
				subject.class.new.intermediario.must_be_nil
			end

			def test_HaveIntermediarioTest_se_tiver_intermediario_posso_setalo_como_nil
				subject.intermediario.wont_be_nil
				subject.intermediario = nil
				subject.intermediario.must_be_nil
			end

			def test_HaveIntermediarioTest_deve_manter_o_objeto_intermediario_se_ja_tiver
				subject.intermediario.must_equal intermediario
				intermediario.cpf_cnpj = 'nova-www'
				subject.intermediario.cpf_cnpj.must_equal 'nova-www'
			end

			def test_HaveIntermediarioTest_Se_setar_o_intermediario_com_outra_class_deve_ignorar
				subject.intermediario = 7777
				subject.intermediario.must_equal intermediario
			end

			def test_HaveIntermediarioTest_posso_setar_o_intermediario_com_um_hash_com_os_parametros_do_intermediario
				intermediario.assign_attributes(cpf_cnpj: '123456', razao_social: '123465')
				subject.intermediario = {cpf_cnpj: '99999', razao_social: '654389'}
				subject.intermediario.cpf_cnpj.must_equal '99999' 
				subject.intermediario.razao_social.must_equal '654389'
			end

			def test_HaveIntermediarioTest_ao_setar_um_intermediario_com_um_hash_e_nao_tiver_um_intermediario_deve_instanciar_um_com_os_parametros
				subject.intermediario = nil
				subject.intermediario = {cpf_cnpj: '99999', razao_social: '654389'}
				subject.intermediario.cpf_cnpj.must_equal '99999' 
				subject.intermediario.razao_social.must_equal '654389'
			end

			def test_HaveIntermediarioTest_posso_setar_o_intermediario_com_um_bloco
				intermediario.assign_attributes(cpf_cnpj: '123456', razao_social: '11111')
				subject.intermediario do |address|
					address.cpf_cnpj =        '99999'
					address.razao_social = '11111'
				end
				subject.intermediario.cpf_cnpj.must_equal '99999' 
				subject.intermediario.razao_social.must_equal '11111'
			end

			def test_HaveIntermediarioTest_ao_setar_um_intermediario_com_um_bloco_e_nao_tiver_um_intermediario_deve_instanciar_um_com_os_parametros
				subject.intermediario = nil
				subject.intermediario do |address|
					address.cpf_cnpj =        '99999'
					address.razao_social = '11111'
				end
				subject.intermediario.cpf_cnpj.must_equal '99999' 
				subject.intermediario.razao_social.must_equal '11111'
			end

			def test_HaveIntermediarioTest_posso_mudar_o_objeto_intermediario
				novo_intermediario = FactoryGirl.build(:intermediario)
				subject.intermediario = novo_intermediario
				subject.intermediario.must_equal novo_intermediario
			end

			def test_HaveIntermediarioTest_posso_modificar_a_class_do_intermediario
				BrNfe.intermediario_class = NewClassIntermediario
				novo_objeto = subject.class.new(intermediario: {cpf_cnpj: '123'})
				novo_objeto.intermediario.class.must_equal NewClassIntermediario
				BrNfe.intermediario_class = BrNfe::Servico::Intermediario
			end			
		end
	end
end