require 'test_helper'

describe BrNfe::Service::MG::BeloHorizonte::V1::Base do
	subject        { FactoryGirl.build(:br_nfe_service_mg_bh_v1_base, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:service_emitente)   }
	
	it "Deve herdar de BrNfe::Service::Base" do
		subject.class.superclass.must_equal BrNfe::Service::Base
	end
	it "Certificado deve ser obrigatório" do
		subject.certificado_obrigatorio?.must_equal true
	end
	it '#ssl_request? deve ser true' do
		subject.ssl_request?.must_equal true
	end
	describe '#wsdl' do
		it "deve setar a url correta quando o env for em modo de produção" do
			subject.env = :production
			subject.wsdl.must_equal 'https://bhissdigital.pbh.gov.br/bhiss-ws/nfse?wsdl'
		end
		it "deve setar a url correta quando o env for em modo de homologação" do
			subject.env = :test
			subject.wsdl.must_equal 'https://bhisshomologa.pbh.gov.br/bhiss-ws/nfse?wsdl'
		end
	end

	describe '#soap_body_root_tag' do
		it "por padrão deve dar um raise avisando que deve ser sobrescrito" do
			assert_raises RuntimeError do
				subject.soap_body_root_tag
			end
		end
	end

	it "As tags ID deve ter apenas o I maiusculo" do
		subject.tag_id.must_equal :Id
	end

	it "o método #content_xml deve conter a estrutura definida no manual" do
		skip "\n\n ----->>>  Testar depois com dados reais <<<-----\n\n"
		subject.expects(:soap_body_root_tag).twice.returns('RootTag')
		subject.expects(:xml_builder).returns('<XmlBuilder>content</XmlBuilder>')
		expected_return = '<ns2:RootTag xmlns:ns2="http://ws.bhiss.pbh.gov.br">' +
		                  	'<nfseCabecMsg>' + 
		                  		'<?xml version="1.0" encoding="UTF-8"?>' + 
		                  		'<cabecalho xmlns="http://www.abrasf.org.br/nfse.xsd" versao="0.01">' + 
		                  			'<versaoDados>1.00</versaoDados>' + 
		                  		'</cabecalho>' + 
		                  	'</nfseCabecMsg>' + 
		                  	'<nfseDadosMsg>' + 
		                  		'<?xml version="1.0" encoding="UTF-8"?>' + 
		                  		'<XmlBuilder>content</XmlBuilder>' + 
		                  	'</nfseDadosMsg>' + 
		                  '</ns2:RootTag>'
		subject.content_xml.must_equal expected_return
	end
end