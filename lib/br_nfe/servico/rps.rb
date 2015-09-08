module BrNfe
	module Servico
		class Rps < BrNfe::ActiveModelBase
			include BrNfe::Helper::HaveDestinatario
			include BrNfe::Helper::HaveIntermediario
			include BrNfe::Helper::HaveCondicaoPagamento

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
			attr_accessor :numero_processo
			attr_accessor :codigo_cnae
			attr_accessor :outras_informacoes

			def contem_substituicao?
				numero_substituicao.present? && serie_substituicao.present? && tipo_substituicao.present?
			end
		end
	end
end