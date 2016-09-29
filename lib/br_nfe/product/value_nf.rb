module BrNfe
	module Product
		module ValueNf
			def value_nf_tp_amb value, xml_version=:v3_10
				value == :production ? '1' : '2'
			end
			def value_nf_cpf value, xml_version=:v3_10
				"#{value}".max_size(11)
			end
			def value_nf_cnpj value, xml_version=:v3_10
				"#{value}".max_size(14)
			end

			def value_nf_id_estrangeiro value, xml_version=:v3_10
				"#{value}".max_size(20)
			end

			def value_nf_fone value, xml_version=:v3_10
				"#{value}".gsub(/[^\d]/,'').rjust(6, '0').max_size(14)
			end

			def value_nf_text value, max=60, xml_version=:v3_10
				"#{value}".max_size(max).br_nfe_escape_html.to_valid_format_nf
			end

			def value_nf_codigo_ibge_municipio value, xml_version=:v3_10
				"#{value}".gsub(/[^\d]/,'').rjust(7, '0').max_size(7)
			end

			def value_nf_UF value, xml_version=:v3_10
				"#{value}".max_size(2)
			end

			def value_nf_CEP value, xml_version=:v3_10
				"#{value}".gsub(/[^\d]/,'').ljust(8, '0').max_size(8)
			end

			def value_nf_codigo_pais value, xml_version=:v3_10
				"#{value}".gsub(/[^\d]/,'').rjust(4, '0').max_size(4)
			end

			def value_nf_IE value, xml_version=:v3_10
				"#{value}".gsub(/[^\w]/,'').rjust(2, '0').max_size(14)
			end

			def value_nf_IM value, xml_version=:v3_10
				"#{value}".max_size(15)
			end

			def value_nf_CNAE value, xml_version=:v3_10
				"#{value}".gsub(/[^\d]/,'').rjust(7, '0').max_size(7)
			end

			def value_nf_CRT value, xml_version=:v3_10
				"#{value}".max_size(1)
			end

			# E16a - Indicador da IE do Destinatário
			# 1 = Contribuinte ICMS (informar a IE do destinatário);
			# 2 = Contribuinte isento de Inscrição no cadastro de Contribuintes do ICMS;
			# 9 = Não Contribuinte, que pode ou não possuir Inscrição Estadual no Cadastro de
			#     Contribuintes do ICMS.
			#
			# Nota 1: No caso de NFC-e informar indIEDest=9 e não informar
			#         a tag IE do destinatário;
			# Nota 2: No caso de operação com o Exterior informar indIEDest=9 e 
			#         não informar a tag IE do destinatário;
			# Nota 3: No caso de Contribuinte Isento de Inscrição (indIEDest=2), 
			#         não informar a tag IE do destinatário.
			#
			def value_nf_indicador_IE v_ie, nfe, xml_version=:v3_10
				if nfe.nfce? # 65 NFC-e
					'9'
				elsif "#{v_ie}".strip.upcase == 'ISENTO'
					'2'
				elsif "#{v_ie}".present?
					'1'
				else
					'9'
				end
			end

			# Obrigatório, nas operações que se beneficiam de incentivos
			# fiscais existentes nas áreas sob controle da SUFRAMA. A
			# omissão desta informação impede o processamento da
			# operação pelo Sistema de Mercadoria Nacional da SUFRAMA e
			# a liberação da Declaração de Ingresso, prejudicando a
			# comprovação do ingresso / internamento da mercadoria nestas
			# áreas.
			# Min: 8 Max: 9
			def value_nf_inscricao_suframa v_suframa, xml_version=:v3_10
				"#{v_suframa}".gsub(/[^\d]/,'').rjust(8, '0').max_size(9)
			end

			def value_nf_email v_email, xml_version=:v3_10
				value_nf_text(v_email, 60)
			end

			# 1=Operação interna;
			# 2=Operação interestadual;
			# 3=Operação com exterior.
			def value_nf_id_local_destino v_endereco_destino, xml_version=:v3_10
				if v_endereco_destino.exterior?
					3
				elsif emitente.endereco.codigo_ibge_uf == v_endereco_destino.codigo_ibge_uf
					1
				else
					2
				end
			end

			# Indica operação com Consumidor final
			# 0=Normal;
			# 1=Consumidor final;
			def value_nf_consumidor_final value, xml_version=:v3_10
				value ? '1' : 	'0'
			end

		end
	end
end