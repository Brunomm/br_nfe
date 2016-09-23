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


end