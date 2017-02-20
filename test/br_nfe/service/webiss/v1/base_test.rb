require 'test_helper'

describe BrNfe::Service::Webiss::V1::Base do
	subject             { FactoryGirl.build(:service_webiss_v1_base, emitente: emitente) }
	let(:rps)           { FactoryGirl.build(:br_nfe_rps, :completo) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }
	let(:intermediario) { FactoryGirl.build(:intermediario) }

	describe "inheritance class" do
		it { subject.class.superclass.must_equal BrNfe::Service::Base }
	end

	describe "#wsdl" do
		before do
			subject.env = :production
		end

	# BA :
		# Brumado-BA
		it "se codigo da cidade emitente for 2904605 então deve pagar a URL de Brumado-BA" do
			subject.ibge_code_of_issuer_city = '2904605'
			subject.wsdl.must_equal 'https://www7.webiss.com.br/brumadoba_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '2904605'
			subject.env = :test
			subject.wsdl.must_equal 'https://www7.webiss.com.br/brumadoba_wsnfse_homolog/nfseServices.svc?wsdl'
		end

		# Candeias-BA
		it "se codigo da cidade emitente for 2906501 então deve pagar a URL de Candeias-BA" do
			subject.ibge_code_of_issuer_city = '2906501'
			subject.wsdl.must_equal 'https://www4.webiss.com.br/candeiasba_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '2906501'
			subject.env = :test
			subject.wsdl.must_equal 'https://www4.webiss.com.br/candeiasba_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# Feira de Santana-BA
		it "se codigo da cidade emitente for 2910800 então deve pagar a URL de Feira de Santana-BA" do
			subject.ibge_code_of_issuer_city = '2910800'
			subject.wsdl.must_equal 'https://feiradesantanaba.webiss.com.br/servicos/wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '2910800'
			subject.env = :test
			subject.wsdl.must_equal 'https://feiradesantanaba.webiss.com.br/servicos/wsnfse_homolog/nfseServices.svc?wsdl'
		end

		# Guanambi-BA
		it "se codigo da cidade emitente for 2911709 então deve pagar a URL de Guanambi-BA" do
			subject.ibge_code_of_issuer_city = '2911709'
			subject.wsdl.must_equal 'https://www4.webiss.com.br/guanambiba_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '2911709'
			subject.env = :test
			subject.wsdl.must_equal 'https://www4.webiss.com.br/guanambiba_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# Itapetinga-BA
		it "se codigo da cidade emitente for 2916401 então deve pagar a URL de Itapetinga-BA" do
			subject.ibge_code_of_issuer_city = '2916401'
			subject.wsdl.must_equal 'https://www5.webiss.com.br/itapetingaba_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '2916401'
			subject.env = :test
			subject.wsdl.must_equal 'https://www5.webiss.com.br/itapetingaba_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# Luis Eduardo Magalhães-BA
		it "se codigo da cidade emitente for 2919553 então deve pagar a URL de Luis Eduardo Magalhães-BA" do
			subject.ibge_code_of_issuer_city = '2919553'
			subject.wsdl.must_equal 'https://www4.webiss.com.br/luiseduardomagalhaesba_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '2919553'
			subject.env = :test
			subject.wsdl.must_equal 'https://www4.webiss.com.br/luiseduardomagalhaesba_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# Vitória da Conquista-BA
		it "se codigo da cidade emitente for 2933307 então deve pagar a URL de Vitória da Conquista-BA" do
			subject.ibge_code_of_issuer_city = '2933307'
			subject.wsdl.must_equal 'https://www4.webiss.com.br/vitoriadaconquistaba_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '2933307'
			subject.env = :test
			subject.wsdl.must_equal 'https://www4.webiss.com.br/vitoriadaconquistaba_wsnfse_homolog/NfseServices.svc?wsdl'
		end

	# GO :
		# Caldas Novas-MG
		it "se codigo da cidade emitente for 5204508 então deve pagar a URL de Caldas Novas-GO" do
			subject.ibge_code_of_issuer_city = '5204508'
			subject.wsdl.must_equal 'https://www3.webiss.com.br/caldasnovasgo_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '5204508'
			subject.env = :test
			subject.wsdl.must_equal 'https://www3.webiss.com.br/caldasnovasgo_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# Planaltina-GO
		it "se codigo da cidade emitente for 5217609 então deve pagar a URL de Planaltina-GO" do
			subject.ibge_code_of_issuer_city = '5217609'
			subject.wsdl.must_equal 'https://www.webiss.com.br/planaltinago_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '5217609'
			subject.env = :test
			subject.wsdl.must_equal 'https://www.webiss.com.br/planaltinago_wsnfse_homolog/nfseServices.svc?wsdl'
		end

	# MG :
		# Além Paraiba-MG
		it "se codigo da cidade emitente for 3101508 então deve pagar a URL de Além Paraiba-MG" do
			subject.ibge_code_of_issuer_city = '3101508'
			subject.wsdl.must_equal 'https://www4.webiss.com.br/alemparaibamg_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3101508'
			subject.env = :test
			subject.wsdl.must_equal 'https://www4.webiss.com.br/alemparaibamg_wsnfse_homolog/NfseServices.svc?wsdl'
		end
		# Arcos-MG
		it "se codigo da cidade emitente for 3104205 então deve pagar a URL de Arcos-MG" do
			subject.ibge_code_of_issuer_city = '3104205'
			subject.wsdl.must_equal 'https://www1.webiss.com.br/arcosmg_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3104205'
			subject.env = :test
			subject.wsdl.must_equal 'https://www1.webiss.com.br/arcosmg_wsnfse_homolog/NfseServices.svc?wsdl'
		end
		# Barbacena-MG
		it "se codigo da cidade emitente for 3105608 então deve pagar a URL de Barbacena-MG" do
			subject.ibge_code_of_issuer_city = '3105608'
			subject.wsdl.must_equal 'https://www.webiss.com.br/mgbarbacena_wsNFSe/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3105608'
			subject.env = :test
			subject.wsdl.must_equal 'https://www.webiss.com.br/mgbarbacena_wsNFSe_homolog/NfseServices.svc?wsdl'
		end
		# Barroso-MG
		it "se codigo da cidade emitente for 3105905 então deve pagar a URL de Barroso-MG" do
			subject.ibge_code_of_issuer_city = '3105905'
			subject.wsdl.must_equal 'https://www1.webiss.com.br/barrosomg_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3105905'
			subject.env = :test
			subject.wsdl.must_equal 'https://www1.webiss.com.br/barrosomg_wsnfse_homolog/NfseServices.svc?wsdl'
		end
		# Bom Despacho-MG
		it "se codigo da cidade emitente for 3107406 então deve pagar a URL de Bom Despacho-MG" do
			subject.ibge_code_of_issuer_city = '3107406'
			subject.wsdl.must_equal 'https://www4.webiss.com.br/bomdespachomg_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3107406'
			subject.env = :test
			subject.wsdl.must_equal 'https://www4.webiss.com.br/bomdespachomg_wsnfse_homolog/NfseServices.svc?wsdl'
		end
		# Camanducaia-MG
		it "se codigo da cidade emitente for 3110509 então deve pagar a URL de Camanducaia-MG" do
			subject.ibge_code_of_issuer_city = '3110509'
			subject.wsdl.must_equal 'https://www1.webiss.com.br/camanducaiamg_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3110509'
			subject.env = :test
			subject.wsdl.must_equal 'https://www1.webiss.com.br/camanducaiamg_wsnfse_homolog/NfseServices.svc?wsdl'
		end
		# Campo Belo-MG
		it "se codigo da cidade emitente for 3111200 então deve pagar a URL de Campo Belo-MG" do
			subject.ibge_code_of_issuer_city = '3111200'
			subject.wsdl.must_equal 'https://www1.webiss.com.br/campobelomg_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3111200'
			subject.env = :test
			subject.wsdl.must_equal 'https://www1.webiss.com.br/campobelomg_wsnfse_homolog/NfseServices.svc?wsdl'
		end
		# Campos Altos-MG
		it "se codigo da cidade emitente for 3111507 então deve pagar a URL de Campos Altos-MG" do
			subject.ibge_code_of_issuer_city = '3111507'
			subject.wsdl.must_equal 'https://www7.webiss.com.br/camposaltosmg_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3111507'
			subject.env = :test
			subject.wsdl.must_equal 'https://www7.webiss.com.br/camposaltosmg_wsnfse_homolog/nfseServices.svc?wsdl'
		end
		# Cássia-MG
		it "se codigo da cidade emitente for 3115102 então deve pagar a URL de Cássia-MG" do
			subject.ibge_code_of_issuer_city = '3115102'
			subject.wsdl.must_equal 'https://www7.webiss.com.br/cassiamg_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3115102'
			subject.env = :test
			subject.wsdl.must_equal 'https://www7.webiss.com.br/cassiamg_wsnfse_homolog/NfseServices.svc?wsdl'
		end
		# Coronel Fabriciano-MG
		it "se codigo da cidade emitente for 3119401 então deve pagar a URL de Coronel Fabriciano-MG" do
			subject.ibge_code_of_issuer_city = '3119401'
			subject.wsdl.must_equal 'https://www.webiss.com.br/Fabriciano_wsNFSe/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3119401'
			subject.env = :test
			subject.wsdl.must_equal 'https://www.webiss.com.br/Fabriciano_wsNFSe_homolog/NfseServices.svc?wsdl'
		end
		# Extrema-MG
		it "se codigo da cidade emitente for 3125101 então deve pagar a URL de Extrema-MG" do
			subject.ibge_code_of_issuer_city = '3125101'
			subject.wsdl.must_equal 'https://www.webiss.com.br/extremamg_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3125101'
			subject.env = :test
			subject.wsdl.must_equal 'https://www.webiss.com.br/extremamg_wsnfse_homolog/nfseServices.svc?wsdl'
		end
		# Formiga-MG
		it "se codigo da cidade emitente for 3126109 então deve pagar a URL de Formiga-MG" do
			subject.ibge_code_of_issuer_city = '3126109'
			subject.wsdl.must_equal 'https://www1.webiss.com.br/formigamg_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3126109'
			subject.env = :test
			subject.wsdl.must_equal 'https://www1.webiss.com.br/formigamg_wsnfse_homolog/NfseServices.svc?wsdl'
		end
		# Frutal-MG
		it "se codigo da cidade emitente for 3127107 então deve pagar a URL de Frutal-MG" do
			subject.ibge_code_of_issuer_city = '3127107'
			subject.wsdl.must_equal 'https://www.webiss.com.br/mgfrutal_wsNFSe/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3127107'
			subject.env = :test
			subject.wsdl.must_equal 'https://www.webiss.com.br/mgfrutal_wsNFSe_homolog/NfseServices.svc?wsdl'
		end
		# Jaboticatubas-MG
		it "se codigo da cidade emitente for 3134608 então deve pagar a URL de Jaboticatubas-MG" do
			subject.ibge_code_of_issuer_city = '3134608'
			subject.wsdl.must_equal 'https://www4.webiss.com.br/jaboticatubasmg_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3134608'
			subject.env = :test
			subject.wsdl.must_equal 'https://www4.webiss.com.br/jaboticatubasmg_wsnfse_homolog/NfseServices.svc?wsdl'
		end
		# Matozinhos-MG
		it "se codigo da cidade emitente for 3141108 então deve pagar a URL de Matozinhos-MG" do
			subject.ibge_code_of_issuer_city = '3141108'
			subject.wsdl.must_equal 'https://www4.webiss.com.br/matozinhosmg_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3141108'
			subject.env = :test
			subject.wsdl.must_equal 'https://www4.webiss.com.br/matozinhosmg_wsnfse_homolog/NfseServices.svc?wsdl'
		end
		# Nova Serrana-MG
		it "se codigo da cidade emitente for 3145208 então deve pagar a URL de Nova Serrana-MG" do
			subject.ibge_code_of_issuer_city = '3145208'
			subject.wsdl.must_equal 'https://www1.webiss.com.br/novaserranamg_wsnfse/nfseservices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3145208'
			subject.env = :test
			subject.wsdl.must_equal 'https://www1.webiss.com.br/novaserranamg_wsnfse_homolog/nfseservices.svc?wsdl'
		end
		# Passos-MG
		it "se codigo da cidade emitente for 3147907 então deve pagar a URL de Passos-MG" do
			subject.ibge_code_of_issuer_city = '3147907'
			subject.wsdl.must_equal 'https://www5.webiss.com.br/passosmg_wsnfse/nfseservices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3147907'
			subject.env = :test
			subject.wsdl.must_equal 'https://www5.webiss.com.br/passosmg_wsnfse_homolog/nfseservices.svc?wsdl'
		end
		# Prudente de Morais-MG
		it "se codigo da cidade emitente for 3153608 então deve pagar a URL de Prudente de Morais-MG" do
			subject.ibge_code_of_issuer_city = '3153608'
			subject.wsdl.must_equal 'https://www4.webiss.com.br/prudentedemoraismg_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3153608'
			subject.env = :test
			subject.wsdl.must_equal 'https://www4.webiss.com.br/prudentedemoraismg_wsnfse_homolog/NfseServices.svc?wsdl'
		end
		# Rio Piracicaba-MG
		it "se codigo da cidade emitente for 3155702 então deve pagar a URL de Rio Piracicaba-MG" do
			subject.ibge_code_of_issuer_city = '3155702'
			subject.wsdl.must_equal 'https://www5.webiss.com.br/rioPiracicabaMG_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3155702'
			subject.env = :test
			subject.wsdl.must_equal 'https://www5.webiss.com.br/rioPiracicabaMG_wsnfse_homolog/nfseServices.svc?wsdl'
		end
		# Santa Bárbara-MG
		it "se codigo da cidade emitente for 3157203 então deve pagar a URL de Santa Bárbara-MG" do
			subject.ibge_code_of_issuer_city = '3157203'
			subject.wsdl.must_equal 'https://www5.webiss.com.br/santabarbaramg_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3157203'
			subject.env = :test
			subject.wsdl.must_equal 'https://www5.webiss.com.br/santabarbaramg_wsnfse_homolog/NfseServices.svc?wsdl'
		end
		# Santa Rita do Sapucaí-MG
		it "se codigo da cidade emitente for 3159605 então deve pagar a URL de Santa Rita do Sapucaí-MG" do
			subject.ibge_code_of_issuer_city = '3159605'
			subject.wsdl.must_equal 'https://www.webiss.com.br/santaritadosapucai_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3159605'
			subject.env = :test
			subject.wsdl.must_equal 'https://www.webiss.com.br/santaritadosapucai_wsnfse_homolog/NfseServices.svc?wsdl'
		end
		# São Lourenço-MG
		it "se codigo da cidade emitente for 3163706 então deve pagar a URL de São Lourenço-MG" do
			subject.ibge_code_of_issuer_city = '3163706'
			subject.wsdl.must_equal 'https://www7.webiss.com.br/saolourencomg_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3163706'
			subject.env = :test
			subject.wsdl.must_equal 'https://www7.webiss.com.br/saolourencomg_wsnfse_homolog/nfseServices.svc?wsdl'
		end
		# Uberaba-MG
		it "se codigo da cidade emitente for 3170107 então deve pagar a URL de São Lourenço-MG" do
			subject.ibge_code_of_issuer_city = '3170107'
			subject.wsdl.must_equal 'https://www1.webiss.com.br/Uberaba_wsNFSe/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3170107'
			subject.env = :test
			subject.wsdl.must_equal 'https://www1.webiss.com.br/Uberaba_wsNFSe_homolog/NfseServices.svc?wsdl'
		end

	# MT :
		# Itanhangá-MT
		it "se codigo da cidade emitente for 5104542 então deve pagar a URL de Itanhangá-MT" do
			subject.ibge_code_of_issuer_city = '5104542'
			subject.wsdl.must_equal 'https://www7.webiss.com.br/itanhangamt_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '5104542'
			subject.env = :test
			subject.wsdl.must_equal 'https://www7.webiss.com.br/itanhangamt_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# Lucas do Rio Verde-MT
		it "se codigo da cidade emitente for 5105259 então deve pagar a URL de Lucas do Rio Verde-MT" do
			subject.ibge_code_of_issuer_city = '5105259'
			subject.wsdl.must_equal 'https://www1.webiss.com.br/LucasDoRioVerdeMT_wsNFSe/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '5105259'
			subject.env = :test
			subject.wsdl.must_equal 'https://www1.webiss.com.br/LucasDoRioVerdeMT_wsNFSe_homolog/NfseServices.svc?wsdl'
		end

		# São José do Rio Claro-MT
		it "se codigo da cidade emitente for 5107305 então deve pagar a URL de São José do Rio Claro-MT" do
			subject.ibge_code_of_issuer_city = '5107305'
			subject.wsdl.must_equal 'https://www5.webiss.com.br/saojosedorioclaromt_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '5107305'
			subject.env = :test
			subject.wsdl.must_equal 'https://www5.webiss.com.br/saojosedorioclaromt_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# Tangará da Serra-MT
		it "se codigo da cidade emitente for 5107958 então deve pagar a URL de Tangará da Serra-MT" do
			subject.ibge_code_of_issuer_city = '5107958'
			subject.wsdl.must_equal 'https://www4.webiss.com.br/tangaradaserramt_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '5107958'
			subject.env = :test
			subject.wsdl.must_equal 'https://www4.webiss.com.br/tangaradaserramt_wsnfse_homolog/NfseServices.svc?wsdl'
		end

	# RO :
		# Cacoal-RO
		it "se codigo da cidade emitente for 1100049 então deve pagar a URL de Mesquita-RJ" do
			subject.ibge_code_of_issuer_city = '1100049'
			subject.wsdl.must_equal 'https://www4.webiss.com.br/cacoalro_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '1100049'
			subject.env = :test
			subject.wsdl.must_equal 'https://www4.webiss.com.br/cacoalro_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# Cerejeiras-RO
		it "se codigo da cidade emitente for 1100056 então deve pagar a URL de Mesquita-RJ" do
			subject.ibge_code_of_issuer_city = '1100056'
			subject.wsdl.must_equal 'https://www5.webiss.com.br/cerejeirasro_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '1100056'
			subject.env = :test
			subject.wsdl.must_equal 'https://www5.webiss.com.br/cerejeirasro_wsnfse_homolog/NfseServices.svc?wsdl'
		end 	

		# Machadinho D' Oeste-RO
		it "se codigo da cidade emitente for 1100130 então deve pagar a URL de Mesquita-RJ" do
			subject.ibge_code_of_issuer_city = '1100130'
			subject.wsdl.must_equal 'https://www7.webiss.com.br/machadinhodoestero_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '1100130'
			subject.env = :test
			subject.wsdl.must_equal 'https://www7.webiss.com.br/machadinhodoestero_wsnfse_homolog/nfseServices.svc?wsdl'
		end 

		# Nova Brasilândia D' Oeste-RO
		it "se codigo da cidade emitente for 1100148 então deve pagar a URL de Mesquita-RJ" do
			subject.ibge_code_of_issuer_city = '1100148'
			subject.wsdl.must_equal 'https://www7.webiss.com.br/novabrasilandiadoestero_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '1100148'
			subject.env = :test
			subject.wsdl.must_equal 'https://www7.webiss.com.br/novabrasilandiadoestero_wsnfse_homolog/NfseServices.svc?wsdl'
		end 	

		# Vilhena-RO
		it "se codigo da cidade emitente for 1100304 então deve pagar a URL de Mesquita-RJ" do
			subject.ibge_code_of_issuer_city = '1100304'
			subject.wsdl.must_equal 'https://vilhenaro.webiss.com.br/servicos/wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '1100304'
			subject.env = :test
			subject.wsdl.must_equal 'https://vilhenaro.webiss.com.br/servicos/wsnfse_homolog/nfseServices.svc?wsdl'
		end 	

	# RJ : 
		# Mesquita-RJ
		it "se codigo da cidade emitente for 3302858 então deve pagar a URL de Mesquita-RJ" do
			subject.ibge_code_of_issuer_city = '3302858'
			subject.wsdl.must_equal 'https://www5.webiss.com.br/mesquitarj_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3302858'
			subject.env = :test
			subject.wsdl.must_equal 'https://www5.webiss.com.br/mesquitarj_wsnfse_homolog/NfseServices.svc?wsdl'
		end 

		# Niterói-RJ
		it "se codigo da cidade emitente for 3303302 então deve pagar a URL de Niterói-RJ" do
			subject.ibge_code_of_issuer_city = '3303302'
			subject.wsdl.must_equal 'https://www3.webiss.com.br/rjniteroi_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3303302'
			subject.env = :test
			subject.wsdl.must_equal 'https://www3.webiss.com.br/rjniteroi_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# Queimados-RJ
		it "se codigo da cidade emitente for 3304144 então deve pagar a URL de Queimados-RJ" do
			subject.ibge_code_of_issuer_city = '3304144'
			subject.wsdl.must_equal 'https://www1.webiss.com.br/queimadosrj_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3304144'
			subject.env = :test
			subject.wsdl.must_equal 'https://www1.webiss.com.br/queimadosrj_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# Silva Jardim-RJ
		it "se codigo da cidade emitente for 3305604 então deve pagar a URL de Silva Jardim-RJ" do
			subject.ibge_code_of_issuer_city = '3305604'
			subject.wsdl.must_equal 'https://www3.webiss.com.br/silvajardimrj_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3305604'
			subject.env = :test
			subject.wsdl.must_equal 'https://www3.webiss.com.br/silvajardimrj_wsnfse_homolog/nfseServices.svc?wsdl'
		end

		# Teresópolis-RJ
		it "se codigo da cidade emitente for 3305802 então deve pagar a URL de Silva Jardim-RJ" do
			subject.ibge_code_of_issuer_city = '3305802'
			subject.wsdl.must_equal 'https://www1.webiss.com.br/rjteresopolis_wsNFSe/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '3305802'
			subject.env = :test
			subject.wsdl.must_equal 'https://www1.webiss.com.br/rjteresopolis_wsNFSe_homolog/NfseServices.svc?wsdl'
		end

	# RS : 
		# Bagé-RS
		it "se codigo da cidade emitente for 4301602 então deve pagar a URL de Bagé-RS" do
			subject.ibge_code_of_issuer_city = '4301602'
			subject.wsdl.must_equal 'https://www1.webiss.com.br/BageRS_wsNFSe/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '4301602'
			subject.env = :test
			subject.wsdl.must_equal 'https://www1.webiss.com.br/BageRS_wsNFSe_homolog/NfseServices.svc?wsdl'
		end

	# SC:
		# Içara-SC
		it "se codigo da cidade emitente for 4207007 então deve pagar a URL de Içara-SC" do
			subject.ibge_code_of_issuer_city = '4207007'
			subject.wsdl.must_equal 'https://www.webiss.com.br/icarasc_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '4207007'
			subject.env = :test
			subject.wsdl.must_equal 'https://www.webiss.com.br/icarasc_wsnfse_homolog/nfseServices.svc?wsdl'
		end

		# Irineópolis-SC
		it "se codigo da cidade emitente for 4207908 então deve pagar a URL de Irineópolis-SC" do
			subject.ibge_code_of_issuer_city = '4207908'
			subject.wsdl.must_equal 'https://www5.webiss.com.br/irineopolissc_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '4207908'
			subject.env = :test
			subject.wsdl.must_equal 'https://www5.webiss.com.br/irineopolissc_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# Lauro Muller-SC
		it "se codigo da cidade emitente for 4209607 então deve pagar a URL de Lauro Muller-SC" do
			subject.ibge_code_of_issuer_city = '4209607'
			subject.wsdl.must_equal 'https://www4.webiss.com.br/lauromullersc_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '4209607'
			subject.env = :test
			subject.wsdl.must_equal 'https://www4.webiss.com.br/lauromullersc_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# Mafra-SC
		it "se codigo da cidade emitente for 4210100 então deve pagar a URL de Mafra-SC" do
			subject.ibge_code_of_issuer_city = '4210100'
			subject.wsdl.must_equal 'https://www5.webiss.com.br/mafrasc_wsnfse/nfseservices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '4210100'
			subject.env = :test
			subject.wsdl.must_equal 'https://www5.webiss.com.br/mafrasc_wsnfse_homolog/nfseservices.svc?wsdl'
		end

		# Papanduva-SC
		it "se codigo da cidade emitente for 4212205 então deve pagar a URL de Papanduva-SC" do
			subject.ibge_code_of_issuer_city = '4212205'
			subject.wsdl.must_equal 'https://www5.webiss.com.br/papanduvasc_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '4212205'
			subject.env = :test
			subject.wsdl.must_equal 'https://www5.webiss.com.br/papanduvasc_wsnfse_homolog/nfseServices.svc?wsdl'
		end

		# Siderópolis-SC
		it "se codigo da cidade emitente for 4217600 então deve pagar a URL de Siderópolis-SC" do
			subject.ibge_code_of_issuer_city = '4217600'
			subject.wsdl.must_equal 'https://www7.webiss.com.br/sideropolissc_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '4217600'
			subject.env = :test
			subject.wsdl.must_equal 'https://www7.webiss.com.br/sideropolissc_wsnfse_homolog/nfseServices.svc?wsdl'
		end

	# SE: 
		# Aracaju-SE
		it "se codigo da cidade emitente for 2800308 então deve pagar a URL de Aracaju-SE" do
			subject.ibge_code_of_issuer_city = '2800308'
			subject.wsdl.must_equal 'https://aracajuse.webiss.com.br/servicos/wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '2800308'
			subject.env = :test
			subject.wsdl.must_equal 'https://aracajuse.webiss.com.br/servicos/wsnfse_homolog/nfseServices.svc?wsdl'
		end

		# Estância-SE
		it "se codigo da cidade emitente for 2802106 então deve pagar a URL de Estância-SE" do
			subject.ibge_code_of_issuer_city = '2802106'
			subject.wsdl.must_equal 'https://www7.webiss.com.br/estanciase_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '2802106'
			subject.env = :test
			subject.wsdl.must_equal 'https://www7.webiss.com.br/estanciase_wsnfse_homolog/nfseServices.svc?wsdl'
		end

		# Lagarto-SE
		it "se codigo da cidade emitente for 2803500 então deve pagar a URL de Lagarto-SE" do
			subject.ibge_code_of_issuer_city = '2803500'
			subject.wsdl.must_equal 'https://www3.webiss.com.br/lagartose_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '2803500'
			subject.env = :test
			subject.wsdl.must_equal 'https://www3.webiss.com.br/lagartose_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# São Cristóvão-SE
		it "se codigo da cidade emitente for 2806701 então deve pagar a URL de São Cristóvão-SE" do
			subject.ibge_code_of_issuer_city = '2806701'
			subject.wsdl.must_equal 'https://www.webiss.com.br/saocristovaose_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '2806701'
			subject.env = :test
			subject.wsdl.must_equal 'https://www.webiss.com.br/saocristovaose_wsnfse_homolog/NfseServices.svc?wsdl'
		end

	# TO:
		# Gurupi-TO
		it "se codigo da cidade emitente for 1709500 então deve pagar a URL de Gurupi-TO" do
			subject.ibge_code_of_issuer_city = '1709500'
			subject.wsdl.must_equal 'https://www.webiss.com.br/gurupito_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '1709500'
			subject.env = :test
			subject.wsdl.must_equal 'https://www.webiss.com.br/gurupito_wsnfse_homolog/nfseServices.svc?wsdl'
		end

		# Palmas-TO
		it "se codigo da cidade emitente for 1721000 então deve pagar a URL de Palmas-TO" do
			subject.ibge_code_of_issuer_city = '1721000'
			subject.wsdl.must_equal 'https://www5.webiss.com.br/palmasto_wsnfse/NfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '1721000'
			subject.env = :test
			subject.wsdl.must_equal 'https://www5.webiss.com.br/palmasto_wsnfse_homolog/NfseServices.svc?wsdl'
		end

		# Porto Nacional-TO
		it "se codigo da cidade emitente for 1718204 então deve pagar a URL de Porto Nacional-TO" do
			subject.ibge_code_of_issuer_city = '1718204'
			subject.wsdl.must_equal 'https://www7.webiss.com.br/portonacionalto_wsnfse/nfseServices.svc?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da WebISS" do
			subject.ibge_code_of_issuer_city = '1718204'
			subject.env = :test
			subject.wsdl.must_equal 'https://www7.webiss.com.br/portonacionalto_wsnfse_homolog/nfseServices.svc?wsdl'
		end

	end

	describe "#canonicalization_method_algorithm" do
		it { subject.canonicalization_method_algorithm.must_equal 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315' }
	end

	describe "#message_namespaces" do
		it "deve ter um valor" do
			subject.message_namespaces.must_equal({
					"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", 
					"xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
					xmlns: 'http://www.abrasf.org.br/nfse'
				})
		end
	end

	describe "#soap_namespaces" do
		it "deve conter os namespaces padrões mais o namespace da mensagem" do
			subject.soap_namespaces.must_equal({
				'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
				'xmlns:xsd'     => 'http://www.w3.org/2001/XMLSchema',
				'xmlns:xsi'     => 'http://www.w3.org/2001/XMLSchema-instance',
				'xmlns:SOAP-ENC' => "http://schemas.xmlsoap.org/soap/encoding/",
				'xmlns:ns4301' => "http://tempuri.org"
			})
		end
	end

	describe "#soap_body_root_tag" do
		it "por padrão deve dar um Raise pois é necessário que seja sobrescrito nas sublcasses" do
			assert_raises RuntimeError do
				subject.soap_body_root_tag
			end
		end
	end

	describe "#content_xml" do
		let(:expected_xml) do
			dados =  "<rootTag xmlns=\"http://tempuri.org/\">"
			dados +=   "<cabec></cabec>"
			dados +=   '<msg>'
			dados +=     "<![CDATA[<xml>Builder</xml>]]>"
			dados +=   '</msg>'
			dados += "</rootTag>"
			dados
		end
		it "deve encapsular o XML de xml_builder em um CDATA mantendo o XML body no padrão da WebISS" do
			subject.expects(:soap_body_root_tag).returns('rootTag').twice	
			subject.expects(:xml_builder).returns('<xml>Builder</xml>')
			subject.content_xml.must_equal expected_xml
		end
		it "Caso o xml_builder já vier com a tag <?xml não deve inserir a tag novamnete" do
			subject.expects(:soap_body_root_tag).returns('rootTag').twice	
			subject.expects(:xml_builder).returns('<xml>Builder</xml>')
			subject.content_xml.must_equal expected_xml
		end
	end

end