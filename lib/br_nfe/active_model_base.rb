module BrNfe
	class ActiveModelBase
		include ::ActiveModel::Model
		include BrNfe::ActiveModel::Associations

		# Utilizado para referenciar o objeto que utiliza a informação.
		# Setado automaticamnete no has_one e has_many;
		# Exemplo:
		#    ~$ endereco = Endereco.new
		#    ~$ pessoa = Pessoa.new(endereco: endereco)
		#    ~$ endereco.reference
		#    ~$ => pessoa
		#
		attr_accessor :reference

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

		def canonicalize(xml)
			xml = Nokogiri::XML(xml.to_s, &:noblanks)
			xml.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
		end

		def convert_to_time(value)
			return if value.blank?
			if value.class.in?([Time, DateTime])
				value.to_time.in_time_zone
			else
				Time.zone ? Time.zone.parse(value.to_s) : Time.parse(value.to_s)
			end
		rescue
			nil
		end

		def convert_to_date(value)
			return if value.blank?
			if value.is_a?(Date)
				value
			else
				Date.parse(value.to_s)
			end
		rescue
			nil
		end

		def convert_to_boolean(value)
			BrNfe.true_values.include?(value)
		end

	end
end