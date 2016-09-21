require 'test_helper'

module ResponsePathTest
	def response_lot_number_path; :response_lot_number_path end
	def response_protocol_path; :response_protocol_path end
	def response_received_date_path; :response_received_date_path end
	def response_situation_path; :response_situation_path end
	def response_situation_key_values; {response_situation_key_values: :ok} end
	def response_cancelation_date_time_path; :response_cancelation_date_time_path end
	def response_message_errors_path; :response_message_errors_path end
	def response_message_code_key; :response_message_code_key end
	def response_message_msg_key; :response_message_msg_key end
	def response_message_solution_key; :response_message_solution_key end
	def response_invoices_path; :response_invoices_path end
	def response_invoice_numero_nf_path; :response_invoice_numero_nf_path end
	def response_invoice_codigo_verificacao_path; :response_invoice_codigo_verificacao_path end
	def response_invoice_data_emissao_path; :response_invoice_data_emissao_path end
	def response_invoice_url_nf_path; :response_invoice_url_nf_path end
	def response_invoice_rps_numero_path; :response_invoice_rps_numero_path end
	def response_invoice_rps_serie_path; :response_invoice_rps_serie_path end
	def response_invoice_rps_tipo_path; :response_invoice_rps_tipo_path end
	def response_invoice_rps_situacao_path; :response_invoice_rps_situacao_path end
	def response_invoice_rps_substituido_numero_path; :response_invoice_rps_substituido_numero_path end
	def response_invoice_rps_substituido_serie_path; :response_invoice_rps_substituido_serie_path end
	def response_invoice_rps_substituido_tipo_path; :response_invoice_rps_substituido_tipo_path end
	def response_invoice_data_emissao_rps_path; :response_invoice_data_emissao_rps_path end
	def response_invoice_competencia_path; :response_invoice_competencia_path end
	def response_invoice_natureza_operacao_path; :response_invoice_natureza_operacao_path end
	def response_invoice_regime_especial_tributacao_path; :response_invoice_regime_especial_tributacao_path end
	def response_invoice_optante_simples_nacional_path; :response_invoice_optante_simples_nacional_path end
	def response_invoice_incentivador_cultural_path; :response_invoice_incentivador_cultural_path end
	def response_invoice_outras_informacoes_path; :response_invoice_outras_informacoes_path end
	def response_invoice_item_lista_servico_path; :response_invoice_item_lista_servico_path end
	def response_invoice_cnae_code_path; :response_invoice_cnae_code_path end
	def response_invoice_description_path; :response_invoice_description_path end
	def response_invoice_codigo_municipio_path; :response_invoice_codigo_municipio_path end
	def response_invoice_total_services_path; :response_invoice_total_services_path end
	def response_invoice_deductions_path; :response_invoice_deductions_path end
	def response_invoice_valor_pis_path; :response_invoice_valor_pis_path end
	def response_invoice_valor_cofins_path; :response_invoice_valor_cofins_path end
	def response_invoice_valor_inss_path; :response_invoice_valor_inss_path end
	def response_invoice_valor_ir_path; :response_invoice_valor_ir_path end
	def response_invoice_valor_csll_path; :response_invoice_valor_csll_path end
	def response_invoice_iss_retained_path; :response_invoice_iss_retained_path end
	def response_invoice_outras_retencoes_path; :response_invoice_outras_retencoes_path end
	def response_invoice_total_iss_path; :response_invoice_total_iss_path end
	def response_invoice_base_calculation_path; :response_invoice_base_calculation_path end
	def response_invoice_iss_tax_rate_path; :response_invoice_iss_tax_rate_path end
	def response_invoice_valor_liquido_path; :response_invoice_valor_liquido_path end
	def response_invoice_desconto_condicionado_path; :response_invoice_desconto_condicionado_path end
	def response_invoice_desconto_incondicionado_path; :response_invoice_desconto_incondicionado_path end
	def response_invoice_responsavel_retencao_path; :response_invoice_responsavel_retencao_path end
	def response_invoice_numero_processo_path; :response_invoice_numero_processo_path end
	def response_invoice_municipio_incidencia_path; :response_invoice_municipio_incidencia_path end
	def response_invoice_orgao_gerador_municipio_path; :response_invoice_orgao_gerador_municipio_path end
	def response_invoice_orgao_gerador_uf_path; :response_invoice_orgao_gerador_uf_path end
	def response_invoice_cancelamento_codigo_path; :response_invoice_cancelamento_codigo_path end
	def response_invoice_cancelamento_numero_nf_path; :response_invoice_cancelamento_numero_nf_path end
	def response_invoice_cancelamento_cnpj_path; :response_invoice_cancelamento_cnpj_path end
	def response_invoice_cancelamento_municipio_path; :response_invoice_cancelamento_municipio_path end
	def response_invoice_cancelamento_data_hora_path; :response_invoice_cancelamento_data_hora_path end
	def response_invoice_nfe_substituidora_path; :response_invoice_nfe_substituidora_path end
	def response_invoice_codigo_obra_path; :response_invoice_codigo_obra_path end
	def response_invoice_codigo_art_path; :response_invoice_codigo_art_path end
	def response_invoice_cancelamento_inscricao_municipal_path; :response_invoice_cancelamento_inscricao_municipal_path end
	def response_invoice_emitente_cnpj_path; :response_invoice_emitente_cnpj_path end
	def response_invoice_emitente_inscricao_municipal_path; :response_invoice_emitente_inscricao_municipal_path end
	def response_invoice_emitente_razao_social_path; :response_invoice_emitente_razao_social_path end
	def response_invoice_emitente_nome_fantasia_path; :response_invoice_emitente_nome_fantasia_path end
	def response_invoice_emitente_telefone_path; :response_invoice_emitente_telefone_path end
	def response_invoice_emitente_email_path; :response_invoice_emitente_email_path end
	def response_invoice_emitente_endereco_logradouro_path; :response_invoice_emitente_endereco_logradouro_path end
	def response_invoice_emitente_endereco_numero_path; :response_invoice_emitente_endereco_numero_path end
	def response_invoice_emitente_endereco_complemento_path; :response_invoice_emitente_endereco_complemento_path end
	def response_invoice_emitente_endereco_bairro_path; :response_invoice_emitente_endereco_bairro_path end
	def response_invoice_emitente_endereco_codigo_municipio_path; :response_invoice_emitente_endereco_codigo_municipio_path end
	def response_invoice_emitente_endereco_uf_path; :response_invoice_emitente_endereco_uf_path end
	def response_invoice_emitente_endereco_cep_path; :response_invoice_emitente_endereco_cep_path end
	def response_invoice_destinatario_cpf_path; :response_invoice_destinatario_cpf_path end
	def response_invoice_destinatario_cnpj_path; :response_invoice_destinatario_cnpj_path end
	def response_invoice_destinatario_inscricao_municipal_path; :response_invoice_destinatario_inscricao_municipal_path end
	def response_invoice_destinatario_inscricao_estadual_path; :response_invoice_destinatario_inscricao_estadual_path end
	def response_invoice_destinatario_inscricao_suframa_path; :response_invoice_destinatario_inscricao_suframa_path end
	def response_invoice_destinatario_razao_social_path; :response_invoice_destinatario_razao_social_path end
	def response_invoice_destinatario_telefone_path; :response_invoice_destinatario_telefone_path end
	def response_invoice_destinatario_email_path; :response_invoice_destinatario_email_path end
	def response_invoice_destinatario_endereco_logradouro_path; :response_invoice_destinatario_endereco_logradouro_path end
	def response_invoice_destinatario_endereco_numero_path; :response_invoice_destinatario_endereco_numero_path end
	def response_invoice_destinatario_endereco_complemento_path; :response_invoice_destinatario_endereco_complemento_path end
	def response_invoice_destinatario_endereco_bairro_path; :response_invoice_destinatario_endereco_bairro_path end
	def response_invoice_destinatario_endereco_codigo_municipio_path; :response_invoice_destinatario_endereco_codigo_municipio_path end
	def response_invoice_destinatario_endereco_uf_path; :response_invoice_destinatario_endereco_uf_path end
	def response_invoice_destinatario_endereco_cep_path; :response_invoice_destinatario_endereco_cep_path end
