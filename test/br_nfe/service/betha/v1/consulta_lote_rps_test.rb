require 'test_helper'

describe BrNfe::Service::Betha::V1::ConsultaLoteRps do
	subject             { FactoryGirl.build(:servico_betha_consulta_lote_rps, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::V1::Gateway }
	end

	describe "validations" do
		it { must validate_presence_of(:protocolo) }
	end

	describe "#url_wsdl" do
		context "for env production" do
			it { subject.url_wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/consultarLoteRps?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.url_wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/consultarLoteRps?wsdl' }
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
		prestador = content_xml[:'ns1:consultar_lote_rps_envio'][:prestador]
		
		prestador[:cnpj].must_equal '12345678901234'
		prestador[:inscricao_municipal].must_be_nil
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_lote_rps_envio }
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/betha/v1/xsd' }
				
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('servico_consultar_lote_rps_envio_v01.xsd'))
					document = Nokogiri::XML(subject.content_xml)
					errors = schema.validate(document)
					errors.must_be_empty
				end
			end
		end
	end

	describe "#request and set response" do
		before do 
			savon.mock!
			stub_request(:get, subject.url_wsdl).to_return(status: 200, body: read_fixture('service/wsdl/betha/v1/consultar_lote_rps.xml') )
		end
		after  { savon.unmock! }

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = read_fixture('service/response/betha/v1/consulta_lote_rps/fault.xml')
			
			savon.expects(:consultar_lote_rps_envio).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaLoteRps
			response.status.must_equal :falied
			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal     'E10'
			response.error_messages[0][:message].must_equal  'RPS já informado.'
			response.error_messages[0][:solution].must_equal 'Para essa Inscrição Municipal/CNPJ já existe um RPS informado com o mesmo número, série e tipo.'
			response.successful_request?.must_equal true
		end

		it "Quando encontrar uma nota fiscal com as informações preenchidas" do
			fixture = read_fixture('service/response/betha/v1/consulta_lote_rps/success.xml')
			savon.expects(:consultar_lote_rps_envio).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaLoteRps
			response.notas_fiscais.size.must_equal 1
			response.status.must_equal :success
			response.successful_request?.must_equal true

			nf = response.notas_fiscais[0]
			nf.numero_nf.must_equal '4'
			nf.codigo_verificacao.must_equal 'E6E7686366'
			nf.data_emissao.must_equal DateTime.parse('2016-09-08T10:03:16.850-03:00')
			nf.url_nf.must_equal 'http://e-gov.betha.com.br/e-nota/visualizarnotaeletronica?link=XXXXXXXXXXXXX'
			nf.xml_nf[0..89].must_equal '<ConsultarLoteRpsResposta><ListaNfse><ComplNfse><Nfse><InfNfse><Numero>4</Numero><CodigoVe'
			nf.rps_numero.must_equal '3146'
			nf.rps_serie.must_equal 'SN'
			nf.rps_tipo.must_equal '1'
			nf.rps_situacao.must_be_nil
			nf.rps_substituido_numero.must_be_nil
			nf.rps_substituido_serie.must_be_nil
			nf.rps_substituido_tipo.must_be_nil
			nf.data_emissao_rps.must_equal DateTime.parse('2016-09-08T10:02:00-03:00')
			nf.competencia.must_equal DateTime.parse('2016-09-01T00:00:00-03:00')
			nf.natureza_operacao.must_equal '1'
			nf.regime_especial_tributacao.must_be_nil
			nf.optante_simples_nacional.must_equal '1'
			nf.incentivador_cultural.must_be_nil
			nf.outras_informacoes.must_equal 'http://e-gov.betha.com.br/e-nota/visualizarnotaeletronica?link=XXXXXXXXXXXXX'
			nf.item_lista_servico.must_equal '0107'
			nf.cnae_code.must_equal '6202300'
			nf.description.must_equal '1 TESTE WEBSERVICE: R$ 5,00'
			nf.codigo_municipio.must_equal '4204202'
			nf.valor_total_servicos.must_equal '349'
			nf.iss_retido.must_equal '2'
			nf.total_iss.must_equal '0'
			nf.base_calculo.must_equal '349'
			nf.iss_aliquota.must_equal '2.0000'
			nf.valor_liquido.must_be_nil
			nf.deducoes.must_equal '0'
			nf.valor_pis.must_be_nil
			nf.valor_cofins.must_be_nil
			nf.valor_inss.must_be_nil
			nf.valor_ir.must_be_nil
			nf.valor_csll.must_be_nil
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

			nf.destinatario.cpf_cnpj.must_equal '12345678901234'		
		end
	end
end