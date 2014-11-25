unit koProcessorXSDLibTools;

interface

uses

  Controls, Classes, msxml,
  Contnrs,
  csCommon,
  csRTTITools,
  csCustomList, StrUtils,
  koProcessorXSDLib, XmlIntf, XmlDoc;

const
  XML_MIN_LENGHT = 3222069609;
  XML_NOT_HAS_ATTRIBUTE = 3222069280;
type

  TcsXSDValidatorErrorType = (etUnknown, etMinLength, etNotHasAttribute);

  TcsXSDValidatorModeType = (vmInternal, vmMSXML);

  TcsXSDValidator = class;

  TcsXSDValidatorErrorParam = class

  end;

  TcsXSDValidatorError = class(TcsPropertyObject)
  private
    FXPAth: String;
    FValidator: TcsXSDValidator;
    FErrorCode: Cardinal;
    FURL: String;
    FFullXpath: String;
    FParams: TStringList;
    FReason: String;
    Flinepos: Integer;
    FsrcText: WideString;
    Ffilepos: Integer;
    Fline: Integer;
    FXSDElement: TXSDObject;
    procedure SetErrorCode(const Value: Cardinal);
    procedure SetXPAth(const Value: String);
    procedure SetURL(const Value: String);
    procedure SetFullXpath(const Value: String);
    procedure SetReason(const Value: String);
    procedure Setfilepos(const Value: Integer);
    procedure Setline(const Value: Integer);
    procedure Setlinepos(const Value: Integer);
    procedure SetsrcText(const Value: WideString);
    procedure SetXSDElement(const Value: TXSDObject);
    function GetErrorType: TcsXSDValidatorErrorType;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property ErrorType: TcsXSDValidatorErrorType read GetErrorType;
    property Params: TStringList read FParams;
    property FullXpath: String read FFullXpath write SetFullXpath;
    property XPAth: String read FXPAth write SetXPAth;
    property ErrorCode: Cardinal read FErrorCode write SetErrorCode;
    property URL: String read FURL write SetURL;
    property Validator: TcsXSDValidator read FValidator;
    property Reason: String read FReason write SetReason;
    property srcText: WideString read FsrcText write SetsrcText;
    property line: Integer read Fline write Setline;
    property linepos: Integer read Flinepos write Setlinepos;
    property filepos: Integer read Ffilepos write Setfilepos;
    property XSDElement: TXSDObject read FXSDElement write SetXSDElement;
  end;

  AcsXSDValidatorErrors = class(TcsCustomList)
  private
    function GetItem(Index: Integer): TcsXSDValidatorError;
  public
    property Items[Index: Integer]: TcsXSDValidatorError read GetItem;
  end;


  TcsXSDValidator = class
  private
    FMode: TcsXSDValidatorModeType;
    FXMLDocument: IXMLDocument;
    FXSDLibrary: TXSDLibrary;
    FErrors: AcsXSDValidatorErrors;
    procedure SetMode(const Value: TcsXSDValidatorModeType);
    procedure SetXMLDocument(const Value: IXMLDocument);
    procedure SetXSDLibrary(const Value: TXSDLibrary);
    procedure SetErrors(const Value: AcsXSDValidatorErrors);
  public
    constructor Create;
    destructor Destroy; override;
    property Errors: AcsXSDValidatorErrors read FErrors write SetErrors;
    property XMLDocument: IXMLDocument read FXMLDocument write SetXMLDocument;
    property XSDLibrary: TXSDLibrary read FXSDLibrary write SetXSDLibrary;
    property Mode: TcsXSDValidatorModeType read FMode write SetMode;
    function CheckXmlByXSD(AXSD: TXSDLibrary; AXML: IXMLDocument): Boolean;
    function ErrorText: String;
  end;

