module BrNfe
	module Servico
		module Betha
			module V1
				class BuildResponse  < BrNfe::ActiveModelBase

					attr_accessor :hash
					attr_accessor :nfe_method
					
					def messages
						hash["#{nfe_method.to_s}_resposta".to_sym]
					end

					def success?
						messages[:lista_mensagem_retorno].blank?
					end

					def response
						@response ||= BrNfe::Servico::Response::Default.new do |resp|
							resp.success          = success?
							resp.error_messages   = error_messages
							resp.notas_fiscais    = get_notas_fiscais
							resp.protocolo        = messages[:protocolo]
							resp.data_recebimento = messages[:data_recebimento]
							resp.numero_lote      = messages[:numero_lote]
						end
					end

					def error_messages
						@error_messages ||= []
						return @error_messages if success? || !@error_messages.blank?
						msgs = messages[:lista_mensagem_retorno][:mensagem_retorno]
						if msgs.is_a?(Hash)
							@error_messages << get_message(msgs)
						else #Array
							msgs.each do |msg|
								@error_messages << get_message(msg)
							end
						end
						@error_messages
					end

				private

					def get_message(hash)
						{
							codigo:   hash[:codigo],
							mensagem: hash[:mensagem],
							correcao: hash[:correcao]
						}
					end

					def get_notas_fiscais
						@notas_fiscais = []
						return @notas_fiscais if messages[:lista_nfse].blank? || messages[:lista_nfse][:compl_nfse].blank?
						compl_nfse = messages[:lista_nfse][:compl_nfse]
						
						if compl_nfse.is_a?(Hash)
							@notas_fiscais << new_nota_fiscal(compl_nfse)
						elsif compl_nfse.is_a?(Array)
							compl_nfse.map{|p| @notas_fiscais << new_nota_fiscal(p) }
						end
						@notas_fiscais		
					end

					def new_nota_fiscal(params)
						info_nfse          = params[:nfse][:inf_nfse]
						info_cancelamento = params[:nfse_cancelamento]
						info_substituicao = params[:nfse_substituicao]

						BrNfe::Servico::Response::NotaFiscal.new do |nfse|
							nfse.numero_nf                = info_nfse[:numero]
							nfse.codigo_verificacao       = info_nfse[:codigo_verificacao]
							nfse.data_emissao             = info_nfse[:data_emissao]
							nfse.data_emissao_rps         = info_nfse[:data_emissao_rps]
							nfse.competencia              = info_nfse[:competencia]
							nfse.outras_informacoes       = info_nfse[:outras_informacoes]
							nfse.url_nf                   = info_nfse[:outras_informacoes]
							
							get_informacoes_rps      nfse, info_nfse[:identificacao_rps]
							get_dados_servico        nfse, info_nfse[:servico]
							get_emitente_servico     nfse, info_nfse[:prestador_servico]
							get_destinatario_servico nfse, info_nfse[:tomador_servico]
							get_orgao_gerador        nfse, info_nfse[:orgao_gerador]
							get_construcao_civil     nfse, info_nfse[:construcao_civil]
							
							get_intermediario     nfse, info_nfse[:intermediario_servico] if info_nfse[:intermediario_servico]

							get_info_cancelamento(   nfse, info_cancelamento) if info_cancelamento
							
							get_info_substituicao(   nfse, info_substituicao) if info_substituicao

							nfse.emitente.optante_simples_nacional = info_nfse[:optante_simples_nacional]
							nfse.emitente.natureza_operacao        = info_nfse[:natureza_operacao]
						end
					end

					def get_intermediario(nfse, params)
						nfse.intermediario do |int|
							int.razao_social = params[:razao_social]
							int.cpf_cnpj = params[:cpf_cnpj][:cnpj] || params[:cpf_cnpj][:cpf] if params[:cpf_cnpj]
							int.inscricao_municipal = params[:inscricao_municipal]
						end						
					end

					def get_info_substituicao(nfse, params)
						params ||= {}
						params = params[:substituicao_nfse] || {}

						nfse.nfe_substituidora = params[:nfse_substituidora]
					end

					def get_info_cancelamento(nfse, params)
						params ||= {}
						params = params[:confirmacao] || {}

						info_pedido_cancelamento = params[:pedido][:inf_pedido_cancelamento] if params[:pedido]
						info_pedido_cancelamento ||= {}

						confirmacao_cancelamento = params[:inf_confirmacao_cancelamento] || {}

						nfse.cancelamento_codigo              = info_pedido_cancelamento[:codigo_cancelamento]
						nfse.cancelamento_numero_nf           = info_pedido_cancelamento[:identificacao_nfse][:numero]              if info_pedido_cancelamento[:identificacao_nfse]
						nfse.cancelamento_cnpj                = info_pedido_cancelamento[:identificacao_nfse][:cnpj]                if info_pedido_cancelamento[:identificacao_nfse]
						nfse.cancelamento_inscricao_municipal = info_pedido_cancelamento[:identificacao_nfse][:inscricao_municipal] if info_pedido_cancelamento[:identificacao_nfse]
						nfse.cancelamento_municipio           = info_pedido_cancelamento[:identificacao_nfse][:codigo_municipio]    if info_pedido_cancelamento[:identificacao_nfse]
						nfse.cancelamento_sucesso             = confirmacao_cancelamento[:sucesso]
						nfse.cancelamento_data_hora           = confirmacao_cancelamento[:data_hora]						
					end

					def get_construcao_civil(nfse, params)
						params ||= {}
						nfse.codigo_obra = params[:codigo_obra]
						nfse.codigo_art  = params[:art]
					end

					def get_orgao_gerador(nfse, params)
						params ||= {}
						nfse.orgao_gerador_municipio = params[:codigo_municipio]
						nfse.orgao_gerador_uf        = params[:uf]
					end

					def get_emitente_servico(nfse, dados_emitente)
						dados_emitente ||= {}
						nfse.emitente do |em|
							em.cnpj                       = dados_emitente[:identificacao_prestador][:cnpj]                if dados_emitente[:identificacao_prestador]
							em.inscricao_municipal        = dados_emitente[:identificacao_prestador][:inscricao_municipal] if dados_emitente[:identificacao_prestador]
							em.razao_social               = dados_emitente[:razao_social]
							em.nome_fantasia              = dados_emitente[:nome_fantasia]
							em.telefone                   = dados_emitente[:contato][:telefone] if dados_emitente[:contato]
							em.email                      = dados_emitente[:contato][:email]    if dados_emitente[:contato]
							em.endereco                   = get_endereco(dados_emitente[:endereco])
						end
					end

					def get_destinatario_servico(nfse, dados_destinatario)
						dados_destinatario ||= {}
						identificacao_tomador = dados_destinatario[:identificacao_tomador] || {}
						nfse.destinatario do |em|
							em.cpf_cnpj            = identificacao_tomador[:cpf_cnpj][:cnpj] || identificacao_tomador[:cpf_cnpj][:cpf] if identificacao_tomador[:cpf_cnpj]
							em.inscricao_municipal = identificacao_tomador[:inscricao_municipal]
							em.inscricao_estadual  = identificacao_tomador[:inscricao_estadual]
							em.razao_social        = dados_destinatario[:razao_social]
							em.nome_fantasia       = dados_destinatario[:nome_fantasia]
							em.telefone            = dados_destinatario[:contato][:telefone] if dados_destinatario[:contato]
							em.email               = dados_destinatario[:contato][:email]    if dados_destinatario[:contato]
							em.endereco            = get_endereco(dados_destinatario[:endereco])
						end
					end

					def get_endereco(params)
						params ||= {}
						BrNfe::Endereco.new do |e|
							e.logradouro       = params[:endereco]
							e.numero           = params[:numero]
							e.complemento      = params[:complemento]
							e.bairro           = params[:bairro]
							e.nome_municipio   = params[:nome_municipio]
							e.codigo_municipio = params[:codigo_municipio]
							e.uf               = params[:uf]
							e.cep              = params[:cep]
							e.codigo_pais      = params[:codigo_pais] if params[:codigo_pais]
							e.nome_pais        = params[:nome_pais]   if params[:nome_pais]
						end
					end

					
					def get_dados_servico(nfse, dados_servico)
						nfse.item_lista_servico     = dados_servico[:item_lista_servico]
						nfse.codigo_cnae            = dados_servico[:codigo_cnae]
						nfse.discriminacao          = dados_servico[:discriminacao]
						nfse.codigo_municipio       = dados_servico[:codigo_municipio]

						nfse.valor_servicos          = dados_servico[:valores][:valor_servicos]
						nfse.valor_deducoes          = dados_servico[:valores][:valor_deducoes]
						nfse.valor_pis               = dados_servico[:valores][:valor_pis]
						nfse.valor_cofins            = dados_servico[:valores][:valor_cofins]
						nfse.valor_inss              = dados_servico[:valores][:valor_inss]
						nfse.valor_ir                = dados_servico[:valores][:valor_ir]
						nfse.valor_csll              = dados_servico[:valores][:valor_csll]
						nfse.iss_retido              = dados_servico[:valores][:iss_retido]
						nfse.valor_iss               = dados_servico[:valores][:valor_iss]
						nfse.base_calculo            = dados_servico[:valores][:base_calculo]
						nfse.aliquota                = dados_servico[:valores][:aliquota]
						nfse.desconto_condicionado   = dados_servico[:valores][:desconto_condicionado]
						nfse.desconto_incondicionado = dados_servico[:valores][:desconto_incondicionado]
					end

					def get_informacoes_rps(nfse, info_rps)
						nfse.rps_numero   = info_rps[:numero]
						nfse.rps_serie    = info_rps[:serie]
						nfse.rps_tipo     = info_rps[:tipo]
						nfse.rps_situacao = info_rps[:situacao]
					end
				end
			end
		end
	end
end