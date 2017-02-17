module BrNfe
	module Product
		class Emitente  < BrNfe::Person
			validate  :validar_endereco

			# IE do Substituto Tributário da UF de destino da mercadoria,
			# quando houver a retenção do ICMS ST para a UF de destino.
			#
			# <b>Tipo: </b> _Number_
			# 
			attr_accessor :inscricao_estadual_st
			
			# Código CNAE
			#
			attr_accessor :cnae_code



		end
	end
end