function csXMLGetNodeXPath(AXmlNode: IXMLNode; AParentNode: IXMLNode = nil): String;
function csXMLGetNodeByXPath(AXmlNode: IXMLNode; AXPath: String; AForce: Boolean): IXMLNode;
function csXMLCreateNodeByXPath(AXmlNode: IXMLNode; AXPath: String; ANodeName: String = ''): IXmlNode;

function csXMLFindValue(ASeparationNode: IXMLNode; AXPath: String; IsAttribute: Boolean; AValue: String): IXMLNode;

function GetXPathStrList(AXpath: String): TStringList;

implementation

function GetErrorTypeByCode(ACode: Integer): TcsXSDValidatorErrorType;
begin
  Result := etUnknown;
  case ACode of
    XML_MIN_LENGHT: Result := etMinLength;
    XML_NOT_HAS_ATTRIBUTE: Result := etNotHasAttribute;
  end;
end;

function GetXPathStrList(AXpath: String): TStringList;
var
  i: Integer;
begin
  Result := TStringList.Create;
  StrToList(AXpath, Result, '/');
  for i:= Result.Count - 1  downto 0 do
  begin
    if Result[i] = '' then
    begin
      Result.Delete(i);
    end;
  end;
end;

function csXMLFindValue(ASeparationNode: IXMLNode; AXPath: String; AValue: String): IXMLNode;
var
  xPathSep: string;
  level: Integer;
begin
  xPathSep := csXMLGetNodeXPath(ASeparationNode);
end;

function csXMLCreateNodeByXPath(AXmlNode: IXMLNode; AXPath: String; ANodeName: String = ''): IXmlNode;
var
  strl: TStringList;
  i: Integer;
  nd: IXMLNode;
  ndName: String;
begin
  try
    strl := GetXPathStrList(AXPath);
    nd := AXmlNode;

    ndName := ANodeName;

    if not CText(strl[0], AXmlNode.NodeName) then
      Exit;

    if ANodeName = '' then
    begin
      ANodeName := strl[strl.Count - 1];
      strl.Delete(strl.Count - 1);
    end;


    for i := 1 to strl.Count - 1 do
    begin
      if nd.ChildNodes.FindNode(strl[i]) <> nil then
        nd := nd.ChildNodes.FindNode(strl[i])
      else
        nd := nd.AddChild(strl[i]);
    end;
    if nd.ChildNodes.FindNode(ndName) = nil then
      Result := nd.AddChild(ANodeName)
    else
      Result := nd.ChildNodes.FindNode(ndName);
  finally
    FreeNil(strl);
  end;
end;


function csXMLGetNodeByXPath(AXmlNode: IXMLNode; AXPath: String; AForce: Boolean): IXMLNode;
var
  strSrcXpath: TStringList;
  parXml: IXMLNode;
  first: Boolean;
  curXPath: String;
  i: Integer;
  j: Integer;
begin
  Result := nil;
  strSrcXpath := TStringList.Create;
  try
    StrToList(AXPath, strSrcXpath, '/');
    parXml := AXmlNode;
    for i := strSrcXpath.Count - 1 downto 0 do
    begin
      if strSrcXpath[i] = '' then
        strSrcXpath.Delete(i);
    end;

    if AXmlNode.LocalName <> strSrcXpath[0] then Exit;

    for i := 1 to strSrcXpath.Count - 1 do
    begin
      if strSrcXpath[i] = '' then
        Continue;
      curXPath := strSrcXpath[i];
      if LeftStr(curXPath, 1) = '@' then
      begin
        for j := 0 to parXml.AttributeNodes.Count - 1 do
        begin
          if parXml.AttributeNodes.Get(j).LocalName = curXPath then
          begin
            parXml := parXml.AttributeNodes.Get(j);
            Break;
          end;
        end;
      end else
      for j := 0 to parXml.ChildNodes.Count - 1 do
      begin
        if parXml.ChildNodes[j].NodeName = curXPath then
        begin
          parXml := parXml.ChildNodes.Get(j);
          Break;
        end;
      end;
    end;
    if (csXMLGetNodeXPath(parXml) = AXPath) then
      Result := parXml
    else if AForce then
      Result := parXml;
 // csPrint(AXPath +' '+ GetNodeXPath(Result));
  finally
    FreeNil(strSrcXpath);
  end;
