require 'test_helper'

describe BrNfe::Product::Evento::Cancelamento do
	subject { FactoryGirl.build(:product_evento_cancelamento) }

	describe '#default values' do
		it 'for #data_hora' do
			subject.class.new.data_hora.to_s.must_equal Time.current.in_time_zone.to_s
		end
		it 'for #numero_sequencial' do
			subject.class.new.numero_sequencial.must_equal 1
		end
		it 'for #codigo_evento' do
			subject.class.new.codigo_evento.must_equal '110111'
		end
	end

	describe '#aliases' do
		it { must_have_alias_attribute :nProt, :protocolo_nfe }
		it { must_have_alias_attribute :xJust, :justificativa }
	end
	
	describe "Validations" do
		describe '#protocolo_nfe' do
			it { must validate_presence_of(:protocolo_nfe) }
			it { must validate_length_of(:protocolo_nfe).is_equal_to(15) }
		end
		describe '#justificativa' do
			it { must validate_length_of(:justificativa).is_at_least(15).is_at_most(255) }
		end
	end
end