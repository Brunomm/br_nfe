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

		# O método instance invoice e demais são testados dando o build no XML das NFSs
	end

end