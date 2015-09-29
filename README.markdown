[![security](https://hakiri.io/github/Brunomm/br_nfe/master.svg)](https://hakiri.io/github/Brunomm/br_nfe/master)

# **BrNfe**
Gem para emissão de notas fiscais eletrônicas.

## Versão 1.0.1
**Motivo e Objetivo**
Devido a falta de padronização dos parâmetros e a forma de envio e resposta na transmissão de Notas Fiscais de Serviços (NFS), esta gem vem com o objetivo de obter uma forma padronizada dessa tarefa, e assim, facilitando a vida de muitos desenvolvedores.

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

## NFS-e desenvolvidas

* Betha Sistemas V 1.0
* Betha Sistemas V 2.02

####**1 - Começando**
Foi criado várias classes para auxiliar na montagem dos dados para emissão da NF, dentre eles estão:

```ruby
BrNfe::Endereco
BrNfe::Emitente
BrNfe::Destinatario
BrNfe::CondicaoPagamento
BrNfe::Servico::Intermediario
BrNfe::Servico::Rps
```

A seguir um exemplo de cada  objeto com valores:

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
@emitente = BrNfe::Emitente.new({
	cnpj: '11.111.111/1111-00',
	inscricao_municipal: '66165-4',
	razao_social: 'RAZÃO SOCIAL',
	natureza_operacao: '1',
	nome_fantasia: 'NOME FANTASIA',
	telefone: '4933665577',
	email: 'emitente@mail.com',
	regime_especial_tributacao: '1',
	optante_simples_nacional: true,
	incentivo_fiscal: false,
	endereco: @endereco
})
```

 Perceba que para definir o endereço do emitente, foi setado diretamente o objeto `@endereco`, porém, também é possível setar o objeto endereço em forma de `block` ou `hash` (isso vale para todas as classes), por exemplo:
```ruby
# Hash
@emitente = BrNfe::Emitente.new({
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
@emitente = BrNfe::Emitente.new do |emitente|
	emitente.cnpj = '11.111.111/1111-00'
	...
	emitente.endereco do |endereco|
		endereco.logradouro  = "RUA FERNANDO ...",
		endereco.numero      = 369,
		endereco.complemento = "E",
		...
	end
end
```

Lembrando que por padrão, sempre que for chamar `@emitente.endereco` irá retornar um objeto da class `BrNfe::Endereco`, mesmo que não seja setado valor algum, ex:
```ruby
@emitente = BrNfe::Emitente.new
@emitente.endereco
# => #<BrNfe::Endereco:0x000000022669a0 @codigo_pais="1058",  ....>
```
***
**Destinatário**
```ruby
@destinatario = BrNfe::Destinatario.new({
	cpf_cnpj: "111.111.111-00",
	inscricao_municipal: "",
	inscricao_estadual:  "",
	inscricao_suframa:   "",
	razao_social: "NOME DA PESSOA OU EMPRESA",
	nome_fantasia: "",
	telefone: "3365478",
	email: "destinatario@mail.com",
	endereco: {
		...
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
@intermediario = BrNfe::Servico::Intermediario.new({
	cpf_cnpj: '11.111.111/0001-36',
	inscricao_municipal: '3355-6',
	razao_social: "INTERMEDIÁRIO DO SERVIÇO"
})
```
***
**RPS**
```ruby
@rps = BrNfe::Servico::Rps.new do |rps|
	rps.destinatario  = { ... } # Attributos da class BrNfe::Destinatario
	rps.intermediario do |intermediario|
		.... # Dados da class BrNfe::Servico::Intermediario
	end
	rps.condicao_pagamento  = BrNfe::CondicaoPagamento.new(...)

	rps.numero                  = 5525
	rps.serie                   = "SN"
	rps.tipo                    = "1"
	rps.data_emissao            = DateTime.now
	rps.status                  = "1"
	rps.competencia             = DateTime.now
	rps.numero_substituicao     = "5524"
	rps.serie_substituicao      = "SN"
	rps.tipo_substituicao       = "1"
	rps.codigo_obra             = ""
	rps.codigo_art              = ""
	rps.valor_servicos          = 100.00
	rps.valor_deducoes          = "0"
	rps.valor_pis               = "0"
	rps.valor_cofins            = ""
	rps.valor_inss              = ""
	rps.valor_ir                = ""
	rps.valor_csll              = ""
	rps.outras_retencoes        = ""
	rps.iss_retido              = ""
	rps.valor_iss               = 2.0
	rps.aliquota                = 0.02 # = 2%
	rps.base_calculo            = "100.00"
	rps.desconto_incondicionado = ""
	rps.desconto_condicionado   = ""
	rps.responsavel_retencao    = ""
	rps.item_lista_servico      = "1.07"
	rps.discriminacao           = "1 Configuração de servidor: R$ 500.00"
	rps.exigibilidade_iss       = "1"
	rps.codigo_municipio        = "4204202"
	rps.municipio_incidencia    = "4204202"
	rps.codigo_pais             = ""
	rps.numero_processo         = ""
	rps.codigo_cnae             = ""
	rps.outras_informacoes      = ""
	rps.codigo_tributacao_municipio = ""
end
```
####**2 - Exemplos**
Para todos os Web Services, após instanciados, poderá ser chamado o método `request`, no qual será enviado os dados via XML para o órgão emissor correspondente. 

Se desejar, antes de enviar os dados, o objeto poderá ser validado, EX:
```ruby
@ws = BrNfe::Servico::Betha::V1::ConsultaLoteRps.new(...)
if @ws.valid?
	@ws.request
	@response = @ws.response
end
```
O resultado obtido na variável `@response`  é um objeto da class `BrNfe::Servico::Response::Default`, no qual será retornada em todas as requisições. Essa classe é responsável de manter o padrão das mensagens de resposta para todos os webservices. Se desejar, poderá obter a resposta original (no formato Hash) de cada órgão emissor através do método `original_response`.
Para saber quais os valores obtidos pelo `BrNfe::Servico::Response::Default`, veja: [Resposta padrão](exemplos/resposta_padrao.markdown)

Lista de exemplos:

* [Betha Sistemas v1.0](exemplos/betha_v1.markdown)
* [Betha Sistemas v2.02](exemplos/betha_v2.markdown)

####**3 - Configurações**
```ruby
BrNfe.setup do |config|
	# É possível customizar as classes auxiliares, por exemlo, 
	# se você quiser fazer alguma validação específica para o endereço, 
	# que contenha os mesmo atributos, e setar na configuração da gem 
	# qual será a classe que irá representar o  endereco.
	# config.endereco_class = ClasseCustomizadaEndereco
	
	config.endereco_class = BrNfe::Endereco
	config.emitente_class = BrNfe::Emitente
	config.destinatario_class = BrNfe::Destinatario
	config.intermediario_class = BrNfe::Servico::Intermediario
	config.condicao_pagamento_class = BrNfe::CondicaoPagamento
	config.rps_class BrNfe::Servico::Rps
	
	# Se você utiliza certificado SSL, faça as seguintes modificações na configuração:
	# config.client_wsdl_ssl_verify_mode   = :peer
	# config.client_wsdl_ssl_cert_file     = 'caminho/client_cert.pem'
	# config.client_wsdl_ssl_cert_key_file = 'caminho/client_key.pem'
	# config.client_wsdl_ssl_cert_key_password = 'senha'
	config.client_wsdl_ssl_verify_mode   = :none
	config.client_wsdl_ssl_cert_file     = nil
	config.client_wsdl_ssl_cert_key_file = nil
	config.client_wsdl_ssl_cert_key_password = nil
	
	# Se você quiser exibir em log a requisição SOAP, mude para true as opções a seguir
	config.client_wsdl_log = false
	config.client_wsdl_pretty_print_xml = false
end
```


## Objetivos futuros
* Emitir notas fiscais de produtos.
* Emitir notas fiscais de serviços para todas as cidades do Brasil.  

## Contribuições

Seja um contribuidor. Você pode contribuir de N formas. Seguem elas:

* Desenvolver emissão de NFS-e para outras cidades.
* Desenvolver emissão de NF-e (produtos).
* Refatorando código.
* Fornecendo Feedback construtivo (Sempre bem vindo!).

## Licença

- BSD
- Copyleft 2015 Bruno M. Mergen