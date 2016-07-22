module BrNfe
	module Service
		module SC
			module Gaspar
				class RecepcaoLoteRps < BrNfe::Service::Thema::V1::RecepcaoLoteRps
					def wsdl
						"http://nfse#{'hml' if env == :test}.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl"
					end

					def self.novo
						@endereco = BrNfe::Endereco.new({
							logradouro: "R BONIFACIO HAENDCHEN",
							numero: 1160,
							complemento: "E",
							bairro: "BELCHIOR CENTRAL",
							nome_municipio: "Gaspar",
							codigo_municipio: 4205902,
							uf: "SC",
							cep: "89110-000",
						})
						@emitente = BrNfe::Emitente.new({
							cnpj: '01.116.962/0001-73',
							inscricao_municipal: '66165-4',
							razao_social: 'AIRTON DOS SANTOS BARULHO - ME',
							natureza_operacao: '1',
							nome_fantasia: 'AIRTON DOS SANTOS BARULHO - ME',
							telefone: '4933665577',
							email: 'emitente@mail.com',
							regime_especial_tributacao: '1',
							optante_simples_nacional: true,
							incentivo_fiscal: false,
							endereco: @endereco
						})

						@destinatario = BrNfe::Destinatario.new({
							cpf_cnpj: "05.760.702/0001-97",
							inscricao_municipal: "",
							inscricao_estadual:  "",
							inscricao_suframa:   "",
							razao_social: "SISMAI LATOARIA E BORRACHARIA LTDA - ME",
							nome_fantasia: "SISMAI LATOARIA E BORRACHARIA LTDA - ME",
							telefone: "3365478",
							email: "destinatario@mail.com",
							endereco: @endereco
						})

						@rps = BrNfe::Service::Rps.new do |rps|
							rps.destinatario  = @destinatario
							rps.numero                  = 5525
							rps.serie                   = "SN"
							rps.tipo                    = "1"
							rps.data_emissao            = Time.current	
							rps.status                  = "1"
							rps.competencia             = Time.current
							rps.numero_substituicao     = "5524"
							rps.serie_substituicao      = "SN"
							rps.tipo_substituicao       = "1"
							rps.codigo_obra             = ""
							rps.codigo_art              = ""
							rps.total_services          = 100.00
							rps.deductions              = "0"
							rps.valor_pis               = "0"
							rps.valor_cofins            = ""
							rps.valor_inss              = ""
							rps.valor_ir                = ""
							rps.valor_csll              = ""
							rps.outras_retencoes        = ""
							rps.iss_retained            = ""
							rps.total_iss               = 2.0
							rps.iss_tax_rate            = 0.02 # = 2%
							rps.base_calculation        = "100.00"
							rps.desconto_incondicionado = ""
							rps.desconto_condicionado   = ""
							rps.responsavel_retencao    = ""
							rps.item_lista_servico      = "1.07"
							rps.description             = "1 Configuração de servidor: R$ 500.00"
							rps.exigibilidade_iss       = "1"
							rps.codigo_municipio        = "4204202"
							rps.municipio_incidencia    = "4204202"
							rps.codigo_pais             = ""
							rps.numero_processo         = ""
							rps.cnae_code               = ""
							rps.outras_informacoes      = ""
							rps.codigo_tributacao_municipio = ""
						end

						# BrNfe::Service::Betha::V1::RecepcaoLoteRps.
						# BrNfe::Service::SC::Gaspar::ConsultaSituacaoLoteDfs.
						new({
							emitente: @emitente,
							numero_lote_rps: 7786,
							lote_rps: [@rps],
							certificate_pkcs12_path: "#{BrNfe.root}/test/cert.pfx",
							certificate_pkcs12_password: 'associacao'
						})
					end					
				end
			end
		end
	end
end