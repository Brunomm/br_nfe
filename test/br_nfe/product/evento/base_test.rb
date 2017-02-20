require 'test_helper'

describe BrNfe::Product::Evento::Base do
	subject { FactoryGirl.build(:product_evento_base) }

	describe '#aliases' do
		it { must_have_alias_attribute :Id,         :chave }
		it { must_have_alias_attribute :cOrgao,     :codigo_orgao }
		it { must_have_alias_attribute :chNFe,      :chave_nfe }
		it { must_have_alias_attribute :dhEvento,   :data_hora, Time.current }
		it { must_have_alias_attribute :tpEvento,   :codigo_evento, '1' }
		it { must_have_alias_attribute :nSeqEvento, :numero_sequencial }
	end
	
	describe "Validations" do
		describe '#chave' do
			before { subject.stubs(:generate_key) }
			it { must validate_presence_of(:chave) }
			it { must validate_length_of(:chave).is_equal_to(54) }
		end
		describe '#chave_nfe' do
			it { must validate_presence_of(:chave_nfe) }
			it { must validate_length_of(:chave_nfe).is_equal_to(44) }
		end
		describe '#data_hora' do
			it { must validate_presence_of(:data_hora) }
		end
		describe '#codigo_evento' do
			it { must validate_presence_of(:codigo_evento) }
			it { must validate_inclusion_of(:codigo_evento).in_array(%w[110111 110110 210200 210210 210220 210240 110140]) }
		end
		describe '#numero_sequencial' do
			it { must validate_numericality_of(:numero_sequencial).
				only_integer.
				is_greater_than_or_equal_to(1).
				is_less_than_or_equal_to(20)
			}
		end
	end

	describe '#chave' do
		it "se não setar um chave manualmente deve gerar a chave" do
			subject.assign_attributes(
				codigo_evento:  210220,
				chave_nfe: '35130407267118000120550000000001231939233471',
				numero_sequencial: 2
			)
			subject.chave.must_equal 'ID2102203513040726711800012055000000000123193923347102'
		end
		it "se já tiver uma chave setada não deve gerar novamente" do
			subject.chave = 'ID431701'
			subject.chave.must_equal 'ID431701'
		end
	end

	

end