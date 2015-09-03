module BrNfe
	class Seed  < BrNfe::ActiveModelBase
		attr_accessor :env
		attr_accessor :incremento
		attr_accessor :numero_rps


		def default_values
			{env: :test}
		end

		def emitente
			BrNfe::Emitente.new({
				cnpj:                       '18.113.831/0001-35',
				inscricao_municipal:        '42615-6',
				razao_social:               'TWOWEB AGENCIA DIGITAL LTDA - ME',
				nome_fantasia:              'TWOWEB AGENCIA DIGITAL',
				telefone:                   '33161107',
				email:                      'mail@mail.com',
				regime_especial_tributacao: '1',
				optante_simples_nacional:   '1',
				incentivo_fiscal:           '2',
				natureza_operacao:          '1',
				endereco: {
					logradouro:       'R AFONSO PENA',
					numero:           '420',
					complemento:      'D',
					bairro:           'SAO CRISTOVAO',
					nome_municipio:   'Chapeco',
					codigo_municipio: '4204202',
					uf:               'SC',
					cep:              '89804023',
				}
			})
		end

		def destinatario
			BrNfe::Destinatario.new({
				cpf_cnpj:            '18.077.391/0001-08',
				razao_social:        'I9K SOLUCOES TECNOLOGICAS LTDA',
				nome_fantasia:       'I9K SOLUCOES',
				telefone:            '336644557',
				email:               'mail@mail.com',
				endereco: {
					logradouro:       'R JERUSALEM',
					numero:           '61',
					complemento:      'E, SALAS 06 E 07',
					bairro:           'PASSO DOS FORTES',
					nome_municipio:   'Chapeco',
					codigo_municipio: '4204202',
					uf:               'SC',
					cep:              '89805675',
				}
			})
		end


		def recepcao_lote_rps_v1
			BrNfe::Servico::Betha::V1::RecepcaoLoteRps.new do |recepcao|
				recepcao.emitente = emitente
				recepcao.lote_rps = rps
				recepcao.numero_lote_rps = 1807+incremento
				recepcao.env = :test
			end
		end

		def consulta_lote_rps_v1(protocolo)
			BrNfe::Servico::Betha::V1::ConsultaLoteRps.new do |obj|
				obj.env = :test
				obj.emitente = emitente
				obj.protocolo = protocolo
			end
		end

		def consulta_nfs_por_rps_v1
			BrNfe::Servico::Betha::V1::ConsultaNfsPorRps.new do |obj|
				obj.env = :test
				obj.emitente = emitente
				obj.rps = rps
			end
		end

		def consulta_nfse_v1(params={})
			BrNfe::Servico::Betha::V1::ConsultaNfse.new do |obj|
				obj.env = :test
				obj.emitente = emitente
				obj.numero_nfse  = params[:numero_nfse]
				obj.data_inicial = params[:data_inicial] || Date.today.beginning_of_month
				obj.data_final   = params[:data_final] || Date.today.end_of_month
			end
		end



		def cancelamento_nfs_v1(params = {})
			BrNfe::Servico::Betha::V1::CancelamentoNfs.new do |c|
				c.env               = :test
				c.emitente          = emitente
				c.numero_nfse       = params[:numero_nfse]
				codigo_cancelamento = params[:codigo_cancelamento] || '1'
			end
		end


		def rps
			BrNfe::Servico::Rps.new do |rps|
				rps.destinatario = destinatario
				rps.numero       = numero_rps
				rps.serie        = 'SN'
				rps.tipo         = '1'
				rps.data_emissao = DateTime.now
				rps.status       = '1'
				rps.competencia  = Date.today

				rps.valor_servicos          = '49.00'
				rps.valor_deducoes          = '0.0'
				rps.valor_pis               = '0.0'
				rps.valor_cofins            = '0.0'
				rps.valor_inss              = '0.0'
				rps.valor_ir                = '0.0'
				rps.valor_csll              = '0.0'
				rps.outras_retencoes        = '0.0'
				rps.valor_iss               = '0.98'
				rps.aliquota                = '0.02'
				rps.base_calculo            = '49.00'
				rps.desconto_incondicionado = '0.0'
				rps.desconto_condicionado   = '0.0'

				rps.iss_retido                  = '2'
				rps.responsavel_retencao        = ''
				rps.item_lista_servico          = '0107'
				rps.codigo_tributacao_municipio = ''
				rps.discriminacao               = "1 MENSALIDADE PLANO LIGHT. 49,00 \n\n\n\n\nValor Aprox dos Tributos: R$ 6,59 Federal, R$ 0,00 Estadual e R$ 1,62 Municipal \n Fonte: IBPT/FECOMERCIO SC 5oi7eW"
				rps.exigibilidade_iss           = ''
				rps.codigo_municipio            = '4204202'
				rps.numero_processo             = ''
				rps.codigo_cnae                 = '6202300'
			end			
		end

	end
end