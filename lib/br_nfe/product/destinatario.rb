module BrNfe
	module Product
		class Destinatario  < BrNfe::Person
			
			# E16a - Indicador da IE do Destinatário
			# 1 = Contribuinte ICMS (informar a IE do destinatário);
			# 2 = Contribuinte isento de Inscrição no cadastro de Contribuintes do ICMS;
			# 9 = Não Contribuinte, que pode ou não possuir Inscrição Estadual no Cadastro de
			#     Contribuintes do ICMS.
			# 
			# <b>Type:     </b> _Integer_
			# <b>Required: </b> _yes_
			# <b>Default:  </b> _9_
			# <b>Length:   </b> _1_
			# <b>tag:      </b> indIEDest
			#
			# Nota 1: No caso de NFC-e informar indIEDest=9 e não informar
			#         a tag IE do destinatário;
			# Nota 2: No caso de operação com o Exterior informar indIEDest=9 e 
			#         não informar a tag IE do destinatário;
			# Nota 3: No caso de Contribuinte Isento de Inscrição (indIEDest=2), 
			#         não informar a tag IE do destinatário.
			#
			attr_accessor :indicador_ie
			alias_attribute :indIEDest, :indicador_ie
			def indicador_ie
				@indicador_ie ||= capture_indicador_ie
				@indicador_ie.to_i
			end
			
			attr_accessor :suframa

			validate :validar_endereco

			validates :indicador_ie, inclusion: {in: [1,2,9]}
		private
			def capture_indicador_ie
				if "#{inscricao_estadual}".strip.upcase == 'ISENTO'
					'2'
				elsif "#{inscricao_estadual}".present?
					'1'
				else
					'9'
				end
			end
		end
	end
end