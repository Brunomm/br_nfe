require 'test_helper'

describe BrNfe::Product::Gateway::WebServiceSVRS do
	subject { FactoryGirl.build(:product_gateway_web_service_svrs) }

	it "deve herdar da class base" do
		subject.class.superclass.must_equal BrNfe::Product::Gateway::Base
	end

	describe 'STATUS SERVIÇO' do
		describe '#wsdl_status_servico' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_status_servico.must_equal 'https://nfe.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx?wsdl'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.wsdl_status_servico.must_equal 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx?wsdl'
			end
		end

		describe '#operation_status_servico' do
			it { subject.operation_status_servico.must_equal :nfe_status_servico_nf2 }
		end

		describe '#version_xml_status_servico' do
			it { subject.version_xml_status_servico.must_equal :v3_10 }
		end

		describe '#url_xmlns_status_servico' do
			it { subject.url_xmlns_status_servico.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2' }
		end		
	end
	
	
end