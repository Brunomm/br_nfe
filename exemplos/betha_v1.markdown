# **BrNfe Exemplos**
## **Betha Sistemas v1.0**

###**1 - CancelamentoNfs **
```ruby
@ws = BrNfe::Service::Betha::V1::CancelamentoNfs.new do |record|
	record.certificado_password = 'MINHASENHA'
	record.certificado_path     = 'local/do/meu/certificado.pfx'
	# record.certificado = @certificado # Se você já tem em sua app um certificado instanciado
	record.numero_nfse          = 5525
	record.codigo_cancelamento  = 1
	record.emitente = {
		cnpj: 12345678901234,
		inscricao_municipal: '66598-6',
		razao_social: 'Minha empresa LTDA',
		endereco: {
			codigo_municipio: '46544',
			...
		}
	}
end
```

###**2 - ConsultaLoteRps **
```ruby
@ws = BrNfe::Service::Betha::V1::ConsultaLoteRps.new do |record|
	record.protocolo          = 'E1AS5D43ASDAS23'
	record.emitente = {
		cnpj: 12345678901234,
		inscricao_municipal: '66598-6',
		razao_social: 'Minha empresa LTDA',
		endereco: {
			codigo_municipio: '46544',
			...
		}
	}
end
```

###**3 - ConsultaNfsPorRps **
```ruby
@ws = BrNfe::Service::Betha::V1::ConsultaNfsPorRps.new do |record|
	record.rps do |rps|
		rps.numero = 6444
		rps.serie = 'SN'
		rps.tipo = '1'
	end
	record.emitente = {
		cnpj: 12345678901234,
		inscricao_municipal: '66598-6',
		razao_social: 'Minha empresa LTDA',
		endereco: {
			codigo_municipio: '46544',
			...
		}
	}
end
```

###**4 - ConsultaNfse **
```ruby
@ws = BrNfe::Service::Betha::V1::ConsultaNfse.new do |record|
	record.numero_nfse  = 5525 # não obrigatório
	record.data_inicial = 1.month.ago
	record.data_final   = DateTime.now
	record.emitente do |emitente|
		emitente.inscricao_municipal = '66598-6',
		emitente.cnpj         = 12345678901234,
		emitente.razao_social = 'Minha empresa LTDA',
		emitente.endereco     = BrNfe::Endereco.new(codigo_municipio: '46544', ...)
	end
end
```

###**5 - ConsultaSituacaoLoteRps **
```ruby
@ws = BrNfe::Service::Betha::V1::ConsultaSituacaoLoteRps.new do |record|
	record.protocolo = 'E1AS5D43ASDAS23'
	record.emitente  = BrNfe::Emitente.new(cnpj: 12345678901234, ...) 
end
```

###**6 - RecepcaoLoteRps **
```ruby
@ws = BrNfe::Service::Betha::V1::RecepcaoLoteRps.new do |record|
	record.certificado_password = 'MINHASENHA'
	record.certificado_path     = 'local/do/meu/certificado.pfx'
	record.emitente  = BrNfe::Emitente.new(cnpj: 12345678901234, ...)
	record.numero_lote_rps = 988
	record.lote_rps        = [
		# RPS 1
		BrNfe::Service::Rps.new do |rps|
			rps.destinatario = BrNfe::Destinatario.new(cpf_cnpj: 123456789012, ...)
			rps.numero       = 456
			rps.serie        = 'SN'
			rps.tipo         = '1'
			rps.data_emissao = DateTime.now
			rps.status       = '1'
			rps.competencia  = Date.today
			rps.valor_servicos    = '49.00'
			rps.valor_deducoes    = '0.0'
			rps.valor_pis         = '0.0'
			rps.valor_cofins      = '0.0'
			rps.valor_inss        = '0.0'
			rps.valor_ir          = '0.0'
			rps.valor_csll        = '0.0'
			rps.outras_retencoes  = '0.0'
			rps.valor_iss         = '0.98'
			rps.aliquota          = '0.02' # = 2%
			rps.base_calculo      = '49.00'
			rps.desconto_incondicionado = '0.0'
			rps.desconto_condicionado   = '0.0'
			rps.iss_retido              = '2'
			rps.responsavel_retencao    = ''
			rps.item_lista_servico      = '0107'
			rps.codigo_tributacao_municipio = '2525'
			rps.discriminacao               = "1 MENSALIDADE PLANO LIGHT. 49,00 \n\n\n\n\nValor Aprox dos Tributos: R$ 6,59 Federal, R$ 0,00 Estadual e R$ 1,62 Municipal \n Fonte: IBPT/FECOMERCIO SC 5oi7eW"
			rps.exigibilidade_iss = '1'
			rps.codigo_municipio  = '4204202'
			rps.numero_processo   = ''
			rps.codigo_cnae       = '6202300'
		end,
		# RPS 2
		BrNfe::Service::Rps.new({
			...	
		})
	]
end
```