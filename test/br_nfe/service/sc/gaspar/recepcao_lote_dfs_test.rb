require 'test_helper'

describe BrNfe::Service::SC::Gaspar::RecepcaoLoteDfs do
	subject { FactoryGirl.build(:service_sc_gaspar_recepcao_lote_dfs, emitente: emitente) }
	let(:rps_basico) { FactoryGirl.build(:br_nfe_rps)              } 
	let(:rps_completo) { FactoryGirl.build(:br_nfe_rps, :completo) } 
	let(:emitente) { FactoryGirl.build(:emitente, natureza_operacao: 51) } 
	let(:xsd_text) do 
		f = File.read(BrNfe.root+'/test/br_nfe/service/sc/gaspar/XSD/nfse.xsd-gaspar.xml')
		# Substiruo a localização do arquivo xmldsig-core-schema.xsd conforme a localização da gem
		f.gsub('xmldsig-core-schema20020212.xsd', BrNfe.root+'/test/br_nfe/service/sc/gaspar/XSD/xmldsig-core-schema20020212.xsd' )
	end
	let(:schema) { Nokogiri::XML::Schema(xsd_text) }
	
	it { must validate_presence_of(:numero_lote_rps) }

	describe "Validações a partir do arquivo XSD" do
		it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
			subject.lote_rps = [rps_completo]

			# A porcaria do XSD está escrito errado "ContrucaoCivil"
			rps_completo.codigo_obra = nil
			rps_completo.codigo_art = nil


			document = Nokogiri::XML(subject.xml_builder)
			errors = schema.validate(document)

			errors.must_be_empty
		end
		it "Deve ser válido com 1 RPS com apenas as informações obrigatórias preenchidas" do
			subject.lote_rps = [rps_basico]

			document = Nokogiri::XML(subject.xml_builder)
			errors = schema.validate(document)

			errors.must_be_empty
		end

		it "Deve ser válido com vários RPS's - 1 rps completo e 1 parcial" do
			subject.lote_rps = [rps_completo, rps_basico]

			# A porcaria do XSD está escrito errado "ContrucaoCivil"
			rps_completo.codigo_obra = nil
			rps_completo.codigo_art = nil


			document = Nokogiri::XML(subject.xml_builder)
			errors = schema.validate(document)

			errors.must_be_empty
		end
		
	end
end