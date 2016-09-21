# **BrNfe - Resposta padrão**
A resposta padrão de todas as requisições de nota fiscal de serviço será um objeto da classe `BrNfe::Service::Response::Default`, no qual contém os seguntes valores:

```ruby
@response = @ws.response

@response.success? 
# Irá retornar true/false/nil

@response.error_messages
# Sempre irá retornar um Array, mesmo que não tenha nenhuma mensagem.
# ex: [{codigo: 'xx1', mensagem: 'ms error', correcao: 'faça algumacorreção'},...]

@response.protocolo
# Serve para requisições no qual retorna um protocolo para consulta posterior (ex: recepção lote rps)

@response.data_recebimento
# Data de recebimento do rps

@response.numero_lote
# número do lote rps

@response.notas_fiscais
# Sempre irá retornar um Array, onde neste array terá 0, 1 ou N Notas fiscais.

# Exemplo de uma instância de Nota Fiscal de resposta

@nf = BrNfe::Service::Response::NotaFiscal.new({
	intermediario: BrNfe::Service::Intermediario.new(...),
	destinatario:  BrNfe::Service::Destinatario.new(...),
	emitente:      BrNfe::Service::Emitente.new(...),
	condicao_pagamento:     BrNfe::CondicaoPagamento.new(...),
	numero_nf:               '55654',
	codigo_verificacao:      '1',
	data_emissao:            Date.today,
	url_nf:                  'http://www.orgaoemissor.com/nota/fiscal/xxxxx.pdf',
	rps_numero:              '5525',
	rps_serie:               'SN',
	rps_tipo:                '1',
	rps_situacao:            '1',
	rps_substituido_numero:  '',
	rps_substituido_serie:   '',
	rps_substituido_tipo:    '',
	data_emissao_rps:        Data.yesterday,
	competencia:             Data.yesterday,
	outras_informacoes:      'outras info',
	item_lista_servico:      '0107',
	codigo_cnae:             '315',
	discriminacao:           '1 PLANO LIGHT R$ 50.00 ....',
	codigo_municipio:        '47523',
	valor_servicos:          '50.00',
	valor_deducoes:          '0.00',
	valor_pis:               '',
	valor_cofins:            '',
	valor_inss:              '',
	valor_ir:                '',
	valor_csll:              '',
	iss_retido:              '',
	outras_retencoes:        '',
	valor_iss:               '1.0',
	base_calculo:            '50',
	aliquota:                '0.02',
	valor_liquido:           '',
	desconto_condicionado:   '',
	desconto_incondicionado: '',
	responsavel_retencao:    '',
	numero_processo:         '',
	municipio_incidencia:    '47562',
	orgao_gerador_municipio: '47562',
	orgao_gerador_uf:        'SC',
	nfe_substituidora:       '55650',
	codigo_obra:             '',
	codigo_art:              '',
	cancelamento_codigo:     '',
	cancelamento_numero_nf:  '',
	cancelamento_cnpj:       '',
	cancelamento_municipio:  '',
	cancelamento_sucesso:    '',
	cancelamento_data_hora:  '',
	cancelamento_inscricao_municipal: ''

})

# MÉTODOS DA NF

@nf.substituida?
# Retorna true ou false


```