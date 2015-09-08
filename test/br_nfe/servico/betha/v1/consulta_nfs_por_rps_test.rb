require 'test_helper'

describe BrNfe::Servico::Betha::V1::ConsultaNfsPorRps do
	subject             { FactoryGirl.build(:servico_betha_consulta_nfs_por_rps, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:emitente) }
	let(:rps)           { subject.rps } 

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Servico::Betha::V1::Gateway }
	end

	describe "#wsdl" do
		context "for env production" do
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/consultarNfsePorRps?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/consultarNfsePorRps?wsdl' }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_nfse_por_rps }
	end

	describe "rps" do
		it 'Já_inicia_com_um_emitente' do
			subject.class.new.rps.class.must_equal BrNfe::Servico::Rps
		end

		it 'Mesmo_setando_o_rps_como_nil_retorna_um_novo_rps' do
			subject.rps.must_equal rps
			
			subject.rps = nil
			subject.rps.class.must_equal BrNfe::Servico::Rps
			subject.rps.wont_equal rps
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

		it 'posso_setar_o_rps_com_um_hash_com_os_parametros_do_rps' do
			rps.assign_attributes(numero: '123456', serie: '123465', tipo: '1')
			subject.rps = {numero: '99999', serie: '654389', tipo: '2'}
			subject.rps.numero.must_equal '99999' 
			subject.rps.serie.must_equal '654389'
			subject.rps.tipo.must_equal  '2'
		end

		it 'posso_setar_o_rps_com_um_bloco' do
			rps.assign_attributes(numero: '123456', serie: '316531', tipo: '1')
			subject.rps do |address|
				address.numero = '99999'
				address.serie =  '11111'
				address.tipo =   '2'
			end
			subject.rps.numero.must_equal '99999' 
			subject.rps.serie.must_equal '11111'
			subject.rps.tipo.must_equal  '2'
		end

		it 'posso_mudar_o_objeto_rps' do
			novo_rps = FactoryGirl.build(:br_nfe_rps)
			subject.rps = novo_rps
			subject.rps.must_equal novo_rps
		end
	end

	describe "#xml_builder" do
		it "deve adicionar o valor do xml_inf_pedido_cancelamento e assinar o xml" do
			xml = subject.xml_builder.to_s
			xml = Nokogiri::XML xml

			xml.xpath('Temp/Prestador/Cnpj').first.text.must_equal               emitente.cnpj
			xml.xpath('Temp/Prestador/InscricaoMunicipal').first.text.must_equal emitente.inscricao_municipal
			
			xml.xpath('Temp/IdentificacaoRps/Numero').first.text.must_equal rps.numero.to_s
			xml.xpath('Temp/IdentificacaoRps/Serie').first.text.must_equal  rps.serie.to_s
			xml.xpath('Temp/IdentificacaoRps/Tipo').first.text.must_equal   rps.tipo.to_s
		end
	end

	describe "#set_response" do
		let(:hash_response)  { {envelope: {body: {consultar_nfse_por_rps_envio_response: 'valor_hash'} } } }
		let(:response)       { FactoryGirl.build(:response_default) } 
		let(:build_response) { FactoryGirl.build(:betha_v1_build_response) }

		it "deve instanciar um objeto response pelo build_response" do
			res = Object.new
			res.stubs(:hash).returns( hash_response )
			build_response.stubs(:response).returns(response)

			BrNfe::Servico::Betha::V1::BuildResponse.expects(:new).
				with({hash: 'valor_hash', nfe_method: :consultar_nfse_rps}).
				returns(build_response)

			subject.instance_variable_get(:@response).must_be_nil
			
			subject.set_response(res).must_equal response
			subject.instance_variable_get(:@response).must_equal response
		end
	end

end