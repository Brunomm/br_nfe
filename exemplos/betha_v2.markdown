# **BrNfe Exemplos**
## **Betha Sistemas v2.02**

###**1 - CancelamentoNfs **
```ruby
@ws = BrNfe::Service::Betha::V2::CancelamentoNfs.new({
	certificado_password: 'MINHASENHA',
	certificado_path:     'local/do/meu/certificado.pfx',
	# certificado:  @certificado, # Se você já tem em sua app um certificado instanciado
	numero_nfse:                5525,
	codigo_cancelamento: 1,
	emitente: {
		cnpj: 12345678901234,
		inscricao_municipal: '66598-6',
		razao_social: 'Minha empresa LTDA',
		endereco: {
			codigo_municipio: '46544',
			...
		}
	}
})
```

###**2 - ConsultaLoteRps **
```ruby
@ws = BrNfe::Service::Betha::V2::ConsultaLoteRps.new do |record|
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
@ws = BrNfe::Service::Betha::V2::ConsultaNfsPorRps.new do |record|
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

###**4 - EnvioLoteRpsSincrono **
```ruby
@ws = BrNfe::Service::Betha::V2::EnvioLoteRpsSincrono.new do |record|
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
			rps.discriminacao               = "1 PLANO LIGHT. 49,00"
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


###**5 - GeraNfse **
```ruby
@ws = BrNfe::Service::Betha::V2::GeraNfse.new do |record|
	record.certificado_password = 'MINHASENHA'
	record.certificado_path     = 'local/do/meu/certificado.pfx'
	record.emitente  = BrNfe::Emitente.new(cnpj: 12345678901234, ...)
	record.numero_lote_rps = 988
	record.rps  = {
		destinatario:  BrNfe::Destinatario.new(cpf_cnpj: 123456789012, ...),
		numero:                  456,
		serie:                   'SN',
		tipo:                    '1',
		data_emissao:            DateTime.now,
		status:                  '1',
		competencia:             Date.today,
		valor_servicos:          '49.00',
		valor_deducoes:          '0.0',
		valor_pis:               '0.0',
		valor_cofins:            '0.0',
		valor_inss:              '0.0',
		valor_ir:                '0.0',
		valor_csll:              '0.0',
		outras_retencoes:        '0.0',
		valor_iss:               '0.98',
		aliquota:                '0.02', # = 2%
		base_calculo:            '49.00',
		desconto_incondicionado: '0.0',
		desconto_condicionado:   '0.0',
		iss_retido:              '2',
		responsavel_retencao:    '',
		item_lista_servico:      '0107',
		codigo_tributacao_municipio: '2525',
		discriminacao:           "1 PLANO LIGHT. 49,00",
		exigibilidade_iss:       '1',
		codigo_municipio:        '4204202',
		numero_processo:         '',
		codigo_cnae:             '6202300'
	}
end
```

###**6 - RecepcaoLoteRps **
```ruby
@ws = BrNfe::Service::Betha::V2::RecepcaoLoteRps.new do |record|
	record.certificado_password = 'MINHASENHA'
	record.certificado_path     = 'local/do/meu/certificado.pfx'
	record.emitente        = {cnpj: 12345678901234, ...}
	record.numero_lote_rps = 988
	record.lote_rps        = [
		# RPS 1
		BrNfe::Service::Rps.new do |rps|
			rps.destinatario = {cpf_cnpj: 123456789012, ...}
			rps.intermediaro = {cpf_cnpj: 123456789012, ...}
			rps.condicao_pagamento = BrNfe::CondicaoPagamento.new(...)
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
			rps.discriminacao               = "1 PLANO LIGHT. 49,00"
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

###**7 - SubstituicaoNfse **
```ruby
@ws = BrNfe::Service::Betha::V2::SubstituicaoNfse.new do |record|
	record.certificado_password = 'MINHASENHA'
	record.certificado_path     = 'local/do/meu/certificado.pfx'
	record.emitente             = {cnpj: 12345678901234, ...}
	record.numero_nfse          = 5525
	record.codigo_cancelamento  = 1
	record.rps  do |rps| 
				rps.destinatario = BrNfe::Destinatario.new(cpf_cnpj: 123456789012, ...)
		rps.numero                  = 456
		rps.serie                   = 'SN'
		rps.tipo                    = '1'
		rps.data_emissao            = DateTime.now
		rps.status                  = '1'
		rps.competencia             = Date.today
		rps.valor_servicos          = '49.00'
		rps.valor_deducoes          = '0.0'
		rps.valor_pis               = '0.0'
		rps.valor_cofins            = '0.0'
		rps.valor_inss              = '0.0'
		rps.valor_ir                = '0.0'
		rps.valor_csll              = '0.0'
		rps.outras_retencoes        = '0.0'
		rps.valor_iss               = '0.98'
		rps.aliquota                = '0.02' # = 2%
		rps.base_calculo            = '49.00'
		rps.desconto_incondicionado = '0.0'
		rps.desconto_condicionado   = '0.0'
		rps.iss_retido              = '2'
		rps.responsavel_retencao    = ''
		rps.item_lista_servico      = '0107'
		rps.codigo_tributacao_municipio = '2525'
		rps.discriminacao           = "1 PLANO LIGHT. 49,00"
		rps.exigibilidade_iss       = '1'
		rps.codigo_municipio        = '4204202'
		rps.numero_processo         = ''
		rps.codigo_cnae             = '6202300
	end
end
```