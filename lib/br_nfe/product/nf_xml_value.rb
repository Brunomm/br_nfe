module BrNfe
	module Product
		module NfXmlValue
			def nf_xml_value_codigo_nf value
				only_numbers(value, {min_size: 8, max_size: 8})
			end
			def nf_xml_value_tipo_ambiente value, xml_version=:v3_10
				value == :production ? '1' : '2'
			end
			def nf_xml_value_cpf value, xml_version=:v3_10
				only_numbers value, {min_size: 11, max_size: 11}
			end
			def nf_xml_value_cnpj value, xml_version=:v3_10
				only_numbers value, {min_size: 14, max_size: 14}
			end
			def nf_xml_value_indicador_sincrono value
				value ? '1' : '0'
			end

			def nf_xml_value_id_estrangeiro value, xml_version=:v3_10
				"#{value}".max_size(20)
			end

			def nf_xml_value_fone value, xml_version=:v3_10
				only_numbers value, {min_size: 6, max_size: 14}
			end

			def nf_xml_value_text value, max=60, xml_version=:v3_10
				"#{value}".strip.max_size(max).br_nfe_escape_html.remove_accents.gsub(/\r\n/,' ').gsub(/\n/,' ')
			end

			def nf_xml_value_codigo_ibge_municipio value, xml_version=:v3_10
				only_numbers value, {min_size: 7, max_size: 7}
			end

			def nf_xml_value_UF value, xml_version=:v3_10
				"#{value}".max_size(2)
			end

			def nf_xml_value_CEP value, xml_version=:v3_10
				only_numbers value, {min_size: 8, max_size: 8}
			end

			def nf_xml_value_codigo_pais value, xml_version=:v3_10
				only_numbers value, {min_size: 4, max_size: 4}
			end

			def nf_xml_value_IE value, xml_version=:v3_10
				if value.blank?
					'ISENTO'
				else
					"#{value}".gsub(/[^\w]/,'').rjust(2, '0').max_size(14)
				end
			end

			def nf_xml_value_IM value, xml_version=:v3_10
				"#{value}".max_size(15)
			end

			def nf_xml_value_CNAE value, xml_version=:v3_10
				only_numbers value, {min_size: 7, max_size: 7}
			end

			def nf_xml_value_CRT value, xml_version=:v3_10
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
			def nf_xml_value_indicador_IE indicador_ie, nfe, xml_version=:v3_10
				if nfe.nfce? # 65 NFC-e
					'9'
				else
					indicador_ie
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
			def nf_xml_value_inscricao_suframa v_suframa, xml_version=:v3_10
				only_numbers v_suframa, {min_size: 8, max_size: 9}
			end

			def nf_xml_value_email v_email, xml_version=:v3_10
				nf_xml_value_text(v_email, 60)
			end

			# 1=Operação interna;
			# 2=Operação interestadual;
			# 3=Operação com exterior.
			def nf_xml_value_id_local_destino v_endereco_destino, xml_version=:v3_10
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
			def nf_xml_value_consumidor_final value, xml_version=:v3_10
				value ? '1' : 	'0'
			end

			def nf_xml_value_date_time time, xml_version=:v3_10
				if time.is_a?(Time) || time.is_a?(DateTime)
					time.to_s(:iso8601)
				elsif time.is_a?(Date)
					time.to_time.to_s(:iso8601)
				end
			end

			def nf_xml_value_time time, xml_version=:v3_10
				if time.is_a?(Time) || time.is_a?(DateTime)
					time.strftime('%H:%M:%S')
				end
			end

			def nf_xml_value_date value, xml_version=:v3_10
				if value.is_a?(Date)
					value.to_s(:iso8601)
				elsif value.is_a?(Time) || value.is_a?(DateTime)
					value.to_date.to_s(:iso8601)
				end
			end

			def nf_xml_value_monetary value, xml_version=:v3_10
				"%.2f" % value.to_f.round(2)
			end

			def nf_xml_value_percent value, xml_version=:v3_10
				"%.4f" % value.to_f.round(4)
			end

			def nf_xml_value_quantidade value, xml_version=:v3_10
				"%.4f" % value.to_f.round(4)
			end

			def nf_xml_value_peso value, xml_version=:v3_10
				"%.3f" % value.to_f.round(3)
			end

			def nf_xml_value_float value, precision, xml_version=:v3_10
				"%.#{precision}f" % value.to_f.round(precision)
			end

			def nf_xml_value_CFOP value, xml_version=:v3_10
				only_numbers value, {min_size: 4, max_size: 4}
			end

			def nf_xml_value_placa placa, xml_version=:v3_10
				"#{placa}".gsub(/[^\w]/,'').rjust(7, '0').max_size(7)
			end

			# Registro Nacional de Transportador de Carga (ANTT)
			#
			def nf_xml_value_RNTC rntc, xml_version=:v3_10
				nf_xml_value_text rntc, 20
			end

			def nf_xml_fixed_code code, options={}, xml_version=:v3_10
				options = {size: 2}.merge(options)
				"#{code.to_i}".rjust(options[:size], '0')
			end

			def nf_xml_value_CEST cest, xml_version=:v3_10
				"#{cest.to_i}".rjust(7, '0') if cest.present?
			end

			def nf_xml_value_EAN ean, xml_version=:v3_10
				if ean.to_i > 0
					if "#{ean}".strip.size > 8
						"#{ean}".strip.rjust(12, '0') 
					else
						"#{ean}".strip.rjust(8, '0') 
					end
				end
			end

			def nf_xml_value_NCM ncm, xml_version=:v3_10
				ncm = ncm.to_i
				if ncm > 0
					"#{ncm}".rjust(8, '0') 
				else
					"#{ncm}".rjust(2, '0') 
				end
			end

			def nf_xml_value_EXTIPI value, xml_version=:v3_10
				"#{value}".rjust(2, '0')
			end

			def nf_xml_value_boolean value, xml_version=:v3_10
				value ? '1' : '0'
			end

			def nf_xml_value_NVE value, xml_version=:v3_10
				"#{value}".max_size(6)
			end

			def nf_xml_value_number value, max_size, xml_version=:v3_10
				only_numbers value, {max_size: max_size}
			end

			def nf_xml_value_drawback value, xml_version=:v3_10
				if "#{value}".strip.size <= 9 
					only_numbers value, min_size: 9, max_size: 9
				else
					only_numbers value, min_size: 11, max_size: 11
				end
			end

			def nf_xml_value_chave_nfe value, xml_version=:v3_10
				only_numbers value, {min_size: 44, max_size: 44}
			end

			def nf_xml_value_number_fixed_size value, size, xml_version=:v3_10
				only_numbers value, {min_size: size, max_size: size}
			end

			def nf_xml_value_codigo_enquadramento_IPI value
				if value.blank?
					'999'
				else
					nf_xml_value_text value, 3
				end
			end

			def nf_xml_value_ISSQN_incentivo_fiscal value
				value ? 1 : 2
			end

			def nf_xml_value_numero_recibo value
				only_numbers "#{value}".strip, max_size: 15
			end

			def nf_xml_value_orgao_emissor evento
				if evento.codigo_orgao.present?
					evento.codigo_orgao
				else
					if gateway.is_a?(BrNfe::Product::Gateway::WebServiceSVAN) && evento.is_a?(BrNfe.cancelamento_product_class)
						91
					else
						"#{evento.chave_nfe}"[0..1]
					end
				end
			end

		private

			def only_numbers value, options={}
				options[:min_size] ||= 0
				options[:max_size] ||= 1
				"#{value}".gsub(/[^\d]/,'').rjust(options[:min_size], '0').max_size(options[:max_size])
			end
		end
	end
end