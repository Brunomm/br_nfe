module BrNfe
	module Product
		module Evento
			class Base < BrNfe::ActiveModelBase

				# Identificador da TAG a ser assinada, 
				# a regra de formação do Id é: 
				#  "ID"+ tpEvento + chave da NF-e + nSeqEvento
				#
				#  ATENÇÃO: Caso o valor não for setado manualmente
				#           será gerado uma chave conforma a regra descrita anteriormente.
				# 
				# <b>Type:     </b> _String_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _ID1101113513040726711800012055000000000123193923347101_
				# <b>Length:   </b> _54_
				# <b>tag:      </b> Id
				#
				attr_accessor :chave
				def chave
					if @chave.present?
						@chave
					else
						generate_key
					end
				end
				alias_attribute :Id, :chave


				# CÓDIGO DO ÓRGÃO UTILIZADO PARA O EVENTO
				#   Código do órgão de recepção do Evento. Utilizar a Tabela
				#   do IBGE, utilizar 91 para identificar o Ambiente Nacional.
				#
				# ATENÇÃO: Não é obrigatório setar o valor nesse atributo,
				#          pois no momento em que monta o XML vai verificar 
				#          o código do Órgão conforme o gateway utilizado.
				#          Porém se for setado algum valor nesse atributo, será
				#          considerado o valor setado manualmente.
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _91_
				# <b>Length:   </b> _2_
				# <b>tag:      </b> cOrgao
				#
				attr_accessor :codigo_orgao
				alias_attribute :cOrgao, :codigo_orgao

				# CHAVE DE ACESSO DA NFE REFERENCIADA
				# Chave de Acesso da NF-e vinculada ao Evento
				# 
				# <b>Type:     </b> _String_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _35130407267118000120550000000001231939233471_
				# <b>Length:   </b> _44_
				# <b>tag:      </b> chNFe
				#
				attr_accessor :chave_nfe
				alias_attribute :chNFe, :chave_nfe

				# DATA E HORA DO EVENTO
				# Data e hora do evento no formato AAAA-MM-DDThh:mm:ssTZD(UTC - Universal Coordinated Time)
				#   Onde TZD pode ser -02:00 (Fernando de Noronha), -03:00
				#   (Brasília) ou -04:00 (Manaus), no horário de verão serão -
				#   01:00, -02:00 e -03:00. Ex.: 2010-08-19T13:00:15-03:00.
				# 
				# <b>Type:     </b> _Datetime_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _Date.current_
				# <b>Default:  </b> _Date.current_
				# <b>tag:      </b> dhEvento
				#
				attr_accessor :data_hora
				alias_attribute :dhEvento, :data_hora
				def data_hora
					convert_to_time( @data_hora )
				end

				# CÓDIGO DO EVENTO
				# 110111 = Cancelamento
				# 110110 = Carta de correção
				# 210200 = Confirmação da Operação
				# 210210 = Ciência da Emissão
				# 210220 = Desconhecimento da Operação
				# 210240 = Operação não Realizada
				# 110140 = EPEC
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _110111_
				# <b>Length:   </b> _6_
				# <b>tag:      </b> tpEvento
				#
				attr_accessor :codigo_evento
				alias_attribute :tpEvento, :codigo_evento
				def codigo_evento
					"#{@codigo_evento}".strip
				end

				# SEQUENCIAL DO EVENTO
				# Sequencial do evento para o mesmo tipo de evento. Para
				# maioria dos eventos nSeqEvento=1, nos casos em que
				# possa existir mais de um evento, como é o caso da Carta de
				# Correção, o autor do evento deve numerar de forma
				# sequencial.
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _1_
				# <b>Default:  </b> _1_
				# <b>Length:   </b> _max_value: 20_
				# <b>tag:      </b> nSeqEvento
				#
				attr_accessor :numero_sequencial
				alias_attribute :nSeqEvento, :numero_sequencial

				validates :chave, presence: true
				validates :chave, length: {is: 54}, allow_blank: true
				validates :chave_nfe, presence: true
				validates :chave_nfe, length: {is: 44}, allow_blank: true
				validates :data_hora, presence: true
				validates :codigo_evento, presence: true
				validates :codigo_evento, inclusion: {in: %w[110111 110110 210200 210210 210220 210240 110140]}
				validates :numero_sequencial, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 20}

			private

				def default_values
					{
						data_hora: Time.current,
						numero_sequencial: 1,
					}
				end

				def generate_key
					key =  'ID'
					key << "#{codigo_evento}"
					key << "#{chave_nfe}"
					key << "#{numero_sequencial}".rjust(2, '0')
					key
				end

			end
		end
	end
end