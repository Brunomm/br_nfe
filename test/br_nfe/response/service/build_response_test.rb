require 'test_helper'

describe BrNfe::Response::Service::BuildResponse do
	subject { FactoryGirl.build(:service_build_response) }
	let(:response) { FactoryGirl.build(:response_service_default) }

	describe "#initialize" do
		it "ao inicializar deve chamar o metodo include_module! depois de setar os atributos" do
			BrNfe::Response::Service::BuildResponse.any_instance.expects(:assign_attributes).in_sequence(sequence_1)
			BrNfe::Response::Service::BuildResponse.any_instance.expects(:include_module!).in_sequence(sequence_1)
			BrNfe::Response::Service::BuildResponse.new(nfe_xml_path: 'path')
		end
	end

	describe "include_module!" do
		module RackModuleTest; end
		
		it "se tiver valor em module_methods deve incluir o module na classe" do
			subject.module_methods = RackModuleTest
			subject.class.expects(:send).with(:include, RackModuleTest)
			subject.send(:include_module!)
		end
		it "se não tiver valor em module_methods não deve tenatar incluir module na classe" do
			subject.module_methods = nil
			subject.class.expects(:send).never
			subject.send(:include_module!)
		end
	end

	describe "#response" do
		it "Deve instanciar se setar na variavel @response um objeto da classe BrNfe::Response::Service::Default" do
			response
			subject.stubs(:message_errors_path).returns('message_errors_path')
			subject.stubs(:get_message_for_path).with('message_errors_path').returns('get_message_for_path')
			subject.stubs(:get_invoices).returns('get_invoices')
			subject.stubs(:get_protocol).returns('get_protocol')
			subject.stubs(:get_received_date).returns('get_received_date')
			subject.stubs(:get_lot_number).returns('get_lot_number')
			subject.stubs(:get_situation).returns('get_situation')
			subject.stubs(:savon_response).returns(stub(xml: 'savon_response'))
			subject.stubs(:get_cancelation_date_time).returns('get_cancelation_date_time')
			BrNfe::Response::Service::Default.expects(:new).with({
				error_messages:   'get_message_for_path',
				notas_fiscais:    'get_invoices',
				protocolo:        'get_protocol',
				data_recebimento: 'get_received_date',
				numero_lote:      'get_lot_number',
				situation:        'get_situation',
				original_xml:     'savon_response',
				cancelation_date_time: 'get_cancelation_date_time'
			}).returns(response)
			subject.response.must_equal response
			subject.instance_variable_get(:@response).must_equal response
		end
		it "se já tem valor setado em @response não deve instanciar um novo" do
			subject.instance_variable_set(:@response, response)
			BrNfe::Response::Service::Default.expects(:new).never
			subject.response.must_equal response
		end
	end

	describe "#find_value_for_keys" do
		let(:var_hash) { {lvl1: {lvl2: {lvl3: 'value' } } } } 
		
		it "deve retornar o valor do hash quando encontra-lo" do
			subject.find_value_for_keys(var_hash, [:lvl1, :lvl2, :lvl3]).must_equal 'value'
		end
		it "Se as chaves não exisitrem deve retornar nil" do
			subject.find_value_for_keys(var_hash, [:lvl1, :noexist, :lvl4]).must_be_nil
		end
		it "o valor da chave não for um hash e ainda não terminar o loop não deve dar erro" do
			subject.find_value_for_keys(var_hash, [:lvl1, :lvl2, :lvl3, :lvl4]).must_be_nil
		end
		it "pode retornar um hash se o ultimo valor for Hash" do
			subject.find_value_for_keys(var_hash, [:lvl1, :lvl2]).must_equal({lvl3: 'value'})
		end
		it "se não passar apenas uma chave sem array deve retorar o valor da chave" do
			subject.find_value_for_keys(var_hash, :lvl1).must_equal({lvl2: {lvl3: 'value'}})
		end
	end

	describe "#path_with_root" do
		it "deve concatenar o array do parametro com o Array do root path" do
			subject.keys_root_path = [:root_path]
			subject.path_with_root([:child, :child2]).must_equal([:root_path, :child, :child2])
		end
		it "se o path do params estiver em branco deve retornar nil" do
			subject.keys_root_path = [:root_path]
			subject.path_with_root([]).must_be_nil
		end
	end

	describe "#get_message_for_path" do
		before do
			subject.stubs(:savon_body).returns(:savon_body)
			subject.stubs(:path_with_root).with(:msg_path).returns([:msg, :path])
		end
		it "Quando ao procurar a mensagem retornar um Hash deve buscar a msg pelo metodo get_message_for_hash" do
			subject.expects(:find_value_for_keys).with(:savon_body, [:msg, :path]).returns({message: 'ok'}).in_sequence(sequence_1)
			subject.expects(:get_message_for_hash).with({message: 'ok'}).returns("MSG")

			subject.get_message_for_path(:msg_path).must_equal ['MSG']
		end
		it "Quando ao procurar a mensagem retornar um Array deve buscar as msgs do array pelo metodo get_message_for_hash" do
			subject.expects(:find_value_for_keys).with(:savon_body, [:msg, :path]).returns([{msg: 1},{msg: 2}]).in_sequence(sequence_1)
			subject.expects(:get_message_for_hash).with({msg: 1}).returns("MSG1").in_sequence(sequence_1)
			subject.expects(:get_message_for_hash).with({msg: 2}).returns("MSG2").in_sequence(sequence_1)

			subject.get_message_for_path(:msg_path).must_equal ['MSG1','MSG2']
		end
		it "Quando ao procurar a mensagem retornar uma String deve add a string na msg" do
			subject.expects(:find_value_for_keys).with(:savon_body, [:msg, :path]).returns('MESSAGE').in_sequence(sequence_1)
			subject.expects(:get_message_for_hash).never

			subject.get_message_for_path(:msg_path).must_equal ['MESSAGE']
		end
	end

	describe "#get_message_for_hash" do
		it "deve retornar um Hash com :code, :message e :solution que devem ser encontradas no has do parametro" do
			subject.stubs(:message_code_key).returns(:codigo)
			subject.stubs(:message_msg_key).returns(:mensagem)
			subject.stubs(:message_solution_key).returns(:solucao)
			result = subject.get_message_for_hash({codigo: 'CODE', mensagem: 'Mensagem de erro', solucao: "Solução"})
			result.must_equal({
				code: 'CODE',
				message: 'Mensagem de erro',
				solution: 'Solução'
			})
		end
	end

	describe "#get_invoices" do
		before do
			subject.stubs(:savon_body).returns(:savon_body)
			subject.stubs(:invoices_path).returns([:invoice, :path])
			subject.stubs(:path_with_root).with([:invoice, :path]).returns([:inv, :path])
		end
		it "Quando ao procurar a nota fiscal retornar um Hash deve instanciar a nf pelo metodo instance_invoice" do
			subject.expects(:find_value_for_keys).with(:savon_body, [:inv, :path]).returns({invoice: 123})
			subject.expects(:instance_invoice).with({invoice: 123}).returns(:invoice)

			subject.get_invoices.must_equal [:invoice]
		end

		it "Quando ao procurar a nota fiscal retornar um Array deve instanciar as nfs pelo metodo instance_invoice" do
			subject.expects(:find_value_for_keys).with(:savon_body, [:inv, :path]).returns([{invoice: 1}, {invoice: 2}]).in_sequence(sequence_1)
			subject.expects(:instance_invoice).with({invoice: 1}).returns(:invoice1).in_sequence(sequence_1)
			subject.expects(:instance_invoice).with({invoice: 2}).returns(:invoice2).in_sequence(sequence_1)
			subject.get_invoices.must_equal [:invoice1, :invoice2]
		end

		describe "#get_protocol" do
			it "deve buscar o numero do protocolo a partir do caminho em protocol_path" do
				subject.stubs(:savon_body).returns(:savon_body)
				subject.stubs(:protocol_path).returns(:protocol_path)
				subject.stubs(:path_with_root).with(:protocol_path).returns([:path, :root])
				subject.expects(:find_value_for_keys).with(:savon_body, [:path, :root]).returns('13546')

				subject.send(:get_protocol).must_equal '13546'
			end
		end

		describe "#get_situation" do
			context "deve buscar a situação a partir do caminho em situation_path" do
				it "se encontrar a situação deve buscar formatar seu valor através do método #situation_key_values" do
					subject.stubs(:savon_body).returns(:savon_body)
					subject.stubs(:situation_path).returns(:situation_path)
					subject.stubs(:path_with_root).with(:situation_path).returns([:path, :root])
					subject.expects(:find_value_for_keys).with(:savon_body, [:path, :root]).returns('1').in_sequence(sequence_1)
					subject.expects(:situation_key_values).returns({'1'=> :v1, '2'=> :v2}).in_sequence(sequence_1)
					subject.send(:get_situation).must_equal :v1
				end
				it "se não encontrar a situação não deve buscar seu valor através do método #situation_key_values" do
					subject.stubs(:savon_body).returns(:savon_body)
					subject.stubs(:situation_path).returns(:situation_path)
					subject.stubs(:path_with_root).with(:situation_path).returns([:path, :root])
					subject.expects(:find_value_for_keys).with(:savon_body, [:path, :root]).returns('')
					subject.expects(:situation_key_values).never
					subject.send(:get_situation).must_equal ''
				end
			end
		end

		describe "#get_received_date" do
			it "deve buscar a data de recebimento a partir do caminho em received_date_path" do
				subject.stubs(:savon_body).returns(:savon_body)
				subject.stubs(:received_date_path).returns(:received_date_path)
				subject.stubs(:path_with_root).with(:received_date_path).returns([:path, :root])
				subject.expects(:find_value_for_keys).with(:savon_body, [:path, :root]).returns('1')

				subject.send(:get_received_date).must_equal '1'
			end
		end

		describe "#get_lot_number" do
			it "deve buscar o numero do lote a partir do caminho em lot_number_path" do
				subject.stubs(:savon_body).returns(:savon_body)
				subject.stubs(:lot_number_path).returns(:lot_number_path)
				subject.stubs(:path_with_root).with(:lot_number_path).returns([:path, :root])
				subject.expects(:find_value_for_keys).with(:savon_body, [:path, :root]).returns('777')

				subject.send(:get_lot_number).must_equal '777'
			end
		end

		describe "#get_cancelation_date_time" do
			it "deve buscar o numero do lote a partir do caminho em cancelation_date_time_path" do
				subject.stubs(:savon_body).returns(:savon_body)
				subject.stubs(:cancelation_date_time_path).returns(:cancelation_date_time_path)
				subject.stubs(:path_with_root).with(:cancelation_date_time_path).returns([:path, :root])
				subject.expects(:find_value_for_keys).with(:savon_body, [:path, :root]).returns('777')

				subject.send(:get_cancelation_date_time).must_equal '777'
			end
		end

		describe "#instance_invoice" do
			# Sim, sinto vergonha por ter feito um teste dessse ='(
			it "deve simplesmente instanciar um NF a partir dos métodos e busca por atrubutos via hash e XML" do
				invoice = BrNfe::Response::Service::NotaFiscal.new
				subject.stubs(:get_xml_nf).returns(:get_xml_nf)
				subject.stubs(:invoice_numero_nf_path).returns(:invoice_numero_nf_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_numero_nf_path).returns(:invoice_numero_nf_value)
				subject.stubs(:invoice_codigo_verificacao_path).returns(:invoice_codigo_verificacao_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_codigo_verificacao_path).returns(:invoice_codigo_verificacao_value)
				subject.stubs(:invoice_data_emissao_path).returns(:invoice_data_emissao_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_data_emissao_path).returns(:invoice_data_emissao_value)
				subject.stubs(:invoice_url_nf_path).returns(:invoice_url_nf_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_url_nf_path).returns(:invoice_url_nf_value)
				subject.stubs(:invoice_rps_numero_path).returns(:invoice_rps_numero_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_rps_numero_path).returns(:invoice_rps_numero_value)
				subject.stubs(:invoice_rps_serie_path).returns(:invoice_rps_serie_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_rps_serie_path).returns(:invoice_rps_serie_value)
				subject.stubs(:invoice_rps_tipo_path).returns(:invoice_rps_tipo_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_rps_tipo_path).returns(:invoice_rps_tipo_value)
				subject.stubs(:invoice_rps_situacao_path).returns(:invoice_rps_situacao_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_rps_situacao_path).returns(:invoice_rps_situacao_value)
				subject.stubs(:invoice_rps_substituido_numero_path).returns(:invoice_rps_substituido_numero_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_rps_substituido_numero_path).returns(:invoice_rps_substituido_numero_value)
				subject.stubs(:invoice_rps_substituido_serie_path).returns(:invoice_rps_substituido_serie_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_rps_substituido_serie_path).returns(:invoice_rps_substituido_serie_value)
				subject.stubs(:invoice_rps_substituido_tipo_path).returns(:invoice_rps_substituido_tipo_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_rps_substituido_tipo_path).returns(:invoice_rps_substituido_tipo_value)
				subject.stubs(:invoice_data_emissao_rps_path).returns(:invoice_data_emissao_rps_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_data_emissao_rps_path).returns(:invoice_data_emissao_rps_value)
				subject.stubs(:invoice_competencia_path).returns(:invoice_competencia_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_competencia_path).returns(:invoice_competencia_value)
				subject.stubs(:invoice_outras_informacoes_path).returns(:invoice_outras_informacoes_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_outras_informacoes_path).returns(:invoice_outras_informacoes_value)
				subject.stubs(:invoice_item_lista_servico_path).returns(:invoice_item_lista_servico_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_item_lista_servico_path).returns(:invoice_item_lista_servico_value)
				subject.stubs(:invoice_cnae_code_path).returns(:invoice_cnae_code_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_cnae_code_path).returns(:invoice_cnae_code_value)
				subject.stubs(:invoice_description_path).returns(:invoice_description_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_description_path).returns(:invoice_description_value)
				subject.stubs(:invoice_codigo_municipio_path).returns(:invoice_codigo_municipio_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_codigo_municipio_path).returns(:invoice_codigo_municipio_value)
				subject.stubs(:invoice_total_services_path).returns(:invoice_total_services_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_total_services_path).returns(:invoice_total_services_value)
				subject.stubs(:invoice_deductions_path).returns(:invoice_deductions_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_deductions_path).returns(:invoice_deductions_value)
				subject.stubs(:invoice_valor_pis_path).returns(:invoice_valor_pis_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_valor_pis_path).returns(:invoice_valor_pis_value)
				subject.stubs(:invoice_valor_cofins_path).returns(:invoice_valor_cofins_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_valor_cofins_path).returns(:invoice_valor_cofins_value)
				subject.stubs(:invoice_valor_inss_path).returns(:invoice_valor_inss_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_valor_inss_path).returns(:invoice_valor_inss_value)
				subject.stubs(:invoice_valor_ir_path).returns(:invoice_valor_ir_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_valor_ir_path).returns(:invoice_valor_ir_value)
				subject.stubs(:invoice_valor_csll_path).returns(:invoice_valor_csll_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_valor_csll_path).returns(:invoice_valor_csll_value)
				subject.stubs(:invoice_iss_retained_path).returns(:invoice_iss_retained_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_iss_retained_path).returns(:invoice_iss_retained_value)
				subject.stubs(:invoice_outras_retencoes_path).returns(:invoice_outras_retencoes_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_outras_retencoes_path).returns(:invoice_outras_retencoes_value)
				subject.stubs(:invoice_total_iss_path).returns(:invoice_total_iss_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_total_iss_path).returns(:invoice_total_iss_value)
				subject.stubs(:invoice_base_calculation_path).returns(:invoice_base_calculation_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_base_calculation_path).returns(:invoice_base_calculation_value)
				subject.stubs(:invoice_iss_tax_rate_path).returns(:invoice_iss_tax_rate_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_iss_tax_rate_path).returns(:invoice_iss_tax_rate_value)
				subject.stubs(:invoice_valor_liquido_path).returns(:invoice_valor_liquido_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_valor_liquido_path).returns(:invoice_valor_liquido_value)
				subject.stubs(:invoice_desconto_condicionado_path).returns(:invoice_desconto_condicionado_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_desconto_condicionado_path).returns(:invoice_desconto_condicionado_value)
				subject.stubs(:invoice_desconto_incondicionado_path).returns(:invoice_desconto_incondicionado_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_desconto_incondicionado_path).returns(:invoice_desconto_incondicionado_value)
				subject.stubs(:invoice_responsavel_retencao_path).returns(:invoice_responsavel_retencao_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_responsavel_retencao_path).returns(:invoice_responsavel_retencao_value)
				subject.stubs(:invoice_numero_processo_path).returns(:invoice_numero_processo_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_numero_processo_path).returns(:invoice_numero_processo_value)
				subject.stubs(:invoice_municipio_incidencia_path).returns(:invoice_municipio_incidencia_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_municipio_incidencia_path).returns(:invoice_municipio_incidencia_value)
				subject.stubs(:invoice_orgao_gerador_municipio_path).returns(:invoice_orgao_gerador_municipio_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_orgao_gerador_municipio_path).returns(:invoice_orgao_gerador_municipio_value)
				subject.stubs(:invoice_orgao_gerador_uf_path).returns(:invoice_orgao_gerador_uf_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_orgao_gerador_uf_path).returns(:invoice_orgao_gerador_uf_value)
				subject.stubs(:invoice_cancelamento_codigo_path).returns(:invoice_cancelamento_codigo_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_cancelamento_codigo_path).returns(:invoice_cancelamento_codigo_value)
				subject.stubs(:invoice_cancelamento_numero_nf_path).returns(:invoice_cancelamento_numero_nf_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_cancelamento_numero_nf_path).returns(:invoice_cancelamento_numero_nf_value)
				subject.stubs(:invoice_cancelamento_cnpj_path).returns(:invoice_cancelamento_cnpj_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_cancelamento_cnpj_path).returns(:invoice_cancelamento_cnpj_value)
				subject.stubs(:invoice_cancelamento_inscricao_municipal_path).returns(:invoice_cancelamento_inscricao_municipal_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_cancelamento_inscricao_municipal_path).returns(:invoice_cancelamento_inscricao_municipal_value)
				subject.stubs(:invoice_cancelamento_municipio_path).returns(:invoice_cancelamento_municipio_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_cancelamento_municipio_path).returns(:invoice_cancelamento_municipio_value)
				subject.stubs(:invoice_cancelamento_sucesso_path).returns(:invoice_cancelamento_sucesso_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_cancelamento_sucesso_path).returns(:invoice_cancelamento_sucesso_value)
				subject.stubs(:invoice_cancelamento_data_hora_path).returns(:invoice_cancelamento_data_hora_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_cancelamento_data_hora_path).returns(:invoice_cancelamento_data_hora_value)
				subject.stubs(:invoice_nfe_substituidora_path).returns(:invoice_nfe_substituidora_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_nfe_substituidora_path).returns(:invoice_nfe_substituidora_value)
				subject.stubs(:invoice_codigo_obra_path).returns(:invoice_codigo_obra_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_codigo_obra_path).returns(:invoice_codigo_obra_value)
				subject.stubs(:invoice_codigo_art_path).returns(:invoice_codigo_art_path)
				subject.stubs(:find_value_for_keys).with(:hash_nf, :invoice_codigo_art_path).returns(:invoice_codigo_art_value)

				BrNfe::Response::Service::NotaFiscal.expects(:new).with({
					xml_nf:                           :get_xml_nf,
					numero_nf:                        :invoice_numero_nf_value,
					codigo_verificacao:               :invoice_codigo_verificacao_value,
					data_emissao:                     :invoice_data_emissao_value,
					url_nf:                           :invoice_url_nf_value,
					rps_numero:                       :invoice_rps_numero_value,
					rps_serie:                        :invoice_rps_serie_value,
					rps_tipo:                         :invoice_rps_tipo_value,
					rps_situacao:                     :invoice_rps_situacao_value,
					rps_substituido_numero:           :invoice_rps_substituido_numero_value,
					rps_substituido_serie:            :invoice_rps_substituido_serie_value,
					rps_substituido_tipo:             :invoice_rps_substituido_tipo_value,
					data_emissao_rps:                 :invoice_data_emissao_rps_value,
					competencia:                      :invoice_competencia_value,
					outras_informacoes:               :invoice_outras_informacoes_value,
					item_lista_servico:               :invoice_item_lista_servico_value,
					cnae_code:                        :invoice_cnae_code_value,
					description:                      :invoice_description_value,
					codigo_municipio:                 :invoice_codigo_municipio_value,
					total_services:                   :invoice_total_services_value,
					deductions:                       :invoice_deductions_value,
					valor_pis:                        :invoice_valor_pis_value,
					valor_cofins:                     :invoice_valor_cofins_value,
					valor_inss:                       :invoice_valor_inss_value,
					valor_ir:                         :invoice_valor_ir_value,
					valor_csll:                       :invoice_valor_csll_value,
					iss_retained:                     :invoice_iss_retained_value,
					outras_retencoes:                 :invoice_outras_retencoes_value,
					total_iss:                        :invoice_total_iss_value,
					base_calculation:                 :invoice_base_calculation_value,
					iss_tax_rate:                     :invoice_iss_tax_rate_value,
					valor_liquido:                    :invoice_valor_liquido_value,
					desconto_condicionado:            :invoice_desconto_condicionado_value,
					desconto_incondicionado:          :invoice_desconto_incondicionado_value,
					responsavel_retencao:             :invoice_responsavel_retencao_value,
					numero_processo:                  :invoice_numero_processo_value,
					municipio_incidencia:             :invoice_municipio_incidencia_value,
					orgao_gerador_municipio:          :invoice_orgao_gerador_municipio_value,
					orgao_gerador_uf:                 :invoice_orgao_gerador_uf_value,
					cancelamento_codigo:              :invoice_cancelamento_codigo_value,
					cancelamento_numero_nf:           :invoice_cancelamento_numero_nf_value,
					cancelamento_cnpj:                :invoice_cancelamento_cnpj_value,
					cancelamento_inscricao_municipal: :invoice_cancelamento_inscricao_municipal_value,
					cancelamento_municipio:           :invoice_cancelamento_municipio_value,
					cancelamento_sucesso:             :invoice_cancelamento_sucesso_value,
					cancelamento_data_hora:           :invoice_cancelamento_data_hora_value,
					nfe_substituidora:                :invoice_nfe_substituidora_value,
					codigo_obra:                      :invoice_codigo_obra_value,
					codigo_art:                       :invoice_codigo_art_value
				}).returns(invoice)

				subject.instance_invoice(:hash_nf).must_equal invoice
			end
		end
	end

end