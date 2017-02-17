require 'test_helper'

describe BrNfe::Product::Response::Base do
	subject { FactoryGirl.build(:product_response_base) }

	describe '#aliases' do
		it { must_have_alias_attribute :tpAmb,    :environment, 2, :test }
		it { must_have_alias_attribute :verAplic, :app_version }
		it { must_have_alias_attribute :dhRecbto, :processed_at, '2016-06-06T16:00:00 -0200', Time.parse('2016-06-06T16:00:00 -02:00') }
		it { must_have_alias_attribute :nRec,     :protocol }
		it { must_have_alias_attribute :cStat,    :processing_status_code }
		it { must_have_alias_attribute :xMotivo,  :processing_status_motive }
	end

	describe '#environment' do
		it "se for setado o valor '1' deve retornar o valor :production" do
			subject.environment = 1
			subject.environment.must_equal :production
			subject.environment = '1'
			subject.environment.must_equal :production
		end
		it "se for setado qualquer outro valor diferente de '1' deve retornar o valor :test" do
			subject.environment = 2
			subject.environment.must_equal :test
			subject.environment = '2'
			subject.environment.must_equal :test
			subject.environment = 'Y'
			subject.environment.must_equal :test
		end
	end

	describe '#processed_successfully?' do
		it "deve retornar true se #processing_status for :success" do
			subject.expects(:processing_status).returns(:success)
			subject.processed_successfully?.must_equal true
		end
		it "deve retornar false se #processing_status for doferente de :success" do
			subject.expects(:processing_status).returns(:other)
			subject.processed_successfully?.must_equal false
		end
	end

	describe '#processing_status' do
		it 'Deve retornar :success se o processing_status_code estiver entre os valores da constante NFE_STATUS_SUCCESS' do
			BrNfe::Constants::NFE_STATUS_SUCCESS.each do |code|
				subject.processing_status_code = code
				subject.processing_status.must_equal :success
			end
		end
		it 'Deve retornar :processing se o processing_status_code estiver entre os valores da constante NFE_STATUS_PROCESSING' do
			BrNfe::Constants::NFE_STATUS_PROCESSING.each do |code|
				subject.processing_status_code = code
				subject.processing_status.must_equal :processing
			end
		end
		it 'Deve retornar :offline se o processing_status_code estiver entre os valores da constante NFE_STATUS_OFFLINE' do
			BrNfe::Constants::NFE_STATUS_OFFLINE.each do |code|
				subject.processing_status_code = code
				subject.processing_status.must_equal :offline
			end
		end
		it 'Deve retornar :denied se o processing_status_code estiver entre os valores da constante NFE_STATUS_DENIED' do
			BrNfe::Constants::NFE_STATUS_DENIED.each do |code|
				subject.processing_status_code = code
				subject.processing_status.must_equal :denied
			end
		end
		it "deve retornar o status :error para qualquer outro código que não esteja entre os códigos testados anteriormente" do
			subject.processing_status_code = '000'
			subject.processing_status.must_equal :error
			subject.processing_status_code = '1000'
			subject.processing_status.must_equal :error
		end
	end
end