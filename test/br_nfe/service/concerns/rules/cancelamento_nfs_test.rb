require 'test_helper'

class RuleCancelamentoNfsTest < BrNfe::Service::Base
	include BrNfe::Service::Concerns::Rules::CancelamentoNfs
end

describe BrNfe::Service::Concerns::Rules::CancelamentoNfs do
	subject { RuleCancelamentoNfsTest.new(nfe_number: 1254, codigo_cancelamento: 1, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:service_emitente, endereco: endereco) }
	let(:endereco) { FactoryGirl.build(:endereco) } 
	
	it { must validate_presence_of(:nfe_number) }
	it { must validate_presence_of(:codigo_cancelamento) }
	it { must validate_presence_of(:codigo_ibge_municipio_prestacao) }
end