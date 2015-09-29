module BrNfe
	module Servico
		module Betha
			module V2
				class BuildResponse  < BrNfe::Servico::Betha::BuildResponse
					attr_accessor :xml
										
					def messages
						@messages ||= Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym }).parse(xml.to_s)["#{nfe_method.to_s}_resposta".to_sym]
					end

				private

					def key_complemento_nfse
						:comp_nfse
					end

					def new_nota_fiscal(params)
						info_nfse         = params[:nfse] ? params[:nfse][:inf_nfse] : {}
						
						BrNfe::Servico::Response::NotaFiscal.new do |nfse|
							nfse.numero_nf                = info_nfse[:numero]
							nfse.codigo_verificacao       = info_nfse[:codigo_verificacao]
							nfse.data_emissao             = info_nfse[:data_emissao]
							nfse.outras_informacoes       = info_nfse[:outras_informacoes]
							nfse.url_nf                   = info_nfse[:outras_informacoes]							
							
							get_emitente_servico     nfse, info_nfse[:prestador_servico]
							get_info_cancelamento(   nfse, params[:nfse_cancelamento]) if params[:nfse_cancelamento]
							get_info_substituicao(   nfse, params[:nfse_substituicao]) if params[:nfse_substituicao]
							get_orgao_gerador        nfse, info_nfse[:orgao_gerador]

							if info_nfse[:valores_nfse]
								nfse.base_calculo  = info_nfse[:valores_nfse][:base_calculo]
								nfse.aliquota      = info_nfse[:valores_nfse][:aliquota]
								nfse.valor_iss     = info_nfse[:valores_nfse][:valor_iss]
								nfse.valor_liquido = info_nfse[:valores_nfse][:valor_liquido_nfse]
							end

							get_declaracao_prestacao_servico(nfse, info_nfse[:declaracao_prestacao_servico]) if info_nfse[:declaracao_prestacao_servico]

						end
					end

					def get_emitente_servico(nfse, dados_emitente)
						dados_emitente ||= {}
						nfse.emitente do |em|
							if dados_emitente[:identificacao_prestador]
								em.cnpj = dados_emitente[:identificacao_prestador][:cpf_cnpj][:cnpj] if dados_emitente[:identificacao_prestador][:cpf_cnpj]
								em.inscricao_municipal = dados_emitente[:identificacao_prestador][:inscricao_municipal]
							end
							em.razao_social  = dados_emitente[:razao_social]
							em.nome_fantasia = dados_emitente[:nome_fantasia]
							if dados_emitente[:contato]
								em.telefone   = dados_emitente[:contato][:telefone]
								em.email      = dados_emitente[:contato][:email]
							end
							em.endereco      = get_endereco(dados_emitente[:endereco])
						end
					end

					def get_info_cancelamento(nfse, params)
						params ||= {}
						params = params[:confirmacao] || {}

						info_pedido_cancelamento = params[:pedido][:inf_pedido_cancelamento] if params[:pedido]
						info_pedido_cancelamento ||= {}

						confirmacao_cancelamento = params[:inf_confirmacao_cancelamento] || {}

						nfse.cancelamento_codigo              = info_pedido_cancelamento[:codigo_cancelamento]
						if info_pedido_cancelamento[:identificacao_nfse]
							nfse.cancelamento_numero_nf           = info_pedido_cancelamento[:identificacao_nfse][:numero]              
							nfse.cancelamento_cnpj                = info_pedido_cancelamento[:identificacao_nfse][:cpf_cnpj][:cnpj]     if info_pedido_cancelamento[:identificacao_nfse][:cpf_cnpj]
							nfse.cancelamento_inscricao_municipal = info_pedido_cancelamento[:identificacao_nfse][:inscricao_municipal]
							nfse.cancelamento_municipio           = info_pedido_cancelamento[:identificacao_nfse][:codigo_municipio]   
						end
						nfse.cancelamento_sucesso             = confirmacao_cancelamento[:sucesso]
						nfse.cancelamento_data_hora           = confirmacao_cancelamento[:data_hora]						
					end

					def get_declaracao_prestacao_servico(nfse, params)
						params = params[:inf_declaracao_prestacao_servico] || {}
						
						nfse.competencia = params[:competencia]
						nfse.emitente.optante_simples_nacional = params[:optante_simples_nacional]

						get_informacoes_rps      nfse, params[:rps]
						get_dados_servico        nfse, params[:servico]
						get_destinatario_servico nfse, params[:tomador]
						get_intermediario        nfse, params[:intermediario] if params[:intermediario]
						get_construcao_civil     nfse, params[:construcao_civil]
					end

					def get_informacoes_rps(nfse, params)
						params ||= {}
						if params[:identificacao_rps]
							nfse.rps_numero   = params[:identificacao_rps][:numero]
							nfse.rps_serie    = params[:identificacao_rps][:serie]
							nfse.rps_tipo     = params[:identificacao_rps][:tipo]
						end
						nfse.rps_situacao     = params[:situacao]
						nfse.data_emissao_rps = params[:data_emissao]
						if params[:rps_substituido]
							nfse.rps_substituido_numero   = params[:rps_substituido][:numero]
							nfse.rps_substituido_serie    = params[:rps_substituido][:serie]
							nfse.rps_substituido_tipo     = params[:rps_substituido][:tipo]
						end
					end

					def get_dados_servico(nfse, params)
						if valores = params[:valores]
							nfse.valor_servicos          = valores[:valor_servicos]
							nfse.valor_deducoes          = valores[:valor_deducoes]
							nfse.valor_pis               = valores[:valor_pis]
							nfse.valor_cofins            = valores[:valor_cofins]
							nfse.valor_inss              = valores[:valor_inss]
							nfse.valor_ir                = valores[:valor_ir]
							nfse.valor_csll              = valores[:valor_csll]
							nfse.outras_retencoes        = valores[:outras_retencoes]
							# nfse.valor_iss               = valores[:valor_iss]
							nfse.desconto_condicionado   = valores[:desconto_condicionado]
							nfse.desconto_incondicionado = valores[:desconto_incondicionado]
						end

						nfse.iss_retido                 = params[:iss_retido]
						nfse.responsavel_retencao       = params[:responsavel_retencao]
						nfse.item_lista_servico         = params[:item_lista_servico]
						nfse.codigo_cnae                = params[:codigo_cnae]
						nfse.discriminacao              = params[:discriminacao]
						nfse.codigo_municipio           = params[:codigo_municipio]
						nfse.emitente.natureza_operacao = params[:exigibilidade_iss]
						nfse.numero_processo            = params[:numero_processo]
						nfse.municipio_incidencia       = params[:municipio_incidencia]
					end

					def get_destinatario_servico(nfse, params)
						params ||= {}
						nfse.destinatario do |dest|
							if identificacao = params[:identificacao_tomador]
								dest.cpf_cnpj            = identificacao[:cpf_cnpj][:cnpj] || identificacao[:cpf_cnpj][:cpf] if identificacao[:cpf_cnpj]
								dest.inscricao_municipal = identificacao[:inscricao_municipal]
							end
							dest.razao_social     = params[:razao_social]
							dest.nome_fantasia    = params[:nome_fantasia]
							if params[:contato]
								dest.telefone      = params[:contato][:telefone] 
								dest.email         = params[:contato][:email]
							end
							dest.endereco         = get_endereco(params[:endereco])
						end
					end

					
				end
			end
		end
	end
end