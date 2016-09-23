require 'test_helper'

class ResponsePathsV1TcNfseTest
	include BrNfe::Service::Response::Paths::V1::TcNfse
end

describe BrNfe::Service::Response::Paths::V1::TcNfse do
	subject { ResponsePathsV1TcNfseTest.new } 

	it 'valor padrão para o método invoice_numero_nf_path' do
		subject.response_invoice_numero_nf_path.must_equal( [:nfse, :inf_nfse, :numero] )
	end

	it 'valor padrão para o método invoice_codigo_verificacao_path' do
		subject.response_invoice_codigo_verificacao_path.must_equal( [:nfse, :inf_nfse, :codigo_verificacao] )
	end

	it 'valor padrão para o método invoice_data_emissao_path' do
		subject.response_invoice_data_emissao_path.must_equal( [:nfse, :inf_nfse, :data_emissao] )
	end

	it 'valor padrão para o método invoice_rps_numero_path' do
		subject.response_invoice_rps_numero_path.must_equal( [:nfse, :inf_nfse, :identificacao_rps, :numero] )
	end

	it 'valor padrão para o método invoice_rps_serie_path' do
		subject.response_invoice_rps_serie_path.must_equal( [:nfse, :inf_nfse, :identificacao_rps, :serie] )
	end

	it 'valor padrão para o método invoice_rps_tipo_path' do
		subject.response_invoice_rps_tipo_path.must_equal( [:nfse, :inf_nfse, :identificacao_rps, :tipo] )
	end

	it 'valor padrão para o método invoice_competencia_path' do
		subject.response_invoice_competencia_path.must_equal( [:nfse, :inf_nfse, :competencia] )
	end

	it 'valor padrão para o método invoice_outras_informacoes_path' do
		subject.response_invoice_outras_informacoes_path.must_equal( [:nfse, :inf_nfse, :outras_informacoes] )
	end

	it 'valor padrão para o método invoice_item_lista_servico_path' do
		subject.response_invoice_item_lista_servico_path.must_equal( [:nfse, :inf_nfse, :servico, :item_lista_servico] )
	end

	it 'valor padrão para o método invoice_cnae_code_path' do
		subject.response_invoice_cnae_code_path.must_equal( [:nfse, :inf_nfse, :servico, :codigo_cnae] )
	end

	it 'valor padrão para o método invoice_description_path' do
		subject.response_invoice_description_path.must_equal( [:nfse, :inf_nfse, :servico, :discriminacao] )
	end

	it 'valor padrão para o método invoice_codigo_municipio_path' do
		subject.response_invoice_codigo_municipio_path.must_equal( [:nfse, :inf_nfse, :servico, :codigo_municipio] )
	end

	it 'valor padrão para o método invoice_valor_total_servicos_path' do
		subject.response_invoice_valor_total_servicos_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :valor_servicos] )
	end

	it 'valor padrão para o método invoice_deducoes_path' do
		subject.response_invoice_deducoes_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :valor_deducoes] )
	end

	it 'valor padrão para o método invoice_valor_pis_path' do
		subject.response_invoice_valor_pis_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :valor_pis] )
	end

	it 'valor padrão para o método invoice_valor_cofins_path' do
		subject.response_invoice_valor_cofins_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :valor_cofins] )
	end

	it 'valor padrão para o método invoice_valor_inss_path' do
		subject.response_invoice_valor_inss_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :valor_inss] )
	end

	it 'valor padrão para o método invoice_valor_ir_path' do
		subject.response_invoice_valor_ir_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :valor_ir] )
	end

	it 'valor padrão para o método invoice_valor_csll_path' do
		subject.response_invoice_valor_csll_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :valor_csll] )
	end

	it 'valor padrão para o método invoice_iss_retido_path' do
		subject.response_invoice_iss_retido_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :iss_retido] )
	end

	it 'valor padrão para o método invoice_outras_retencoes_path' do
		subject.response_invoice_outras_retencoes_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :outras_retencoes] )
	end

	it 'valor padrão para o método invoice_total_iss_path' do
		subject.response_invoice_total_iss_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :valor_iss] )
	end

	it 'valor padrão para o método invoice_base_calculo_path' do
		subject.response_invoice_base_calculo_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :base_calculo] )
	end

	it 'valor padrão para o método invoice_iss_aliquota_path' do
		subject.response_invoice_iss_aliquota_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :aliquota] )
	end

	it 'valor padrão para o método invoice_valor_liquido_path' do
		subject.response_invoice_valor_liquido_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :valor_liquido_nfse] )
	end

	it 'valor padrão para o método invoice_desconto_condicionado_path' do
		subject.response_invoice_desconto_condicionado_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :desconto_condicionado] )
	end

	it 'valor padrão para o método invoice_desconto_incondicionado_path' do
		subject.response_invoice_desconto_incondicionado_path.must_equal( [:nfse, :inf_nfse, :servico, :valores, :desconto_incondicionado] )
	end

end