require 'test_helper'

describe BrNfe::Product::Reader::Nfe do
	describe "XML Version 3.10" do
		let(:nfe_completa)     { read_fixture('product/nfe/v3_10/completa.xml') } 
		let(:nfe_without_proc) { read_fixture('product/nfe/v3_10/without_proc.xml') }
		describe "Valores da nota fiscal" do
			it "Deve carregar os totais da nota fiscal" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_completa)
				invoice = reader.invoice
				# Valores dos Produtos
				invoice.total_icms_base_calculo.must_equal    1.0
				invoice.total_icms.must_equal                 2.0
				invoice.total_icms_desonerado.must_equal      3.0
				invoice.total_icms_fcp_uf_destino.must_equal  4.0
				invoice.total_icms_uf_destino.must_equal      5.0
				invoice.total_icms_uf_origem.must_equal       6.0
				invoice.total_icms_base_calculo_st.must_equal 7.0
				invoice.total_icms_st.must_equal              8.0
				invoice.total_produtos.must_equal             1800.00
				invoice.total_frete.must_equal                100.00
				invoice.total_seguro.must_equal               10.00
				invoice.total_desconto.must_equal             199.50
				invoice.total_imposto_importacao.must_equal   1.0
				invoice.total_ipi.must_equal                  2.0
				invoice.total_pis.must_equal                  3.0
				invoice.total_cofins.must_equal               4.0
				invoice.total_outras_despesas.must_equal      5.0
				invoice.total_nf.must_equal                   1700.50
				invoice.total_tributos.must_equal             157.87
				# Valores dos Serviços
				invoice.total_servicos.must_equal                         1.0
				invoice.total_servicos_base_calculo.must_equal            2.0
				invoice.total_servicos_iss.must_equal                     3.0
				invoice.total_servicos_pis.must_equal                     4.0
				invoice.total_servicos_cofins.must_equal                  5.0
				invoice.servicos_data_prestacao.must_equal                Date.parse('2017-03-20')
				invoice.total_servicos_deducao.must_equal                 7.0
				invoice.total_servicos_outras_retencoes.must_equal        8.0
				invoice.total_servicos_desconto_incondicionado.must_equal 9.0
				invoice.total_servicos_desconto_condicionado.must_equal   10.0
				invoice.total_servicos_iss_retido.must_equal              11.0
				invoice.regime_tributario_servico.must_equal              7
				# Retenções
				invoice.total_retencao_pis.must_equal                      50.0
				invoice.total_retencao_cofins.must_equal                   51.0
				invoice.total_retencao_csll.must_equal                     52.0
				invoice.total_retencao_base_calculo_irrf.must_equal        53.0
				invoice.total_retencao_irrf.must_equal                     54.0
				invoice.total_retencao_base_calculo_previdencia.must_equal 55.0
				invoice.total_retencao_previdencia.must_equal              56.0
			end
		end
		describe 'Dados diversos da Nota Fiscal' do
			it 'Deve carregar os dados da nota fiscal' do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_completa)
				invoice = reader.invoice

				invoice.codigo_tipo_emissao.must_equal       '1'
				invoice.chave_de_acesso.must_equal           '170685525646000145550010000000181201601017'
				invoice.codigo_nf.must_equal                 '20160101'
				invoice.serie.must_equal                     '1'
				invoice.numero_nf.must_equal                 18
				invoice.natureza_operacao.must_equal         'Venda'
				invoice.forma_pagamento.must_equal           '0'
				invoice.modelo_nf.must_equal                 '55'
				invoice.data_hora_emissao.must_equal         Time.parse('2017-06-06T09:11:39-03:00')
				invoice.data_hora_expedicao.must_equal       Time.parse('2017-06-06T09:11:39-03:10')
				invoice.tipo_operacao.must_equal             '1'
				invoice.tipo_impressao.must_equal            '1'
				invoice.finalidade_emissao.must_equal        '2'
				invoice.tipo_ambiente.must_equal             '2'
				invoice.consumidor_final.must_equal          true
				invoice.presenca_comprador.must_equal        '9'
				invoice.processo_emissao.must_equal          '0'
				invoice.versao_aplicativo.must_equal         '0'
				invoice.informacoes_fisco.must_equal         'INFO ao Fisco'
				invoice.informacoes_contribuinte.must_equal  'Info ao Contribuinte'
				# Exportação
				invoice.exportacao_uf_saida.must_equal       'SC'
				invoice.exportacao_local_embarque.must_equal 'Porto Sao Francisco do Sul'
				invoice.exportacao_local_despacho.must_equal 'Pier 2'
			end
		end
		describe '#Emitente' do
			it "Deve ler os dados do Emitente quando a NF-e possui a tag <nfeProc>" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_completa)
				emit = reader.invoice.emitente
				emit.inscricao_estadual_st.must_equal ''
				emit.cnae_code.must_equal ''
				emit.cpf_cnpj.must_equal '85525646000145'
				emit.razao_social.must_equal 'DIGBOX COMERCIO DE SISTEMAS PARA AUTOMACAO RESIDENCIAL LTDA'
				emit.nome_fantasia.must_equal 'DIGBOX'
				emit.telefone.must_equal '4933124411'
				emit.inscricao_municipal.must_equal '326070'
				emit.inscricao_estadual.must_equal '255422470'
				emit.codigo_regime_tributario.must_equal '1'
				emit.endereco_uf.must_equal 'SC'
				emit.endereco_cep.must_equal '89805045'
				emit.endereco_bairro.must_equal 'LIDER'
				emit.endereco_numero.must_equal '333'
				emit.endereco_nome_pais.must_equal ''
				emit.endereco_logradouro.must_equal 'AV. GETULIO VARGAS - N'
				emit.endereco_codigo_pais.must_equal ''
				emit.endereco_complemento.must_equal ''
				emit.endereco_nome_municipio.must_equal 'CHAPECO'
			end
			it "Deve ler os dados do Emitente quando a NF-e não possui a tag <nfeProc>" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_without_proc)
				emit = reader.invoice.emitente
				emit.inscricao_estadual_st.must_equal '257855416'
				emit.cnae_code.must_equal ''
				emit.cpf_cnpj.must_equal '10864846000204'
				emit.razao_social.must_equal 'PETSUPERMARKET COM PROD PARA ANIMAIS SA'
				emit.nome_fantasia.must_equal ''
				emit.telefone.must_equal '8007711660'
				emit.inscricao_municipal.must_equal ''
				emit.inscricao_estadual.must_equal '492666714119'
				emit.codigo_regime_tributario.must_equal '3'
				emit.endereco_uf.must_equal 'SP'
				emit.endereco_cep.must_equal '06268110'
				emit.endereco_bairro.must_equal 'PQ.IND.MAZZEI'
				emit.endereco_numero.must_equal '1429'
				emit.endereco_nome_pais.must_equal 'BRASIL'
				emit.endereco_logradouro.must_equal 'AV.LOURENCO BELLOLI'
				emit.endereco_codigo_pais.must_equal '1058'
				emit.endereco_complemento.must_equal '1429-1415  L60'
				emit.endereco_nome_municipio.must_equal 'OSASCO'
			end
		end
		describe '#Destinatário' do
			it "Deve ler os dados do Destinatário quando a NF-e possui a tag <nfeProc>" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_completa)
				dest = reader.invoice.destinatario
				dest.cpf_cnpj.must_equal '22174841509'
				dest.razao_social.must_equal 'NINA CLARICE'
				dest.nome_fantasia.must_equal ''
				dest.telefone.must_equal '4732781411'
				dest.inscricao_municipal.must_equal ''
				dest.inscricao_estadual.must_equal ''
				dest.endereco_uf.must_equal 'SC'
				dest.endereco_cep.must_equal '89237100'
				dest.endereco_bairro.must_equal 'VILA NOVA'
				dest.endereco_numero.must_equal '311'
				dest.endereco_nome_pais.must_equal ''
				dest.endereco_logradouro.must_equal 'RUA BENTO T DA ROCHA'
				dest.endereco_codigo_pais.must_equal ''
				dest.endereco_complemento.must_equal 'LETRA E'
				dest.endereco_nome_municipio.must_equal 'JOINVILLE'
				dest.suframa.must_equal ''
			end
			it "Deve ler os dados do Destinatário quando a NF-e não possui a tag <nfeProc>" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_without_proc)
				dest = reader.invoice.destinatario
				dest.cpf_cnpj.must_equal '70560009402'
				dest.razao_social.must_equal 'FELIPE LUCCA LIMA'
				dest.nome_fantasia.must_equal ''
				dest.endereco_logradouro.must_equal 'RUA AFONSO PENA-D'
				dest.endereco_numero.must_equal '444'
				dest.endereco_complemento.must_equal 'PROXIMO AO POSTO'
				dest.endereco_bairro.must_equal 'SAO JOAO'
				dest.endereco_codigo_municipio.must_equal '4204202'
				dest.endereco_nome_municipio.must_equal 'CAPINZAL'
				dest.endereco_uf.must_equal 'SC'
				dest.endereco_cep.must_equal '89804023'
				dest.endereco_codigo_pais.must_equal '1058'
				dest.endereco_nome_pais.must_equal 'BRASIL'
				dest.telefone.must_equal '49991471446'
				dest.indicador_ie.must_equal 9
				dest.email.must_equal 'felipe_lucca@live.ie'				
				dest.inscricao_estadual.must_equal '99999999'
				dest.suframa.must_equal '66547'
				dest.inscricao_municipal.must_equal '4654564'
			end
		end
		describe 'Transporte' do
			it "Quando não há transporte deve carregar apenas a modalidade do frete" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_without_proc)
				transporte = reader.invoice.transporte
				transporte.modalidade_frete.must_equal '9'
				transporte.retencao_valor_sevico.must_be_nil
				transporte.retencao_base_calculo_icms.must_be_nil
				transporte.retencao_aliquota.must_be_nil
				transporte.retencao_valor_icms.must_equal 0.0
				transporte.retencao_cfop.must_be_nil
				transporte.retencao_codigo_municipio.must_be_nil
				# transporte.forma_transporte.must_be_nil
				transporte.veiculo.must_be_nil
				transporte.identificacao_balsa.must_be_nil
				transporte.identificacao_vagao.must_be_nil
				transporte.reboques.must_be_empty
				transporte.volumes.must_be_empty
				transporte.transportador.must_be_nil
			end
			it "Quando há transporte deve carregar todas as informações do transporte" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_completa)
				transporte = reader.invoice.transporte
				transporte.modalidade_frete.must_equal '1'
				transporte.retencao_valor_sevico.must_equal 1.0
				transporte.retencao_base_calculo_icms.must_equal 2.0
				transporte.retencao_aliquota.must_equal 3.0
				transporte.retencao_valor_icms.must_equal 4.0
				transporte.retencao_cfop.must_equal '6304'
				transporte.retencao_codigo_municipio.must_equal '1720903'
				transporte.forma_transporte.must_equal :veiculo
				# Transportador
				transp = transporte.transportador
				transp.cpf_cnpj.must_equal '15114195000178'
				transp.razao_social.must_equal 'SARAH E VALENTINA ALIMENTOS LTDA'
				transp.inscricao_estadual.must_equal '25464478'
				transp.endereco.descricao.must_equal 'CAPIBARIBE-RUA ITAJAI-453'
				transp.endereco_uf.must_equal 'PE'
				transp.endereco_nome_municipio.must_equal 'SAO LOURENCO DA MATA'

				# Veiculo
				transporte.veiculo.placa.must_equal 'UJC5786'
				transporte.veiculo.uf.must_equal 'SC'
				transporte.veiculo.rntc.must_equal '215423'
				transporte.identificacao_balsa.must_be_nil
				transporte.identificacao_vagao.must_be_nil
				# Reboques
				transporte.reboques.size.must_equal 2
				transporte.reboques[0].placa.must_equal 'UJC5786'
				transporte.reboques[0].uf.must_equal 'SC'
				transporte.reboques[0].rntc.must_equal '215423'
				transporte.reboques[1].placa.must_equal 'DUO1107'
				transporte.reboques[1].uf.must_equal 'RS'
				transporte.reboques[1].rntc.must_equal '654899'
				# Volumes
				transporte.volumes.size.must_equal 2 
				transporte.volumes[0].quantidade.must_equal '5'
				transporte.volumes[0].especie.must_equal 'CAIXA'
				transporte.volumes[0].marca.must_equal 'DUO'
				transporte.volumes[0].numercao.must_equal '1'
				transporte.volumes[0].peso_liquido.must_equal 10.000
				transporte.volumes[0].peso_bruto.must_equal 11.000
				transporte.volumes[0].lacres.must_equal( ['LAC001', 'LAC002'] )
				transporte.volumes[1].quantidade.must_equal '10'
				transporte.volumes[1].especie.must_equal 'SACOLA'
				transporte.volumes[1].marca.must_equal 'BR'
				transporte.volumes[1].numercao.must_equal '2'
				transporte.volumes[1].peso_liquido.must_equal 2.000
				transporte.volumes[1].peso_bruto.must_equal 2.250
				transporte.volumes[1].lacres.must_equal( ['LAC003', 'LAC004'] )
			end
		end
		describe '#EndereçoRetirada' do
			it "Quando possui endereço de retirada deve instanciar" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_completa)
				endereco = reader.invoice.endereco_retirada
				reader.invoice.endereco_retirada_cpf_cnpj.must_equal '23020443000140'
				endereco.logradouro.must_equal       'RUA AFONSO PENA - D'
				endereco.numero.must_equal           '420'
				endereco.complemento.must_equal      'D'
				endereco.bairro.must_equal           'SAO CRISTOVAO'
				endereco.codigo_municipio.must_equal '4204202'
				endereco.nome_municipio.must_equal   'CHAPECO'
				endereco.uf.must_equal               'SC'
			end
			it "Quando não possui endereço de retirada deve ficar nil" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_without_proc)
				reader.invoice.endereco_retirada.must_be_nil
				reader.invoice.endereco_retirada_cpf_cnpj.must_be_nil
			end
		end
		describe '#EndereçoEntrega' do
			it "Quando possui endereço de entrega deve instanciar" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_completa)
				endereco = reader.invoice.endereco_entrega
				reader.invoice.endereco_entrega_cpf_cnpj.must_equal '74604254273'
				endereco.logradouro.must_equal       'RUA JUCA BALA'
				endereco.numero.must_equal           '444'
				endereco.complemento.must_equal      'D'
				endereco.bairro.must_equal           'SAO JUCA'
				endereco.codigo_municipio.must_equal '4204204'
				endereco.nome_municipio.must_equal   'SAO CARLOS'
				endereco.uf.must_equal               'SC'
			end
			it "Quando não possui endereço de entrega deve ficar nil" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_without_proc)
				reader.invoice.endereco_entrega.must_be_nil
				reader.invoice.endereco_entrega_cpf_cnpj.must_be_nil
			end
		end
		describe '#Fatura' do
			it "Quando não há fatura não deve isntanciar o objeto" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_without_proc)
				reader.invoice.fatura.must_be_nil
			end
			it "Quando há fatura deve isntanciar o objeto com os valores" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_completa)
				fat = reader.invoice.fatura
				fat.numero_fatura.must_equal  'FAT646498'
				fat.valor_original.must_equal 2000.00
				fat.valor_desconto.must_equal 199.50
				fat.valor_liquido.must_equal  1800.50
				fat.duplicatas.size.must_equal 2
				fat.duplicatas[0].numero_duplicata.must_equal 'DUP646498'
				fat.duplicatas[0].vencimento.must_equal       Date.parse('2017-07-06')
				fat.duplicatas[0].total.must_equal            900.25

				fat.duplicatas[1].numero_duplicata.must_equal 'DUP646499'
				fat.duplicatas[1].vencimento.must_equal        Date.parse('2017-08-06')
				fat.duplicatas[1].total.must_equal             900.25
			end
		end
		describe '#Pagamentos' do
			it "Se não possui nenhum pagamento não deve instanciar pagamento vazio" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_without_proc)
				reader.invoice.pagamentos.must_be_empty
			end
			it "Deve instanciar os pagamentos se existirs" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_completa)
				pagamentos = reader.invoice.pagamentos
				pagamentos.size.must_equal 2
				pagamentos[0].forma_pagamento.must_equal    '03'
				pagamentos[0].total.must_equal              900.25
				pagamentos[0].tipo_integracao.must_equal    '2'
				pagamentos[0].cartao_cnpj.must_equal        '00259231000114'
				pagamentos[0].cartao_bandeira.must_equal    '01'
				pagamentos[0].cartao_autorizacao.must_equal '6498916984994'

				pagamentos[1].forma_pagamento.must_equal    '01'
				pagamentos[1].total.must_equal              900.25
				pagamentos[1].tipo_integracao.must_equal    ''
				pagamentos[1].cartao_cnpj.must_be_nil
				pagamentos[1].cartao_bandeira.must_equal    ''
				pagamentos[1].cartao_autorizacao.must_equal ''
			end
		end
		describe '#Protocolo de autorização e situação da NF-e' do
			it "Quando a nota fiscal não tem protocolo deve setar com a situação de rascunho" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_without_proc)
				nf = reader.invoice
				nf.protocol.must_be_nil
				nf.digest_value.must_be_nil
				nf.processed_at.must_be_nil
				nf.status_code.must_be_nil
				nf.situation.must_equal :draft
			end
			it "Quando a nota fiscal possui o protocolo de autorização deve trazer o protocolo e situação :authorized" do
				reader = BrNfe::Product::Reader::Nfe.new(nfe_completa)
				nf = reader.invoice
				nf.protocol.must_equal     '342170067070649'
				nf.digest_value.must_equal '2kA5WLPGvBWAruvJmk6HhNxO/vI='
				nf.processed_at.must_equal Time.parse('2017-06-02T10:10:07-03:00')
				nf.status_code.must_equal  '100'
				nf.situation.must_equal    :authorized
			end
			it "Quando a nota fiscal possui protocolo de autorização e de cancelamento deve trazer o status como :canceled" do
				reader = BrNfe::Product::Reader::Nfe.new(read_fixture('product/nfe/v3_10/cancelada.xml'))
				nf = reader.invoice
				nf.protocol.must_equal     '342170035680552'
				nf.digest_value.must_equal '2kA5WLPGvBWAruvJmk6HhNxO/vI='
				nf.processed_at.must_equal Time.parse('2017-03-24T10:59:56-03:00')
				nf.status_code.must_equal  '135'
				nf.situation.must_equal    :canceled
			end
		end
		describe '#Itens da nota fiscal' do
			let(:invoice) { BrNfe::Product::Reader::Nfe.new(nfe_completa).invoice } 
			it "Deve ler o Item 1 - ICMS-00" do
				item = invoice.itens[0]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            '018-1520'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'PIX - CABO HDMI 15m 2.0 4K ULTRAHD'
				item.codigo_ncm.must_equal                '85444200'
				item.codigos_nve.must_equal               ['55556','66548']
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5101'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  261.25
				item.valor_total_produto.must_equal       261.25
				item.codigo_ean_tributavel.must_equal     '33546896546321'
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 261.25
				item.total_frete.must_equal               0.0
				item.total_seguro.must_equal              0.0
				item.total_desconto.must_equal            0.0
				item.total_outros.must_equal              0.0
				item.soma_total_nfe.must_equal            true
				item.codigo_cest.must_equal               ''
				item.numero_pedido_compra.must_equal      '654879'
				item.item_pedido_compra.must_equal        '7'
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      3.0
				item.total_ipi_devolucao.must_equal       1.58
				item.informacoes_adicionais.must_equal    'Info adicionais produto'
				item.total_tributos.must_equal            0.0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '00'
				icms.modalidade_base_calculo.must_equal      3
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           264.46
				icms.aliquota.must_equal                     2.0
				icms.total.must_equal                        5.29
				icms.modalidade_base_calculo_st.must_be_nil
				icms.mva_st.must_equal                       0.0
				icms.reducao_base_calculo_st.must_equal      0.0
				icms.total_base_calculo_st.must_equal        0.0
				icms.aliquota_st.must_equal                  0.0
				icms.total_st.must_equal                     0.0
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				ipi = item.ipi
				ipi.codigo_cst.must_equal           '52'
				ipi.classe_enquadramento.must_equal ''
				ipi.cnpj_produtor.must_equal        ''
				ipi.codigo_selo.must_equal          ''
				ipi.quantidade_selo.must_equal      ''
				ipi.codigo_enquadramento.must_equal '999'
				ipi.base_calculo.must_equal         0.0
				ipi.aliquota.must_equal             0.0
				ipi.quantidade_unidade.must_equal   0.0
				ipi.total_unidade.must_equal        0.0
				ipi.total.must_equal                0.0
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '03'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              5.56
				pis.quantidade_vendida.must_equal 1.0
				pis.total_aliquota.must_equal     5.56
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '01'
				cofins.total_base_calculo.must_equal 261.25
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 2 - ICMS-10" do
				item = invoice.itens[1]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            '6450'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'DISCABOS - PARALELO SPEAKER 2x1,50mm2 PT'
				item.codigo_ncm.must_equal                '85444900'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5253'
				item.unidade_comercial.must_equal         'MT'
				item.quantidade_comercial.must_equal      70.0
				item.valor_unitario_comercial.must_equal  4.62
				item.valor_total_produto.must_equal       313.40
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'MT'
				item.quantidade_tributavel.must_equal     70.0
				item.valor_unitario_tributavel.must_equal 4.62
				item.total_frete.must_equal               5.0
				item.total_seguro.must_equal              5.0
				item.total_desconto.must_equal            10.0
				item.total_outros.must_equal              5.0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            5.0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '10'
				icms.modalidade_base_calculo.must_equal      3
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           334.67
				icms.aliquota.must_equal                     2.0
				icms.total.must_equal                        6.69
				icms.modalidade_base_calculo_st.must_equal   1
				icms.mva_st.must_equal                       10.0
				icms.reducao_base_calculo_st.must_equal      10.0
				icms.total_base_calculo_st.must_equal        331.33
				icms.aliquota_st.must_equal                  40.0
				icms.total_st.must_equal                     92.37
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				ipi = item.ipi
				ipi.codigo_enquadramento.must_equal '999'
				ipi.codigo_cst.must_equal           '50'
				ipi.classe_enquadramento.must_equal ''
				ipi.cnpj_produtor.must_equal        ''
				ipi.codigo_selo.must_equal          ''
				ipi.quantidade_selo.must_equal      ''
				ipi.base_calculo.must_equal         313.40
				ipi.aliquota.must_equal             2.0
				ipi.quantidade_unidade.must_equal   0.0
				ipi.total_unidade.must_equal        0.0
				ipi.total.must_equal                6.27
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '05'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '01'
				cofins.total_base_calculo.must_equal 313.40
				cofins.aliquota.must_equal           2.5
				cofins.total.must_equal              7.84
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 3 - ICMS-20" do
				item = invoice.itens[2]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            '11114'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'CONTROLLER - FIO PP 3X1,00MM2 750V PT'
				item.codigo_ncm.must_equal                '85444900'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5101'
				item.unidade_comercial.must_equal         'MT'
				item.quantidade_comercial.must_equal      30.0
				item.valor_unitario_comercial.must_equal  5.28
				item.valor_total_produto.must_equal       158.4
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'MT'
				item.quantidade_tributavel.must_equal     30.0
				item.valor_unitario_tributavel.must_equal 5.28
				item.total_frete.must_equal               0.0
				item.total_seguro.must_equal              0.0
				item.total_desconto.must_equal            0.0
				item.total_outros.must_equal              0.0
				item.soma_total_nfe.must_equal            false
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            0.0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '20'
				icms.modalidade_base_calculo.must_equal      3
				icms.reducao_base_calculo.must_equal         10.0
				icms.total_base_calculo.must_equal           142.56
				icms.aliquota.must_equal                     25.0
				icms.total.must_equal                        35.64
				icms.modalidade_base_calculo_st.must_be_nil
				icms.mva_st.must_equal                       0.0
				icms.reducao_base_calculo_st.must_equal      0.0
				icms.total_base_calculo_st.must_equal        0.0
				icms.aliquota_st.must_equal                  0.0
				icms.total_st.must_equal                     0.0
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 4 - ICMS-30" do
				item = invoice.itens[3]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            'CM640'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'AERTECNICA - ACOPLADOR PARA RESPIRO MOD CENTR'
				item.codigo_ncm.must_equal                '85087000'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5102'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      6.0
				item.valor_unitario_comercial.must_equal  95.44
				item.valor_total_produto.must_equal       572.64
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     6.0
				item.valor_unitario_tributavel.must_equal 95.44
				item.total_frete.must_equal               1.0
				item.total_seguro.must_equal              1.0
				item.total_desconto.must_equal            0.0
				item.total_outros.must_equal              1.0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            1.0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '30'
				icms.modalidade_base_calculo.must_be_nil
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           0.0
				icms.aliquota.must_equal                     0.0
				icms.total.must_equal                        0.0
				
				icms.modalidade_base_calculo_st.must_equal   4
				icms.mva_st.must_equal                       40.0
				icms.reducao_base_calculo_st.must_equal      5.0
				icms.total_base_calculo_st.must_equal        765.60
				icms.aliquota_st.must_equal                  3.5
				icms.total_st.must_equal                     26.22
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 5 - ICMS-40" do
				item = invoice.itens[4]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            '241088'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'BELKIN - BRACADEIRA SMARTPHONE PTO/AMAR'
				item.codigo_ncm.must_equal                '42023200'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5103'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      70.0
				item.valor_unitario_comercial.must_equal  56.99
				item.valor_total_produto.must_equal       3_989.30
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     70.0
				item.valor_unitario_tributavel.must_equal 56.99
				item.total_frete.must_equal               0.0
				item.total_seguro.must_equal              0.0
				item.total_desconto.must_equal            0.0
				item.total_outros.must_equal              0.0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            0.0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       2
				icms.codigo_cst.must_equal                   '40'
				icms.modalidade_base_calculo.must_be_nil
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           0.0
				icms.aliquota.must_equal                     0.0
				icms.total.must_equal                        0.0
				icms.modalidade_base_calculo_st.must_be_nil
				icms.mva_st.must_equal                       0.0
				icms.reducao_base_calculo_st.must_equal      0.0
				icms.total_base_calculo_st.must_equal        0.0
				icms.aliquota_st.must_equal                  0.0
				icms.total_st.must_equal                     0.0
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				ipi = item.ipi
				ipi.codigo_enquadramento.must_equal '999'
				ipi.codigo_cst.must_equal           '55'
				ipi.classe_enquadramento.must_equal ''
				ipi.cnpj_produtor.must_equal        ''
				ipi.codigo_selo.must_equal          ''
				ipi.quantidade_selo.must_equal      ''
				ipi.base_calculo.must_equal         0.0
				ipi.aliquota.must_equal             0.0
				ipi.quantidade_unidade.must_equal   0.0
				ipi.total_unidade.must_equal        0.0
				ipi.total.must_equal                0.0
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 6 - ICMS-41" do
				item = invoice.itens[5]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            '0000936'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'MIL EMBALAGENS - BOBINA PLASTICO BOLHA'
				item.codigo_ncm.must_equal                '39211900'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5102'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      2.0
				item.valor_unitario_comercial.must_equal  100.0
				item.valor_total_produto.must_equal       200.0
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     2.0
				item.valor_unitario_tributavel.must_equal 100.0
				item.total_frete.must_equal               0.0
				item.total_seguro.must_equal              0.0
				item.total_desconto.must_equal            0.0
				item.total_outros.must_equal              0.0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            0.0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       7
				icms.codigo_cst.must_equal                   '41'
				icms.modalidade_base_calculo.must_be_nil
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           0.0
				icms.aliquota.must_equal                     0.0
				icms.total.must_equal                        0.0
				icms.modalidade_base_calculo_st.must_be_nil
				icms.mva_st.must_equal                       0.0
				icms.reducao_base_calculo_st.must_equal      0.0
				icms.total_base_calculo_st.must_equal        0.0
				icms.aliquota_st.must_equal                  0.0
				icms.total_st.must_equal                     0.0
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '56'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              20.0
				pis.quantidade_vendida.must_equal 2.0
				pis.total_aliquota.must_equal     20.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 7 - ICMS-50" do
				item = invoice.itens[6]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            'P15009'
				item.codigo_ean.must_equal                '1232132132133123'
				item.descricao_produto.must_equal         '7BALL - CAPA MESA HOME COURISSIMO PRETO'
				item.codigo_ncm.must_equal                '95042000'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5103'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  511.81
				item.valor_total_produto.must_equal       511.81
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 511.81
				item.total_frete.must_equal               0.0
				item.total_seguro.must_equal              0.0
				item.total_desconto.must_equal            0.0
				item.total_outros.must_equal              0.0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            0.0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '50'
				icms.modalidade_base_calculo.must_be_nil
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           0.0
				icms.aliquota.must_equal                     0.0
				icms.total.must_equal                        0.0
				icms.modalidade_base_calculo_st.must_be_nil
				icms.mva_st.must_equal                       0.0
				icms.reducao_base_calculo_st.must_equal      0.0
				icms.total_base_calculo_st.must_equal        0.0
				icms.aliquota_st.must_equal                  0.0
				icms.total_st.must_equal                     0.0
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 8 - ICMS-51" do
				item = invoice.itens[7]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            '1654'
				item.codigo_ean.must_equal                '3333333333333333'
				item.descricao_produto.must_equal         'ABSOLUTE - HDA4 - CAIXA ACUSTICA 100 WATTS'
				item.codigo_ncm.must_equal                '85182100'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5104'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  603.9
				item.valor_total_produto.must_equal       602.67
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 603.9
				item.total_frete.must_equal               1.23
				item.total_seguro.must_equal              1.23
				item.total_desconto.must_equal            1.23
				item.total_outros.must_equal              1.23
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            1.23

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '51'
				icms.modalidade_base_calculo.must_equal      1
				icms.reducao_base_calculo.must_equal         1.23
				icms.total_base_calculo.must_equal           598.9
				icms.aliquota.must_equal                     3.33
				icms.total.must_equal                        19.94
				
				icms.modalidade_base_calculo_st.must_be_nil
				icms.mva_st.must_equal                       0.0
				icms.reducao_base_calculo_st.must_equal      0.0
				icms.total_base_calculo_st.must_equal        0.0
				icms.aliquota_st.must_equal                  0.0
				icms.total_st.must_equal                     0.0
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 9 - ICMS-60" do
				item = invoice.itens[8]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            '1300'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'PURE ACOUSTICS - CAIXA DE SOM PX255'
				item.codigo_ncm.must_equal                '85182200'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5102'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  834.91
				item.valor_total_produto.must_equal       834.91
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 834.91
				item.total_frete.must_equal               0.0
				item.total_seguro.must_equal              0.0
				item.total_desconto.must_equal            0.0
				item.total_outros.must_equal              0.0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            0.0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       5
				icms.codigo_cst.must_equal                   '60'
				icms.modalidade_base_calculo.must_be_nil
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           0.0
				icms.aliquota.must_equal                     0.0
				icms.total.must_equal                        0.0
				icms.modalidade_base_calculo_st.must_be_nil
				icms.mva_st.must_equal                       0.0
				icms.reducao_base_calculo_st.must_equal      0.0
				icms.total_base_calculo_st.must_equal        0.0
				icms.aliquota_st.must_equal                  0.0
				icms.total_st.must_equal                     0.0
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				ipi = item.ipi
				ipi.codigo_enquadramento.must_equal '999'
				ipi.codigo_cst.must_equal           '99'
				ipi.classe_enquadramento.must_equal ''
				ipi.cnpj_produtor.must_equal        ''
				ipi.codigo_selo.must_equal          ''
				ipi.quantidade_selo.must_equal      ''
				ipi.base_calculo.must_equal         834.91
				ipi.aliquota.must_equal             12.33
				ipi.quantidade_unidade.must_equal   0.0
				ipi.total_unidade.must_equal        0.0
				ipi.total.must_equal                102.94
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '71'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              37.99
				pis.quantidade_vendida.must_equal 1.0
				pis.total_aliquota.must_equal     37.99
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '73'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 1.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 10 - ICMS-70" do
				item = invoice.itens[9]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            'SU-07'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'AIRON - SUPORTE CAIXA PAREDE SU-07'
				item.codigo_ncm.must_equal                '85189090'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5102'
				item.unidade_comercial.must_equal         'PAR'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  90.85
				item.valor_total_produto.must_equal       90.85
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PAR'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 90.85
				item.total_frete.must_equal               0.0
				item.total_seguro.must_equal              0.0
				item.total_desconto.must_equal            0.0
				item.total_outros.must_equal              0.0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            0.0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '70'
				icms.modalidade_base_calculo.must_equal      3
				icms.reducao_base_calculo.must_equal         3.44
				icms.total_base_calculo.must_equal           87.72
				icms.aliquota.must_equal                     12.0
				icms.total.must_equal                        10.53

				icms.modalidade_base_calculo_st.must_equal   0
				icms.mva_st.must_equal                       50.0
				icms.reducao_base_calculo_st.must_equal      10.0
				icms.total_base_calculo_st.must_equal        122.64
				icms.aliquota_st.must_equal                  20.0
				icms.total_st.must_equal                     12.18
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 11 - ICMS-90" do
				item = invoice.itens[10]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            '1514'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'GAIA - SUPORTE DE TETO PARA TV COM GIRO MANUAL ATE 300? GSP - 251'
				item.codigo_ncm.must_equal                '38151900'
				item.codigo_cest.must_equal               '2804200'
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5103'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  1190.00
				item.valor_total_produto.must_equal       1190.00
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 1190.00
				item.total_frete.must_equal               0.0
				item.total_seguro.must_equal              0.0
				item.total_desconto.must_equal            0.0
				item.total_outros.must_equal              0.0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            0.0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '90'
				icms.modalidade_base_calculo.must_equal      3
				icms.reducao_base_calculo.must_equal         12.33
				icms.total_base_calculo.must_equal           1043.27
				icms.aliquota.must_equal                     12.33
				icms.total.must_equal                        128.64

				icms.modalidade_base_calculo_st.must_equal   0
				icms.mva_st.must_equal                       40.0
				icms.reducao_base_calculo_st.must_equal      3.0
				icms.total_base_calculo_st.must_equal        1616.02
				icms.aliquota_st.must_equal                  30.0
				icms.total_st.must_equal                     320.47
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 12 - ICMS-101" do
				item = invoice.itens[11]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            '250705022'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'AIRON - BASE GIRATORIA DE TV PLASMA / LCD'
				item.codigo_ncm.must_equal                '94032000'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '2251'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  776.44
				item.valor_total_produto.must_equal       776.44
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 776.44
				item.total_frete.must_equal               122.22
				item.total_seguro.must_equal              12.22
				item.total_desconto.must_equal            0.0
				item.total_outros.must_equal              33.33
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            44.12

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '101'
				icms.modalidade_base_calculo.must_be_nil
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           0.0
				icms.aliquota.must_equal                     0.0
				icms.total.must_equal                        0.0

				icms.modalidade_base_calculo_st.must_be_nil
				icms.mva_st.must_equal                       0.0
				icms.reducao_base_calculo_st.must_equal      0.0
				icms.total_base_calculo_st.must_equal        0.0
				icms.aliquota_st.must_equal                  0.0
				icms.total_st.must_equal                     0.0
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          12.31
				icms.total_credito_sn.must_equal             95.58
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 13 - ICMS-102" do
				item = invoice.itens[12]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            'CM080P'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'AERTECNICA - CENTRAL DE ASPIRACAO PERFETTO P80'
				item.codigo_ncm.must_equal                '85087000'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5111'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  3959.00
				item.valor_total_produto.must_equal       3909.00
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 3959.00
				item.total_frete.must_equal               30.0
				item.total_seguro.must_equal              40.0
				item.total_desconto.must_equal            50.0
				item.total_outros.must_equal              40.0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            123.33

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '102'
				icms.modalidade_base_calculo.must_be_nil
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           0.0
				icms.aliquota.must_equal                     0.0
				icms.total.must_equal                        0.0

				icms.modalidade_base_calculo_st.must_be_nil
				icms.mva_st.must_equal                       0.0
				icms.reducao_base_calculo_st.must_equal      0.0
				icms.total_base_calculo_st.must_equal        0.0
				icms.aliquota_st.must_equal                  0.0
				icms.total_st.must_equal                     0.0
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 14 - ICMS-103" do
				item = invoice.itens[13]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            '348'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'KEF - CONJUNTO DE CAIXA DE SOM T105'
				item.codigo_ncm.must_equal                '85182100'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '1151'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  14734.37
				item.valor_total_produto.must_equal       14734.37
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 14734.37
				item.total_frete.must_equal               0
				item.total_seguro.must_equal              0
				item.total_desconto.must_equal            0
				item.total_outros.must_equal              0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '103'
				icms.modalidade_base_calculo.must_be_nil
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           0.0
				icms.aliquota.must_equal                     0.0
				icms.total.must_equal                        0.0

				icms.modalidade_base_calculo_st.must_be_nil
				icms.mva_st.must_equal                       0.0
				icms.reducao_base_calculo_st.must_equal      0.0
				icms.total_base_calculo_st.must_equal        0.0
				icms.aliquota_st.must_equal                  0.0
				icms.total_st.must_equal                     0.0
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 15 - ICMS-201" do
				item = invoice.itens[14]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            '139'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'CONECTOR FEMEA GIGALAN CAT6'
				item.codigo_ncm.must_equal                '85369010'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5101'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  66.00
				item.valor_total_produto.must_equal       66.00
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 66.00
				item.total_frete.must_equal               0
				item.total_seguro.must_equal              0
				item.total_desconto.must_equal            0
				item.total_outros.must_equal              0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '201'
				icms.modalidade_base_calculo.must_be_nil
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           0.0
				icms.aliquota.must_equal                     0.0
				icms.total.must_equal                        0.0

				icms.modalidade_base_calculo_st.must_equal   0
				icms.mva_st.must_equal                       40.0
				icms.reducao_base_calculo_st.must_equal      0.0
				icms.total_base_calculo_st.must_equal        92.40
				icms.aliquota_st.must_equal                  20.0
				icms.total_st.must_equal                     18.11
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          12.31
				icms.total_credito_sn.must_equal             8.12
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 16 - ICMS-202" do
				item = invoice.itens[15]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            '44'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'ROYAL - VIDRO TEMPERADO INCOLOR'
				item.codigo_ncm.must_equal                '70071900'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5102'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  50.00
				item.valor_total_produto.must_equal       50.00
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 50.00
				item.total_frete.must_equal               0
				item.total_seguro.must_equal              0
				item.total_desconto.must_equal            0
				item.total_outros.must_equal              0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '202'
				icms.modalidade_base_calculo.must_be_nil
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           0.0
				icms.aliquota.must_equal                     0.0
				icms.total.must_equal                        0.0

				icms.modalidade_base_calculo_st.must_equal   0
				icms.mva_st.must_equal                       40.0
				icms.reducao_base_calculo_st.must_equal      30.55
				icms.total_base_calculo_st.must_equal        48.62
				icms.aliquota_st.must_equal                  12.33
				icms.total_st.must_equal                     4.99
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              1.11
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 18.00
				icms_uf_destino.aliquota_interestadual.must_equal      12.00
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 17 - ICMS-203" do
				item = invoice.itens[16]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            'MEXXF17014S'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         '7BALL - PEBOLIN BUENOS AIRES FREIJO'
				item.codigo_ncm.must_equal                '95042000'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5101'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  2228.00
				item.valor_total_produto.must_equal       2228.00
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 2228.00
				item.total_frete.must_equal               0
				item.total_seguro.must_equal              0
				item.total_desconto.must_equal            0
				item.total_outros.must_equal              0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '203'
				icms.modalidade_base_calculo.must_be_nil
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           0.0
				icms.aliquota.must_equal                     0.0
				icms.total.must_equal                        0.0

				icms.modalidade_base_calculo_st.must_equal   0
				icms.mva_st.must_equal                       0.0
				icms.reducao_base_calculo_st.must_equal      0.0
				icms.total_base_calculo_st.must_equal        2228.00
				icms.aliquota_st.must_equal                  0.0
				icms.total_st.must_equal                     0.0
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              2.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 12.00
				icms_uf_destino.aliquota_interestadual.must_equal      17.00
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 18 - ICMS-300" do
				item = invoice.itens[17]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            'FINUS72000ZV'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'FLEX - CONFIGURADOR USB Z-FLEX'
				item.codigo_ncm.must_equal                '85176294'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5102'
				item.unidade_comercial.must_equal         'PC'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  174.92
				item.valor_total_produto.must_equal       174.92
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'PC'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 174.92
				item.total_frete.must_equal               0
				item.total_seguro.must_equal              0
				item.total_desconto.must_equal            0
				item.total_outros.must_equal              0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      ''
				item.item_pedido_compra.must_equal        ''
				item.numero_fci.must_equal                ''
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    ''
				item.total_tributos.must_equal            0

				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '300'
				icms.modalidade_base_calculo.must_be_nil
				icms.reducao_base_calculo.must_equal         0.0
				icms.total_base_calculo.must_equal           0.0
				icms.aliquota.must_equal                     0.0
				icms.total.must_equal                        0.0

				icms.modalidade_base_calculo_st.must_be_nil
				icms.mva_st.must_equal                       0.0
				icms.reducao_base_calculo_st.must_equal      0.0
				icms.total_base_calculo_st.must_equal        0.0
				icms.aliquota_st.must_equal                  0.0
				icms.total_st.must_equal                     0.0
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          0.0
				icms.total_credito_sn.must_equal             0.0
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '07'
				cofins.total_base_calculo.must_equal 0.0
				cofins.aliquota.must_equal           0.0
				cofins.total.must_equal              0.0
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 19 - ICMS-400" do
				item = invoice.itens[18]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            'CM080P'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'AERTECNICA - CENTRAL DE ASPIRACAO PERFETTO P80'
				
				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '400'
				# IPI
				item.ipi.must_be_nil
				# PIS
				item.pis.codigo_cst.must_equal '07'
				# COFINS
				item.cofins.codigo_cst.must_equal '07'
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 20 - ICMS-500" do
				item = invoice.itens[19]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            '164125'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'BELKIN - CAPA PARA IPHONE HALO TRANSPARENTE'
				
				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal     0
				icms.codigo_cst.must_equal '500'
				# IPI
				ipi = item.ipi
				ipi.codigo_enquadramento.must_equal '999'
				ipi.codigo_cst.must_equal           '54'
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '53'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.quantidade_vendida.must_equal 1.0
				pis.total_aliquota.must_equal     1.39
				pis.total.must_equal              1.39
				# COFINS
				item.cofins.codigo_cst.must_equal '07'
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          0.0
				icms_uf_destino.percentual_fcp.must_equal              0.0
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 0.0
				icms_uf_destino.aliquota_interestadual.must_equal      0.0
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           0.0
				icms_uf_destino.total_destino.must_equal               0.0
				icms_uf_destino.total_origem.must_equal                0.0
			end
			it "Deve ler o Item 21 - ICMS-900" do
				item = invoice.itens[20]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            'TQF110039'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         '7BALL - TAQUEIRA DE CHAO BUENOS AIRES PRETA'
				
				######################  Associações HasMany  ######################
				item.declaracoes_importacao.must_be_empty
				item.detalhes_exportacao.must_be_empty

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '900'
				icms.modalidade_base_calculo.must_equal      2
				icms.reducao_base_calculo.must_equal         2.0
				icms.total_base_calculo.must_equal           411.80
				icms.aliquota.must_equal                     17.0
				icms.total.must_equal                        70.01
				icms.modalidade_base_calculo_st.must_equal   0
				icms.mva_st.must_equal                       55.0
				icms.reducao_base_calculo_st.must_equal      1.0
				icms.total_base_calculo_st.must_equal        644.80
				icms.aliquota_st.must_equal                  12.0
				icms.total_st.must_equal                     4.22
				icms.total_desoneracao.must_equal            0.0
				icms.motivo_desoneracao.must_be_nil
				icms.total_icms_operacao.must_equal          0.0
				icms.percentual_diferimento.must_equal       0.0
				icms.total_icms_diferido.must_equal          0.0
				icms.total_base_calculo_st_retido.must_equal 0.0
				icms.total_st_retido.must_equal              0.0
				icms.aliquota_credito_sn.must_equal          2.0
				icms.total_credito_sn.must_equal             8.4
				# IPI
				item.ipi.must_be_nil
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '07'
				# COFINS
				item.cofins.codigo_cst.must_equal '07'
				# Importação
				item.importacao.must_be_nil
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				item.pis_st.must_be_nil
				# COFINS-ST
				item.cofins_st.must_be_nil
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          411.80
				icms_uf_destino.percentual_fcp.must_equal              1.50
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 17.00
				icms_uf_destino.aliquota_interestadual.must_equal      12.00
				icms_uf_destino.percentual_partilha_destino.must_equal 60.0
				icms_uf_destino.total_fcp_destino.must_equal           6.18
				icms_uf_destino.total_destino.must_equal               12.35
				icms_uf_destino.total_origem.must_equal                8.24
			end
			it "Deve ler o Item 22 - Com DI e exportação" do
				item = invoice.itens[21]
				# Atributos
				item.tipo_produto.must_equal              :product
				item.codigo_produto.must_equal            'PD854KL'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'MICROCOMPUTADOR DELL ALL IN ONE INSPIRON 20 3059'
				item.codigo_ncm.must_equal                '84715010'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '6101'
				item.unidade_comercial.must_equal         'UN'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  1400.50
				item.valor_total_produto.must_equal       1400.50
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'UN'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 1400.50
				item.total_frete.must_equal               50.0
				item.total_seguro.must_equal              0.0
				item.total_desconto.must_equal            199.50
				item.total_outros.must_equal              0.0
				item.soma_total_nfe.must_equal            true
				item.numero_pedido_compra.must_equal      '79813168'
				item.item_pedido_compra.must_equal        '000001'
				item.numero_fci.must_equal                'B01F70AF-10BF-4B1F-848C-65FF57F616FE'
				item.percentual_devolucao.must_equal      0.0
				item.total_ipi_devolucao.must_equal       0.0
				item.informacoes_adicionais.must_equal    'OBSERVACOES DO PRODUTO 1'
				item.total_tributos.must_equal            147.87

				######################  Associações HasMany  ######################
				# Declarações de importação
				item.declaracoes_importacao.size.must_equal 1
				di = item.declaracoes_importacao[0]
				di.numero_documento.must_equal   'DOC123'
				di.data_registro.must_equal      Date.parse('2017-06-06')
				di.local_desembaraco.must_equal  'Pier 12'
				di.uf_desembaraco.must_equal     'SC'
				di.data_desembaraco.must_equal   Date.parse '2017-05-30'
				di.via_transporte.must_equal     1
				di.valor_afrmm.must_equal        150.00
				di.tipo_intermediacao.must_equal 3
				di.cnpj_adquirente.must_equal    '85956707000129'
				di.uf_terceiro.must_equal        'PR'
				di.codigo_exportador.must_equal  '945123'
				# Adições da importação
				di.adicoes.size.must_equal 1
				adi = di.adicoes[0]
				adi.numero_adicao.must_equal     '123'
				adi.sequencial.must_equal        1
				adi.codigo_fabricante.must_equal 'XINGLING'
				adi.valor_desconto.must_equal    0.98
				adi.numero_drawback.must_equal   '20160000012'

				# Detalhes da Exportação
				item.detalhes_exportacao.size.must_equal 1
				det_exp = item.detalhes_exportacao[0]
				det_exp.numero_drawback.must_equal    '201612347'
				det_exp.numero_registro.must_equal    '201612347'
				det_exp.chave_nfe_recebida.must_equal '42000082176985000186540000000000006313331836'
				det_exp.quantidade.must_equal         147.0

				######################  Associações HasOne  #########################
				### ICMS
				icms = item.icms
				icms.origem.must_equal                       0
				icms.codigo_cst.must_equal                   '102'
				# IPI
				ipi = item.ipi
				ipi.classe_enquadramento.must_equal 'C1324'
				ipi.cnpj_produtor.must_equal        '00916702000110'
				ipi.codigo_selo.must_equal          'SEL8724'
				ipi.quantidade_selo.must_equal      '10'
				ipi.codigo_enquadramento.must_equal '999'
				ipi.codigo_cst.must_equal           '50'
				ipi.base_calculo.must_equal         1400.50
				ipi.aliquota.must_equal             2.5000
				ipi.quantidade_unidade.must_equal   0.0
				ipi.total_unidade.must_equal        0.0
				ipi.total.must_equal                45.01
				# PIS
				pis = item.pis
				pis.codigo_cst.must_equal         '04'
				pis.total_base_calculo.must_equal 0.0
				pis.aliquota.must_equal           0.0
				pis.total.must_equal              0.0
				pis.quantidade_vendida.must_equal 0.0
				pis.total_aliquota.must_equal     0.0
				# COFINS
				cofins = item.cofins
				cofins.codigo_cst.must_equal         '01'
				cofins.total_base_calculo.must_equal 1400.50
				cofins.aliquota.must_equal           3.0000
				cofins.total.must_equal              54.02
				cofins.quantidade_vendida.must_equal 0.0
				cofins.total_aliquota.must_equal     0.0
				# Importação
				importacao = item.importacao
				importacao.total_base_calculo.must_equal        1400.50
				importacao.total_despesas_aduaneiras.must_equal 300.00
				importacao.total_imposto.must_equal             300.00
				importacao.total_iof.must_equal                 34.70
				# ISSQN
				item.issqn.must_be_nil
				# PIS-ST
				pis_st = item.pis_st
				pis_st.total_base_calculo.must_equal 0.0
				pis_st.aliquota.must_equal           0.0
				pis_st.total.must_equal              54.02
				pis_st.quantidade_vendida.must_equal 1.0
				pis_st.total_aliquota.must_equal     54.02
				# COFINS-ST
				cofins_st = item.cofins_st
				cofins_st.total_base_calculo.must_equal 2.0
				cofins_st.aliquota.must_equal           3.0
				cofins_st.quantidade_vendida.must_equal 1.0000
				cofins_st.total_aliquota.must_equal     4.0
				cofins_st.total.must_equal              54.02
				# ICMS UF DESTINO
				icms_uf_destino = item.icms_uf_destino
				icms_uf_destino.total_base_calculo.must_equal          1400.50
				icms_uf_destino.percentual_fcp.must_equal              1.50
				icms_uf_destino.aliquota_interna_uf_destino.must_equal 12.00
				icms_uf_destino.aliquota_interestadual.must_equal      17.00
				icms_uf_destino.percentual_partilha_destino.must_equal 80.00
				icms_uf_destino.total_fcp_destino.must_equal           27.01
				icms_uf_destino.total_destino.must_equal               244.87
				icms_uf_destino.total_origem.must_equal                61.22
			end
			it "Deve ler o Item 23 - Com ISSQN" do
				item = invoice.itens[22]
				# Atributos
				item.tipo_produto.must_equal              :service
				item.codigo_produto.must_equal            '123457'
				item.codigo_ean.must_equal                ''
				item.descricao_produto.must_equal         'DESCRICAO DO SERVICO'
				item.codigo_ncm.must_equal                '99'
				item.codigo_cest.must_equal               ''
				item.codigos_nve.must_equal               []
				item.codigo_extipi.must_equal             ''
				item.cfop.must_equal                      '5933'
				item.unidade_comercial.must_equal         'UN'
				item.quantidade_comercial.must_equal      1.0
				item.valor_unitario_comercial.must_equal  100.0
				item.valor_total_produto.must_equal       100.0
				item.codigo_ean_tributavel.must_equal     ''
				item.unidade_tributavel.must_equal        'UN'
				item.quantidade_tributavel.must_equal     1.0
				item.valor_unitario_tributavel.must_equal 100.0
				item.total_frete.must_equal               0.0
				item.total_seguro.must_equal              0.0
				item.total_desconto.must_equal            0.0
				item.total_outros.must_equal              0.0
				item.soma_total_nfe.must_equal            true
				item.informacoes_adicionais.must_equal    'Informacao Adicional do Servico'
				item.total_tributos.must_equal            0.0

				# ISSQN
				issqn = item.issqn
				issqn.total_base_calculo.must_equal            100.00
				issqn.aliquota.must_equal                      2.00
				issqn.total.must_equal                         2.00
				issqn.municipio_ocorrencia.must_equal          '3554003'
				issqn.codigo_servico.must_equal                '14.02'
				issqn.total_deducao_bc.must_equal              10.0
				issqn.total_outras_retencoes.must_equal        12.65
				issqn.total_desconto_incondicionado.must_equal 22.77
				issqn.total_desconto_condicionado.must_equal   10.47
				issqn.total_iss_retido.must_equal              2.45
				issqn.indicador_iss.must_equal                 1
				issqn.codigo_servico_municipio.must_equal      '1752464'
				issqn.municipio_incidencia.must_equal          '4265778'
				issqn.codigo_pais.must_equal                   '128'
				issqn.numero_processo.must_equal               '88782561'
				issqn.incentivo_fiscal.must_equal              false
			end
		end
	end
end