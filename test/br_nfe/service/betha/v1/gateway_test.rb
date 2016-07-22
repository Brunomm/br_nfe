require 'test_helper'

describe BrNfe::Service::Betha::V1::Gateway do
	subject             { FactoryGirl.build(:br_nfe_servico_betha_v1_gateway, emitente: emitente) }
	let(:rps)           { FactoryGirl.build(:br_nfe_rps, :completo) }
	let(:emitente)      { FactoryGirl.build(:emitente) }
	let(:intermediario) { FactoryGirl.build(:intermediario) }

	describe "inheritance class" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::Base }
	end

	describe "#message_namespaces" do
		it "deve ter um valor" do
			subject.message_namespaces.must_equal({"xmlns:ns1" => "http://www.betha.com.br/e-nota-contribuinte-ws"})
		end
	end

	describe "#soap_namespaces" do
		it "deve conter os namespaces padrões mais o namespace da mensagem" do
			subject.soap_namespaces.must_equal({
				'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
				'xmlns:ins0'    => 'http://www.w3.org/2000/09/xmldsig#',
				'xmlns:xsd'     => 'http://www.w3.org/2001/XMLSchema',
				'xmlns:xsi'     => 'http://www.w3.org/2001/XMLSchema-instance',
				"xmlns:ns1"     => "http://www.betha.com.br/e-nota-contribuinte-ws"
			})
		end
	end

	describe "#namespace_identifier" do
		it { subject.namespace_identifier.must_equal :ns1 }
	end

end