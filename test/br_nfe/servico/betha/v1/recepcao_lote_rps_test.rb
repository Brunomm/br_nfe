require 'test_helper'

describe BrNfe::Servico::Betha::V1::RecepcaoLoteRps do
	subject        { FactoryGirl.build(:br_nfe_servico_betha_recepcao_lote_rps, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:emitente)   }
	let(:rps_1)    { FactoryGirl.build(:br_nfe_rps, valor_pis: '', valor_cofins: nil, valor_inss: nil, valor_ir: nil, valor_csll: nil) } 
	let(:rps_2)    { FactoryGirl.build(:br_nfe_rps, :completo) } 

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Servico::Betha::V1::Gateway }
	end

	describe "#wsdl" do
		context "for env production" do
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/recepcionarLoteRps?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/recepcionarLoteRps?wsdl' }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :enviar_lote_rps }
	end

	describe "#xml_inf_rps" do
		it "estrutura com informações do rps parcialmente preenchidas" do
			xml = subject.xml_inf_rps(rps_1).doc

			xml.xpath('InfRps').first.attr("Id").must_equal "rps#{rps_1.numero}"
			xml.xpath('InfRps/IdentificacaoRps/Numero').first.text.must_equal rps_1.numero.to_s
			xml.xpath('InfRps/IdentificacaoRps/Serie').first.text.must_equal  rps_1.serie
			xml.xpath('InfRps/IdentificacaoRps/Tipo').first.text.must_equal   rps_1.tipo

			xml.xpath('InfRps/RpsSubstituido/Numero').first.must_be_nil
			xml.xpath('InfRps/RpsSubstituido/Serie').first.must_be_nil
			xml.xpath('InfRps/RpsSubstituido/Tipo').first.must_be_nil
			
			xml.xpath('InfRps/DataEmissao').first.text.must_equal              rps_1.data_emissao.to_s(:br_nfe)
			xml.xpath('InfRps/NaturezaOperacao').first.text.must_equal         emitente.natureza_operacao
			xml.xpath('InfRps/RegimeEspecialTributacao').first.text.must_equal emitente.regime_especial_tributacao
			xml.xpath('InfRps/OptanteSimplesNacional').first.text.must_equal   emitente.optante_simples_nacional
			xml.xpath('InfRps/IncentivadorCultural').first.text.must_equal     emitente.incentivo_fiscal
			xml.xpath('InfRps/Status').first.text.must_equal                   rps_1.status

			# Serviço
			xml.xpath('InfRps/Servico/ItemListaServico').first.text.must_equal          rps_1.item_lista_servico
			xml.xpath('InfRps/Servico/CodigoCnae').first.text.must_equal                rps_1.codigo_cnae
			xml.xpath('InfRps/Servico/CodigoTributacaoMunicipio').first.must_be_nil
			xml.xpath('InfRps/Servico/Discriminacao').first.text.must_equal             rps_1.discriminacao
			xml.xpath('InfRps/Servico/CodigoMunicipio').first.text.must_equal           rps_1.codigo_municipio
			# Valores dos serviços
			xml.xpath('InfRps/Servico/Valores/ValorServicos').first.text.must_equal     rps_1.valor_servicos
			xml.xpath('InfRps/Servico/Valores/IssRetido').first.text.must_equal         rps_1.iss_retido
			xml.xpath('InfRps/Servico/Valores/BaseCalculo').first.text.must_equal       rps_1.base_calculo
			xml.xpath('InfRps/Servico/Valores/ValorDeducoes').first.text.must_equal     rps_1.valor_deducoes
			xml.xpath('InfRps/Servico/Valores/ValorPis').first.must_be_nil
			xml.xpath('InfRps/Servico/Valores/ValorCofins').first.must_be_nil
			xml.xpath('InfRps/Servico/Valores/ValorInss').first.must_be_nil
			xml.xpath('InfRps/Servico/Valores/ValorIr').first.must_be_nil
			xml.xpath('InfRps/Servico/Valores/ValorCsll').first.must_be_nil
			xml.xpath('InfRps/Servico/Valores/ValorIss').first.text.must_equal          rps_1.valor_iss
			xml.xpath('InfRps/Servico/Valores/OutrasRetencoes').first.text.must_equal   rps_1.outras_retencoes
			xml.xpath('InfRps/Servico/Valores/Aliquota').first.text.must_equal          rps_1.aliquota
			
			# Prestador
			xml.xpath('InfRps/Prestador/Cnpj').first.text.must_equal               emitente.cnpj
			xml.xpath('InfRps/Prestador/InscricaoMunicipal').first.text.must_equal emitente.inscricao_municipal
			
			# Tomador
			xml.xpath('InfRps/Tomador/RazaoSocial').first.text.must_equal                             rps_1.destinatario.razao_social
			xml.xpath('InfRps/Tomador/IdentificacaoTomador/CpfCnpj/Cpf').first.text.must_equal        BrNfe::Helper::CpfCnpj.new(rps_1.destinatario.cpf_cnpj).sem_formatacao
			xml.xpath('InfRps/Tomador/IdentificacaoTomador/InscricaoMunicipal').first.text.must_equal rps_1.destinatario.inscricao_municipal
			xml.xpath('InfRps/Tomador/IdentificacaoTomador/InscricaoEstadual').first.text.must_equal  rps_1.destinatario.inscricao_estadual
			xml.xpath('InfRps/Tomador/Endereco/Endereco').first.text.must_equal                       rps_1.destinatario.endereco.logradouro
			xml.xpath('InfRps/Tomador/Endereco/Numero').first.text.must_equal                         rps_1.destinatario.endereco.numero
			xml.xpath('InfRps/Tomador/Endereco/Complemento').first.text.must_equal                    rps_1.destinatario.endereco.complemento
			xml.xpath('InfRps/Tomador/Endereco/Bairro').first.text.must_equal                         rps_1.destinatario.endereco.bairro
			xml.xpath('InfRps/Tomador/Endereco/CodigoMunicipio').first.text.must_equal                rps_1.destinatario.endereco.codigo_municipio
			xml.xpath('InfRps/Tomador/Endereco/Uf').first.text.must_equal                             rps_1.destinatario.endereco.uf
			xml.xpath('InfRps/Tomador/Endereco/Cep').first.text.must_equal                            rps_1.destinatario.endereco.cep
			xml.xpath('InfRps/Tomador/Contato/Telefone').first.text.must_equal                        rps_1.destinatario.telefone
			xml.xpath('InfRps/Tomador/Contato/Email').first.text.must_equal                           rps_1.destinatario.email			
			
			xml.xpath('InfRps/IntermediarioServico').first.must_be_nil
			xml.xpath('InfRps/ConstrucaoCivil').first.must_be_nil
			xml.xpath('InfRps/OutrasInformacoes').first.must_be_nil
			xml.xpath('InfRps/CondicaoPagamento').first.must_be_nil
		end
		it "estrutura com toas informações do rps preenchidas" do
			rps_2.destinatario.cpf_cnpj = '12345678901234'
			xml = subject.xml_inf_rps(rps_2).doc

			xml.xpath('InfRps').first.attr("Id").must_equal "rps#{rps_2.numero}"
			xml.xpath('InfRps/IdentificacaoRps/Numero').first.text.must_equal rps_2.numero.to_s
			xml.xpath('InfRps/IdentificacaoRps/Serie').first.text.must_equal  rps_2.serie
			xml.xpath('InfRps/IdentificacaoRps/Tipo').first.text.must_equal   rps_2.tipo

			xml.xpath('InfRps/RpsSubstituido/Numero').first.text.must_equal rps_2.numero_substituicao
			xml.xpath('InfRps/RpsSubstituido/Serie').first.text.must_equal  rps_2.serie_substituicao
			xml.xpath('InfRps/RpsSubstituido/Tipo').first.text.must_equal   rps_2.tipo_substituicao
			
			xml.xpath('InfRps/DataEmissao').first.text.must_equal              rps_2.data_emissao.to_s(:br_nfe)
			xml.xpath('InfRps/NaturezaOperacao').first.text.must_equal         emitente.natureza_operacao
			xml.xpath('InfRps/RegimeEspecialTributacao').first.text.must_equal emitente.regime_especial_tributacao
			xml.xpath('InfRps/OptanteSimplesNacional').first.text.must_equal   emitente.optante_simples_nacional
			xml.xpath('InfRps/IncentivadorCultural').first.text.must_equal     emitente.incentivo_fiscal
			xml.xpath('InfRps/Status').first.text.must_equal                   rps_2.status

			# Serviço
			xml.xpath('InfRps/Servico/ItemListaServico').first.text.must_equal          rps_2.item_lista_servico
			xml.xpath('InfRps/Servico/CodigoCnae').first.text.must_equal                rps_2.codigo_cnae
			xml.xpath('InfRps/Servico/CodigoTributacaoMunicipio').first.text.must_equal rps_2.codigo_tributacao_municipio
			xml.xpath('InfRps/Servico/Discriminacao').first.text.must_equal             rps_2.discriminacao
			xml.xpath('InfRps/Servico/CodigoMunicipio').first.text.must_equal           rps_2.codigo_municipio
			# Valores dos serviços
			xml.xpath('InfRps/Servico/Valores/ValorServicos').first.text.must_equal     rps_2.valor_servicos
			xml.xpath('InfRps/Servico/Valores/IssRetido').first.text.must_equal         rps_2.iss_retido
			xml.xpath('InfRps/Servico/Valores/BaseCalculo').first.text.must_equal       rps_2.base_calculo
			xml.xpath('InfRps/Servico/Valores/ValorDeducoes').first.text.must_equal     rps_2.valor_deducoes
			xml.xpath('InfRps/Servico/Valores/ValorPis').first.text.must_equal          rps_2.valor_pis
			xml.xpath('InfRps/Servico/Valores/ValorCofins').first.text.must_equal       rps_2.valor_cofins
			xml.xpath('InfRps/Servico/Valores/ValorInss').first.text.must_equal         rps_2.valor_inss
			xml.xpath('InfRps/Servico/Valores/ValorIr').first.text.must_equal           rps_2.valor_ir
			xml.xpath('InfRps/Servico/Valores/ValorCsll').first.text.must_equal         rps_2.valor_csll
			xml.xpath('InfRps/Servico/Valores/ValorIss').first.text.must_equal          rps_2.valor_iss
			xml.xpath('InfRps/Servico/Valores/OutrasRetencoes').first.text.must_equal   rps_2.outras_retencoes
			xml.xpath('InfRps/Servico/Valores/Aliquota').first.text.must_equal          rps_2.aliquota
			
			# Prestador
			xml.xpath('InfRps/Prestador/Cnpj').first.text.must_equal               emitente.cnpj
			xml.xpath('InfRps/Prestador/InscricaoMunicipal').first.text.must_equal emitente.inscricao_municipal
			
			# Tomador
			xml.xpath('InfRps/Tomador/RazaoSocial').first.text.must_equal                             rps_2.destinatario.razao_social
			xml.xpath('InfRps/Tomador/IdentificacaoTomador/CpfCnpj/Cnpj').first.text.must_equal       BrNfe::Helper::CpfCnpj.new(rps_2.destinatario.cpf_cnpj).sem_formatacao
			xml.xpath('InfRps/Tomador/IdentificacaoTomador/InscricaoMunicipal').first.text.must_equal rps_2.destinatario.inscricao_municipal
			xml.xpath('InfRps/Tomador/IdentificacaoTomador/InscricaoEstadual').first.text.must_equal  rps_2.destinatario.inscricao_estadual
			xml.xpath('InfRps/Tomador/Endereco/Endereco').first.text.must_equal                       rps_2.destinatario.endereco.logradouro
			xml.xpath('InfRps/Tomador/Endereco/Numero').first.text.must_equal                         rps_2.destinatario.endereco.numero
			xml.xpath('InfRps/Tomador/Endereco/Complemento').first.text.must_equal                    rps_2.destinatario.endereco.complemento
			xml.xpath('InfRps/Tomador/Endereco/Bairro').first.text.must_equal                         rps_2.destinatario.endereco.bairro
			xml.xpath('InfRps/Tomador/Endereco/CodigoMunicipio').first.text.must_equal                rps_2.destinatario.endereco.codigo_municipio
			xml.xpath('InfRps/Tomador/Endereco/Uf').first.text.must_equal                             rps_2.destinatario.endereco.uf
			xml.xpath('InfRps/Tomador/Endereco/Cep').first.text.must_equal                            rps_2.destinatario.endereco.cep
			xml.xpath('InfRps/Tomador/Contato/Telefone').first.text.must_equal                        rps_2.destinatario.telefone
			xml.xpath('InfRps/Tomador/Contato/Email').first.text.must_equal                           rps_2.destinatario.email			
			
			xml.xpath('InfRps/IntermediarioServico/RazaoSocial').first.text.must_equal        rps_2.intermediario.razao_social
			xml.xpath('InfRps/IntermediarioServico/CpfCnpj/Cnpj').first.text.must_equal       BrNfe::Helper::CpfCnpj.new(rps_2.intermediario.cpf_cnpj).sem_formatacao
			xml.xpath('InfRps/IntermediarioServico/InscricaoMunicipal').first.text.must_equal rps_2.intermediario.inscricao_municipal

			xml.xpath('InfRps/ConstrucaoCivil/CodigoObra').first.text.must_equal rps_2.codigo_obra
			xml.xpath('InfRps/ConstrucaoCivil/Art').first.text.must_equal rps_2.codigo_art

			xml.xpath('InfRps/OutrasInformacoes').first.text.must_equal rps_2.outras_informacoes

			xml.xpath('InfRps/CondicaoPagamento/Condicao').first.text.must_equal rps_2.condicao_pagamento.condicao
			xml.xpath('InfRps/CondicaoPagamento/QtdParcela').first.text.must_equal '2'
			xml.xpath('InfRps/CondicaoPagamento/Parcelas').count.must_equal 2

			xml.xpath('InfRps/CondicaoPagamento/Parcelas/Parcela').first.text.must_equal '1'
			xml.xpath('InfRps/CondicaoPagamento/Parcelas/DataVencimento').first.text.must_equal Date.parse('15/10/2015').to_s(:br_nfe)
			xml.xpath('InfRps/CondicaoPagamento/Parcelas/Valor').first.text.must_equal '10.0'

			xml.xpath('InfRps/CondicaoPagamento/Parcelas/Parcela').last.text.must_equal '2'
			xml.xpath('InfRps/CondicaoPagamento/Parcelas/DataVencimento').last.text.must_equal Date.parse('15/11/2015').to_s(:br_nfe)
			xml.xpath('InfRps/CondicaoPagamento/Parcelas/Valor').last.text.must_equal '20.0'
		end
	end

	describe "#lote_rps_xml" do
		let(:info_rps_1) do
			Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
				xml.InfRps "RPS1"
			end
		end
		let(:info_rps_2) do
			Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
				xml.InfRps "RPS2"
			end
		end

		before do
			rps_1.numero = '1'
			rps_2.numero = '2'
			subject.lote_rps = [rps_1, rps_2]
		end

		it "estrutura deve conter as informações assinadas de todos os RPSs do lote" do
			subject.expects(:xml_inf_rps).with(rps_1).returns(info_rps_1)
			subject.expects(:xml_inf_rps).with(rps_2).returns(info_rps_2)

			subject.expects(:assinatura_xml).with(info_rps_1.doc.root.to_s, '#rps1').returns('<Signature>RPS_1</Signature>')
			subject.expects(:assinatura_xml).with(info_rps_2.doc.root.to_s, '#rps2').returns('<Signature>RPS_2</Signature>')

			xml = subject.lote_rps_xml.doc

			xml.xpath('LoteRps/NumeroLote').first.text.must_equal         subject.numero_lote_rps
			xml.xpath('LoteRps/Cnpj').first.text.must_equal               emitente.cnpj
			xml.xpath('LoteRps/InscricaoMunicipal').first.text.must_equal emitente.inscricao_municipal
			xml.xpath('LoteRps/QuantidadeRps').first.text.must_equal      '2'
			
			xml.xpath('LoteRps/ListaRps/Rps/InfRps').first.text.must_equal    'RPS1'
			xml.xpath('LoteRps/ListaRps/Rps/Signature').first.text.must_equal 'RPS_1'
			
			xml.xpath('LoteRps/ListaRps/Rps/InfRps').last.text.must_equal    'RPS2'
			xml.xpath('LoteRps/ListaRps/Rps/Signature').last.text.must_equal 'RPS_2'

		end
	end

	describe "#xml_builder" do
		let(:xml_lote_rps) do
			Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
				xml.LoteRps "Valor lote rps"
			end
		end

		it "estrutura" do
			subject.numero_lote_rps = '8899'
			subject.expects(:lote_rps_xml).returns(xml_lote_rps)
			subject.expects(:assinatura_xml).with(xml_lote_rps.doc.root.to_s, '#lote8899').returns('<Signature>SIGN</Signature>')
			
			xml = Nokogiri::XML(subject.xml_builder)

			xml.xpath("Temp/LoteRps").first.text.must_equal "Valor lote rps"
			xml.xpath("Temp/Signature").first.text.must_equal "SIGN"
		end
	end
	
end