module BrNfe
	module Servico
		class Rps < BrNfe::ActiveModelBase
			attr_accessor :numero
			attr_accessor :serie
			attr_accessor :tipo
			attr_accessor :data_emissao
			attr_accessor :status
			attr_accessor :competencia

			attr_accessor :valor_servicos
			attr_accessor :valor_deducoes
			attr_accessor :valor_pis
			attr_accessor :valor_cofins
			attr_accessor :valor_inss
			attr_accessor :valor_ir
			attr_accessor :valor_csll
			attr_accessor :outras_retencoes
			attr_accessor :valor_iss
			attr_accessor :aliquota
			attr_accessor :desconto_incondicionado
			attr_accessor :desconto_condicionado

			attr_accessor :iss_retido
			attr_accessor :responsavel_retencao
			attr_accessor :item_lista_servico
			attr_accessor :codigo_tributacao_municipio
			attr_accessor :discriminacao
			attr_accessor :exigibilidade_iss
			attr_accessor :municipio_incidencia
			attr_accessor :numero_processo

			########################### DADOS DO DESTINATÁRIO ###########################
			def destinatario
				@destinatario.is_a?(BrNfe::Destinatario) ? @destinatario : @destinatario = BrNfe::Destinatario.new()
			end

			def destinatario=(value)
				if value.is_a?(BrNfe::Destinatario) 
					@destinatario = value
				elsif value.is_a?(Hash)
					destinatario.assign_attributes(value)
				end
			end
			#############################################################################
			########################### DADOS DO INTERMEDIÁRIO ##########################
			def intermediario
				@intermediario.is_a?(BrNfe::Servico::Intermediario) ? @intermediario : nil
			end

			def intermediario=(value)
				if value.is_a?(BrNfe::Servico::Intermediario) || value.nil? 
					@intermediario = value
				elsif value.is_a?(Hash)
					intermediario ? intermediario.assign_attributes(value) : (@intermediario = BrNfe::Servico::Intermediario.new(value))
				end
			end
			#############################################################################


		end
	end
end