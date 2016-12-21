require 'test_helper'

describe BrNfe::Product::Gateway::WebServiceSP do
	subject { BrNfe::Product::Gateway::WebServiceSP.new(env: :test) }

	it "deve herdar da class base" do
		subject.class.superclass.must_equal BrNfe::Product::Gateway::Base
	end

	describe 'STATUS SERVIÇO' do
		describe '#wsdl_status_servico' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_status_servico.must_equal 'https://nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx?wsdl'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.wsdl_status_servico.must_equal 'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx?wsdl'
			end
		end

		describe '#operation_status_servico' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.operation_status_servico.must_equal :nfe_status_servico_nf2
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.operation_status_servico.must_equal :nfe_status_servico_nf2
			end
		end

		describe '#version_xml_status_servico' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.version_xml_status_servico.must_equal :v3_10
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.version_xml_status_servico.must_equal :v3_10
			end
		end

		describe '#url_xmlns_status_servico' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.url_xmlns_status_servico.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.url_xmlns_status_servico.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2'
			end
		end

		describe '#ssl_version_status_servico' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.ssl_version_status_servico.must_equal :TLSv1
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.ssl_version_status_servico.must_equal :TLSv1
			end
		end
	end

	describe 'AUTORIZAÇÃO' do
		describe '#wsdl_autorizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_autorizacao.must_equal 'https://nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx?wsdl'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.wsdl_autorizacao.must_equal 'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx?wsdl'
			end
		end

		describe '#operation_autorizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.operation_autorizacao.must_equal :nfe_autorizacao_lote
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.operation_autorizacao.must_equal :nfe_autorizacao_lote
			end
		end

		describe '#version_xml_autorizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.version_xml_autorizacao.must_equal :v3_10
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.version_xml_autorizacao.must_equal :v3_10
			end
		end

		describe '#url_xmlns_autorizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.url_xmlns_autorizacao.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.url_xmlns_autorizacao.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao'
			end
		end

		describe '#ssl_version_autorizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.ssl_version_autorizacao.must_equal :SSLv3
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.ssl_version_autorizacao.must_equal :TLSv1
			end
		end
	end

	describe 'RETORNO AUTORIZAÇÃO' do
		describe '#wsdl_retorno_autorizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_retorno_autorizacao.must_equal 'https://nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx?wsdl'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.wsdl_retorno_autorizacao.must_equal 'https://homologacao.nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx?wsdl'
			end
		end

		describe '#operation_retorno_autorizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.operation_retorno_autorizacao.must_equal :nfe_ret_autorizacao_lote
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.operation_retorno_autorizacao.must_equal :nfe_ret_autorizacao_lote
			end
		end

		describe '#version_xml_retorno_autorizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.version_xml_retorno_autorizacao.must_equal :v3_10
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.version_xml_retorno_autorizacao.must_equal :v3_10
			end
		end

		describe '#url_xmlns_retorno_autorizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.url_xmlns_retorno_autorizacao.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.url_xmlns_retorno_autorizacao.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao'
			end
		end

		describe '#ssl_version_retorno_autorizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.ssl_version_retorno_autorizacao.must_equal :SSLv3
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.ssl_version_retorno_autorizacao.must_equal :TLSv1
			end
		end
	end

	describe 'CONSULTA PROTOCOLO' do
		describe '#wsdl_consulta_protocolo' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_consulta_protocolo.must_equal 'https://nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx?wsdl'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.wsdl_consulta_protocolo.must_equal 'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx?wsdl'
			end
		end

		describe '#operation_consulta_protocolo' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.operation_consulta_protocolo.must_equal :nfe_consulta_nf2
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.operation_consulta_protocolo.must_equal :nfe_consulta_nf2
			end
		end

		describe '#version_xml_consulta_protocolo' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.version_xml_consulta_protocolo.must_equal :v3_10
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.version_xml_consulta_protocolo.must_equal :v3_10
			end
		end

		describe '#url_xmlns_consulta_protocolo' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.url_xmlns_consulta_protocolo.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.url_xmlns_consulta_protocolo.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2'
			end
		end

		describe '#ssl_version_consulta_protocolo' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.ssl_version_consulta_protocolo.must_equal :SSLv3
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.ssl_version_consulta_protocolo.must_equal :TLSv1
			end
		end
	end
	
	describe 'NFE INUTILIZAÇÃO' do
		describe '#wsdl_inutilizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_inutilizacao.must_equal 'https://nfe.fazenda.sp.gov.br/ws/nfeinutilizacao2.asmx?wsdl'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.wsdl_inutilizacao.must_equal 'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao2.asmx?wsdl'
			end
		end

		describe '#operation_inutilizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.operation_inutilizacao.must_equal :nfe_inutilizacao_nf2
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.operation_inutilizacao.must_equal :nfe_inutilizacao_nf2
			end
		end

		describe '#version_xml_inutilizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.version_xml_inutilizacao.must_equal :v3_10
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.version_xml_inutilizacao.must_equal :v3_10
			end
		end

		describe '#url_xmlns_inutilizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.url_xmlns_inutilizacao.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao2'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.url_xmlns_inutilizacao.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao2'
			end
		end

		describe '#ssl_version_inutilizacao' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.ssl_version_inutilizacao.must_equal :SSLv3
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.ssl_version_inutilizacao.must_equal :TLSv1
			end
		end
	end
	
	describe 'RECEPÇÃO EVENTO' do
		describe '#wsdl_recepcao_evento' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_recepcao_evento.must_equal 'https://nfe.fazenda.sp.gov.br/ws/recepcaoevento.asmx?wsdl'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.wsdl_recepcao_evento.must_equal 'https://homologacao.nfe.fazenda.sp.gov.br/ws/recepcaoevento.asmx?wsdl'
			end
		end

		describe '#operation_recepcao_evento' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.operation_recepcao_evento.must_equal :nfe_recepcao_evento
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.operation_recepcao_evento.must_equal :nfe_recepcao_evento
			end
		end

		describe '#version_xml_recepcao_evento' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.version_xml_recepcao_evento.must_equal :v1_00
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.version_xml_recepcao_evento.must_equal :v1_00
			end
		end

		describe '#url_xmlns_recepcao_evento' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.url_xmlns_recepcao_evento.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.url_xmlns_recepcao_evento.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento'
			end
		end

		describe '#ssl_version_recepcao_evento' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.ssl_version_recepcao_evento.must_equal :SSLv3
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.ssl_version_recepcao_evento.must_equal :TLSv1
			end
		end
	end

	describe 'DOWNLOAD NF' do
		describe '#wsdl_download_nf' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.wsdl_download_nf.must_equal 'https://www.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx?wsdl'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.wsdl_download_nf.must_equal 'https://hom.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx?wsdl'
			end
		end

		describe '#operation_download_nf' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.operation_download_nf.must_equal :nfe_download_nf
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.operation_download_nf.must_equal :nfe_download_nf
			end
		end

		describe '#version_xml_download_nf' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.version_xml_download_nf.must_equal :v1_00
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.version_xml_download_nf.must_equal :v1_00
			end
		end

		describe '#url_xmlns_download_nf' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.url_xmlns_download_nf.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeDownloadNF'
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.url_xmlns_download_nf.must_equal 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeDownloadNF'
			end
		end

		describe '#ssl_version_download_nf' do
			it "para ambiente de produção" do
				subject.env = :production
				subject.ssl_version_download_nf.must_equal :TLSv1
			end
			it "para ambiente de homologação" do
				subject.env = :test
				subject.ssl_version_download_nf.must_equal :TLSv1
			end
		end
	end
end