module BrNfe
	module Product
		module Nfe
			class AdicaoImportacao < BrNfe::ActiveModelBase
				# Numero da Adição
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _123_
				# <b>Length:   </b> _max: 3_
				# <b>tag:      </b> nAdicao
				#
				attr_accessor :numero_adicao
				alias_attribute :nAdicao, :numero_adicao

				# Numero sequencial do item dentro da Adição
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _2_
				# <b>Length:   </b> _max: 3_
				# <b>tag:      </b> nSeqAdic
				#
				attr_accessor :sequencial
				alias_attribute :nSeqAdic, :sequencial

				# Código do fabricante estrangeiro
				# Código do fabricante estrangeiro, usado nos sistemas internos
				# de informação do emitente da NF-e
				# 
				# <b>Type:     </b> _String_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _XINGLING_
				# <b>Length:   </b> _max: 60_
				# <b>tag:      </b> cFabricante
				#
				attr_accessor :codigo_fabricante
				alias_attribute :cFabricante, :codigo_fabricante

				# Valor do desconto do item da DI – Adição
				# 
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _35.50_
				# <b>Length:   </b> _precision: 2_
				# <b>tag:      </b> vDescDI
				#
				attr_accessor :valor_desconto
				alias_attribute :vDescDI, :valor_desconto

				# Número do ato concessório de Drawback
				# O número do Ato Concessório de Suspensão deve ser
				# preenchido com 11 dígitos (AAAANNNNNND) e o número do
				# Ato Concessório de Drawback Isenção deve ser preenchido
				# com 9 dígitos (AANNNNNND). (Observação incluída na NT
				# 2013/005 v. 1.10)
				# 
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _20160000012_
				# <b>Length:   </b> _min: 9, max: 11_
				# <b>tag:      </b> nDraw
				#
				attr_accessor :numero_drawback
				alias_attribute :nDraw, :numero_drawback

				validates :numero_adicao,     presence: true
				validates :sequencial,        presence: true
				validates :codigo_fabricante, presence: true
				validates :numero_drawback,   length: {in: 9..11 },  allow_blank: true
				validates :codigo_fabricante, length: {maximum: 60}, allow_blank: true

			end
		end
	end
end