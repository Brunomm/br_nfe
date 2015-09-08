module BrNfe
	class Emitente  < BrNfe::ActiveModelBase
		include BrNfe::Helper::HaveAddress
		
		attr_accessor :cnpj
		attr_accessor :inscricao_municipal
		attr_accessor :razao_social
		attr_accessor :nome_fantasia
		attr_accessor :telefone
		attr_accessor :email
		attr_accessor :regime_especial_tributacao
		attr_accessor :optante_simples_nacional
		attr_accessor :incentivo_fiscal
		attr_accessor :natureza_operacao


		def razao_social
			"#{@razao_social}".to_valid_format
		end

		def nome_fantasia
			"#{@nome_fantasia}".to_valid_format
		end
		
	end
end