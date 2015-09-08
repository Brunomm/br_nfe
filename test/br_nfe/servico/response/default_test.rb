require 'test_helper'

describe BrNfe::Servico::Response::Default do
	subject { FactoryGirl.build(:response_default) }

	describe "#success?" do
		it "when is true" do
			subject.success = true
			subject.success?.must_equal true
		end

		it "when is false" do
			subject.success = false
			subject.success?.must_equal false
		end
	end

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

end