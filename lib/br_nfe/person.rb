module BrNfe
	class Person  < BrNfe::ActiveModelBase
		include BrNfe::Association::HaveAddress

		delegate :uf,              :uf=,               to: :endereco, prefix: :endereco
		delegate :cep,             :cep=,              to: :endereco, prefix: :endereco
		delegate :bairro,          :bairro=,           to: :endereco, prefix: :endereco
		delegate :numero,          :numero=,           to: :endereco, prefix: :endereco
		delegate :nome_pais,       :nome_pais=,        to: :endereco, prefix: :endereco
		delegate :logradouro,      :logradouro=,       to: :endereco, prefix: :endereco
		delegate :codigo_pais,     :codigo_pais=,      to: :endereco, prefix: :endereco
		delegate :complemento,     :complemento=,      to: :endereco, prefix: :endereco
		delegate :nome_municipio,  :nome_municipio=,   to: :endereco, prefix: :endereco
		delegate :codigo_ibge_uf,  :codigo_ibge_uf=,   to: :endereco, prefix: :endereco
		delegate :codigo_municipio,:codigo_municipio=, to: :endereco, prefix: :endereco
		
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
		validates :codigo_regime_tributario, inclusion: {in: ['1', '2', '3', 1, 2, 3]}, allow_blank: true, if: :validate_regime_tributario?
		
		def cpf_cnpj
			return "" unless @cpf_cnpj.present?
			BrNfe::Helper::CpfCnpj.new(@cpf_cnpj).sem_formatacao
		end
			
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
			convert_to_boolean(incentivo_fiscal)
		end

	private

		def validate_regime_tributario?
			true
		end
		
	end
end