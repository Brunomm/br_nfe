[![Build Status](https://travis-ci.org/Brunomm/br_nfe.svg?branch=master)](https://travis-ci.org/Brunomm/br_nfe) [![Test Coverage](https://codeclimate.com/github/Brunomm/br_nfe/badges/coverage.svg)](https://codeclimate.com/github/Brunomm/br_nfe/coverage) [![Gem Version](https://badge.fury.io/rb/br_nfe.svg)](http://badge.fury.io/rb/br_nfe) [![Code Climate](https://codeclimate.com/github/Brunomm/br_nfe/badges/gpa.svg)](https://codeclimate.com/github/Brunomm/br_nfe)

# **BrNfe**
Gem para emissão de notas fiscais eletrônicas.

**Motivação**

Devido a falta de padronização dos parâmetros e a forma de envio e resposta na transmissão de Notas Fiscais de Serviços (NFS-e), esta gem vem com o objetivo de obter uma forma padronizada dessa tarefa, e assim, facilitando a vida de muitos desenvolvedores.

A Nota Fiscal eletrônica de produto está em desenvolvimento e pode ser acompanhada através da issue [#4](https://github.com/Brunomm/br_nfe/issues/4)

**O que essa gem faz?**

 - Assina digitalmente a nota fiscal eletrônica.
 - Envia os parâmetros com a formatação adequada conforme documentação de cada web service desenvolvido.
 - Formata em um padrão único a resposta de cada web service.
 - Valida (opcionalmente) a obrigatoriedade de cada informação a ser enviada.

## Instalação
**Manualmente**

    gem install br_nfe

**Gemfile**
    
     gem 'br_nfe'

#**Introdução**
Com o objetivo de padronizar os valores, foi criado algumas classes auxiliares para montar e organizar os dados para a emissão das notas fiscais, dentre eles estão:

> - `BrNfe::Endereco`
> -- Tem o objetivo de padronizar os dados de endereço para o emitente e destinatário.

> ####**Específico para NFS-e**:
> - `BrNfe::Service::Emitente`
> -- Classe para instanciar  o emitente da nota fiscal de **serviço (NFS-e)**. 
> -- Contém as validações e regras para o mesmo.
> -- Contém uma "Associação" com `BrNfe::Endereco`

> - `BrNfe::Service::Destinatario`
> -- Classe para instanciar o destinatário da nota fiscal de **serviço (NFS-e)**. 
> -- Contém as validações e regras para o mesmo.
> -- Contém uma "Associação" com `BrNfe::Endereco`
> 
> - `BrNfe::Service::Intermediario`
> -- Classe para instanciar o intermediário na nota fiscal de **serviço (NFS-e)**. 
> -- Contém as validações e regras para o mesmo.
> 
> - `BrNfe::Service::Item`
> -- Item da nota fiscal de serviço;
> -- Alguns órgãos emissores permitem adicionar vários itens de serviço na NFS. 
> -- Ainda, para alguns emissores é obrigatório a definição de itens de serviço, porém para outros esse item não é necessário.
> 
> - `BrNfe::Service::Rps`
> -- Classe para instanciar o RPS (Recibo Provisório de Serviço).
> -- Contém as validações e regras para o mesmo.
> -- Contém "Associação" com `BrNfe::Service::Destinatario` e `BrNfe::Service::Intermediario`
> -- Contém vários `BrNfe::Service::Item` através do atributo `items`

Como citado anteriormente, essas são classes para objetos **auxiliares**, e serão utilizados para manter uma melhor organização da gem.

##**Entendendo a organização da gem**

Primeiramente é necessário ter conhecimento das **_operações_** disponíveis para cada tipo de Nota Fiscal. Vamos a elas:
### Notas Fiscais de Serviço (NFS)
Existe uma certa "padronização" das operações desenvolvidas pelos Órgãos Emissores¹.  São elas:

 - **Cancelamento de NFS** _(Utilizado para cancelar uma NFS)_
 - **Consulta do Lote RPS** _(Utilizado para consultar um lote de RPS)_
 - **Consulta de NFS por RPS** _(Utilizado para consultar uma NFS através dos dados do RPS)_
 - **Consulta NFS** _(Utilizado para consultar uma ou várias NFS através do número e/ou data)_
 - **Consulta Situação do lote RPS** _(Utilizado para consultar a situação de um lote de RPS para verificar se foi processado e se foi processado com sucesso ou erro)_
 - **Recepção do lote RPS** _(Utilizado enviar RPS's para emissão de NFS)_

Através destas operações, serão instanciados os objetos para realizar as funcionalidades para cada atividade. 

Cada cidade contrata um órgão emissor para o processamento das notas (ou pode ser que a própria prefeitura desenvolva), então para realizar as operações para cada cidade, você deverá saber qual a empresa contratada para esse fim, e então instanciar o objeto de acordo com sua necessidade. 
A seguir segue o padrão para instanciar os objetos para cada operação:

- Para Cancelamento de NFS: 
```ruby
	BrNfe::Service::ORGAO_EMISSOR::VERSAO_DO_XML::CancelaNfse.new(...)
```
- Para Consulta do Lote RPS: 
```ruby
BrNfe::Service::ORGAO_EMISSOR::VERSAO_DO_XML::ConsultaLoteRps.new(...)
```
- Para Consulta de NFS por RPS: 
```ruby
BrNfe::Service::ORGAO_EMISSOR::VERSAO_DO_XML::ConsultaNfsPorRps.new(...)
```
- Para Consulta NFS: 
```ruby
BrNfe::Service::ORGAO_EMISSOR::VERSAO_DO_XML::ConsultaNfse.new(...)
```
- Para Consulta Situação do lote RPS: 
```ruby
BrNfe::Service::ORGAO_EMISSOR::VERSAO_DO_XML::ConsultaSituacaoLoteRps.new(...)
```
- Para Recepção do lote RPS: 
```ruby
BrNfe::Service::ORGAO_EMISSOR::VERSAO_DO_XML::RecepcaoLoteRps.new(...)
```

Para enviar os dados para processamento deve ser chamado o método **`request`**, no qual será enviado os dados via XML para o órgão emissor correspondente. 

Se desejar, antes de enviar os dados, o objeto poderá ser validado, EX:
```ruby
@ws = BrNfe::Service::ORGAO_EMISSOR::V1::ConsultaLoteRps.new(...)
if @ws.valid?
	@ws.request
	@response = @ws.response
else
	# Tratamento da validação
end
```

O resultado obtido na variável `@response`  é um objeto com os dados pertinentes e derivados de cada operação, por exemplo, se eu utilizar a operação de `RecepcaoLoteRps`, então a resposta será um objeto da classe `BrNfe::Service::Response::RecepcaoLoteRps`, na qual tem as informações obtidas pela resposta dessa operação. Já para a operação `ConsultaLoteRps` a resposta é um objeto da classe `BrNfe::Service::Response::ConsultaLoteRps`, e assim segue para cada operação. (para ver exemplos das respostas obtidas a cada operação, consulte a wiki).

Se desejar, é possível obter a resposta original ([do savon](http://savonrb.com/version2/response.html)) de cada órgão emissor através do método `original_response`.



###**Instanciando e manipulando objetos**

Em todas as classes desenvolvidas é possível instanciar objetos em forma de `Hash` ou `Block`.  Veja:
```ruby
# Hash
@endereco = BrNfe::Endereco.new({
	logradouro: "RUA FERNANDO MACHADO",
	numero: 369,
	complemento: "E",
	# ...
})

# Block
@endereco = BrNfe::Endereco.new do |endereco|
	endereco.logradouro = "RUA FERNANDO MACHADO"
	endereco.numero = 369
	endereco.complemento = "E"
	# ...
})
```

As associações também podem ser instanciadas em forma de `Hash` ou `Block`, e ainda pode ser setado o objeto diretamente. Exemplo:
```ruby
# Hash
@emitente = BrNfe::Service::Emitente.new({
	cnpj: '11.111.111/1111-00',
	...
	endereco: {
		logradouro: "RUA FERNANDO MACHADO",
		numero: 369,
		complemento: "E",
		...
	}
})
# Block
@emitente = BrNfe::Service::Emitente.new do |emitente|
	emitente.cnpj = '11.111.111/1111-00'
	...
	emitente.endereco do |address|
		address.logradouro  = "RUA FERNANDO ...",
		address.numero      = 369,
		address.complemento = "E",
		...
	end
	# OU
	# emitente.endereco = {
	#	logradouro: "RUA FERNANDO ...",
	#	numero: 369,
	#	complemento: "E",
	#	...
	# }
end

# Setando o objeto
@endereco = BrNfe::Endereco.new(rua: "RUA DOS PRAZERES",...)
@emitente = BrNfe::Service::Emitente.new(razao_social: 'Emitente LTDA', endereco: @endereco)

```

Também é possível fazer o `merge` dos atributos através do método `assign_attributes`, por exemplo:
```ruby
@endereco = BrNfe::Endereco.new({
	logradouro: "RUA 1",
	numero: 100,
	uf: 'SC'
})
@endereco.logradouro
# => "RUA 1"
@endereco.numero
# => 100
@endereco.uf
# => "SC"

@endereco.assign_attributes(numero: 200, uf: 'RS')
@endereco.logradouro
# => "RUA 1"
@endereco.numero
# => 200
@endereco.uf
# => "RS"
```

### **Exemplo para Recepção de um Lote RPS:**


**Endereço:**
```ruby
@endereco = BrNfe::Endereco.new({
	logradouro: "RUA FERNANDO MACHADO",
	numero: 369,
	complemento: "E",
	bairro: "CENTRO",
	nome_municipio: "CHAPECÓ",
	codigo_municipio: 4204202,
	uf: "SC",
	cep: "89665-000",
	# codigo_pais: 1058, <- Default
	# nome_pais: 'BRASIL', <- Default
})
```
***
**Emitente:**
```ruby
@emitente = BrNfe::Service::Emitente.new({
	cnpj: '11.111.111/1111-00',
	inscricao_municipal: '66165-4',
	razao_social: 'RAZÃO SOCIAL',
	natureza_operacao: '1',
	nome_fantasia: 'NOME FANTASIA',
	telefone: '4933665577',
	email: 'emitente@mail.com',
	regime_especial_tributacao: '1',
	codigo_regime_tributario: '1', # 1: Simples Nacional, 2: Simples Nacional(sublimite), 3: Reg. Normal
	incentivo_fiscal: false,
	endereco: @endereco
})
```


Lembrando que por padrão, sempre que for chamar `@emitente.endereco` irá retornar um objeto da class `BrNfe::Endereco`, mesmo que não seja setado valor algum, ex:
```ruby
@emitente = BrNfe::Service::Emitente.new
@emitente.endereco
# => #<BrNfe::Endereco:0x000000022669a0 @codigo_pais="1058",  ....>
```
***
**Destinatário**
```ruby
@destinatario = BrNfe::Service::Destinatario.new({
	cpf_cnpj: "111.111.111-00",
	inscricao_municipal: "",
	inscricao_estadual:  "",
	inscricao_suframa:   "",
	razao_social: "NOME DA PESSOA OU EMPRESA",
	nome_fantasia: "",
	telefone: "3365478",
	email: "destinatario@mail.com",
	endereco: {
		logradouro: "RUA AUGUSTO VILA LOBO",
	numero: 45,
	complemento: "E",
	bairro: "CENTRO",
	nome_municipio: "FLORIANÓPOLIS",
	codigo_municipio: '4205407',
	uf: "SC",
	cep: "89665-000",
	}
})
```
***
**Condição de pagamento**
```ruby
@condicao_pagamento = BrNfe::CondicaoPagamento.new do |cond|
	cond.condicao = 'A_PRAZO' # ou 'A_VISTA'
	cond.parcelas = [
		{valor: 50.33, vencimento: Date.today}, 
		{valor: '27.00', vencimento: 1.month.since}
	]
end
```
***
**Intermediário do serviço**
```ruby
@intermediario = BrNfe::Service::Intermediario.new({
	cpf_cnpj: '11.111.111/0001-36',
	inscricao_municipal: '3355-6',
	razao_social: "INTERMEDIÁRIO DO SERVIÇO"
})
```
***
**RPS**
```ruby
@rps = BrNfe::Service::Rps.new do |rps|
	rps.destinatario  = @destinatario
	rps.intermediario = @intermediario
	rps.condicao_pagamento  =  @condicao_pagamento
	rps.numero                  = 5525
	rps.serie                   = "SN"
	rps.tipo                    = "1"
	rps.data_emissao            = DateTime.now
	rps.status                  = "1"
	rps.competencia             = DateTime.now
	rps.numero_substituicao     = "5524"
	rps.serie_substituicao      = "SN"
	rps.tipo_substituicao       = "1"
	rps.valor_servicos          = 100.00
	rps.valor_deducoes          = "0"
	rps.valor_pis               = "0"
	rps.valor_iss               = 2.0
	rps.aliquota                = 0.02 # = 2%
	rps.base_calculo            = "100.00"
	rps.item_lista_servico      = "1.07"
	rps.discriminacao           = "1 Configuração de servidor: R$ 500.00"
	rps.exigibilidade_iss       = "1"
	rps.codigo_municipio        = "4204202"
	rps.municipio_incidencia    = "4204202"
end
```
***
**RecepcaoLoteRps** (Com o órgão emissor Betha)
```ruby
@recepcao = BrNfe::Service::Betha::V1::RecepcaoLoteRps.new do |ws|
	ws.emitente = @emitente
	ws.lote_rps = [@rps]
	ws.numero_lote_rps = 214
	ws.env = :production # OU :test
	ws.certificate_pkcs12_path  = '/path/to/certificate.pfx'
	wx.certificate_pkcs12_password = 'PASSWORD'
end

@recepcao.request
resp = @recepcao.response
#=> #<BrNfe::Service::Response::RecepcaoLoteRps:0x000016a9e28 ...>

resp.protocolo
#=> 'EX456156E'

resp.data_recebimento
#=> Fri, 23 Sep 2015 17:40:15 -0300

resp.numero_lote
#=> 214

```

Para demais operações consulte a WiKi.

### Configurações
É possível customizar as classes auxiliares, por exemplo, se você quiser fazer alguma validação específica para o endereço, que contenha os mesmo atributos, você deve criar sua própria `class`  e setar na configuração da gem  qual será a classe que irá representar o  endereço. Exemplo:
```ruby
class MeuEndereco < BrNfe::Endereco
	validates :cep, length: { is: 8 }
end

emitente = BrNfe::Service::Emitente.new
emitente.endereco
#=> #<BrNfe::Endereco:0x000000016741d8 @codigo_pais="1058", @nome_pais="BRASIL">

BrNfe.endereco_class = MeuEndereco

emitente = BrNfe::Service::Emitente.new
emitente.endereco
#=> #<MeuEndereco:0x000000016741d8 @codigo_pais="1058", @nome_pais="BRASIL">
```

Segue as configurações possíveis
```ruby
BrNfe.setup do |config|
	# Classe que representa o endereço
	config.endereco_class = BrNfe::Endereco
	
	# Classe que representa os emitentes para NFS
	config.emitente_service_class = BrNfe::Service::Emitente
	
	# Classe que representa o destinatário para NFS
	config.destinatario_service_class = BrNfe::Service::Destinatario
	
	# Classe que representa o intermediário da NFS
	config.intermediario_service_class = BrNfe::Service::Intermediario

	# Classe que representa a condição de pagamento da NFS
	config.condicao_pagamento_class = BrNfe::CondicaoPagamento
	
	# Classe que representa o RPS da NFS
	config.rps_class = BrNfe::Service::Rps

	# Classe que representa o item de uma NFS
	config.service_item_class = BrNfe::Service::Item
	
	# Se você quiser exibir em log a requisição SOAP, mude para true as opções a seguir
	config.client_wsdl_log = false
	config.client_wsdl_pretty_print_xml = false
end
```


## Objetivos futuros
* Emitir notas fiscais de produtos (em andamento).
* Emitir notas fiscais de serviços para todas as cidades do Brasil.  
* Emitir DANFE.  
* Leitura de notas fiscais de produto e serviço

## Contribuições

Seja um contribuidor. Você pode contribuir de várias formas:

* Desenvolver emissão de NFS-e para outras cidades.
* Desenvolver emissão de NF-e (produtos).
* Refatorando código.
* Fornecendo Feedback construtivo (Sempre bem vindo!).


## Licença

- MIT
- Copyleft 2016 Bruno Mucelini Mergen

----------

> ¹ **Órgão Emissor: ** É a empresa contratada pela prefeitura com  a finalidade de processar as notas fiscais. Exemplo: (Betha, Simpliss, Thema)

----------

