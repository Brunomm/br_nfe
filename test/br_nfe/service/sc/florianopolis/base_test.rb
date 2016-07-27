require 'test_helper'

describe BrNfe::Service::SC::Florianopolis::Base do
	subject { FactoryGirl.build(:service_sc_floripa_base) }

	it { must validate_presence_of(:aedf) }
	it { must validate_length_of(:aedf).is_at_most(7) }
	it { must validate_numericality_of(:aedf).only_integer.is_greater_than_or_equal_to(100000).is_less_than_or_equal_to(9999999).allow_nil }

	it "a request deve estar nil pois florianopolis não tem webservice" do
		subject.request.must_be_nil
	end

	describe "#content_xml" do
		it "deve concatenar o valro do metodo xml_builder com o cabeçalho padrão para XML" do
			subject.expects(:xml_builder).returns("<XMLBuilder>Value<XMLBuilder>")
			subject.content_xml.must_equal '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><XMLBuilder>Value<XMLBuilder>'
		end
	end
end