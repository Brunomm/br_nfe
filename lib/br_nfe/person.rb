module BrNfe
	class Person  < BrNfe::ActiveModelBase
		include BrNfe::Association::HaveAddress
		
		# Obrigatórios
		attr_accessor :cpf_cnpj
		alias_attribute :cpf,  :cpf_cnpj
		alias_attribute :cnpj, :cpf_cnpj
		attr_accessor :razao_social

		#Não obrigatórios
		attr_accessor :nome_fantasia
		attr_accessor :telefone
		attr_accessor :email
		
		attr_accessor :regime_especial_tributacao
		attr_accessor :natureza_operacao
		attr_accessor :inscricao_municipal
		attr_accessor :inscricao_estadual
		attr_accessor :inscricao_suframa
		attr_accessor :incentivo_fiscal

		# CRT - Código de Regime Tributário
		# 1=Simples Nacional;
		# 2=Simples Nacional, excesso sublimite de receita bruta;
		# 3=Regime Normal.
		#
		attr_accessor :codigo_regime_tributario

		validates :cpf_cnpj, :razao_social, presence: true
		validates :codigo_regime_tributario, inclusion: {in: ['1', '2', '3', 1, 2, 3]}, allow_blank: true
		
		def razao_social
			"#{@razao_social}".to_valid_format_nf
		end

		def nome_fantasia
			"#{@nome_fantasia}".to_valid_format_nf
		end

		def optante_simples_nacional?
			"#{codigo_regime_tributario}".in?(['1','2'])
		end

		def incentivo_fiscal?
			BrNfe.true_values.include?(incentivo_fiscal)
		end
		
	end
end