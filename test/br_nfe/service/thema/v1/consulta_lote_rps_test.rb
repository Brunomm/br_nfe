require 'test_helper'

describe BrNfe::Service::Thema::V1::ConsultaLoteRps do
	subject             { FactoryGirl.build(:service_thema_v1_consulta_lote_rps, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }

	it { must validate_presence_of(:protocolo) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Thema::V1::Base }
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_lote_rps }
	end

	it "#soap_body_root_tag" do
		subject.soap_body_root_tag.must_equal 'consultarLoteRps'
	end

	describe "#url_wsdl" do
		it "default" do
			subject.ibge_code_of_issuer_city = '111'
			subject.env = :production
			subject.url_wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl'
			subject.env = :test
			subject.url_wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl'
		end
		describe 'Para a cidade 4205902 - Gaspar-SC' do
			before { subject.ibge_code_of_issuer_city = '4205902' }
			it "ambiente de produção" do
				subject.env = :production
				subject.url_wsdl.must_equal 'http://nfse.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.url_wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl'
			end			
		end	 	
	end
	
	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/thema/v1/xsd' }
				
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('nfse.xsd'))
					document = Nokogiri::XML(subject.xml_builder)
					errors = schema.validate(document)
					errors.must_be_empty
				end
			end
		end
	end

	describe "#request and set response" do
		before do 
			savon.mock!
			stub_request(:get, subject.url_wsdl).to_return(status: 200, body: read_fixture('service/wsdl/thema/v1/nfse_consulta.xml') )
		end
		after  { savon.unmock! }

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = read_fixture('service/response/thema/v1/consulta_lote_rps/fault.xml')
			
			savon.expects(:consultar_lote_rps).returns(fixture)
			subject.request
			response = subject.response

			response.status.must_equal :falied
			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal 'E86'
			response.error_messages[0][:message].must_equal 'Número do protocolo de recebimento do lote inexistente na base de dados'
			response.error_messages[0][:solution].must_equal 'Confira se o lote foi enviado e informe o número correto do protocolo de recebimento.'
			response.successful_request?.must_equal true
		end

		it "Quando encontrar uma nota fiscal com as informações completas" do
			fixture = read_fixture('service/response/thema/v1/consulta_lote_rps/nfse_complete.xml')
			savon.expects(:consultar_lote_rps).returns(fixture)
			subject.request
			response = subject.response

			nf = response.notas_fiscais[0]
			nf.numero_nf.must_equal '201600000000003'
			nf.codigo_verificacao.must_equal '1004156850'
			nf.data_emissao.must_equal DateTime.parse('2016-08-12T20:02:36.000Z')
			nf.url_nf.must_be_nil
			nf.xml_nf[0..89].must_equal '<ConsultarLoteRpsResposta xmlns="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"><Lista'
			nf.rps_numero.must_equal '15'
			nf.rps_serie.must_equal 'SN'
			nf.rps_tipo.must_equal '1'
			nf.rps_situacao.must_be_nil
			nf.rps_substituido_numero.must_be_nil
			nf.rps_substituido_serie.must_be_nil
			nf.rps_substituido_tipo.must_be_nil
			nf.data_emissao_rps.must_equal Date.parse('2016-08-12Z')
			nf.competencia.must_equal DateTime.parse('2016-08-12T00:00:00.000Z')
			nf.natureza_operacao.must_equal '59'
			nf.regime_especial_tributacao.must_equal '1'
			nf.optante_simples_nacional.must_equal '1'
			nf.incentivador_cultural.must_equal '0'
			nf.outras_informacoes.must_be_nil
			nf.item_lista_servico.must_equal '107'
			nf.cnae_code.must_equal '6202300'
			nf.description.must_equal '1 TESTE WEBSERVICE: R$ 5,00'
			nf.codigo_municipio.must_equal '4204202'
			nf.valor_total_servicos.must_equal '1700'
			nf.iss_retido.must_equal '2'
			nf.total_iss.must_equal '33.72'
			nf.base_calculo.must_equal '1685.88'
			nf.iss_aliquota.must_equal '0.02'
			nf.valor_liquido.must_equal '1663.02'
			nf.deducoes.must_equal '7'
			nf.valor_pis.must_equal '1.12'
			nf.valor_cofins.must_equal '2.12'
			nf.valor_inss.must_equal '3.12'
			nf.valor_ir.must_equal '4.12'
			nf.valor_csll.must_equal '5.12'
			nf.outras_retencoes.must_equal '6.12'
			nf.desconto_condicionado.must_equal '8.12'
			nf.desconto_incondicionado.must_equal '7.12'
			nf.responsavel_retencao.must_be_nil
			nf.numero_processo.must_be_nil
			nf.orgao_gerador_municipio.must_equal '4205902'
			nf.orgao_gerador_uf.must_equal 'SC'
			nf.cancelamento_codigo.must_be_nil
			nf.cancelamento_numero_nf.must_be_nil
			nf.cancelamento_cnpj.must_be_nil
			nf.cancelamento_inscricao_municipal.must_be_nil
			nf.cancelamento_municipio.must_be_nil
			nf.cancelamento_data_hora.must_be_nil
			nf.cancelamento_sucesso.must_equal false
			nf.nfe_substituidora.must_be_nil
			
			nf.emitente.cnpj.must_equal '65978078000120'
			nf.emitente.inscricao_municipal.must_equal '11849'
			nf.emitente.razao_social.must_equal 'EMPRESA EMITENTE LTDA'
			nf.emitente.nome_fantasia.must_equal 'EMITENTE'
			nf.emitente.telefone.must_equal '3326891'
			nf.emitente.email.must_equal 'emitente@gmail.com'

			nf.emitente.endereco.logradouro.must_equal 'DOUGLAS ALEXANDRE'
			nf.emitente.endereco.numero.must_equal '50'
			nf.emitente.endereco.complemento.must_equal ''
			nf.emitente.endereco.bairro.must_equal 'CENTRO'
			nf.emitente.endereco.codigo_municipio.must_equal '4205902'
			nf.emitente.endereco.uf.must_equal 'SC'
			nf.emitente.endereco.cep.must_equal '89110000'

			nf.destinatario.cpf_cnpj.must_equal '08670364000'
			nf.destinatario.inscricao_municipal.must_be_nil
			nf.destinatario.inscricao_estadual.must_be_nil
			nf.destinatario.inscricao_suframa.must_be_nil
			nf.destinatario.razao_social.must_equal 'BRUNO MUCELINI MERGEN'
			nf.destinatario.telefone.must_equal '4920493900'
			nf.destinatario.email.must_equal 'brunomergen@gmail.com'

			nf.destinatario.endereco.logradouro.must_equal 'RUA IGUACU E'
			nf.destinatario.endereco.numero.must_equal '587'
			nf.destinatario.endereco.complemento.must_equal ''
			nf.destinatario.endereco.bairro.must_equal 'SAIC'
			nf.destinatario.endereco.codigo_municipio.must_equal '4204202'
			nf.destinatario.endereco.uf.must_equal 'SC'
			nf.destinatario.endereco.cep.must_equal '89802171'
		end
	end
end