end;

function csXMLGetNodeXPath(AXmlNode: IXMLNode; AParentNode: IXMLNode = nil): String;
var
  strSrcXpath: TStringList;
  parXml: IXMLNode;
  first: Boolean;
  curXPath: String;
  i: Integer;
begin
  Result := '';
  strSrcXpath := TStringList.Create;
  try
    parXml := AXmlNode;
    first := True;
    while parXml <> nil do
    begin
      {if parXml.NodeName = '#document' then
      begin
        strSrcXpath.Insert(0, '/');
        Break;
      end
      else} if parXml.NodeName <> '#document' then
        strSrcXpath.Insert(0, parXml.NodeName);
      if (first) and (AParentNode <> nil) then
        parXml := AParentNode
      else
        parXml := parXml.ParentNode;
      first := False;
    end;
    for i := 0 to strSrcXpath.Count - 1 do
    begin
      Result := Result + strSrcXpath[i];
      if (strSrcXpath.Count - 1) <> i then
        Result := Result + '/';

    end;
  finally
    FreeNil(strSrcXpath);
  end;
  Result := '/'+Result;
end;

{ TXSDValidator }

function GetDomNodeXpath(ANode: IXMLDOMNode): String;
var
  nd: IXMLDOMNode;
begin
  Result := '';
  Result := ANode.nodeName;
  nd := ANode.parentNode;
  while (nd <> nil) do
  begin
    if nd.nodeName <> '#document' then
      Result := nd.nodeName +'/'+Result;
    nd := nd.parentNode;
  end;
  Result := '/'+Result;
end;

function GetNameSpaceURI(domdoc: IXMLDOMDocument3): string;
var
  targetNamespaceNode: IXMLDOMNode;
begin
  targetNamespaceNode := domdoc.documentElement.attributes.getNamedItem('targetNamespace');

  if Assigned(targetNamespaceNode) then
    result := targetNamespaceNode.nodeValue
  else
    result := '';
end;

function TcsXSDValidator.CheckXmlByXSD(AXSD: TXSDLibrary;
  AXML: IXMLDocument): Boolean;
  function CheckByMSXML: Boolean;
  var
    xsdSchema: IXMLDOMDocument3;
    xsdDocument: IXMLDOMDocument3;
    errs: IXMLDOMParseError2;
    err: IXMLDOMParseError2;
    i: Integer;
    procedure AddError(AError: IXMLDOMParseError2);
    var
      err: TcsXSDValidatorError;
      nd: IXMLDOMNode;
      i: Integer;
    begin
      err := TcsXSDValidatorError.Create();
      err.FValidator := Self;
      err.FErrorCode := AError.errorCode;
      err.URL := AError.url;
      err.Reason := AError.reason;
      err.srcText := AError.srcText;
      err.FullXpath := AError.errorXPath;
      err.line := AError.line;
      err.linepos := AError.linepos;
      err.filepos := AError.filepos;
      nd := xsdDocument.selectSingleNode(AError.errorXPath);
      if nd <> nil then
      begin
        err.XPAth := GetDomNodeXpath(nd);
      end;
      err.XSDElement := FXSDLibrary.GetXSDElementByXPath(err.XPAth);
      for i := 0 to AError.errorParametersCount - 1 do
      begin
        err.Params.Add(AError.errorParameters(i));
      end;
      FErrors.Add(err);
    end;
  begin
    FErrors.Clear;
    xsdSchema := CoDOMDocument60.Create();
    xsdDocument := CoDOMDocument60.Create();
    //xsdDocument.validateOnParse := True;
    xsdDocument.schemas := CoXMLSchemaCache60.Create();

    xsdDocument.setProperty('SelectionLanguage', 'XPath');
    xsdDocument.setProperty('MultipleErrorMessages', True);
    xsdDocument.setProperty('SelectionNamespaces', 'xmlns=''geo-office.ru''');
    xsdDocument.loadXML(AXML.XML.Text);
    xsdSchema.setProperty('SelectionLanguage', 'XPath');
    xsdSchema.resolveExternals := True;

    if xsdSchema.load(AXSD.XSDFileName) then
    begin
      xsdDocument.Schemas.Add( GetNameSpaceURI(xsdSchema), xsdSchema);
    end
    else
    begin
      result:= false;
    end;
    errs := xsdDocument.validate as IXMLDOMParseError2;
    if errs <> nil then
    begin
      for i := 0 to errs.allErrors.length - 1 do
      begin
        err := errs.allErrors.item[i];
        AddError(err);
      end;
      Result := True;
    end else
    begin
      Result := True;
    end;
  end;
