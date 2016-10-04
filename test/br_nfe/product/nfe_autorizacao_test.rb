require 'test_helper'

describe BrNfe::Product::NfeAutorizacao do
	subject { FactoryGirl.build(:product_nfe_autorizacao) }
	let(:gateway) { FactoryGirl.build(:product_gateway_web_service_svrs) }
	let(:nota_fiscal) { FactoryGirl.build(:product_nota_fiscal) } 

	before do
		subject.stubs(:gateway).returns(gateway)
	end

	context 'validations' do
		describe '#notas_fiscais' do
			it 'Deve ter no mínimo 1 e no máximo 50 notas fiscais' do 
				# Como só aceita objetos de NotaFiscal então sobrescrevo o método
				# para setar os valores em `notas_fiscais`
				class Shoulda::Matchers::ActiveModel::ValidateLengthOfMatcher
					def string_of_length(length)
						[BrNfe::Product::NotaFiscal.new] * length
					end
				end
				
				must validate_length_of(:notas_fiscais).is_at_most(50).is_at_least(1) 
				
				# Volto a alteração que fiz no método para outros testes
				# Funcionarem adequadamente
				class Shoulda::Matchers::ActiveModel::ValidateLengthOfMatcher
					def string_of_length(length)
						'x' * length
					end
				end
			end

			it "Se tiver mais que 1 NF-e e pelo menos 1 delas não for válida deve adiiconar o erro da NF no objeto" do
				nota_fiscal.stubs(:valid?).returns(true)
				nf2 = FactoryGirl.build(:product_nota_fiscal, numero_nf: 356)
				nf2.errors.add(:base, 'Erro da Nota fiscal')
				nf2.stubs(:valid?).returns(false)
				subject.notas_fiscais = [nota_fiscal, nf2]

				must_be_message_error :base, :invalid_invoice, {number: 356, nf_message: 'Erro da Nota fiscal'}
			end

		end

	end
	
	it 'o método #url_xmlns deve pegar o valor do método url_xmlns_autorizacao do gateway ' do
		gateway.expects(:url_xmlns_autorizacao).returns('http://teste.url_xmlns_autorizacao.com')
		subject.url_xmlns.must_equal 'http://teste.url_xmlns_autorizacao.com'
	end

	it 'o método #wsdl deve pegar o valor do método wsdl_autorizacao do gateway ' do
		gateway.expects(:wsdl_autorizacao).returns('http://teste.wsdl_autorizacao.com')
		subject.wsdl.must_equal 'http://teste.wsdl_autorizacao.com'
	end

	it 'o método #method_wsdl deve pegar o valor do método operation_autorizacao do gateway ' do
		gateway.expects(:operation_autorizacao).returns(:operation_autorizacao)
		subject.method_wsdl.must_equal :operation_autorizacao
	end

	it 'o método #gateway_xml_version deve pegar o valor do método version_xml_autorizacao do gateway ' do
		gateway.expects(:version_xml_autorizacao).returns(:v3_20)
		subject.gateway_xml_version.must_equal :v3_20
	end

	describe '#notas_fiscais' do
		it "deve inicializar o objeto com um Array" do
			subject.class.new.instance_variable_get(:@notas_fiscais).must_be_kind_of Array
		end
		it "deve aceitar apenas objetos da class Hash ou NotaFiscal" do
			nf_hash = {serie: 1, numero_nf: 1146}
			subject.notas_fiscais = [nota_fiscal, 1, 'string', nil, {}, [], :symbol, nf_hash, true]
			subject.notas_fiscais.size.must_equal 2
			subject.notas_fiscais[0].must_equal nota_fiscal

			subject.notas_fiscais[1].serie.must_equal 1
			subject.notas_fiscais[1].numero_nf.must_equal 1146
		end
		it "posso adicionar notas fiscais  com <<" do
			new_object = subject.class.new
			new_object.notas_fiscais << nota_fiscal
			new_object.notas_fiscais << 1
			new_object.notas_fiscais << nil
			new_object.notas_fiscais << {serie: 500, numero_nf: 223}
			new_object.notas_fiscais << {serie: 700, numero_nf: 800}

			new_object.notas_fiscais.size.must_equal 3
			new_object.notas_fiscais[0].must_equal nota_fiscal

			new_object.notas_fiscais[1].serie.must_equal 500
			new_object.notas_fiscais[1].numero_nf.must_equal 223
			new_object.notas_fiscais[2].serie.must_equal 700
			new_object.notas_fiscais[2].numero_nf.must_equal 800
		end
	end

	# describe '#xml_builder' do
	# 	it "deve renderizar para o xml nfe_autorizacao" do
	# 		subject.expects(:render_xml).with('nfe_autorizacao').returns('<ok>1</ok>')
	# 		subject.xml_builder.must_equal '<ok>1</ok>'
	# 	end
	# end

	# describe "Validação do XML através do XSD" do		
	# 	let(:schemas_dir) { BrNfe.root+'/lib/br_nfe/product/xml/v3_10/XSD' }		
	# 	def validate_schema
	# 		subject.stubs(:certificate).returns(nil)			
	# 		Dir.chdir(schemas_dir) do
	# 			schema = Nokogiri::XML::Schema(IO.read('consStatServ_v3.10.xsd'))
	# 			document = Nokogiri::XML(subject.xml_builder)
	# 			errors = schema.validate(document)
	# 			errors.must_be_empty
	# 		end
	# 	end
	# 	it "Deve ser válido em ambiente de produção" do
	# 		subject.env = :production
	# 		validate_schema
	# 	end
	# 	it "Deve ser válido em ambiente de homologação" do
	# 		subject.env = :test
	# 		validate_schema
	# 	end
	# end

end