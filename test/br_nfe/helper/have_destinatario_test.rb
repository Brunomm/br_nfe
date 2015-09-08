
module BrNfeTest
	module HelperTest
		module HaveDestinatarioTest
			class NewClassDestinatario < BrNfe::Destinatario
			end

			def test_HaveDestinatarioTest_Já_inicia_com_um_destinatario
				subject.class.new.destinatario.class.must_equal BrNfe::Destinatario
			end

			def test_HaveDestinatarioTest_Mesmo_setando_o_destinatario_como_nil_retorna_um_novo_destinatario
				destinatario
				subject.destinatario = nil
				subject.destinatario.class.must_equal BrNfe::Destinatario
				subject.destinatario.wont_equal destinatario
			end

			def test_HaveDestinatarioTest_deve_manter_o_objeto_destinatario_se_ja_tiver
				subject.destinatario.must_equal destinatario
				destinatario.cpf_cnpj = 'nova-www'
				subject.destinatario.cpf_cnpj.must_equal 'nova-www'
			end

			def test_HaveDestinatarioTest_Se_setar_o_destinatario_com_outra_class_deve_ignorar
				subject.destinatario = 7777
				subject.destinatario.must_equal destinatario
			end

			def test_HaveDestinatarioTest_posso_setar_o_destinatario_com_um_hash_com_os_parametros_do_destinatario
				destinatario.assign_attributes(cpf_cnpj: '123456', telefone: '123465', email: 'mail@mail.com')
				subject.destinatario = {cpf_cnpj: '99999', telefone: '654389', email: 'mail2'}
				subject.destinatario.cpf_cnpj.must_equal '99999' 
				subject.destinatario.telefone.must_equal '654389'
				subject.destinatario.email.must_equal  'mail2'
			end

			def test_HaveDestinatarioTest_posso_setar_o_destinatario_com_um_bloco
				destinatario.assign_attributes(cpf_cnpj: '123456', telefone: '11111', email: 'mail1')
				subject.destinatario do |address|
					address.cpf_cnpj =        '99999'
					address.telefone = '11111'
					address.email =         'mail1'
				end
				subject.destinatario.cpf_cnpj.must_equal '99999' 
				subject.destinatario.telefone.must_equal '11111'
				subject.destinatario.email.must_equal  'mail1'
			end

			def test_HaveDestinatarioTest_posso_mudar_o_objeto_destinatario
				novo_destinatario = FactoryGirl.build(:destinatario)
				subject.destinatario = novo_destinatario
				subject.destinatario.must_equal novo_destinatario
			end

			def test_HaveDestinatarioTest_posso_modificar_a_class_do_destinatario
				BrNfe.destinatario_class = NewClassDestinatario
				novo_objeto = subject.class.new
				novo_objeto.destinatario.class.must_equal NewClassDestinatario
				BrNfe.destinatario_class = BrNfe::Destinatario
			end			
		end
	end
end