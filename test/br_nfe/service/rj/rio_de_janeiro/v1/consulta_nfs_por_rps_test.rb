require 'test_helper'

describe BrNfe::Service::RJ::RioDeJaneiro::V1::ConsultaNfsPorRps do
	subject             { FactoryGirl.build(:service_rj_rj_v1_consulta_nfs_por_rps, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }
	let(:rps)           { subject.rps } 

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::RJ::RioDeJaneiro::V1::Base }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::ConsultaNfsPorRps inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::ConsultaNfsPorRps
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_nfse_por_rps }
	end

	it "#soap_body_root_tag" do
		subject.soap_body_root_tag.must_equal 'ConsultarNfsePorRpsRequest'
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/fixtures/service/schemas/rj/rio_de_janeiro/V1' }
				
		describe "Validações a partir do arquivo XSD" do
			# Só assim para passar na validação XSD.
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('tipos_nfse_v01.xsd'))
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
			stub_request(:get, subject.wsdl).to_return(status: 200, body: read_fixture('service/wsdl/rj/rio_de_janeiro/v1/nfse.asmx.xml') )
		end
		after  { savon.unmock! }

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = read_fixture('service/response/rj/rio_de_janeiro/v1/consulta_nfse_por_rps/fault.xml')
			
			savon.expects(:consultar_nfse_por_rps).returns(fixture)
			subject.request
			response = subject.response

			response.status.must_equal :falied
			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal 'E43'
			response.error_messages[0][:message].must_equal  'Inscrição Municipal do prestador não encontrada na base de dados do município.'
			response.error_messages[0][:solution].must_equal 'Informe a inscrição municipal correta do prestador.'
			response.successful_request?.must_equal true
		end

		it "Quando encontrar uma nota fiscal com as informações básicas preenchidas" do
			fixture = read_fixture('service/response/rj/rio_de_janeiro/v1/consulta_nfse_por_rps/nfse_simple.xml')
			savon.expects(:consultar_nfse_por_rps).returns(fixture)
			subject.request
			response = subject.response

			response.notas_fiscais.size.must_equal 1
			response.status.must_equal :success
			response.successful_request?.must_equal true

			nf = response.notas_fiscais[0]
			nf.numero_nf.must_equal '4'
			nf.codigo_verificacao.must_equal 'E6E7686366'
			nf.data_emissao.must_equal DateTime.parse('2016-07-28T16:17:25.398921')
			nf.url_nf.must_be_nil
			nf.rps_numero.must_equal '10'
			nf.rps_serie.must_equal 'SN'
			nf.rps_tipo.must_equal '1'
			nf.rps_situacao.must_be_nil
			nf.rps_substituido_numero.must_be_nil
			nf.rps_substituido_serie.must_be_nil
			nf.rps_substituido_tipo.must_be_nil
			nf.data_emissao_rps.must_equal Date.parse('2016-07-28')
			nf.competencia.must_equal DateTime.parse('2016-07-28T00:00:00')
			nf.natureza_operacao.must_equal '1'
			nf.regime_especial_tributacao.must_equal '1'
			nf.optante_simples_nacional.must_equal '1'
			nf.incentivador_cultural.must_equal '2'
			nf.outras_informacoes.must_equal 'Info'
			nf.item_lista_servico.must_equal '1.07'
			nf.cnae_code.must_equal '6202300'
			nf.description.must_equal '1 TESTE WEBSERVICE: R$ 5,00'
			nf.codigo_municipio.must_equal '4204202'
			nf.valor_total_servicos.must_equal '10'
			nf.iss_retido.must_equal '2'
			nf.total_iss.must_equal '0.2'
			nf.base_calculo.must_equal '10'
			nf.iss_aliquota.must_equal '3.5'
			nf.valor_liquido.must_equal '10'
			nf.deducoes.must_be_nil
			nf.valor_pis.must_be_nil
			nf.valor_cofins.must_be_nil
			nf.valor_inss.must_be_nil
			nf.valor_ir.must_be_nil
			nf.valor_csll.must_be_nil
			nf.outras_retencoes.must_be_nil
			nf.desconto_condicionado.must_be_nil
			nf.desconto_incondicionado.must_be_nil
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

		it "Quando encontrar uma nota fiscal com as informações completas" do
			fixture = read_fixture('service/response/rj/rio_de_janeiro/v1/consulta_nfse_por_rps/nfse_complete.xml')
			savon.expects(:consultar_nfse_por_rps).returns(fixture)
			subject.request
			response = subject.response

			response.notas_fiscais.size.must_equal 1
			response.status.must_equal :success
			response.successful_request?.must_equal true

			nf = response.notas_fiscais[0]
			nf.numero_nf.must_equal '5'
			nf.codigo_verificacao.must_equal '1EC6119563'
			nf.data_emissao.must_equal DateTime.parse('2016-07-28T23:06:54.088754')
			nf.url_nf.must_be_nil
			nf.rps_numero.must_equal '11'
			nf.rps_serie.must_equal 'SN'
			nf.rps_tipo.must_equal '1'
			nf.rps_situacao.must_be_nil
			nf.rps_substituido_numero.must_be_nil
			nf.rps_substituido_serie.must_be_nil
			nf.rps_substituido_tipo.must_be_nil
			nf.data_emissao_rps.must_equal Date.parse('2016-07-28')
			nf.competencia.must_equal DateTime.parse('2016-07-28T00:00:00')
			nf.natureza_operacao.must_equal '1'
			nf.regime_especial_tributacao.must_equal '1'
			nf.optante_simples_nacional.must_equal '1'
			nf.incentivador_cultural.must_equal '2'
			nf.outras_informacoes.must_be_nil
			nf.item_lista_servico.must_equal '1.07'
			nf.cnae_code.must_equal '6202300'
			nf.description.must_equal '1 TESTE WEBSERVICE: R$ 5,00'
			nf.codigo_municipio.must_equal '4204202'
			nf.valor_total_servicos.must_equal '500'
			nf.iss_retido.must_equal '2'
			nf.total_iss.must_equal '0.2'
			nf.base_calculo.must_equal '10'
			nf.iss_aliquota.must_equal '2'
			nf.valor_liquido.must_equal '463.02'
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
			nf.orgao_gerador_municipio.must_equal '4204202'
			nf.orgao_gerador_uf.must_equal 'SC'
			nf.cancelamento_codigo.must_be_nil
			nf.cancelamento_numero_nf.must_equal '5'
			nf.cancelamento_cnpj.must_equal '23020443000140'
			nf.cancelamento_inscricao_municipal.must_equal '488542'
			nf.cancelamento_municipio.must_equal '4204202'
			nf.cancelamento_sucesso.must_equal true
			nf.cancelamento_data_hora.must_equal DateTime.parse('2016-07-28T23:06:54.392477')
			nf.nfe_substituidora.must_equal '6'
			nf.codigo_obra.must_equal 'VCodigoObra'
			nf.codigo_art.must_equal 'VArt'

			nf.emitente.cnpj.must_equal '23020443000140'
			nf.emitente.inscricao_municipal.must_equal '488542'
			nf.emitente.razao_social.must_equal 'DUOBR SISTEMAS LTDA ME'
			nf.emitente.nome_fantasia.must_equal 'DUOBR SISTEMAS'
			nf.emitente.telefone.must_equal '4933161107'
			nf.emitente.email.must_equal 'emitente@mail.com.br'

			nf.emitente.endereco.logradouro.must_equal 'RUA DOS PRAZERES'
			nf.emitente.endereco.numero.must_equal '520'
			nf.emitente.endereco.complemento.must_equal 'D'
			nf.emitente.endereco.bairro.must_equal 'SAO CRISTOVAO'
			nf.emitente.endereco.codigo_municipio.must_equal '4204202'
			nf.emitente.endereco.uf.must_equal 'SC'
			nf.emitente.endereco.cep.must_equal '89804023'

			nf.destinatario.cpf_cnpj.must_equal '12345678901'
			nf.destinatario.inscricao_municipal.must_equal '3365'
			nf.destinatario.inscricao_estadual.must_be_nil
			nf.destinatario.inscricao_suframa.must_be_nil
			nf.destinatario.razao_social.must_equal 'BRUNO DAS COVES'
			nf.destinatario.telefone.must_equal '4920493900'
			nf.destinatario.email.must_equal 'destinatario@mail.com.br'

			nf.destinatario.endereco.logradouro.must_equal 'RUA IGUACU - E'
			nf.destinatario.endereco.numero.must_equal '587'
			nf.destinatario.endereco.complemento.must_equal ''
			nf.destinatario.endereco.bairro.must_equal 'SAIC'
			nf.destinatario.endereco.codigo_municipio.must_equal '45678932'
			nf.destinatario.endereco.uf.must_equal 'SC'
			nf.destinatario.endereco.cep.must_equal '89802171'
		end
	end

end