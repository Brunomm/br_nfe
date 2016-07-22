require 'test_helper'

describe BrNfe::Service::Betha::V2::Gateway do
	subject             { FactoryGirl.build(:br_nfe_servico_betha_v2_gateway, emitente: emitente) }
	let(:rps)           { FactoryGirl.build(:br_nfe_rps, :completo) }
	let(:emitente)      { FactoryGirl.build(:emitente) }
	let(:intermediario) { FactoryGirl.build(:intermediario) }

	# describe "inheritance class" do
	# 	it { subject.class.superclass.must_equal BrNfe::Service::Betha::Base }
	# end

	# describe "#namespaces" do
	# 	it "deve ter um valor" do
	# 		subject.namespaces.must_equal({"xmlns:e" => "http://www.betha.com.br/e-nota-contribuinte-ws"})
	# 	end
	# end

	# describe "#namespace_identifier" do
	# 	it "deve ter o valor e" do
	# 		subject.namespace_identifier.must_equal :e
	# 	end
	# end

	# describe "#version" do
	# 	it { subject.version.must_equal :v2 }
	# end

	# describe "#wsdl" do
	# 	it "quando o env for test" do
	# 		subject.env = :test
	# 		subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/nfseWS?wsdl'
	# 	end
	# 	it "quando o env não for" do
	# 		subject.env = :production
	# 		subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/nfseWS?wsdl'
	# 	end
	# end

	# describe "#cabecalho" do
	# 	it { subject.cabecalho.must_equal "<nfseCabecMsg><![CDATA[<cabecalho xmlns=\"http://www.betha.com.br/e-nota-contribuinte-ws\" versao=\"2.02\">  <versaoDados>2.02</versaoDados></cabecalho>]]></nfseCabecMsg>" }
	# end

	# describe "#content_xml" do
	# 	it  do
	# 		subject.expects(:canonical_xml_builder).returns("<xmlBuilder>value</xmlBuilder>")
	# 		subject.content_xml.must_equal "<nfseDadosMsg><![CDATA[<xmlBuilder>value</xmlBuilder>]]></nfseDadosMsg>"
	# 	end
	# end

	# describe "#canonical_xml_builder" do
	# 	it "deve canonicalizar o valor do metodo xml_builder" do
	# 		xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |new_xml|
	# 			new_xml.Principal{
	# 				new_xml.Valor 1
	# 			}
	# 		end
	# 		subject.expects(:xml_builder).returns(xml)
	# 		subject.canonical_xml_builder.must_equal("<Principal><Valor>1</Valor></Principal>")
	# 	end
		
	# end

	# describe "#format_data_xml_for_signature" do
	# 	it "deve adicionar o attr xmlns no root do XML" do
	# 		xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |new_xml|
	# 			new_xml.Principal{
	# 				new_xml.Valor 1
	# 			}
	# 		end.doc.root

	# 		subject.send(:format_data_xml_for_signature, xml).must_equal "<Principal xmlns=\"http://www.betha.com.br/e-nota-contribuinte-ws\"><Valor>1</Valor></Principal>"
	# 	end
	# end

	# context "#xml_intermediario_servico" do
	# 	it "estrutura com todos os atributos" do
	# 		xml = subject.send(:xml_intermediario_servico, intermediario).doc
	# 		xml.xpath('Intermediario/RazaoSocial').first.text.must_equal        intermediario.razao_social
	# 		xml.xpath('Intermediario/IdentificacaoIntermediario/CpfCnpj/Cnpj').first.text.must_equal       BrNfe::Helper::CpfCnpj.new(intermediario.cpf_cnpj).sem_formatacao
	# 		xml.xpath('Intermediario/IdentificacaoIntermediario/InscricaoMunicipal').first.text.must_equal intermediario.inscricao_municipal
	# 	end
	# 	it "estrutura sem os atributos não obrigatorios" do
	# 		intermediario.assign_attributes({cpf_cnpj: '132.456.789-01', inscricao_municipal: ''})
	# 		xml = subject.send(:xml_intermediario_servico, intermediario).doc

	# 		xml.xpath('Intermediario/IdentificacaoIntermediario/CpfCnpj/Cpf').first.text.must_equal  BrNfe::Helper::CpfCnpj.new(intermediario.cpf_cnpj).sem_formatacao
	# 		xml.xpath('Intermediario/IdentificacaoIntermediario/InscricaoMunicipal').first.must_be_nil
	# 	end
	# 	it "se não tiver intermediario não monta o xml" do
	# 		xml = subject.send(:xml_intermediario_servico, nil).doc
	# 		xml.root.to_s.must_equal ''
	# 	end
	# end

	# context "#xml_prestador" do
	# 	it "estrutura com todos os atributos" do
	# 		xml = subject.send(:xml_prestador).doc

	# 		xml.xpath('Prestador/CpfCnpj/Cnpj').first.text.must_equal emitente.cnpj
	# 		xml.xpath('Prestador/InscricaoMunicipal').first.text.must_equal emitente.inscricao_municipal
	# 	end
	# 	it "estrutura sem os atributos não obrigatorios" do
	# 		emitente.inscricao_municipal = ''
	# 		xml = subject.send(:xml_prestador).doc

	# 		xml.xpath('Prestador/InscricaoMunicipal').first.must_be_nil
	# 	end
	# 	it "se o env não for production não exibe a inscricao_municipal pois a base de testes da Betha está bugada" do
	# 		emitente.inscricao_municipal = '7987897'
	# 		subject.env = :test
	# 		xml = subject.send(:xml_prestador).doc

	# 		xml.xpath('Prestador/InscricaoMunicipal').first.must_be_nil
	# 	end
	# end

	# describe "#xml_dados_servico" do
	# 	before do
	# 		rps.assign_attributes({
	# 			total_services:          1_003.456,
	# 			deductions:              1_003.123465132,
	# 			valor_pis:               1_003.0,
	# 			valor_cofins:            1_003.3654,
	# 			valor_inss:              1_004.456,
	# 			valor_ir:                1_005.456,
	# 			valor_csll:              1_006.456,
	# 			outras_retencoes:        1_007.456,
	# 			total_iss:               1_008.456,
	# 			iss_tax_rate:                1_009.456,
	# 			desconto_incondicionado: 1_010.456,
	# 			desconto_condicionado:   1_011.456,
	# 			responsavel_retencao:    '123',
	# 			item_lista_servico:      '6.356.01',
	# 			iss_retained:              true,
	# 			cnae_code:               '65.687.5654',
	# 			description:             'áêçOÓó'.ljust(2_005, 'a'),
	# 			codigo_municipio:        '1234AAA567890123',
	# 			exigibilidade_iss:       '4',
	# 			codigo_pais:              'A123456',
	# 			municipio_incidencia:    '1234AAA567890123',
	# 			numero_processo:         '5'.rjust(50, '5'),
	# 			codigo_tributacao_municipio: '123465'.ljust(30, 'A'),
	# 		})
	# 	end
	# 	it "deve vir com a estrutura adecuada com todos os valores preenchidos" do
	# 		xml = subject.send(:xml_dados_servico, rps).doc

	# 		xml.xpath('Servico/IssRetido').first.text.must_equal           "1"
	# 		xml.xpath('Servico/ResponsavelRetencao').first.text.must_equal "1"
	# 		xml.xpath('Servico/ItemListaServico').first.text.must_equal    "63560"
	# 		xml.xpath('Servico/CodigoCnae').first.text.must_equal          "6568756"
	# 		xml.xpath('Servico/Discriminacao').first.text.must_equal       'aecOOo'.ljust(2_000, 'a')
	# 		xml.xpath('Servico/CodigoMunicipio').first.text.must_equal     "1234567"
	# 		xml.xpath('Servico/CodigoPais').first.text.must_equal          "1234"
	# 		xml.xpath('Servico/ExigibilidadeISS').first.text.must_equal    "4"
	# 		xml.xpath('Servico/MunicipioIncidencia').first.text.must_equal "1234567"
	# 		xml.xpath('Servico/NumeroProcesso').first.text.must_equal      "5".rjust(30, '5')
	# 		xml.xpath('Servico/CodigoTributacaoMunicipio').first.text.must_equal '123465'.ljust(20, 'A')			
			
	# 		xml.xpath('Servico/Valores/ValorServicos').first.text.must_equal          "1003.46"
	# 		xml.xpath('Servico/Valores/ValorDeducoes').first.text.must_equal          "1003.12"
	# 		xml.xpath('Servico/Valores/ValorPis').first.text.must_equal               "1003.0"
	# 		xml.xpath('Servico/Valores/ValorCofins').first.text.must_equal            "1003.37"
	# 		xml.xpath('Servico/Valores/ValorInss').first.text.must_equal              "1004.46"
	# 		xml.xpath('Servico/Valores/ValorIr').first.text.must_equal                "1005.46"
	# 		xml.xpath('Servico/Valores/ValorCsll').first.text.must_equal              "1006.46"
	# 		xml.xpath('Servico/Valores/OutrasRetencoes').first.text.must_equal        "1007.46"
	# 		xml.xpath('Servico/Valores/ValorIss').first.text.must_equal               "1008.46"
	# 		xml.xpath('Servico/Valores/Aliquota').first.text.must_equal               "1009.46"
	# 		xml.xpath('Servico/Valores/DescontoIncondicionado').first.text.must_equal "1010.46"
	# 		xml.xpath('Servico/Valores/DescontoCondicionado').first.text.must_equal   "1011.46"
	# 	end

	# 	it "se exigibilidade_iss não for 4, então não posso mandar o codigo do pais" do
	# 		rps.exigibilidade_iss = '1'
	# 		xml = subject.send(:xml_dados_servico, rps).doc
	# 		xml.xpath('Servico/CodigoPais').first.must_be_nil
	# 	end

	# 	it "sem os valores não obrigatórios" do
	# 		rps.assign_attributes({
	# 			total_services:          '',
	# 			deductions:              '',
	# 			valor_pis:               '',
	# 			valor_cofins:            '',
	# 			valor_inss:              '',
	# 			valor_ir:                '',
	# 			valor_csll:              '',
	# 			outras_retencoes:        '',
	# 			total_iss:               '',
	# 			iss_tax_rate:                '',
	# 			desconto_incondicionado: '',
	# 			desconto_condicionado:   '',
	# 			responsavel_retencao:    '',
	# 			item_lista_servico:      '',
	# 			iss_retained:              '',
	# 			cnae_code:               '',
	# 			description:             '',
	# 			codigo_municipio:        '',
	# 			exigibilidade_iss:       '',
	# 			codigo_pais:             '',
	# 			municipio_incidencia:    '',
	# 			numero_processo:         '',
	# 			codigo_tributacao_municipio: '',
	# 		})

	# 		xml = subject.send(:xml_dados_servico, rps).doc

	# 		xml.xpath('Servico/IssRetido').first.text.must_equal        "2"
	# 		xml.xpath('Servico/ResponsavelRetencao').first.must_be_nil
	# 		xml.xpath('Servico/ItemListaServico').first.must_be_nil
	# 		xml.xpath('Servico/CodigoCnae').first.must_be_nil
	# 		xml.xpath('Servico/Discriminacao').first.text.must_equal   ''
	# 		xml.xpath('Servico/CodigoMunicipio').first.text.must_equal ''
	# 		xml.xpath('Servico/CodigoPais').first.must_be_nil
	# 		xml.xpath('Servico/ExigibilidadeISS').first.text.must_equal ""
	# 		xml.xpath('Servico/MunicipioIncidencia').first.must_be_nil
	# 		xml.xpath('Servico/NumeroProcesso').first.must_be_nil
	# 		xml.xpath('Servico/CodigoTributacaoMunicipio').first.must_be_nil
			
	# 		xml.xpath('Servico/Valores/ValorServicos').first.text.must_equal "0.0"
	# 		xml.xpath('Servico/Valores/ValorDeducoes').first.must_be_nil
	# 		xml.xpath('Servico/Valores/ValorPis').first.must_be_nil
	# 		xml.xpath('Servico/Valores/ValorCofins').first.must_be_nil
	# 		xml.xpath('Servico/Valores/ValorInss').first.must_be_nil
	# 		xml.xpath('Servico/Valores/ValorIr').first.must_be_nil
	# 		xml.xpath('Servico/Valores/ValorCsll').first.must_be_nil
	# 		xml.xpath('Servico/Valores/OutrasRetencoes').first.must_be_nil
	# 		xml.xpath('Servico/Valores/ValorIss').first.must_be_nil
	# 		xml.xpath('Servico/Valores/Aliquota').first.must_be_nil
	# 		xml.xpath('Servico/Valores/DescontoIncondicionado').first.must_be_nil
	# 		xml.xpath('Servico/Valores/DescontoCondicionado').first.must_be_nil
	# 	end
	# end

	# describe "#xml_inf_declaracao_prestacao_servico" do
	# 	before do
	# 		rps.assign_attributes({
	# 			data_emissao: DateTime.parse('12/04/1991 03:45'),
	# 			status: '123',
	# 			competencia: DateTime.parse('05/11/2000')
	# 		})
	# 		emitente.assign_attributes({
	# 			regime_especial_tributacao: 1,
	# 			optante_simples_nacional: true,
	# 			incentivo_fiscal: false,
	# 		})
	# 	end
	# 	it  do
	# 		sequence1 = sequence('sequence1')
	# 		subject.expects(:xml_identificacao_rps).with(rps).returns(Nokogiri::XML::Builder.new {|xml| xml.Doc1 1}).in_sequence(sequence1)
	# 		subject.expects(:xml_rps_substituido).with(rps).returns(  Nokogiri::XML::Builder.new {|xml| xml.Doc2 2}).in_sequence(sequence1)
	# 		subject.expects(:xml_dados_servico).with(rps).returns(    Nokogiri::XML::Builder.new {|xml| xml.Doc3 3}).in_sequence(sequence1)
	# 		subject.expects(:xml_prestador).returns(                  Nokogiri::XML::Builder.new {|xml| xml.Doc4 4}).in_sequence(sequence1)
	# 		subject.expects(:xml_dados_tomador).with(rps.destinatario).returns(Nokogiri::XML::Builder.new {|xml| xml.Doc5 5}).in_sequence(sequence1)
	# 		subject.expects(:xml_intermediario_servico).with(rps.intermediario).returns(Nokogiri::XML::Builder.new {|xml| xml.Doc6 6}).in_sequence(sequence1)
	# 		subject.expects(:xml_dados_construcao_civil).with(rps).returns(Nokogiri::XML::Builder.new {|xml| xml.Doc7 7}).in_sequence(sequence1)
	# 		xml = subject.send(:xml_inf_declaracao_prestacao_servico, rps).doc

	# 		xml.xpath('InfDeclaracaoPrestacaoServico/Rps/Doc1').first.text.must_equal '1'
	# 		xml.xpath('InfDeclaracaoPrestacaoServico/Rps/DataEmissao').first.text.must_equal '1991-04-12'
	# 		xml.xpath('InfDeclaracaoPrestacaoServico/Rps/Status').first.text.must_equal '1'
	# 		xml.xpath('InfDeclaracaoPrestacaoServico/Rps/Doc2').first.text.must_equal '2'
	# 		xml.xpath('InfDeclaracaoPrestacaoServico/Competencia').first.text.must_equal '2000-11-05'
	# 		xml.xpath('InfDeclaracaoPrestacaoServico/Doc3').first.text.must_equal '3'
	# 		xml.xpath('InfDeclaracaoPrestacaoServico/Doc4').first.text.must_equal '4'
	# 		xml.xpath('InfDeclaracaoPrestacaoServico/Doc5').first.text.must_equal '5'
	# 		xml.xpath('InfDeclaracaoPrestacaoServico/Doc6').first.text.must_equal '6'
	# 		xml.xpath('InfDeclaracaoPrestacaoServico/Doc7').first.text.must_equal '7'
	# 		xml.xpath('InfDeclaracaoPrestacaoServico/RegimeEspecialTributacao').first.text.must_equal '1'
	# 		xml.xpath('InfDeclaracaoPrestacaoServico/OptanteSimplesNacional').first.text.must_equal '1'
	# 		xml.xpath('InfDeclaracaoPrestacaoServico/IncentivoFiscal').first.text.must_equal '2'
	# 	end
	# end

	# describe "#xml_rps_assinado" do
	# 	it  do
	# 		info_servico = Nokogiri::XML::Builder.new {|xml| xml.InfoServico 'valores'}
	# 		subject.expects(:xml_inf_declaracao_prestacao_servico).with(rps).returns(info_servico)
	# 		subject.expects(:assinatura_xml).with(info_servico.doc.root.to_s, "#rps#{rps.numero}").returns("<Signature>true</Signature>")
	# 		xml = subject.send(:xml_rps_assinado, rps).doc
	# 		xml.xpath('Rps/InfoServico').first.text.must_equal 'valores'
	# 		xml.xpath('Rps/Signature').first.text.must_equal 'true'
	# 	end
	# end

	# describe "#xml_pedido_cancelamento_assinado" do
	# 	it  do
	# 		subject.numero_nfse = 888
	# 		xml_cancelamento = Nokogiri::XML::Builder.new {|xml| xml.XmlCancelamento 'valores'}
	# 		subject.expects(:xml_inf_pedido_cancelamento).returns(xml_cancelamento)
	# 		subject.expects(:assinatura_xml).with(xml_cancelamento.doc.root.to_s, "#nf888").returns("<Signature>true</Signature>")
	# 		xml = subject.send(:xml_pedido_cancelamento_assinado).doc
	# 		xml.xpath('Pedido/XmlCancelamento').first.text.must_equal 'valores'
	# 		xml.xpath('Pedido/Signature').first.text.must_equal 'true'
	# 	end
	# end

	# describe "#xml_inf_pedido_cancelamento" do
	# 	before do
	# 		subject.assign_attributes({
	# 			numero_nfse: '336ABC6554411233664125',
	# 			codigo_cancelamento: '1234567890',
	# 			emitente:{
	# 				cnpj: '12345678901234',
	# 				inscricao_municipal: '9996654785524865464565',
	# 				endereco: {codigo_municipio: '123456789012345'}
	# 			}
	# 		})
	# 	end

	# 	it "com env = production" do
	# 		subject.env = :production
	# 		xml = subject.send(:xml_inf_pedido_cancelamento).doc

	# 		xml.xpath('InfPedidoCancelamento').first.attr('Id').must_equal 'nf336ABC6554411233664125'
	# 		# Apenas 15 nuemros
	# 		xml.xpath('InfPedidoCancelamento/IdentificacaoNfse/Numero').first.text.must_equal '336655441123366'
	# 		xml.xpath('InfPedidoCancelamento/IdentificacaoNfse/InscricaoMunicipal').first.text.must_equal '999665478552486'
	# 		xml.xpath('InfPedidoCancelamento/IdentificacaoNfse/CodigoMunicipio').first.text.must_equal '1234567'
	# 		xml.xpath('InfPedidoCancelamento/CodigoCancelamento').first.text.must_equal '1234'			
	# 	end

	# 	it "com env = test" do
	# 		subject.env = :test
	# 		xml = subject.send(:xml_inf_pedido_cancelamento).doc

	# 		xml.xpath('InfPedidoCancelamento').first.attr('Id').must_equal 'nf336ABC6554411233664125'
	# 		xml.xpath('InfPedidoCancelamento/IdentificacaoNfse/Numero').first.text.must_equal '336655441123366'
	# 		xml.xpath('InfPedidoCancelamento/IdentificacaoNfse/InscricaoMunicipal').first.must_be_nil
	# 		xml.xpath('InfPedidoCancelamento/IdentificacaoNfse/CodigoMunicipio').first.text.must_equal '1234567'
	# 		xml.xpath('InfPedidoCancelamento/CodigoCancelamento').first.text.must_equal '1234'			
	# 	end
	# end



	# describe "#xml_condicao_pagamento" do
	# 	it "estrutura a prazo" do
	# 		xml = subject.send(:xml_condicao_pagamento, rps).doc

	# 		xml.xpath('CondicaoPagamento/Condicao').first.text.must_equal                rps.condicao_pagamento.condicao
	# 		xml.xpath('CondicaoPagamento/QtdParcela').first.text.must_equal              '2'
			
	# 		xml.xpath('CondicaoPagamento/Parcelas/Parcela').first.text.must_equal        '1'
	# 		xml.xpath('CondicaoPagamento/Parcelas/DataVencimento').first.text.must_equal '15/10/2015'
	# 		xml.xpath('CondicaoPagamento/Parcelas/Valor').first.text.must_equal          '10.0'

	# 		xml.xpath('CondicaoPagamento/Parcelas/Parcela').last.text.must_equal        '2'
	# 		xml.xpath('CondicaoPagamento/Parcelas/DataVencimento').last.text.must_equal '15/11/2015'
	# 		xml.xpath('CondicaoPagamento/Parcelas/Valor').last.text.must_equal          '20.0'
	# 	end

	# 	it "estrutura a vista" do
	# 		rps.condicao_pagamento.assign_attributes(condicao: 'A_VISTA', parcelas: [])
	# 		xml = subject.send(:xml_condicao_pagamento, rps).doc

	# 		xml.xpath('CondicaoPagamento/Condicao').first.text.must_equal   'A_VISTA'
	# 		xml.xpath('CondicaoPagamento/QtdParcela').first.must_be_nil
			
	# 		xml.xpath('CondicaoPagamento/Parcelas').first.must_be_nil
	# 	end

	# 	it "quando não tem condicao_pagamento" do
	# 		rps.condicao_pagamento = nil
	# 		xml = subject.send(:xml_condicao_pagamento, rps).doc
	# 		xml.root.to_s.must_equal ''
	# 	end
	# end

end