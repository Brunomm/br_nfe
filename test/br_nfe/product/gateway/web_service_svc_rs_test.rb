require 'test_helper'

describe BrNfe::Product::Gateway::WebServiceSvcRS do
	subject { BrNfe::Product::Gateway::WebServiceSvcRS.new(env: :test) }

	it "deve herdar da class WebServiceSVRS" do
		subject.class.superclass.must_equal BrNfe::Product::Gateway::WebServiceSVRS
	end

	describe 'STATUS SERVIÇO' do
		describe '#wsdl_status_servico' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_status_servico.must_equal 'https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx?wsdl'
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

		describe '#ssl_version_status_servico' do
			it { subject.ssl_version_status_servico.must_equal :SSLv3 }
		end
	end

	describe 'AUTORIZAÇÃO' do
		describe '#wsdl_autorizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_autorizacao.must_equal 'https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx?wsdl'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.wsdl_autorizacao.must_equal 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx?wsdl'
			end
		end

		describe '#operation_autorizacao' do
			it { subject.operation_autorizacao.must_equal :nfe_autorizacao_lote }
		end

		describe '#version_xml_autorizacao' do
			it { subject.version_xml_autorizacao.must_equal :v3_10 }
		end

		describe '#url_xmlns_autorizacao' do
			it { subject.url_xmlns_autorizacao.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao' }
		end

		describe '#ssl_version_autorizacao' do
			it { subject.ssl_version_autorizacao.must_equal :SSLv3 }
		end
	end

	describe 'RETORNO AUTORIZAÇÃO' do
		describe '#wsdl_retorno_autorizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_retorno_autorizacao.must_equal 'https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx?wsdl'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.wsdl_retorno_autorizacao.must_equal 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx?wsdl'
			end
		end

		describe '#operation_retorno_autorizacao' do
			it { subject.operation_retorno_autorizacao.must_equal :nfe_ret_autorizacao_lote }
		end

		describe '#version_xml_retorno_autorizacao' do
			it { subject.version_xml_retorno_autorizacao.must_equal :v3_10 }
		end

		describe '#url_xmlns_retorno_autorizacao' do
			it { subject.url_xmlns_retorno_autorizacao.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao' }
		end

		describe '#ssl_version_retorno_autorizacao' do
			it { subject.ssl_version_retorno_autorizacao.must_equal :SSLv3 }
		end
	end

	describe 'CONSULTA PROTOCOLO' do
		describe '#wsdl_consulta_protocolo' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_consulta_protocolo.must_equal 'https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx?wsdl'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.wsdl_consulta_protocolo.must_equal 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx?wsdl'
			end
		end

		describe '#operation_consulta_protocolo' do
			it { subject.operation_consulta_protocolo.must_equal :nfe_consulta_nf2 }
		end

		describe '#version_xml_consulta_protocolo' do
			it { subject.version_xml_consulta_protocolo.must_equal :v3_10 }
		end

		describe '#url_xmlns_consulta_protocolo' do
			it { subject.url_xmlns_consulta_protocolo.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2' }
		end

		describe '#ssl_version_consulta_protocolo' do
			it { subject.ssl_version_consulta_protocolo.must_equal :SSLv3 }
		end
	end
	
	describe 'NFE INUTILIZAÇÃO' do
		describe '#wsdl_inutilizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_inutilizacao.must_be_nil
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.wsdl_inutilizacao.must_be_nil
			end
		end

		describe '#operation_inutilizacao' do
			it { subject.operation_inutilizacao.must_be_nil }
		end

		describe '#version_xml_inutilizacao' do
			it { subject.version_xml_inutilizacao.must_be_nil }
		end

		describe '#url_xmlns_inutilizacao' do
			it { subject.url_xmlns_inutilizacao.must_be_nil }
		end

		describe '#ssl_version_inutilizacao' do
			it { subject.ssl_version_inutilizacao.must_be_nil }
		end
	end
	
	describe 'RECEPÇÃO EVENTO' do
		describe '#wsdl_recepcao_evento' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_recepcao_evento.must_equal 'https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx?wsdl'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.wsdl_recepcao_evento.must_equal 'https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx?wsdl'
			end
		end

		describe '#operation_recepcao_evento' do
			it { subject.operation_recepcao_evento.must_equal :nfe_recepcao_evento }
		end

		describe '#version_xml_recepcao_evento' do
			it { subject.version_xml_recepcao_evento.must_equal :v1_00 }
		end

		describe '#url_xmlns_recepcao_evento' do
			it { subject.url_xmlns_recepcao_evento.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento' }
		end

		describe '#ssl_version_recepcao_evento' do
			it { subject.ssl_version_recepcao_evento.must_equal :SSLv3 }
		end
	end
	
	
end