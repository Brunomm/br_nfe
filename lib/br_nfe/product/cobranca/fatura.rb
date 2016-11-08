module BrNfe
	module Product
		module Cobranca
			class Fatura < BrNfe::ActiveModelBase
				# Número da fatura
				# 
				# <b>Type: </b> _String_
				# <b>Max: </b> _60_
				# <b>Required: </b> _No_
				# <b>Exemplo: </b> _FAT646498_
				#
				attr_accessor :numero_fatura

				# Valor original da fatura
				# 
				# <b>Type: </b> _Float_
				# <b>Required: </b> _No_
				# <b>Exemplo: </b> _1500.50_
				#
				attr_accessor :valor_original

				# Valor do desconto da fatura
				# 
				# <b>Type: </b> _Float_
				# <b>Required: </b> _No_
				# <b>Exemplo: </b> _100.25_
				#
				attr_accessor :valor_desconto

				# Valor do liquido da fatura
				# 
				# <b>Type: </b> _Float_
				# <b>Required: </b> _No_
				# <b>Default: </b> _Auto_
				# <b>Exemplo: </b> _1400.25_
				#
				attr_accessor :valor_liquido
				def valor_liquido
					@valor_liquido || calculate_valor_liquido
				end

				attr_accessor :duplicatas
				def duplicatas
					arry = [@duplicatas].flatten.reject(&:blank?)
					arry_ok = arry.select{|v| v.is_a?(BrNfe.duplicata_product_class) }
					arry.select!{|v| v.is_a?(Hash) }
					arry.map{ |hash| arry_ok.push(BrNfe.duplicata_product_class.new(hash)) }
					@duplicatas = arry_ok
					@duplicatas
				end

				validate :duplicatas_validations
				validates :duplicatas, length: {maximum: 120}

			private
				def calculate_valor_liquido
					valor_original.to_f - valor_desconto.to_f
				end

				############################  DUPLICATAS  ############################
					# Adiciona os erros das duplicatas no objeto
					#
					def duplicatas_validations
						duplicatas.select(&:invalid?).each_with_index do |duplicata, i|
							add_duplicata_errors(duplicata, i+1)
						end
					end
					def add_duplicata_errors(duplicata, index)
						duplicata.errors.full_messages.each do |message|
							errors.add(:base, :invalid_duplicata, {index: index, error_message: message})
						end
					end
			end
		end
	end
end