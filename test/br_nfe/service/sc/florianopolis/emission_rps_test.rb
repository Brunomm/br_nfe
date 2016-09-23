require 'test_helper'

describe BrNfe::Service::SC::Florianopolis::EmissionRPS do
	subject { FactoryGirl.build(:service_sc_floripa_emission_rps, lote_rps: [rps]) }
	let(:rps)    { FactoryGirl.build(:br_nfe_rps, :completo, items: [item]) } 
	let(:xml) { Nokogiri::XML(subject.xml_builder) } 
	let(:item) { FactoryGirl.build(:service_item) }


	it { must validate_presence_of(:cfps) }

	it "deve passar na validação do SCHEMA quando os dados estão preenchidos corretamente" do
		xsd_text = File.read(BrNfe.root+'/test/br_nfe/service/sc/florianopolis/XSD/TiposNFSe_v2.0.xsd')
		# Substiruo a localização do arquivo xmldsig-core-schema.xsd conforme a localização da gem
		xsd_text.gsub!('xmldsig-core-schema.xsd', BrNfe.root+'/test/br_nfe/service/sc/florianopolis/XSD/xmldsig-core-schema.xsd' )
		schema = Nokogiri::XML::Schema(xsd_text)
		document = Nokogiri::XML(subject.content_xml)

		errors = schema.validate(document)

		errors.must_be_empty
	end

	describe "xml_builder" do
		context "Atributos do primeiro nivel " do
			it "deve ter o atributo Versao" do
				xml.at('InfRequisicao/Versao').text.must_equal "2.0"
			end
			it "deve ter o atributo TipoSistema com valor 1 se estiver em ambiente de produção" do
				xml.at('InfRequisicao/TipoSistema').text.must_equal "1"
			end
			it "deve ter o atributo TipoSistema com valor 0 se estiver em ambiente de teste" do
				subject.env = :test
				xml.at('InfRequisicao/TipoSistema').text.must_equal "0"
			end
			it "o atributo Identificacao deve estar presente se tiver o valor de rps.numero" do
				rps.numero = 987654321
				xml.at('InfRequisicao/Identificacao').text.must_equal '987654321'
			end
			it "o atributo Identificacao não deve estar presente se não houver o valor de rps.numero" do
				rps.numero = nil
				xml.at('InfRequisicao/Identificacao').must_be_nil
			end
			it "DataEmissao deve ter o valor formatado para data com a data de emissão" do
				rps.data_emissao = Date.parse('12/08/2014')
				xml.at('InfRequisicao/DataEmissao').text.must_equal '2014-08-12'
			end
			it "NumeroSerieRequisicao deve ter o valor da serie do rps" do
				rps.serie = '2'
				xml.at('InfRequisicao/NumeroSerieRequisicao').text.must_equal '2'
			end
			it "NumeroSerieRequisicao deve ter valor mesmo se a serie do rps for nil" do
				rps.serie = nil
				xml.at('InfRequisicao/NumeroSerieRequisicao').text.must_equal '0'
			end
			it "CFPS deve ter o valor do atributo cfps" do
				subject.cfps = 5547
				xml.at('InfRequisicao/CFPS').text.must_equal '5547'
			end
		end

		context "atributos de AEDF" do
			it "AEDF deve conter apenas números" do
				subject.aedf = 'ABC123456DEF789'
				xml.at('InfRequisicao/AEDF/AEDF').text.must_equal "1234567"
			end
			it "AEDF deve conter tamanho máximo de 7 digitos" do
				subject.aedf = 987654321
				xml.at('InfRequisicao/AEDF/AEDF').text.must_equal "9876543"
			end
			it "o atributo TipoAedf deve ter sempre o valor 'NORMAL'" do
				xml.at('InfRequisicao/AEDF/TipoAedf').text.must_equal "NORMAL"
			end
		end

		context "atributos de DadosServico" do
			let(:item_2) { FactoryGirl.build(:service_item, cnae_code: '666', description: 'DESC', valor_total:  547.8888) } 
			it "o deve ter um atributo ItemServico para cada item de serviço com suas respectivas informações" do
				rps.items << item_2
				items = xml.at('InfRequisicao/DadosServico').search('ItemServico')
				
				items[0].at('IdCNAE').text.must_equal '886'
				items[0].at('CodigoAtividade').text.must_equal '1234567'
				items[0].at('DescricaoServico').text.must_equal 'Item description'
				items[0].at('CST').text.must_equal '1'
				items[0].at('Aliquota').text.must_equal '0.025'
				items[0].at('ValorUnitario').text.must_equal '100.0'
				items[0].at('Quantidade').text.must_equal '2'
				items[0].at('ValorTotal').text.must_equal '200.0'

				items[1].at('IdCNAE').text.must_equal '886'
				items[1].at('CodigoAtividade').text.must_equal '666'
				items[1].at('DescricaoServico').text.must_equal 'DESC'
				items[1].at('CST').text.must_equal '1'
				items[1].at('Aliquota').text.must_equal '0.025'
				items[1].at('ValorUnitario').text.must_equal '100.0'
				items[1].at('Quantidade').text.must_equal '2'
				items[1].at('ValorTotal').text.must_equal '547.89'
			end

			it "atributo BaseCalculo deve ter o valor monetário do base_calculo do RPS" do
				rps.base_calculo = '31.1111'
				items = xml.at('InfRequisicao/DadosServico/BaseCalculo').text.must_equal '31.11'
			end
			it "atributo ValorISSQN deve ter o valor monetário do total_iss do RPS" do
				rps.total_iss = '7.666'
				items = xml.at('InfRequisicao/DadosServico/ValorISSQN').text.must_equal '7.67'
			end
			it "atributo ValorTotalServicos deve ter o valor monetário do valor_total_servicos do RPS" do
				rps.valor_total_servicos = 28_731.664
				items = xml.at('InfRequisicao/DadosServico/ValorTotalServicos').text.must_equal '28731.66'
			end
			context "BaseCalculoSubstituicao" do
				it "se houver valor no atributo total_base_calculo_st do RPS deve exibir o atribudo do XML" do
					rps.total_base_calculo_st = 778
					items = xml.at('InfRequisicao/DadosServico/BaseCalculoSubstituicao').text.must_equal '778.0'	
				end
				it "se não houver valor no atributo total_base_calculo_st do RPS não irá exibir o atribudo do XML" do
					rps.total_base_calculo_st = nil
					items = xml.at('InfRequisicao/DadosServico/BaseCalculoSubstituicao').must_be_nil
				end
			end
			context "ValorISSQNSubstituicao" do
				it "se houver valor no atributo total_issqn_st do RPS deve exibir o atribudo do XML" do
					rps.total_issqn_st = 778
					items = xml.at('InfRequisicao/DadosServico/ValorISSQNSubstituicao').text.must_equal '778.0'	
				end
				it "se não houver valor no atributo total_issqn_st do RPS não irá exibir o atribudo do XML" do
					rps.total_issqn_st = nil
					items = xml.at('InfRequisicao/DadosServico/ValorISSQNSubstituicao').must_be_nil
				end
			end
			context "DadosAdicionais" do
				it "se houver valor no atributo description do RPS deve exibir o atribudo do XML" do
					rps.description = 'description'
					items = xml.at('InfRequisicao/DadosServico/DadosAdicionais').text.must_equal 'description'
				end
				it "se não houver valor no atributo description do RPS não irá exibir o atribudo do XML" do
					rps.description = nil
					items = xml.at('InfRequisicao/DadosServico/DadosAdicionais').must_be_nil
				end
			end
		end		
	end
end