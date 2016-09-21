require 'test_helper'

describe BrNfe::Service::Response::Default do
	subject { FactoryGirl.build(:response_service_default) }


	describe "#notas_fiscais" do
		it "deve inicializar como um vetor vazio" do
			subject.class.new.notas_fiscais.must_equal []
		end

		it "posso utilizar o << para adicionar valores" do
			new_object = subject.class.new
			new_object.notas_fiscais << 'x'
			new_object.notas_fiscais << 'y'
			new_object.notas_fiscais.must_equal ['x','y']
		end

		it "sempre retorna um array" do
			subject.notas_fiscais = {valor: '2'}
			subject.notas_fiscais.must_equal [{valor: '2'}]
		end
	end

	describe "#error_messages" do
		it "deve inicializar como um vetor vazio" do
			subject.class.new.error_messages.must_equal []
		end

		it "posso utilizar o << para adicionar valores" do
			new_object = subject.class.new
			new_object.error_messages << 'aaa'
			new_object.error_messages << 'bbbbb'
			new_object.error_messages.must_equal ['aaa','bbbbb']
		end

		it "sempre retorna um array" do
			subject.error_messages = {valor: '2'}
			subject.error_messages.must_equal [{valor: '2'}]
		end
	end

	describe "#success?" do
		it "quando o status for igual a success deve retornar true" do
			subject.status = :success
			subject.success?.must_equal true
		end

		it "quando o status for diferente a success deve retornar false" do
			subject.status = :other
			subject.success?.must_equal false
		end
	end

	describe "#status" do
		it "se não houver valor na variável @status deve buscar e setar o valor em get_status" do
			subject.status = nil
			subject.expects(:get_status).returns(:new_status)

			subject.status.must_equal :new_status
			subject.instance_variable_get(:@status).must_equal :new_status
		end
		it "se houver valor na variável @status não deve buscar o valor em get_status" do
			subject.status = :other_status
			subject.expects(:get_status).never

			subject.status.must_equal :other_status
			subject.instance_variable_get(:@status).must_equal :other_status
		end
	end

	describe "#get_status" do
		it "se tiver alguma mensagem de erro deve retornar o status :falied" do
			subject.error_messages << 'Message'
			subject.get_status.must_equal :falied
		end
		it "se não tiver nenhuma mensagem de erro deve retornar o status :success" do
			subject.error_messages = []
			subject.get_status.must_equal :success
		end
	end

	describe "#unsuccessful_request?" do
		it "deve retornar true se o status for :soap_error" do
			subject.status = :soap_error
			subject.unsuccessful_request?.must_equal true
		end
		it "deve retornar true se o status for :http_error" do
			subject.status = :http_error
			subject.unsuccessful_request?.must_equal true
		end
		it "deve retornar true se o status for :unknown_error" do
			subject.status = :unknown_error
			subject.unsuccessful_request?.must_equal true
		end
		it "deve retornar false se o status for :success" do
			subject.status = :success
			subject.unsuccessful_request?.must_equal false
		end
		it "deve retornar false se o status for :falied" do
			subject.status = :falied
			subject.unsuccessful_request?.must_equal false
		end
	end

	describe "#successful_request?" do
		it "se unsuccessful_request? for false então deve retornar true" do
			subject.expects(:unsuccessful_request?).returns(false)
			subject.successful_request?.must_equal true
		end
		it "se unsuccessful_request? for true então deve retornar false" do
			subject.expects(:unsuccessful_request?).returns(true)
			subject.successful_request?.must_equal false
		end
	end

	describe "#message_codes" do
		it "deve retornar os códigos das mensagens de erro no formato de string" do
			subject.expects(:error_messages).returns([
				{code: 'CODE1', message: 'msg', solution: :solut},
				{code: :CODE2, message: 'msg', solution: :solut},
				{code: 3, message: 'msg', solution: :solut},
				'Mensage string'
			])
			subject.message_codes.must_equal(['CODE1', 'CODE2', '3'])
		end
		it "se não houver mensagem de erro retorna um array vazio" do
			subject.message_codes.must_equal([])
		end
		it "se a mensagem de erro for apenas strings deve retornar um array vazio" do
			subject.expects(:error_messages).returns(['str1','str2'])
			subject.message_codes.must_equal([])
		end
	end

	describe 'array de erros que correspondem a determinadas situações do estado do RPS' do
		describe '#situation_unreceived_code_errors' do
			let(:default_codes) { ['E4'] } 
			it 'por padrão deve retornar os codigos padrões correspondente a sutiação unreceived' do
				subject.situation_unreceived_code_errors.must_equal( default_codes )
			end
			it 'ao setar um valor deve acrescentar o valor padrão e não sobrescrever' do
				subject.situation_unreceived_code_errors = [['code2','code3'],'code4']
				subject.situation_unreceived_code_errors.must_equal( ['code2','code3','code4']+default_codes )
			end
		end

		describe '#situation_unprocessed_code_errors' do
			let(:default_codes) { ['E92'] } 
			it 'por padrão deve retornar os codigos padrões correspondente a sutiação unprocessed' do
				subject.situation_unprocessed_code_errors.must_equal( default_codes )
			end
			it 'ao setar um valor deve acrescentar o valor padrão e não sobrescrever' do
				subject.situation_unprocessed_code_errors = [['code2','code3'],'code4']
				subject.situation_unprocessed_code_errors.must_equal( ['code2','code3','code4']+default_codes )
			end
		end

		describe '#situation_success_code_errors' do
			let(:default_codes) { [] } 
			it 'por padrão deve retornar os codigos padrões correspondente a sutiação success' do
				subject.situation_success_code_errors.must_equal( default_codes )
			end
			it 'ao setar um valor deve acrescentar o valor padrão e não sobrescrever' do
				subject.situation_success_code_errors = [['code2','code3'],'code4']
				subject.situation_success_code_errors.must_equal( ['code2','code3','code4']+default_codes )
			end
		end
	end

	describe '#get_situation_by_message_codes' do
		before do
			subject.stubs(:message_codes).returns(['ERR1','ERR2'])
		end
		it "deve retornar :unreceived se alguma mensagem de erro estiver entre as mensagens do metodo situation_unreceived_code_errors" do
			subject.situation_unreceived_code_errors = 'ERR1'
			subject.get_situation_by_message_codes.must_equal :unreceived
		end
		it "deve retornar :unprocessed se alguma mensagem de erro estiver entre as mensagens do metodo situation_unprocessed_code_errors" do
			subject.situation_unprocessed_code_errors = 'ERR1'
			subject.get_situation_by_message_codes.must_equal :unprocessed
		end
		it "deve retornar :success se alguma mensagem de erro estiver entre as mensagens do metodo situation_success_code_errors" do
			subject.situation_success_code_errors = 'ERR1'
			subject.get_situation_by_message_codes.must_equal :success
		end
		it "deve retornar :error se o codigo não estiver presente em nenhum dos metodos com os codigos padrões" do
			subject.get_situation_by_message_codes.must_equal :error
		end
		it "se não houver nenhuma mensagem de erro deve retornar nil" do
			subject.unstub(:message_codes)
			subject.get_situation_by_message_codes.must_be_nil
		end
	end

	describe '#situation' do
		it "se não houver setado uma situação e tiver alguma mensagem de erro deve buscar o valor da situação no metodo #get_situation_by_message_codes" do
			subject.situation = nil
			subject.stubs(:error_messages).returns(['a error'])
			subject.expects(:get_situation_by_message_codes).returns(:sit)
			subject.situation.must_equal :sit
			subject.instance_variable_get(:@situation).must_equal :sit
		end
		it "se não houver setado uma situação e também não tiver mensagem de erro deve retornar nil" do
			subject.situation = nil
			subject.stubs(:error_messages).returns([])
			subject.expects(:get_situation_by_message_codes).never
			subject.situation.must_be_nil
		end
		it "mesmo com mensagem de erro se tiver algum valor na situação não deve tentar buscar a situação pelos codigos de erros" do
			subject.situation = :some_value
			subject.stubs(:error_messages).returns(['a error'])
			subject.expects(:get_situation_by_message_codes).never
			subject.situation.must_equal :some_value
		end
	end

end