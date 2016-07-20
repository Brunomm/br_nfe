require 'test_helper'

describe BrNfe::Response::Service::Default do
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

end