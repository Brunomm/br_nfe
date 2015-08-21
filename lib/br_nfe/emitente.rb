module BrNfe
	class Emitente  < BrNfe::ActiveModelBase
		
		attr_accessor :cnpj
		attr_accessor :inscricao_municipal
		attr_accessor :razao_social
		attr_accessor :nome_fantasia
		attr_accessor :telefone
		attr_accessor :email
		attr_accessor :codigo_cnae
		attr_accessor :regime_especial_tributacao
		attr_accessor :optante_simples_nacional
		attr_accessor :incentivo_fiscal

		def endereco
			@endereco.is_a?(BrNfe.endereco_class) ? @endereco : @endereco = BrNfe.endereco_class.new()
		end

		def endereco=(value)
			if value.is_a?(BrNfe.endereco_class) 
				@endereco = value
			elsif value.is_a?(Hash)
				endereco.assign_attributes(value)
			end
		end
	end
end