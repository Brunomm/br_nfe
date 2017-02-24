<?xml version="1.0" encoding="UTF-8"?>
<wsdl:definitions xmlns:s="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/" xmlns:mime="http://schemas.xmlsoap.org/wsdl/mime/" xmlns:tns="http://tempuri.org/" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:tm="http://microsoft.com/wsdl/mime/textMatching/" xmlns:http="http://schemas.xmlsoap.org/wsdl/http/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" targetNamespace="http://tempuri.org/" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/">
  <wsdl:types>
    <s:schema elementFormDefault="qualified" targetNamespace="http://tempuri.org/">
      <s:element name="HelloWorld">
        <s:complexType/>
      </s:element>
      <s:element name="HelloWorldResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="HelloWorldResult" type="s:string"/>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="RecebeLoteRPS">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="xml">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="RecebeLoteRPSResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="RecebeLoteRPSResult">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="ConsultarNFSEPorRPS">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="xml">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="ConsultarNFSEPorRPSResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="ConsultarNFSEPorRPSResult">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="ConsultarLoteRPS">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="xml">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="ConsultarLoteRPSResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="ConsultarLoteRPSResult">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="ConsultaNFSE">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="xml">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="ConsultaNFSEResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="ConsultaNFSEResult">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="CancelamentoNFSE">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="xml">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="CancelamentoNFSEResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="CancelamentoNFSEResult">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="ConsultarSituacaoLoteRPS">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="xml">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="ConsultarSituacaoLoteRPSResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="ConsultarSituacaoLoteRPSResult">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="getLoteByID">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="1" maxOccurs="1" name="idlote" type="s:int"/>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="getLoteByIDResponse">
        <s:complexType/>
      </s:element>
      <s:element name="ConsultarNotasRecebidas">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="xmlEnvio">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="ConsultarNotasRecebidasResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="ConsultarNotasRecebidasResult">
              <s:complexType mixed="true">
                <s:sequence>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="AtualizarDadosContribuinte">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="cpfCnpj" type="s:string"/>
            <s:element minOccurs="0" maxOccurs="1" name="razaoSocial" type="s:string"/>
            <s:element minOccurs="0" maxOccurs="1" name="endLogradouro" type="s:string"/>
            <s:element minOccurs="1" maxOccurs="1" name="endNumPredial" type="s:int"/>
            <s:element minOccurs="0" maxOccurs="1" name="endBairro" type="s:string"/>
            <s:element minOccurs="0" maxOccurs="1" name="endCidade" type="s:string"/>
            <s:element minOccurs="0" maxOccurs="1" name="endCidadeUF" type="s:string"/>
            <s:element minOccurs="0" maxOccurs="1" name="usuarioAlteracao" type="s:string"/>
            <s:element minOccurs="0" maxOccurs="1" name="endCidadeIBGE" type="s:string"/>
            <s:element minOccurs="0" maxOccurs="1" name="endCep" type="s:string"/>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="AtualizarDadosContribuinteResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="AtualizarDadosContribuinteResult">
              <s:complexType>
                <s:sequence>
                  <s:element ref="s:schema"/>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="AtualizarOptSimplesNacional">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="cnpjempresa" type="s:string"/>
            <s:element minOccurs="1" maxOccurs="1" name="optanteSN" type="s:boolean"/>
            <s:element minOccurs="0" maxOccurs="1" name="usuarioAlteracao" type="s:string"/>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="AtualizarOptSimplesNacionalResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="AtualizarOptSimplesNacionalResult">
              <s:complexType>
                <s:sequence>
                  <s:element ref="s:schema"/>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="BaixarEmpresa">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="cnpjempresa" type="s:string"/>
            <s:element minOccurs="0" maxOccurs="1" name="usuarioAlteracao" type="s:string"/>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="BaixarEmpresaResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="BaixarEmpresaResult">
              <s:complexType>
                <s:sequence>
                  <s:element ref="s:schema"/>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="ValidarLoteRPS">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="outterXml" type="s:string"/>
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="ValidarLoteRPSResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="ValidarLoteRPSResult">
              <s:complexType>
                <s:sequence>
                  <s:element ref="s:schema"/>
                  <s:any/>
                </s:sequence>
              </s:complexType>
            </s:element>
          </s:sequence>
        </s:complexType>
      </s:element>
    </s:schema>
  </wsdl:types>
  <wsdl:message name="HelloWorldSoapIn">
    <wsdl:part name="parameters" element="tns:HelloWorld"/>
  </wsdl:message>
  <wsdl:message name="HelloWorldSoapOut">
    <wsdl:part name="parameters" element="tns:HelloWorldResponse"/>
  </wsdl:message>
  <wsdl:message name="RecebeLoteRPSSoapIn">
    <wsdl:part name="parameters" element="tns:RecebeLoteRPS"/>
  </wsdl:message>
  <wsdl:message name="RecebeLoteRPSSoapOut">
    <wsdl:part name="parameters" element="tns:RecebeLoteRPSResponse"/>
  </wsdl:message>
  <wsdl:message name="ConsultarNFSEPorRPSSoapIn">
    <wsdl:part name="parameters" element="tns:ConsultarNFSEPorRPS"/>
  </wsdl:message>
  <wsdl:message name="ConsultarNFSEPorRPSSoapOut">
    <wsdl:part name="parameters" element="tns:ConsultarNFSEPorRPSResponse"/>
  </wsdl:message>
  <wsdl:message name="ConsultarLoteRPSSoapIn">
    <wsdl:part name="parameters" element="tns:ConsultarLoteRPS"/>
  </wsdl:message>
  <wsdl:message name="ConsultarLoteRPSSoapOut">
    <wsdl:part name="parameters" element="tns:ConsultarLoteRPSResponse"/>
  </wsdl:message>
  <wsdl:message name="ConsultaNFSESoapIn">
    <wsdl:part name="parameters" element="tns:ConsultaNFSE"/>
  </wsdl:message>
  <wsdl:message name="ConsultaNFSESoapOut">
    <wsdl:part name="parameters" element="tns:ConsultaNFSEResponse"/>
  </wsdl:message>
  <wsdl:message name="CancelamentoNFSESoapIn">
    <wsdl:part name="parameters" element="tns:CancelamentoNFSE"/>
  </wsdl:message>
  <wsdl:message name="CancelamentoNFSESoapOut">
    <wsdl:part name="parameters" element="tns:CancelamentoNFSEResponse"/>
  </wsdl:message>
  <wsdl:message name="ConsultarSituacaoLoteRPSSoapIn">
    <wsdl:part name="parameters" element="tns:ConsultarSituacaoLoteRPS"/>
  </wsdl:message>
  <wsdl:message name="ConsultarSituacaoLoteRPSSoapOut">
    <wsdl:part name="parameters" element="tns:ConsultarSituacaoLoteRPSResponse"/>
  </wsdl:message>
  <wsdl:message name="getLoteByIDSoapIn">
    <wsdl:part name="parameters" element="tns:getLoteByID"/>
  </wsdl:message>
  <wsdl:message name="getLoteByIDSoapOut">
    <wsdl:part name="parameters" element="tns:getLoteByIDResponse"/>
  </wsdl:message>
  <wsdl:message name="ConsultarNotasRecebidasSoapIn">
    <wsdl:part name="parameters" element="tns:ConsultarNotasRecebidas"/>
  </wsdl:message>
  <wsdl:message name="ConsultarNotasRecebidasSoapOut">
    <wsdl:part name="parameters" element="tns:ConsultarNotasRecebidasResponse"/>
  </wsdl:message>
  <wsdl:message name="AtualizarDadosContribuinteSoapIn">
    <wsdl:part name="parameters" element="tns:AtualizarDadosContribuinte"/>
  </wsdl:message>
  <wsdl:message name="AtualizarDadosContribuinteSoapOut">
    <wsdl:part name="parameters" element="tns:AtualizarDadosContribuinteResponse"/>
  </wsdl:message>
  <wsdl:message name="AtualizarOptSimplesNacionalSoapIn">
    <wsdl:part name="parameters" element="tns:AtualizarOptSimplesNacional"/>
  </wsdl:message>
  <wsdl:message name="AtualizarOptSimplesNacionalSoapOut">
    <wsdl:part name="parameters" element="tns:AtualizarOptSimplesNacionalResponse"/>
  </wsdl:message>
  <wsdl:message name="BaixarEmpresaSoapIn">
    <wsdl:part name="parameters" element="tns:BaixarEmpresa"/>
  </wsdl:message>
  <wsdl:message name="BaixarEmpresaSoapOut">
    <wsdl:part name="parameters" element="tns:BaixarEmpresaResponse"/>
  </wsdl:message>
  <wsdl:message name="ValidarLoteRPSSoapIn">
    <wsdl:part name="parameters" element="tns:ValidarLoteRPS"/>
  </wsdl:message>
  <wsdl:message name="ValidarLoteRPSSoapOut">
    <wsdl:part name="parameters" element="tns:ValidarLoteRPSResponse"/>
  </wsdl:message>
  <wsdl:portType name="NFSEWSSoap">
    <wsdl:operation name="HelloWorld">
      <wsdl:input message="tns:HelloWorldSoapIn"/>
      <wsdl:output message="tns:HelloWorldSoapOut"/>
    </wsdl:operation>
    <wsdl:operation name="RecebeLoteRPS">
      <wsdl:input message="tns:RecebeLoteRPSSoapIn"/>
      <wsdl:output message="tns:RecebeLoteRPSSoapOut"/>
    </wsdl:operation>
    <wsdl:operation name="ConsultarNFSEPorRPS">
      <wsdl:input message="tns:ConsultarNFSEPorRPSSoapIn"/>
      <wsdl:output message="tns:ConsultarNFSEPorRPSSoapOut"/>
    </wsdl:operation>
    <wsdl:operation name="ConsultarLoteRPS">
      <wsdl:input message="tns:ConsultarLoteRPSSoapIn"/>
      <wsdl:output message="tns:ConsultarLoteRPSSoapOut"/>
    </wsdl:operation>
    <wsdl:operation name="ConsultaNFSE">
      <wsdl:input message="tns:ConsultaNFSESoapIn"/>
      <wsdl:output message="tns:ConsultaNFSESoapOut"/>
    </wsdl:operation>
    <wsdl:operation name="CancelamentoNFSE">
      <wsdl:input message="tns:CancelamentoNFSESoapIn"/>
      <wsdl:output message="tns:CancelamentoNFSESoapOut"/>
    </wsdl:operation>
    <wsdl:operation name="ConsultarSituacaoLoteRPS">
      <wsdl:input message="tns:ConsultarSituacaoLoteRPSSoapIn"/>
      <wsdl:output message="tns:ConsultarSituacaoLoteRPSSoapOut"/>
    </wsdl:operation>
    <wsdl:operation name="getLoteByID">
      <wsdl:input message="tns:getLoteByIDSoapIn"/>
      <wsdl:output message="tns:getLoteByIDSoapOut"/>
    </wsdl:operation>
    <wsdl:operation name="ConsultarNotasRecebidas">
      <wsdl:input message="tns:ConsultarNotasRecebidasSoapIn"/>
      <wsdl:output message="tns:ConsultarNotasRecebidasSoapOut"/>
    </wsdl:operation>
    <wsdl:operation name="AtualizarDadosContribuinte">
      <wsdl:documentation xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/">Permite atualizar alguns dos dados cadastrais dos contribuintes no sistema.</wsdl:documentation>
      <wsdl:input message="tns:AtualizarDadosContribuinteSoapIn"/>
      <wsdl:output message="tns:AtualizarDadosContribuinteSoapOut"/>
    </wsdl:operation>
    <wsdl:operation name="AtualizarOptSimplesNacional">
      <wsdl:documentation xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/">Permite alterar a opção de 'Optante do simples nacional' de uma empresa cadastrada no sistema NFS-e</wsdl:documentation>
      <wsdl:input message="tns:AtualizarOptSimplesNacionalSoapIn"/>
      <wsdl:output message="tns:AtualizarOptSimplesNacionalSoapOut"/>
    </wsdl:operation>
    <wsdl:operation name="BaixarEmpresa">
      <wsdl:documentation xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/">Permite baixar(cancelar) o cadastro de uma empresa no sistema.</wsdl:documentation>
      <wsdl:input message="tns:BaixarEmpresaSoapIn"/>
      <wsdl:output message="tns:BaixarEmpresaSoapOut"/>
    </wsdl:operation>
    <wsdl:operation name="ValidarLoteRPS">
      <wsdl:input message="tns:ValidarLoteRPSSoapIn"/>
      <wsdl:output message="tns:ValidarLoteRPSSoapOut"/>
    </wsdl:operation>
  </wsdl:portType>
  <wsdl:binding name="NFSEWSSoap" type="tns:NFSEWSSoap">
    <soap:binding transport="http://schemas.xmlsoap.org/soap/http"/>
    <wsdl:operation name="HelloWorld">
      <soap:operation soapAction="http://tempuri.org/HelloWorld" style="document"/>
      <wsdl:input>
        <soap:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="RecebeLoteRPS">
      <soap:operation soapAction="http://tempuri.org/RecebeLoteRPS" style="document"/>
      <wsdl:input>
        <soap:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="ConsultarNFSEPorRPS">
      <soap:operation soapAction="http://tempuri.org/ConsultarNFSEPorRPS" style="document"/>
      <wsdl:input>
        <soap:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="ConsultarLoteRPS">
      <soap:operation soapAction="http://tempuri.org/ConsultarLoteRPS" style="document"/>
      <wsdl:input>
        <soap:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="ConsultaNFSE">
      <soap:operation soapAction="http://tempuri.org/ConsultaNFSE" style="document"/>
      <wsdl:input>
        <soap:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="CancelamentoNFSE">
      <soap:operation soapAction="http://tempuri.org/CancelamentoNFSE" style="document"/>
      <wsdl:input>
        <soap:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="ConsultarSituacaoLoteRPS">
      <soap:operation soapAction="http://tempuri.org/ConsultarSituacaoLoteRPS" style="document"/>
      <wsdl:input>
        <soap:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="getLoteByID">
      <soap:operation soapAction="http://tempuri.org/getLoteByID" style="document"/>
      <wsdl:input>
        <soap:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="ConsultarNotasRecebidas">
      <soap:operation soapAction="http://tempuri.org/ConsultarNotasRecebidas" style="document"/>
      <wsdl:input>
        <soap:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="AtualizarDadosContribuinte">
      <soap:operation soapAction="http://tempuri.org/AtualizarDadosContribuinte" style="document"/>
      <wsdl:input>
        <soap:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="AtualizarOptSimplesNacional">
      <soap:operation soapAction="http://tempuri.org/AtualizarOptSimplesNacional" style="document"/>
      <wsdl:input>
        <soap:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="BaixarEmpresa">
      <soap:operation soapAction="http://tempuri.org/BaixarEmpresa" style="document"/>
      <wsdl:input>
        <soap:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="ValidarLoteRPS">
      <soap:operation soapAction="http://tempuri.org/ValidarLoteRPS" style="document"/>
      <wsdl:input>
        <soap:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
  </wsdl:binding>
  <wsdl:binding name="NFSEWSSoap12" type="tns:NFSEWSSoap">
    <soap12:binding transport="http://schemas.xmlsoap.org/soap/http"/>
    <wsdl:operation name="HelloWorld">
      <soap12:operation soapAction="http://tempuri.org/HelloWorld" style="document"/>
      <wsdl:input>
        <soap12:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="RecebeLoteRPS">
      <soap12:operation soapAction="http://tempuri.org/RecebeLoteRPS" style="document"/>
      <wsdl:input>
        <soap12:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="ConsultarNFSEPorRPS">
      <soap12:operation soapAction="http://tempuri.org/ConsultarNFSEPorRPS" style="document"/>
      <wsdl:input>
        <soap12:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="ConsultarLoteRPS">
      <soap12:operation soapAction="http://tempuri.org/ConsultarLoteRPS" style="document"/>
      <wsdl:input>
        <soap12:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="ConsultaNFSE">
      <soap12:operation soapAction="http://tempuri.org/ConsultaNFSE" style="document"/>
      <wsdl:input>
        <soap12:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="CancelamentoNFSE">
      <soap12:operation soapAction="http://tempuri.org/CancelamentoNFSE" style="document"/>
      <wsdl:input>
        <soap12:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="ConsultarSituacaoLoteRPS">
      <soap12:operation soapAction="http://tempuri.org/ConsultarSituacaoLoteRPS" style="document"/>
      <wsdl:input>
        <soap12:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="getLoteByID">
      <soap12:operation soapAction="http://tempuri.org/getLoteByID" style="document"/>
      <wsdl:input>
        <soap12:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="ConsultarNotasRecebidas">
      <soap12:operation soapAction="http://tempuri.org/ConsultarNotasRecebidas" style="document"/>
      <wsdl:input>
        <soap12:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="AtualizarDadosContribuinte">
      <soap12:operation soapAction="http://tempuri.org/AtualizarDadosContribuinte" style="document"/>
      <wsdl:input>
        <soap12:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="AtualizarOptSimplesNacional">
      <soap12:operation soapAction="http://tempuri.org/AtualizarOptSimplesNacional" style="document"/>
      <wsdl:input>
        <soap12:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="BaixarEmpresa">
      <soap12:operation soapAction="http://tempuri.org/BaixarEmpresa" style="document"/>
      <wsdl:input>
        <soap12:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="ValidarLoteRPS">
      <soap12:operation soapAction="http://tempuri.org/ValidarLoteRPS" style="document"/>
      <wsdl:input>
        <soap12:body use="literal"/>
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal"/>
      </wsdl:output>
    </wsdl:operation>
  </wsdl:binding>
  <wsdl:service name="NFSEWS">
    <wsdl:port name="NFSEWSSoap" binding="tns:NFSEWSSoap">
      <soap:address location="http://homologa.nfse.pmfi.pr.gov.br/nfsews/nfse.asmx"/>
    </wsdl:port>
    <wsdl:port name="NFSEWSSoap12" binding="tns:NFSEWSSoap12">
      <soap12:address location="http://homologa.nfse.pmfi.pr.gov.br/nfsews/nfse.asmx"/>
    </wsdl:port>
  </wsdl:service>
</wsdl:definitions>