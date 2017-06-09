module BrNfe
	module Product
		module Reader
			class Transporte
				class << self
					def new xml, path
						@xml      = xml
						@path     = path
						@transporte = BrNfe::Product::Nfe::Transporte::Base.new
						populate!
						@transporte
					end
				private
					def populate!
						@transporte.modalidade_frete          = @xml.css(@path[:transporte][:modalidade_frete]).text
						return if @transporte.modalidade_frete == '9'
						@transporte.retencao_valor_sevico      = @xml.css(@path[:transporte][:retencao_valor_sevico]).text.to_f
						@transporte.retencao_base_calculo_icms = @xml.css(@path[:transporte][:retencao_base_calculo_icms]).text.to_f
						@transporte.retencao_aliquota          = @xml.css(@path[:transporte][:retencao_aliquota]).text.to_f
						@transporte.retencao_valor_icms        = @xml.css(@path[:transporte][:retencao_valor_icms]).text.to_f
						@transporte.retencao_cfop              = @xml.css(@path[:transporte][:retencao_cfop]).text
						@transporte.retencao_codigo_municipio  = @xml.css(@path[:transporte][:retencao_codigo_municipio]).text
						build_transportadora!                 if @xml.css(@path[:transporte][:transportadora][:root]).present?
						build_veiculo!                        if @xml.css(@path[:transporte][:veiculo][:root]).present?
						build_reboques!                       if @xml.css(@path[:transporte][:reboques][:root]).present?
						build_volumes!                        if @xml.css(@path[:transporte][:volumes][:root]).present?
					end

					def build_transportadora!
						@transporte.transportador = {
							cpf_cnpj:                @xml.css(@path[:transporte][:transportadora][:cpf_cnpj]).text,
							razao_social:            @xml.css(@path[:transporte][:transportadora][:razao_social]).text,
							inscricao_estadual:      @xml.css(@path[:transporte][:transportadora][:inscricao_estadual]).text,
							endereco_descricao:      @xml.css(@path[:transporte][:transportadora][:endereco_descricao]).text,
							endereco_uf:             @xml.css(@path[:transporte][:transportadora][:endereco_uf]).text,
							endereco_nome_municipio: @xml.css(@path[:transporte][:transportadora][:endereco_nome_municipio]).text
						}
					end

					def build_veiculo!
						@transporte.veiculo = {
							placa: @xml.css(@path[:transporte][:veiculo][:placa]).text,
							uf:    @xml.css(@path[:transporte][:veiculo][:uf]).text,
							rntc:  @xml.css(@path[:transporte][:veiculo][:rntc]).text
						}
					end

					def build_reboques!
						reboques = []
						@xml.css(@path[:transporte][:reboques][:root]).each do |reboque_path|
							reboques << {
								placa: reboque_path.css(@path[:transporte][:reboques][:placa]).text,
								uf:    reboque_path.css(@path[:transporte][:reboques][:uf]).text,
								rntc:  reboque_path.css(@path[:transporte][:reboques][:rntc]).text
							}
						end
						@transporte.reboques = reboques
					end

					def build_volumes!
						volumes = []
						@xml.css(@path[:transporte][:volumes][:root]).each do |vol_path|
							volumes << {
								quantidade:   vol_path.css(@path[:transporte][:volumes][:quantidade]).text,
								especie:      vol_path.css(@path[:transporte][:volumes][:especie]).text,
								marca:        vol_path.css(@path[:transporte][:volumes][:marca]).text,
								numercao:     vol_path.css(@path[:transporte][:volumes][:numercao]).text,
								peso_liquido: vol_path.css(@path[:transporte][:volumes][:peso_liquido]).text.to_f,
								peso_bruto:   vol_path.css(@path[:transporte][:volumes][:peso_bruto]).text.to_f,
								lacres:       vol_path.css(@path[:transporte][:volumes][:lacres]).map{|e| e.text},
							}
						end
						@transporte.volumes = volumes
					end
				end
			end
		end
	end
end