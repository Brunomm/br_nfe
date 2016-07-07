module BrNfe
	class ActiveModelBase
		include ActiveModel::Model

		def initialize(attributes = {})
			attributes = default_values.merge!(attributes)
			assign_attributes(attributes)
			yield self if block_given?
		end

		def assign_attributes(attributes)
			attributes ||= {}
			attributes.each do |name, value|
				send("#{name}=", value)
			end
		end

		def default_values
			{}
		end
	protected
	
		##################### FORMATAÇÃO DE VALORES #####################
		# Dependendo do WebService de emissão de nota, é necssário passar alguns valores
		# em formatos diferentes.
		# Os metodos a seguir neste bloco poderão ser sobrescritos para cada Webservice
		# tendo assim, um padrão definido para montar os dados para envio.
		# 
		def value_date(value)
			value = Date.parse(value.to_s)
			value.to_s(:br_nfe)
		rescue
			return ''
		end

		def value_date_time(data)
			data_hora = DateTime.parse(data.to_s)
			data_hora.to_s(:br_nfe)
		rescue
			return ''
		end

		# Irá retornar 1(true) e 2(false)
		def value_true_false(value)
			BrNfe.true_values.include?(value) ? '1' : '2'
		end

		# Deve receber um valor do tipo float
		# Irá retornar o valor com a precisão
		# Alguns WS convertem os valores para String com separador de milhar uma vírgula
		#
		def value_monetary(value, precision=2)
			return unless value
			precision ||= 2
			value.to_f.round(precision)
		end

		def value_amount(value, precision=2)
			value_monetary(value, precision)
		end

	end
end