require 'test_helper'
require 'br_nfe/helper/have_address_test.rb'

describe BrNfe::Emitente do
	subject { FactoryGirl.build(:emitente, endereco: endereco) }
	let(:endereco) { FactoryGirl.build(:endereco) } 
	
	describe "#endereco" do
		include BrNfeTest::HelperTest::HaveAddressTest
	end

end