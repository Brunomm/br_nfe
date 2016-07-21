require 'test_helper'

class ResponsePathsBaseTest
	include BrNfe::Service::Response::Paths::Base
end

describe BrNfe::Service::Response::Paths::Base do
	subject { ResponsePathsBaseTest.new } 

	it 'valor padrão para o método lot_number_path' do
		subject.lot_number_path.must_equal []
	end
	it 'valor padrão para o método protocol_path' do
		subject.protocol_path.must_equal []
	end
	it 'valor padrão para o método received_date_path' do
		subject.received_date_path.must_equal []
	end
	it 'valor padrão para o método situation_path' do
		subject.situation_path.must_equal []
	end
	it 'valor padrão para o método cancelation_date_time_path' do
		subject.cancelation_date_time_path.must_equal []
	end
	it 'valor padrão para o método message_errors_path' do
		subject.message_errors_path.must_equal []
	end
	it 'valor padrão para o método message_code_key' do
		subject.message_code_key.must_equal :codigo
	end
	it 'valor padrão para o método message_msg_key' do
		subject.message_msg_key.must_equal :mensagem
	end
	it 'valor padrão para o método message_solution_key' do
		subject.message_solution_key.must_equal :correcao
	end
	it 'valor padrão para o método invoices_path' do
		subject.invoices_path.must_equal []
	end
	it 'valor padrão para o método invoice_numero_nf_path' do
		subject.invoice_numero_nf_path.must_equal []
	end
	it 'valor padrão para o método invoice_codigo_verificacao_path' do
		subject.invoice_codigo_verificacao_path.must_equal []
	end
	it 'valor padrão para o método invoice_data_emissao_path' do
		subject.invoice_data_emissao_path.must_equal []
	end
	it 'valor padrão para o método invoice_url_nf_path' do
		subject.invoice_url_nf_path.must_equal []
	end
	it 'valor padrão para o método invoice_rps_numero_path' do
		subject.invoice_rps_numero_path.must_equal []
	end
	it 'valor padrão para o método invoice_rps_serie_path' do
		subject.invoice_rps_serie_path.must_equal []
	end
	it 'valor padrão para o método invoice_rps_tipo_path' do
		subject.invoice_rps_tipo_path.must_equal []
	end
	it 'valor padrão para o método invoice_rps_situacao_path' do
		subject.invoice_rps_situacao_path.must_equal []
	end
	it 'valor padrão para o método invoice_rps_substituido_numero_path' do
		subject.invoice_rps_substituido_numero_path.must_equal []
	end
	it 'valor padrão para o método invoice_rps_substituido_serie_path' do
		subject.invoice_rps_substituido_serie_path.must_equal []
	end
	it 'valor padrão para o método invoice_rps_substituido_tipo_path' do
		subject.invoice_rps_substituido_tipo_path.must_equal []
	end
	it 'valor padrão para o método invoice_data_emissao_rps_path' do
		subject.invoice_data_emissao_rps_path.must_equal []
	end
	it 'valor padrão para o método invoice_competencia_path' do
		subject.invoice_competencia_path.must_equal []
	end
	it 'valor padrão para o método invoice_outras_informacoes_path' do
		subject.invoice_outras_informacoes_path.must_equal []
	end
	it 'valor padrão para o método invoice_item_lista_servico_path' do
		subject.invoice_item_lista_servico_path.must_equal []
	end
	it 'valor padrão para o método invoice_cnae_code_path' do
		subject.invoice_cnae_code_path.must_equal []
	end
	it 'valor padrão para o método invoice_description_path' do
		subject.invoice_description_path.must_equal []
	end
	it 'valor padrão para o método invoice_codigo_municipio_path' do
		subject.invoice_codigo_municipio_path.must_equal []
	end
	it 'valor padrão para o método invoice_total_services_path' do
		subject.invoice_total_services_path.must_equal []
	end
	it 'valor padrão para o método invoice_deductions_path' do
		subject.invoice_deductions_path.must_equal []
	end
	it 'valor padrão para o método invoice_valor_pis_path' do
		subject.invoice_valor_pis_path.must_equal []
	end
	it 'valor padrão para o método invoice_valor_cofins_path' do
		subject.invoice_valor_cofins_path.must_equal []
	end
	it 'valor padrão para o método invoice_valor_inss_path' do
		subject.invoice_valor_inss_path.must_equal []
	end
	it 'valor padrão para o método invoice_valor_ir_path' do
		subject.invoice_valor_ir_path.must_equal []
	end
	it 'valor padrão para o método invoice_valor_csll_path' do
		subject.invoice_valor_csll_path.must_equal []
	end
	it 'valor padrão para o método invoice_iss_retained_path' do
		subject.invoice_iss_retained_path.must_equal []
	end
	it 'valor padrão para o método invoice_outras_retencoes_path' do
		subject.invoice_outras_retencoes_path.must_equal []
	end
	it 'valor padrão para o método invoice_total_iss_path' do
		subject.invoice_total_iss_path.must_equal []
	end
	it 'valor padrão para o método invoice_base_calculation_path' do
		subject.invoice_base_calculation_path.must_equal []
	end
	it 'valor padrão para o método invoice_iss_tax_rate_path' do
		subject.invoice_iss_tax_rate_path.must_equal []
	end
	it 'valor padrão para o método invoice_valor_liquido_path' do
		subject.invoice_valor_liquido_path.must_equal []
	end
	it 'valor padrão para o método invoice_desconto_condicionado_path' do
		subject.invoice_desconto_condicionado_path.must_equal []
	end
	it 'valor padrão para o método invoice_desconto_incondicionado_path' do
		subject.invoice_desconto_incondicionado_path.must_equal []
	end
	it 'valor padrão para o método invoice_responsavel_retencao_path' do
		subject.invoice_responsavel_retencao_path.must_equal []
	end
	it 'valor padrão para o método invoice_numero_processo_path' do
		subject.invoice_numero_processo_path.must_equal []
	end
	it 'valor padrão para o método invoice_municipio_incidencia_path' do
		subject.invoice_municipio_incidencia_path.must_equal []
	end
	it 'valor padrão para o método invoice_orgao_gerador_municipio_path' do
		subject.invoice_orgao_gerador_municipio_path.must_equal []
	end
	it 'valor padrão para o método invoice_orgao_gerador_uf_path' do
		subject.invoice_orgao_gerador_uf_path.must_equal []
	end
	it 'valor padrão para o método invoice_cancelamento_codigo_path' do
		subject.invoice_cancelamento_codigo_path.must_equal []
	end
	it 'valor padrão para o método invoice_cancelamento_numero_nf_path' do
		subject.invoice_cancelamento_numero_nf_path.must_equal []
	end
	it 'valor padrão para o método invoice_cancelamento_cnpj_path' do
		subject.invoice_cancelamento_cnpj_path.must_equal []
	end
	it 'valor padrão para o método invoice_cancelamento_municipio_path' do
		subject.invoice_cancelamento_municipio_path.must_equal []
	end
	it 'valor padrão para o método invoice_cancelamento_sucesso_path' do
		subject.invoice_cancelamento_sucesso_path.must_equal []
	end
	it 'valor padrão para o método invoice_cancelamento_data_hora_path' do
		subject.invoice_cancelamento_data_hora_path.must_equal []
	end
	it 'valor padrão para o método invoice_nfe_substituidora_path' do
		subject.invoice_nfe_substituidora_path.must_equal []
	end
	it 'valor padrão para o método invoice_codigo_obra_path' do
		subject.invoice_codigo_obra_path.must_equal []
	end
	it 'valor padrão para o método invoice_codigo_art_path' do
		subject.invoice_codigo_art_path.must_equal []
	end
	it 'valor padrão para o método invoice_cancelamento_inscricao_municipal_path' do
		subject.invoice_cancelamento_inscricao_municipal_path.must_equal []
	end
end