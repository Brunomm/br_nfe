require 'test_helper'

describe BrNfe::Service::Betha::V1::ConsultaNfse do
	subject             { FactoryGirl.build(:servico_betha_consulta_nfse, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::V1::Gateway }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::ConsultaNfse inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::ConsultaNfse
	end

	describe "#url_wsdl" do
		context "for env production" do
			it { subject.url_wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/consultarNfse?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.url_wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/consultarNfse?wsdl' }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_nfse_envio }
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/betha/v1/xsd' }
				
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('servico_consultar_nfse_envio_v01.xsd'))
					document = Nokogiri::XML(subject.content_xml)
					errors = schema.validate(document)
					errors.must_be_empty
				end
			end
		end
	end

	it "não deve adicionar a tag InscricaoMunicipal no XML" do
		# Se emitir uma NFS com InscricaoMunicipal 1234 e no cadastro da prefeitura
		# a InscricaoMunicipal estiver cadastrada como 123-4, a nota vai emitir porém
		# no momento de consultar da erro dizendo que a inscrição municipal não existe
		# para o municipio.
		subject.emitente.inscricao_municipal = '12345'
		subject.emitente.cpf_cnpj = '12345678901234'
		content_xml = Nori.new.parse(subject.content_xml).deep_transform_keys!{|k| k.to_s.underscore.to_sym}
		prestador = content_xml[:'ns1:consultar_nfse_envio'][:prestador]
		
		prestador[:cnpj].must_equal '12345678901234'
		prestador[:inscricao_municipal].must_be_nil
	end

	describe "#request and set response" do
		before do 
			savon.mock!
			stub_request(:get, subject.url_wsdl).to_return(status: 200, body: read_fixture('service/wsdl/betha/v1/consultar_nfse.xml') )
		end
		after  { savon.unmock! }

		it "Se não encontrar nenhuma NFe" do
			fixture = read_fixture('service/response/betha/v1/consulta_nfse/nfs_empty.xml')
			savon.expects(:consultar_nfse_envio).returns(fixture)
			subject.request
			response = subject.response

			response.notas_fiscais.must_be_empty
			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = read_fixture('service/response/betha/v1/consulta_nfse/fault.xml')
			
			savon.expects(:consultar_nfse_envio).returns(fixture)
			subject.request
			response = subject.response

			response.status.must_equal :falied
			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal 'E160'
			response.error_messages[0][:message].must_equal  'Arquivo enviado fora da estrutura do arquivo XML de entrada.'
			response.error_messages[0][:solution].must_equal 'Envie um arquivo dentro do schema do arquivo XML de entrada.'
			response.successful_request?.must_equal true
		end

		it "Quando encontrar uma nota fiscal com as informações básicas preenchidas" do
			fixture = read_fixture('service/response/betha/v1/consulta_nfse/success.xml')
			savon.expects(:consultar_nfse_envio).returns(fixture)
			subject.request
			response = subject.response

			response.notas_fiscais.size.must_equal 1
			response.status.must_equal :success
			response.successful_request?.must_equal true

			nf = response.notas_fiscais[0]
			nf.numero_nf.must_equal '55'
			nf.codigo_verificacao.must_equal 'F0O08ZQ2M'
			nf.data_emissao.must_equal DateTime.parse('2013-12-17T21:39:57.630-02:00')
			nf.url_nf.must_equal 'http://e-gov.betha.com.br/e-nota/visualizarnotaeletronica?id=tQ12313131=='
			nf.xml_nf[0..89].must_equal '<ConsultarNfseResposta><ListaNfse><ComplNfse><Nfse><InfNfse><Numero>55</Numero><CodigoVeri'
			nf.rps_numero.must_equal '22'
			nf.rps_serie.must_equal 'SN'
			nf.rps_tipo.must_equal '1'
			nf.rps_situacao.must_be_nil
			nf.rps_substituido_numero.must_be_nil
			nf.rps_substituido_serie.must_be_nil
			nf.rps_substituido_tipo.must_be_nil
			nf.data_emissao_rps.must_equal DateTime.parse('2013-12-17T00:00:00-02:00')
			nf.competencia.must_equal DateTime.parse('2013-12-01T00:00:00-02:00')
			nf.natureza_operacao.must_equal '1'
			nf.regime_especial_tributacao.must_be_nil
			nf.optante_simples_nacional.must_equal '1'
			nf.incentivador_cultural.must_be_nil
			nf.outras_informacoes.must_equal 'http://e-gov.betha.com.br/e-nota/visualizarnotaeletronica?id=tQ12313131=='
			nf.item_lista_servico.must_equal '0102'
			nf.cnae_code.must_equal '6202300'
			nf.description.must_equal 'Descrição: 1 Video Institucional. 1.600,00'
			nf.codigo_municipio.must_equal '4204202'
			nf.valor_total_servicos.must_equal '1600'
			nf.iss_retido.must_equal '2'
			nf.total_iss.must_equal '0'
			nf.base_calculo.must_equal '1600'
			nf.iss_aliquota.must_equal '2'
			nf.valor_liquido.must_equal '1600'
			nf.deducoes.must_equal '0'
			nf.valor_pis.must_equal '0.00'
			nf.valor_cofins.must_equal '0.00'
			nf.valor_inss.must_equal '0.00'
			nf.valor_ir.must_equal '0.00'
			nf.valor_csll.must_equal '0.00'
			nf.outras_retencoes.must_be_nil
			nf.desconto_condicionado.must_equal '0'
			nf.desconto_incondicionado.must_equal '0'
			nf.responsavel_retencao.must_be_nil
			nf.numero_processo.must_be_nil
			nf.municipio_incidencia.must_be_nil
			nf.orgao_gerador_municipio.must_equal '4204202'
			nf.orgao_gerador_uf.must_equal 'SC'
			nf.cancelamento_codigo.must_be_nil
			nf.cancelamento_numero_nf.must_be_nil
			nf.cancelamento_cnpj.must_be_nil
			nf.cancelamento_inscricao_municipal.must_be_nil
			nf.cancelamento_municipio.must_be_nil
			nf.cancelamento_sucesso.must_equal false
			nf.cancelamento_data_hora.must_be_nil
			nf.nfe_substituidora.must_be_nil
			nf.codigo_obra.must_be_nil
			nf.codigo_art.must_be_nil

			nf.destinatario.cpf_cnpj.must_equal '22222222222222'		
		end
	end
end