begin
  FXSDLibrary := AXSD;
  case FMode of
    vmInternal: ;
    vmMSXML:
      begin
        Result := CheckByMSXML;
      end;
  end;
end;

constructor TcsXSDValidator.Create;
begin
  inherited;
  FMode := vmMSXML;
  FErrors := AcsXSDValidatorErrors.Create(True);
end;

destructor TcsXSDValidator.Destroy;
begin
  FreeNil(FErrors);
  inherited;
end;

function TcsXSDValidator.ErrorText: String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Errors.Count - 1 do
  begin
    Result := Result + Errors.Items[i].Reason;
  end;
end;

procedure TcsXSDValidator.SetErrors(const Value: AcsXSDValidatorErrors);
begin
  FErrors := Value;
end;

procedure TcsXSDValidator.SetMode(const Value: TcsXSDValidatorModeType);
begin
  FMode := Value;
end;

procedure TcsXSDValidator.SetXMLDocument(const Value: IXMLDocument);
begin
  FXMLDocument := Value;
end;

procedure TcsXSDValidator.SetXSDLibrary(const Value: TXSDLibrary);
begin
  FXSDLibrary := Value;
end;

{ AcsXSDValidatorErrors }

function AcsXSDValidatorErrors.GetItem(Index: Integer): TcsXSDValidatorError;
begin
  Result := TcsXSDValidatorError(inherited Items[Index]);
end;

{ TcsXSDValidatorError }

constructor TcsXSDValidatorError.Create;
begin
  inherited;
  FParams := TStringList.Create(True);
end;

destructor TcsXSDValidatorError.Destroy;
begin
  FreeNil(FParams);
  inherited;
end;

function TcsXSDValidatorError.GetErrorType: TcsXSDValidatorErrorType;
begin
  Result := GetErrorTypeByCode(FErrorCode);
end;

procedure TcsXSDValidatorError.SetErrorCode(const Value: Cardinal);
begin
  FErrorCode := Value;
end;

procedure TcsXSDValidatorError.Setfilepos(const Value: Integer);
begin
  Ffilepos := Value;
end;

procedure TcsXSDValidatorError.SetFullXpath(const Value: String);
begin
  FFullXpath := Value;
end;

procedure TcsXSDValidatorError.Setline(const Value: Integer);
begin
  Fline := Value;
end;

procedure TcsXSDValidatorError.Setlinepos(const Value: Integer);
begin
  Flinepos := Value;
end;

procedure TcsXSDValidatorError.SetReason(const Value: String);
begin
  FReason := Value;
end;

procedure TcsXSDValidatorError.SetsrcText(const Value: WideString);
begin
  FsrcText := Value;
end;

procedure TcsXSDValidatorError.SetURL(const Value: String);
begin
  FURL := Value;
end;

procedure TcsXSDValidatorError.SetXPAth(const Value: String);
begin
  FXPAth := Value;
end;

procedure TcsXSDValidatorError.SetXSDElement(const Value: TXSDObject);
begin
  FXSDElement := Value;
end;

end.