end

describe BrNfe::Service::Base do
	subject { FactoryGirl.build(:br_nfe_servico_base) }

	describe "Included modules" do
		it "deve ter o module BrNfe::Service::Concerns::ValuesTs::ServiceV1 incluso" do
			subject.class.included_modules.must_include(BrNfe::Service::Concerns::ValuesTs::ServiceV1)
		end
	end
	
	describe '#xml_current_dir_path' do
		it "o valor padrão deve ser o diretorio xml de serviços na versão do layout setado" do
			subject.expects(:xml_version).returns(:version_layout)
			subject.xml_current_dir_path.must_equal(["#{BrNfe.root}/lib/br_nfe/service/xml/version_layout"])
		end
	end

	describe "#response_root_path" do
		it "deve ter um array vazio por padrão" do
			subject.response_root_path.must_equal([])
		end
	end

	describe '#nfse_xml_path' do
		it "deve retornar o caminho generico para encontrar o xml da NFS-e" do
			subject.nfse_xml_path.must_equal '//*/*/*/*'
			# Esse caminho significa: //Envelope/Body/TagRoot/NFSe
		end
	end

	describe "#body_xml_path" do
		it "deve ter um array vazio por padrão" do
			subject.body_xml_path.must_equal([])
		end
	end

	describe "#emitente" do
		class OtherClassEmitente < BrNfe::ActiveModelBase
		end
		it "deve ter incluso o module HaveEmitente" do
			subject.class.included_modules.must_include BrNfe::Association::HaveEmitente
		end
		it "o método #emitente_class deve ter por padrão a class BrNfe::Service::Emitente" do
			subject.emitente.must_be_kind_of BrNfe::Service::Emitente
			subject.send(:emitente_class).must_equal BrNfe::Service::Emitente
		end
		it "a class do emitente pode ser modificada através da configuração emitente_service_class" do
			BrNfe.emitente_service_class = OtherClassEmitente
			subject.emitente.must_be_kind_of OtherClassEmitente
			subject.send(:emitente_class).must_equal OtherClassEmitente

			# É necessário voltar a configuração original para não falhar outros testes
			BrNfe.emitente_service_class = BrNfe::Service::Emitente
		end
	end

	describe "#soap_xml" do
		it "deve trazer a tag_xml e a renderização para o soap_env concatenados" do
			subject.expects(:tag_xml).returns('<?xml?>')
			subject.expects(:render_xml).with('soap_env').returns('<Soap>value</Soap>')
			subject.soap_xml.must_equal '<?xml?><Soap>value</Soap>'
		end
		it "deve renderizar o xml com o valor original" do
			subject.stubs(:xml_builder).returns('<xml>builder</xml>')
			subject.soap_xml.must_equal '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:ins0="http://www.w3.org/2000/09/xmldsig#" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><xml>builder</xml></soapenv:Body></soapenv:Envelope>'
		end
	end

	describe "#request" do
		let(:nori) { Nori.new(:strip_namespaces => true, :convert_tags_to => lambda { |tag| tag.snakecase.to_sym }) }
		let(:soap_fault) do 
			obj = Savon::SOAPFault.new new_response, nori
			obj.stubs(:message_by_version).returns("Message Error")
			obj
		end
		let(:new_response) do
			HTTPI::Response.new 500, {}, '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns2:authenticateResponse xmlns:ns2="http://v1_0.ws.user.example.com"></ns2:authenticateResponse></soap:Body></soap:Envelope>'
		end
		let(:soap_xml) { '<Envelope><Body>XML</Body></Envelope>' } 

		before do
			subject.stubs(:wsdl).returns('http://duobr.com?wsdl')
			subject.stubs(:method_wsdl).returns(:operation)
			subject.expects(:soap_xml).returns(soap_xml)
		end

		it "deve fazer a requisição para o WS passando a resposta para o metodo set_response" do
			subject.client_wsdl.expects(:call).with(:operation, xml: soap_xml).returns(:savon_response)
			subject.expects(:set_response).returns(:result)
			subject.request.must_equal :result
			subject.instance_variable_get(:@original_response).must_equal :savon_response
		end

		it "Se ocorrer erro Savon::SOAPFault deve ser tratado e setar o status da resposta com :soap_error" do
			subject.client_wsdl.expects(:call).with(:operation, xml: soap_xml).raises(soap_fault)
			subject.expects(:set_response).never
			
			subject.request
			subject.response.error_messages.must_equal(['Message Error'])
			subject.response.status.must_equal :soap_error
		end

		it "Se ocorrer erro Savon::HTTPError deve ser tratado e setar o status da resposta com :http_error" do
			http_error = Savon::HTTPError.new(new_response)
			http_error.stubs(:to_s).returns('Message')
			
			subject.client_wsdl.expects(:call).with(:operation, xml: soap_xml).raises(http_error)
			
			subject.request
			subject.response.error_messages.must_equal(['Message'])
			subject.response.status.must_equal :http_error
		end

		it "Se ocorrer qualquer outro erro deve setar o status com :unknown_error" do
			error = RuntimeError.new('ERROU')
			
			subject.client_wsdl.expects(:call).with(:operation, xml: soap_xml).raises(error)
			
			subject.request
			subject.response.error_messages.must_equal(['ERROU'])
			subject.response.status.must_equal :unknown_error
		end
	end

	describe "#set_response" do
		let(:build_response) { BrNfe::Service::Response::Build::Base.new() } 
		it "deve instanciar o build_response e retornar a resposta" do
			build_response
			subject.class.send(:include, ResponsePathTest)
			subject.expects(:response_root_path).returns(:response_root_path)
			subject.expects(:nfse_xml_path).returns(:nfse_xml_path)
			subject.expects(:body_xml_path).returns(:body_xml_path)
			subject.expects(:response_encoding).returns('ENCODE')
			BrNfe::Service::Response::Build::Base.expects(:new).with({
				savon_response: :savon_response, 
				keys_root_path: :response_root_path,
				nfe_xml_path:   :nfse_xml_path, 
				body_xml_path:  :body_xml_path,
				xml_encode:     'ENCODE',
				lot_number_path:                         :response_lot_number_path,
				protocol_path:                           :response_protocol_path,
				received_date_path:                      :response_received_date_path,
				situation_path:                          :response_situation_path,
				situation_key_values:                    {response_situation_key_values: :ok},
				cancelation_date_time_path:              :response_cancelation_date_time_path,
				message_errors_path:                     :response_message_errors_path,
				message_code_key:                        :response_message_code_key,
				message_msg_key:                         :response_message_msg_key,
				message_solution_key:                    :response_message_solution_key,
				invoices_path:                           :response_invoices_path,
				invoice_numero_nf_path:                  :response_invoice_numero_nf_path,
				invoice_codigo_verificacao_path:         :response_invoice_codigo_verificacao_path,
				invoice_data_emissao_path:               :response_invoice_data_emissao_path,
				invoice_url_nf_path:                     :response_invoice_url_nf_path,
				invoice_rps_numero_path:                 :response_invoice_rps_numero_path,
				invoice_rps_serie_path:                  :response_invoice_rps_serie_path,
				invoice_rps_tipo_path:                   :response_invoice_rps_tipo_path,
				invoice_rps_situacao_path:               :response_invoice_rps_situacao_path,
				invoice_rps_substituido_numero_path:     :response_invoice_rps_substituido_numero_path,
				invoice_rps_substituido_serie_path:      :response_invoice_rps_substituido_serie_path,
				invoice_rps_substituido_tipo_path:       :response_invoice_rps_substituido_tipo_path,
				invoice_data_emissao_rps_path:           :response_invoice_data_emissao_rps_path,
				invoice_competencia_path:                :response_invoice_competencia_path,
				invoice_natureza_operacao_path:          :response_invoice_natureza_operacao_path,
				invoice_regime_especial_tributacao_path: :response_invoice_regime_especial_tributacao_path,
				invoice_optante_simples_nacional_path:   :response_invoice_optante_simples_nacional_path,
				invoice_incentivador_cultural_path:      :response_invoice_incentivador_cultural_path,
				invoice_outras_informacoes_path:         :response_invoice_outras_informacoes_path,
				invoice_item_lista_servico_path:         :response_invoice_item_lista_servico_path,
				invoice_cnae_code_path:                  :response_invoice_cnae_code_path,
				invoice_description_path:                :response_invoice_description_path,
				invoice_codigo_municipio_path:           :response_invoice_codigo_municipio_path,
				invoice_total_services_path:             :response_invoice_total_services_path,
				invoice_deductions_path:                 :response_invoice_deductions_path,
				invoice_valor_pis_path:                  :response_invoice_valor_pis_path,
				invoice_valor_cofins_path:               :response_invoice_valor_cofins_path,
				invoice_valor_inss_path:                 :response_invoice_valor_inss_path,
				invoice_valor_ir_path:                   :response_invoice_valor_ir_path,
				invoice_valor_csll_path:                 :response_invoice_valor_csll_path,
				invoice_iss_retained_path:               :response_invoice_iss_retained_path,
				invoice_outras_retencoes_path:           :response_invoice_outras_retencoes_path,
				invoice_total_iss_path:                  :response_invoice_total_iss_path,
				invoice_base_calculation_path:           :response_invoice_base_calculation_path,
				invoice_iss_tax_rate_path:               :response_invoice_iss_tax_rate_path,
				invoice_valor_liquido_path:              :response_invoice_valor_liquido_path,
				invoice_desconto_condicionado_path:      :response_invoice_desconto_condicionado_path,
				invoice_desconto_incondicionado_path:    :response_invoice_desconto_incondicionado_path,
				invoice_responsavel_retencao_path:       :response_invoice_responsavel_retencao_path,
				invoice_numero_processo_path:            :response_invoice_numero_processo_path,
				invoice_municipio_incidencia_path:       :response_invoice_municipio_incidencia_path,
				invoice_orgao_gerador_municipio_path:    :response_invoice_orgao_gerador_municipio_path,
				invoice_orgao_gerador_uf_path:           :response_invoice_orgao_gerador_uf_path,
				invoice_cancelamento_codigo_path:        :response_invoice_cancelamento_codigo_path,
				invoice_cancelamento_numero_nf_path:     :response_invoice_cancelamento_numero_nf_path,
				invoice_cancelamento_cnpj_path:          :response_invoice_cancelamento_cnpj_path,
				invoice_cancelamento_municipio_path:     :response_invoice_cancelamento_municipio_path,
				invoice_cancelamento_data_hora_path:     :response_invoice_cancelamento_data_hora_path,
				invoice_cancelamento_inscricao_municipal_path:       :response_invoice_cancelamento_inscricao_municipal_path,
				invoice_nfe_substituidora_path:                      :response_invoice_nfe_substituidora_path,
				invoice_codigo_obra_path:                            :response_invoice_codigo_obra_path,
				invoice_codigo_art_path:                             :response_invoice_codigo_art_path,
				invoice_emitente_cnpj_path:                          :response_invoice_emitente_cnpj_path,
				invoice_emitente_inscricao_municipal_path:           :response_invoice_emitente_inscricao_municipal_path,
				invoice_emitente_razao_social_path:                  :response_invoice_emitente_razao_social_path,
				invoice_emitente_nome_fantasia_path:                 :response_invoice_emitente_nome_fantasia_path,
				invoice_emitente_telefone_path:                      :response_invoice_emitente_telefone_path,
				invoice_emitente_email_path:                         :response_invoice_emitente_email_path,
				invoice_emitente_endereco_logradouro_path:           :response_invoice_emitente_endereco_logradouro_path,
				invoice_emitente_endereco_numero_path:               :response_invoice_emitente_endereco_numero_path,
				invoice_emitente_endereco_complemento_path:          :response_invoice_emitente_endereco_complemento_path,
				invoice_emitente_endereco_bairro_path:               :response_invoice_emitente_endereco_bairro_path,
				invoice_emitente_endereco_codigo_municipio_path:     :response_invoice_emitente_endereco_codigo_municipio_path,
				invoice_emitente_endereco_uf_path:                   :response_invoice_emitente_endereco_uf_path,
				invoice_emitente_endereco_cep_path:                  :response_invoice_emitente_endereco_cep_path,
				invoice_destinatario_cpf_path:                       :response_invoice_destinatario_cpf_path,
				invoice_destinatario_cnpj_path:                      :response_invoice_destinatario_cnpj_path,
				invoice_destinatario_inscricao_municipal_path:       :response_invoice_destinatario_inscricao_municipal_path,
				invoice_destinatario_inscricao_estadual_path:        :response_invoice_destinatario_inscricao_estadual_path,
				invoice_destinatario_inscricao_suframa_path:         :response_invoice_destinatario_inscricao_suframa_path,
				invoice_destinatario_razao_social_path:              :response_invoice_destinatario_razao_social_path,
				invoice_destinatario_telefone_path:                  :response_invoice_destinatario_telefone_path,
				invoice_destinatario_email_path:                     :response_invoice_destinatario_email_path,
				invoice_destinatario_endereco_logradouro_path:       :response_invoice_destinatario_endereco_logradouro_path,
				invoice_destinatario_endereco_numero_path:           :response_invoice_destinatario_endereco_numero_path,
				invoice_destinatario_endereco_complemento_path:      :response_invoice_destinatario_endereco_complemento_path,
				invoice_destinatario_endereco_bairro_path:           :response_invoice_destinatario_endereco_bairro_path,
				invoice_destinatario_endereco_codigo_municipio_path: :response_invoice_destinatario_endereco_codigo_municipio_path,
				invoice_destinatario_endereco_uf_path:               :response_invoice_destinatario_endereco_uf_path,
				invoice_destinatario_endereco_cep_path:              :response_invoice_destinatario_endereco_cep_path,
			}).returns(build_response)
			build_response.expects(:response).returns('resposta')

			subject.instance_variable_set(:@original_response, :savon_response)

			subject.send(:set_response).must_equal 'resposta'
			subject.instance_variable_get(:@response).must_equal('resposta')
		end
	end	
end