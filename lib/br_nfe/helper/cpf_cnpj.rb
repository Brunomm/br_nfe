module BrNfe
	module Helper
		class CpfCnpj
			
			def initialize(cpf_cnpj)
				@cpf_cnpj = ajusta_cpf_cnpj_com_zero("#{cpf_cnpj}")
			end

			def cpf?
				cpf_ou_cnpj? == :cpf
			end

			def cnpj?
				cpf_ou_cnpj? == :cnpj				
			end

			def cpf_ou_cnpj?
				case sem_formatacao.size
				when 11
					:cpf
				when 14
					:cnpj
				else
					:id_estrangeiro
				end
			end

			def sem_formatacao
				@cpf_cnpj.gsub(/[\.]|[\-]|[\/]/,'')
			end

			def com_formatacao
				cnpj? ? formata_cnpj : formata_cpf
			end

			def formatado_com_label
				cnpj? ? "CNPJ #{formata_cnpj}" : "CPF #{formata_cpf}"
			end

		private

			def ajusta_cpf_cnpj_com_zero(value)
				return "" if value.blank?
				if value.to_s.size <= 11
					value.to_s.rjust(11, '0')
				else
					value.to_s.rjust(14, '0')
				end
			end
			
			def formata_cpf
				@cpf_cnpj.gsub!(/[\.]|[\-]|[\/]/,'')
				"#{@cpf_cnpj[0..2]}.#{@cpf_cnpj[3..5]}.#{@cpf_cnpj[6..8]}-#{@cpf_cnpj[9..10]}"
			end

			def formata_cnpj
				@cpf_cnpj.gsub!(/[\.]|[\-]|[\/]/,'')
				"#{@cpf_cnpj[0..1]}.#{@cpf_cnpj[2..4]}.#{@cpf_cnpj[5..7]}/#{@cpf_cnpj[8..11]}-#{@cpf_cnpj[12..13]}"
			end
		end
	end
end