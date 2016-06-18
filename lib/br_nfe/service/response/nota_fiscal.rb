module BrNfe
	module Service
		module Response
			class NotaFiscal < BrNfe::ActiveModelBase
				include BrNfe::Helper::HaveIntermediario
				include BrNfe::Helper::HaveDestinatario
				include BrNfe::Helper::HaveEmitente
				include BrNfe::Helper::HaveCondicaoPagamento

				attr_accessor :numero_nf
				attr_accessor :codigo_verificacao
				attr_accessor :data_emissao
				attr_accessor :url_nf
				
				#identificacao do rps
				attr_accessor :rps_numero
				attr_accessor :rps_serie
				attr_accessor :rps_tipo
				attr_accessor :rps_situacao
				attr_accessor :rps_substituido_numero
				attr_accessor :rps_substituido_serie
				attr_accessor :rps_substituido_tipo

				attr_accessor :data_emissao_rps    # Datetime
				attr_accessor :competencia         #DateTime
				attr_accessor :outras_informacoes
				
				# dados dos serviços
				attr_accessor :item_lista_servico
				attr_accessor :cnae_code
				attr_accessor :description
				attr_accessor :codigo_municipio

				#Valores dos serviços
				attr_accessor :total_services
				attr_accessor :deductions
				attr_accessor :valor_pis
				attr_accessor :valor_cofins
				attr_accessor :valor_inss
				attr_accessor :valor_ir
				attr_accessor :valor_csll
				attr_accessor :iss_retained
				attr_accessor :outras_retencoes
				attr_accessor :total_iss
				attr_accessor :base_calculation
				attr_accessor :iss_tax_rate
				attr_accessor :valor_liquido # v2
				attr_accessor :desconto_condicionado # v2
				attr_accessor :desconto_incondicionado # v2

				attr_accessor :responsavel_retencao
				attr_accessor :numero_processo
				attr_accessor :municipio_incidencia
				
				# Orgão gerador
				attr_accessor :orgao_gerador_municipio
				attr_accessor :orgao_gerador_uf

				# Dados de cancelamento da NF
				attr_accessor :cancelamento_codigo
				attr_accessor :cancelamento_numero_nf
				attr_accessor :cancelamento_cnpj
				attr_accessor :cancelamento_inscricao_municipal
				attr_accessor :cancelamento_municipio				
				attr_accessor :cancelamento_sucesso
				attr_accessor :cancelamento_data_hora

				# Se a NF foi substituida
				attr_accessor :nfe_substituidora
				def substituida?
					!nfe_substituidora.blank?
				end

				# dados de construcao civil
				attr_accessor :codigo_obra
				attr_accessor :codigo_art

				
			end
		end
	end
end