
module BrNfeTest
	module HelperTest
		module HaveEmitenteTest
			class NewClassEmitente < BrNfe::Emitente
			end

			def test_HaveEmitenteTest_Já_inicia_com_um_emitente
				subject.class.new.emitente.class.must_equal BrNfe::Emitente
			end

			def test_HaveEmitenteTest_Mesmo_setando_o_emitente_como_nil_retorna_um_novo_emitente
				subject.emitente = nil
				subject.emitente.class.must_equal BrNfe::Emitente
				subject.emitente.wont_equal emitente
			end

			def test_HaveEmitenteTest_deve_manter_o_objeto_emitente_se_ja_tiver
				subject.emitente.must_equal emitente
				emitente.cnpj = 'nova-www'
				subject.emitente.cnpj.must_equal 'nova-www'
			end

			def test_HaveEmitenteTest_Se_setar_o_emitente_com_outra_class_deve_ignorar
				subject.emitente = 7777
				subject.emitente.must_equal emitente
			end

			def test_HaveEmitenteTest_posso_setar_o_emitente_com_um_hash_com_os_parametros_do_emitente
				emitente.assign_attributes(cnpj: '123456', telefone: '123465', email: 'mail@mail.com')
				subject.emitente = {cnpj: '99999', telefone: '654389', email: 'mail2'}
				subject.emitente.cnpj.must_equal '99999' 
				subject.emitente.telefone.must_equal '654389'
				subject.emitente.email.must_equal  'mail2'
			end

			def test_HaveEmitenteTest_posso_setar_o_emitente_com_um_bloco
				emitente.assign_attributes(cnpj: '123456', telefone: '11111', email: 'mail1')
				subject.emitente do |address|
					address.cnpj =        '99999'
					address.telefone = '11111'
					address.email =         'mail1'
				end
				subject.emitente.cnpj.must_equal '99999' 
				subject.emitente.telefone.must_equal '11111'
				subject.emitente.email.must_equal  'mail1'
			end

			def test_HaveEmitenteTest_posso_mudar_o_objeto_emitente
				novo_emitente = FactoryGirl.build(:emitente)
				subject.emitente = novo_emitente
				subject.emitente.must_equal novo_emitente
			end

			def test_HaveEmitenteTest_posso_modificar_a_class_do_emitente
				BrNfe.emitente_class = NewClassEmitente
				novo_objeto = subject.class.new
				novo_objeto.emitente.class.must_equal NewClassEmitente
				BrNfe.emitente_class = BrNfe::Emitente
			end			
		end
	end
end