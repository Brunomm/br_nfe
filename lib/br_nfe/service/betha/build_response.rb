module BrNfe
	module Service
		module Betha
			class BuildResponse  < BrNfe::ActiveModelBase
				attr_accessor :nfe_method

				def initialize(attributes = {})
					@error_messages = []
					super(attributes)
				end
				
				def success?
					error_messages.blank?
				end

				def response
					@response ||= BrNfe::Service::Response::Default.new do |resp|
						resp.success          = success?
						resp.error_messages   = error_messages
						resp.notas_fiscais    = get_notas_fiscais
						resp.protocolo        = messages[:protocolo]
						resp.data_recebimento = messages[:data_recebimento]
						resp.numero_lote      = messages[:numero_lote]
					end
				end

				def error_messages						
					return @error_messages unless @error_messages.blank?

					get_messages!(messages[:lista_nfse][:listamensagem_alerta_retorno]) if messages[:lista_nfse]						
					get_messages!(messages[:lista_mensagem_retorno])						
					get_messages!(messages[:lista_mensagem_retorno_lote])

					@error_messages
				end

			private

				def get_notas_fiscais
					@notas_fiscais = []
					return @notas_fiscais if messages[:lista_nfse].blank? || messages[:lista_nfse][key_complemento_nfse].blank?
					comp_nfse = messages[:lista_nfse][key_complemento_nfse]
					
					if comp_nfse.is_a?(Hash)
						@notas_fiscais << new_nota_fiscal(comp_nfse)
					elsif comp_nfse.is_a?(Array)
						comp_nfse.map{|p| @notas_fiscais << new_nota_fiscal(p) }
					end
					@notas_fiscais		
				end

				def get_messages!(msgs)
					return unless msgs
					msgs = msgs[:mensagem_retorno]
					if msgs.is_a?(Hash)
						@error_messages << get_message(msgs)
					elsif msgs.is_a?(Array)
						msgs.each do |msg|
							@error_messages << get_message(msg)
						end
					end
				end

				def get_message(hash)
					if hash[:identificacao_rps]
						{
							codigo:   hash[:codigo],
							mensagem: hash[:mensagem],
							rps: {
								numero: hash[:identificacao_rps][:numero],
								serie:  hash[:identificacao_rps][:serie],
								tipo:   hash[:identificacao_rps][:tipo],
							}
						}
					else
						{
							codigo:   hash[:codigo],
							mensagem: hash[:mensagem],
							correcao: hash[:correcao]
						}
					end
				end

				def get_construcao_civil(nfse, params)
					params ||= {}
					nfse.codigo_obra = params[:codigo_obra]
					nfse.codigo_art  = params[:art]
				end

				def get_info_substituicao(nfse, params)
					params ||= {}
					params = params[:substituicao_nfse] || {}

					nfse.nfe_substituidora = params[:nfse_substituidora]
				end


				def get_orgao_gerador(nfse, params)
					params ||= {}
					nfse.orgao_gerador_municipio = params[:codigo_municipio]
					nfse.orgao_gerador_uf        = params[:uf]
				end

				def get_destinatario_servico(nfse, params)
					params ||= {}
					nfse.destinatario do |dest|
						if identificacao = params[:identificacao_tomador]
							dest.cpf_cnpj            = identificacao[:cpf_cnpj][:cnpj] || identificacao[:cpf_cnpj][:cpf] if identificacao[:cpf_cnpj]
							dest.inscricao_municipal = identificacao[:inscricao_municipal]
							dest.inscricao_estadual = identificacao[:inscricao_estadual]
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
			end
		end
	end
end