module BrNfe
	module Servico
		class Rps < BrNfe::ActiveModelBase
			include BrNfe::Helper::HaveDestinatario
			include BrNfe::Helper::HaveIntermediario
			include BrNfe::Helper::HaveCondicaoPagamento

			attr_accessor :validar_recepcao_rps

			# Sempre que houver RPS, essas informações são obrigatórias
			validates :numero, :serie, :tipo, presence: true

			with_options if: :validar_recepcao_rps do |record|
				record.validates :data_emissao, :item_lista_servico, :discriminacao, :codigo_municipio, 
				                 :valor_servicos, :base_calculo, presence: true
				record.validates :valor_iss, :aliquota, presence: true, unless: :iss_retido?
				
				record.validates :valor_servicos, :valor_deducoes, :valor_pis, :valor_cofins, :valor_inss, :valor_ir, 
				          :valor_csll, :outras_retencoes, :valor_iss, :aliquota, :base_calculo, 
				          :desconto_incondicionado, :desconto_condicionado, numericality: true, allow_blank: true

				record.validate :validar_intermediario
				record.validate :validar_destinatario
			end

			attr_accessor :numero
			attr_accessor :serie
			attr_accessor :tipo

			attr_accessor :data_emissao
			attr_accessor :status
			attr_accessor :competencia

			attr_accessor :numero_substituicao
			attr_accessor :serie_substituicao
			attr_accessor :tipo_substituicao
			
			#Para construção civil
			attr_accessor :codigo_obra
			attr_accessor :codigo_art

			attr_accessor :valor_servicos
			attr_accessor :valor_deducoes
			attr_accessor :valor_pis
			attr_accessor :valor_cofins
			attr_accessor :valor_inss
			attr_accessor :valor_ir
			attr_accessor :valor_csll
			attr_accessor :outras_retencoes
			attr_accessor :iss_retido
			attr_accessor :valor_iss
			attr_accessor :aliquota
			attr_accessor :base_calculo
			attr_accessor :desconto_incondicionado
			attr_accessor :desconto_condicionado
			
			attr_accessor :responsavel_retencao
			attr_accessor :item_lista_servico
			attr_accessor :codigo_tributacao_municipio
			attr_accessor :discriminacao
			attr_accessor :exigibilidade_iss
			attr_accessor :codigo_municipio
			attr_accessor :municipio_incidencia
			attr_accessor :codigo_pais
			attr_accessor :numero_processo
			attr_accessor :codigo_cnae
			attr_accessor :outras_informacoes

			def contem_substituicao?
				numero_substituicao.present? && serie_substituicao.present? && tipo_substituicao.present?
			end

			def iss_retido?
				BrNfe.true_values.include?(iss_retido)
			end

			def competencia
				@competencia || data_emissao
			end

			def default_values
				{
					codigo_pais: '1058',
					validar_recepcao_rps: false
				}
			end
		private

			def validar_intermediario
				return true unless intermediario
				if intermediario.invalid?
					intermediario.errors.full_messages.map{|msg| errors.add(:base, "Intermediário: #{msg}") }
				end
			end

			def validar_destinatario
				if destinatario.invalid?
					destinatario.errors.full_messages.map{|msg| errors.add(:base, "Destinatário: #{msg}") }
				end
			end
		end
	end
end