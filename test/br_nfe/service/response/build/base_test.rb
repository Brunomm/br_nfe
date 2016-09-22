require 'test_helper'

describe BrNfe::Service::Response::Build::Base do
	subject { FactoryGirl.build(:service_build_response) }
	let(:response) { FactoryGirl.build(:response_service_default) }

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



end