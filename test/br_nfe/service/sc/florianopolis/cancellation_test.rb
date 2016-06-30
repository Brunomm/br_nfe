require 'test_helper'

describe BrNfe::Service::SC::Florianopolis::Cancellation do
	subject { FactoryGirl.build(:service_sc_floripa_cancellation) }
	let(:xsd_text) do 
		f = File.read(BrNfe.root+'/test/br_nfe/service/sc/florianopolis/XSD/TiposNFSe_v2.0.xsd')
		# Substiruo a localização do arquivo xmldsig-core-schema.xsd conforme a localização da gem
		f.gsub('xmldsig-core-schema.xsd', BrNfe.root+'/test/br_nfe/service/sc/florianopolis/XSD/xmldsig-core-schema.xsd' )
	end
	let(:schema) { Nokogiri::XML::Schema(xsd_text) }

	it { must validate_presence_of(:aedf) }
	it { must validate_presence_of(:serie_number) }
	it { must validate_length_of(:motive).is_at_most(120) }
	it { must validate_numericality_of(:serie_number).only_integer.is_less_than_or_equal_to(999999).allow_nil }


	describe "Validações a partir do arquivo XSD" do
		it "O xml deve ser válido quando todas as informações possíveis estiverem preenchidas" do
			subject.assign_attributes({motive: 'Motivo'})
			document = Nokogiri::XML(subject.content_xml)
			errors = schema.validate(document)

			errors.must_be_empty
		end

		it "O xml deve ser válido quando apenas as informações obrigatórias estiverem preenchidas " do
			subject.assign_attributes({motive: nil})
			document = Nokogiri::XML(subject.content_xml)
			errors = schema.validate(document)

			errors.must_be_empty
		end
		
	end
end