module BrNfe
	module Product
		module Nfe
			class DetalheExportacao < BrNfe::ActiveModelBase
				# NÚMERO DO ATO CONCESSÓRIO DE DRAWBACK
				# O número do Ato Concessório de Suspensão deve ser
				# preenchido com 11 dígitos (AAAANNNNNND) e o número do
				# Ato Concessório de Drawback Isenção deve ser preenchido
				# com 9 dígitos (AANNNNNND).
				# (Observação incluída na NT 2013/005 v. 1.10)
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _201612347_
				# <b>Length:   </b> _0, 9 OR 11_
				# <b>tag:      </b> nDraw
				#
				attr_accessor :numero_drawback
				def numero_drawback
					"#{@numero_drawback}".gsub(/[^\d]/,'')
				end
				alias_attribute :nDraw, :numero_drawback

				######################################################################
				################# GRUPO SOBRE EXPORTAÇÃO INDIRETA  ###################
					# Número do Registro de Exportação
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_ (Yes if numero_drawback.blank?)
					# <b>Example:  </b> _201612347_
					# <b>Length:   </b> _12_
					# <b>tag:      </b> nRE
					#
					attr_accessor :numero_registro
					def numero_registro
						"#{@numero_registro}".gsub(/[^\d]/,'')
					end
					alias_attribute :nRE, :numero_registro

					# CHAVE DE ACESSO DA NF-E RECEBIDA PARA EXPORTAÇÃO
					# NF-e recebida com fim específico de exportação.
					# No caso de operação com CFOP 3.503, informar a chave de
					# acesso da NF-e que efetivou a exportação
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_ (Yes if numero_drawback.blank?)
					# <b>Example:  </b> _41313.._
					# <b>Length:   </b> _44_
					# <b>tag:      </b> chNFe
					#
					attr_accessor :chave_nfe_recebida
					def chave_nfe_recebida
						"#{@chave_nfe_recebida}".gsub(/[^\d]/,'')
					end
					alias_attribute :chNFe, :chave_nfe_recebida

					# QUANTIDADE DO ITEM REALMENTE EXPORTADO
					# A unidade de medida desta quantidade é a unidade de
					# comercialização deste item.
					# No caso de operação com CFOP 3.503, informar a quantidade
					# de mercadoria devolvida
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_ (Yes if numero_drawback.blank?)
					# <b>Example:  </b> _147.0423_
					# <b>Length:   </b> _precision: 4_
					# <b>tag:      </b> qExport
					#
					attr_accessor :quantidade
					alias_attribute :qExport, :quantidade

				validates :numero_drawback,    length: {in: 9..12}, allow_blank: true
				validates :numero_registro,    length: {is: 12},    allow_blank: true
				validates :chave_nfe_recebida, length: {is: 44},    allow_blank: true
				validates :quantidade, numericality: {greater_than: 0.0}, allow_blank: true

				def ignore?
					numero_drawback.blank? && numero_registro.blank? && 
					chave_nfe_recebida.blank? && quantidade.blank?
				end

				def exportacao_indireta?
					numero_registro.present? || chave_nfe_recebida.present? ||
					quantidade.present?
				end
			end
		end
	end
end