module BrNfe
	module Service
		class Rps < BrNfe::ActiveModelBase
			include BrNfe::Association::HaveDestinatario
			include BrNfe::Service::Association::HaveIntermediario
			include BrNfe::Association::HaveCondicaoPagamento

			# Método utilizado para saberse o modelo deve validar
			# as informações obrigatórias do RPS.
			# Por padrão é setado com true pois a maioria das cidades trabalha com RPS.
			# Para as cidades que não trabalham com RPS esse método deverá ser sobrescrito
			#
			# <b>Tipo: </b> _Boolean_
			def validate_rps?
				true
			end

			# Sempre que houver RPS, essas informações são obrigatórias
			validates :numero, :serie, :tipo, presence: true, if: :validate_rps?

			with_options if: :validar_recepcao_rps do |record|
				record.validates :data_emissao, :item_lista_servico, :description, :codigo_municipio, :base_calculo, presence: true
				record.validates :total_iss, :iss_aliquota, presence: true, unless: :iss_retido?
				record.validates :municipio_incidencia, presence: true, if: :municipio_incidencia_obrigatorio?

				record.validates :valor_total_servicos, :base_calculo, numericality: {greater_than: 0}
				
				record.validates :deducoes, :valor_pis, :valor_cofins, :valor_inss, :valor_ir, 
				          :valor_csll, :outras_retencoes, :total_iss, :iss_aliquota, :base_calculo, 
				          :desconto_incondicionado, :desconto_condicionado, numericality: true, allow_blank: true

				record.validate :validar_intermediario
				record.validate :validar_destinatario
			end


			def initialize(attributes = {})
				self.items = [] # Para poder utilizar o << para adicionar itens
				super
			end
			
			# Itens do RPS
			# Contém um vetor com todos os serviços prestados
			# Para a maioria das cidades os itens são informados junto à discriminação
			# porém para outras poucas cidades é possível inserir vários itens de serviços
			# na NF.
			# 
			# Mesmo para as cidades que não permitem enviar os itens de serviço
			# será necessário informar pelo menos 1 item.
			#
			# <b>Tipo: </b> _Array_
			attr_accessor :items
			def items
				@items = [@items].flatten # Para retornar sempre um vetor
				# Só aceita objetos que forem da classe definida em _BrNfe.service_item_class_
				@items.select!{ |item| item.is_a?(BrNfe.service_item_class) }
				@items
			end

			# Valor da base de cálculo da substituição tributária
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :total_base_calculo_st

			# Valor total do ISS de substituição tributária
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :total_issqn_st
			
			attr_accessor :validar_recepcao_rps

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

			# Valor total dos serviços
			# Pode ser definido diretamente ou então será a soma
			# do valor de todos os itens
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :valor_total_servicos
			def valor_total_servicos
				@valor_total_servicos || items.map(&:valor_total).map(&:to_f).sum.round(2)
			end

			# Valor da base de cálculo
			# Caso não definido irá somar o total dos serviços e subtrair com
			# o valor das deduções
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :base_calculo
			def base_calculo
				@base_calculo || (valor_total_servicos.to_f - deducoes.to_f).round(2)
			end

			# Valor das deduções de impostos 
			# 
			# <b>Tipo: </b> _Float_
			attr_accessor :deducoes

			# Iss retido?
			# Identifica se o ISS foi retido 
			#
			# <b>Tipo: </b> _Integer_
			attr_accessor :iss_retido

			# Valor do Iss retido 
			# Total de iss retido da nota
			#
			# <b>Tipo: </b> _float_
			#
			attr_accessor :total_iss_retido

			# Valor total do ISS (R$)
			# Valor utilizado para identificar o valor total do ISS
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :total_iss
			
			# % de Aliquota do ISS
			# Utilizado para as cidades que não possuem multiplos itens de serviço na nota.
			# Caso não seja definido então irá pegar a aliquota do 1º item que encontrar
			#
			# O Valor informado deve ser o percentual real do ISS
			# EXEMPLO:
			# 2%   = 2.0
			# 3.5% = 3.5
			#
			# <b>Tipo: </b> _Float_
			attr_accessor :iss_aliquota
			def iss_aliquota
				@iss_aliquota || items.first.try(:iss_aliquota)
			end

			# Valor líquido da NF (R$)
			# Caso não seja setado um valor manualmente irá calcular o valor 
			#
			# <b>Tipo: </b> _Float_
			#
			attr_accessor :valor_liquido
			def valor_liquido
				@valor_liquido ||= valor_total_servicos.to_f - (
					valor_pis.to_f + valor_cofins.to_f + valor_inss.to_f + 
					valor_ir.to_f  + valor_csll.to_f   + outras_retencoes.to_f + 
					total_iss_retido.to_f + desconto_incondicionado.to_f + desconto_condicionado.to_f
				)
			end

			attr_accessor :valor_pis
			attr_accessor :valor_cofins
			attr_accessor :valor_inss
			attr_accessor :valor_ir
			attr_accessor :valor_csll
			attr_accessor :outras_retencoes
			attr_accessor :desconto_incondicionado
			attr_accessor :desconto_condicionado
			
			attr_accessor :responsavel_retencao
			attr_accessor :item_lista_servico
			attr_accessor :codigo_tributacao_municipio
			attr_accessor :exigibilidade_iss
			attr_accessor :codigo_municipio
			attr_accessor :municipio_incidencia
			attr_accessor :codigo_pais
			attr_accessor :numero_processo
			attr_accessor :outras_informacoes
			
			# Código CNAE (Classificação Nacional de Atividades Econômicas)
			# Pode ser encontrado em  http://www.cnae.ibge.gov.br/
			# Tamanho de 8 caracteres
			# - Para as cidades que não trabalham com multiplos serviços na nota, se não for definido
			#   um código CNAE será pega o código do 1° item de serviço (se houver algum)
			#
			# <b>Tipo: </b> _String_
			attr_accessor :cnae_code 
			def cnae_code
				@cnae_code || items.first.try(:cnae_code)
			end

			# Descrição dos serviços prestados
			# Algumas cidades permitem adicionar os serviços com itens
			# e a maioria é necessário identificar cada serviço dentro da discriminação.
			#
			# <b>Tipo: </b> _Text_
			attr_accessor :description

			# Verifica se a NF atual está sendo substituida por outra
			#
			# <b>Tipo: </b> _Boolean_
			def replace_invoice?
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

			def municipio_incidencia_obrigatorio?
				"#{exigibilidade_iss}".in?(['1','01','6','06','7','07'])
			end
			def destinatario_class
				BrNfe.destinatario_service_class
			end
		end
	end
end