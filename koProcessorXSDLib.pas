unit koProcessorXSDLib;

interface

uses

  Windows, classes, SysUtils, Contnrs, Variants,
  csCommon, koProcessor, StrUtils,
  csCustomList,
  XMLDoc, XMLIntf, csRTTITools;

type

  QName = String;
  NCName = string;

  TXSDLibrary = class;
  TXSDComplexType = class;
  TXSDSimpleType = class;
  TXSDObject = class;
  TXSDElementKey = class;
  TXSDElement = class;
  TXSDAttribute = class;
  TXSDCustomObject = class;
  TXSDAttributeCollection = class;
  TXSDAnnotationCollection = class;
  TXSDElementCollection = class;
  TXSDObjectCollection = class;
  TXSDElementObjectCollection = class;
  TXSDElementKeyCollection = class;
  TXSDAnnotation  = class;
  TXSDEnumerationCollection = class;
  TXSDRestriction = class;
  TkoXSDElementRestructPrecept = class;
//  group | choice | sequence
  TXSDCustomObjectClass = class of TXSDCustomObject;

  TXSDObjectClass = class of TXSDObject;

  TXSDUse = (xsdOptional, xsdProhibited, xsdRequired);
  TXSDCollectionType = (sequence, all, choice, group, any);

  TkoXSDPrecept = class(TkoProcessPrecept)
  private
    FXPath: String;
    function GetXSDObject: TXSDCustomObject;
    procedure SetXSDObject(const Value: TXSDCustomObject);
    function GetXPath: String;
    procedure SetXPath(const Value: String);
    function GetParent: TkoXSDPrecept;
  protected
    function GetName: string; override;
    function GetHasValue: Boolean; override;
  public
    destructor Destroy; override;
    function GetPreceptInfoString: string; override;
    procedure WriteLinkInfoToXml(AXmlNode: IXMLNode); override;
    function getVisibleName: string; override;
    property Parent: TkoXSDPrecept read GetParent;
  published
    property XPath: String read GetXPath;
    property LinkObject: TXSDCustomObject read GetXSDObject write SetXSDObject;
  end;

  TkoXSDElementPrecept = class(TkoXSDPrecept, IkoProcessPrecept)
  private
    function GetXSDElement: TXSDElement;
    function GetXSDRestruction: TkoXSDElementRestructPrecept;
  protected
    function GetHasValue: Boolean; override;
  public
    function GetIsFixed: Boolean; override;
    function GetAnnotation: string; override;
    function GetFixedValue: Variant; override;
    function GetValueType: TkoProcessDataType; override;

    function GetRestruction: IkoProcessPreceptRestruction;  override;
    procedure SetLinkObject(const Value: TObject); override;
    destructor Destroy; override;
    function GetMaxOccurs: Integer; override;
    function GetMinOccurs: Integer; override;
    function GetRequired: Boolean; override;
    function GetDependenceOnParent: Boolean; override;
    procedure WriteLinkInfoToXml(AXmlNode: IXMLNode); override;
  published
    constructor Create(AStorage: TkoProcessStorage;
      AParent: IkoProcessCustomPrecept); override;
    property Restruction: TkoXSDElementRestructPrecept read GetXSDRestruction;
    property LinkObject: TXSDElement read GetXSDElement;
  end;

  TkoXSDElementRestructPrecept = class (TkoProcessPreceptRestruction, IkoProcessPreceptRestruction)
  private
    function GetLinkObject: TXSDRestriction;
  protected
    procedure SetPrecept(const Value: IkoProcessPrecept); override;
    function GetEnumeration: IkoEnumProcessPrecept; override;
    function GetfractionDigits: Integer; override;
    function Getlength: Integer; override;
    function GetMax: Variant; override;
    function GetMaxIncude: Boolean; override;
    function GetmaxLength: Integer; override;
    function GetMin: Variant; override;
    function GetMinIncude: Boolean; override;
    function GetminLength: Integer; override;
    function GetPattern: String; override;
    function GettotalDigits: Integer; override;
  public
    procedure SetLinkObject(const Value: TObject); override;
  published
    property LinkObject: TXSDRestriction read GetLinkObject;
  end;

  TkoXSDConnectionInfo = class(TkoProcessStorageConnectionInfo)
  private
    FXMLFileName: String;
    procedure SetXMLFileName(const Value: String);
  published
    function CheckParametrs: Boolean; override;
    property XMLFileName: String read FXMLFileName write SetXMLFileName;
  end;

  TkoXSDElementDataLink = class (TkoProcessorDataLink)
  end;

  TkoXSDAttributeDataLink = class (TkoProcessorDataLink)
  end;

  TkoXSDStorage = class (TkoProcessStorage)
  private
    FFileName: String;
    FXSDPackageDir: String;
    FXSDRootName: String;
    FXSDLib: TXSDLibrary;
    procedure SetFileName(const Value: String);
    procedure SetXSDPackageDir(const Value: String);
    procedure SetXSDRootName(const Value: String);
    procedure SetFullFileName(const Value: String);
    function GetFullFileName: String;
  protected
    function InternalGetPrecept: IkoProcessCustomPrecept; override;
  public

    destructor Destroy; override;
    procedure ReadXML(AXMLNode: IXMLNode); override;
    procedure AfterReadXML; override;
    class function GetConnectionInfoClass: TkoProcessStorageConnectionInfoClass; override;
    function GetDataLinkClass(APrecept: IkoProcessCustomPrecept): TkoProcessorDataLinkClass; override;
    function GetPreceptByXMLNode(IXMLNode: IXMLNode): IkoProcessCustomPrecept;
      override;
    property FullFileName: String read GetFullFileName write SetFullFileName;

    constructor Create(AOwner: TkoProcessor; AParent: TkoProcessorElement); override;
    property XSDLib: TXSDLibrary read FXSDLib;
  published
    property XSDPackageDir: String read FXSDPackageDir write SetXSDPackageDir;
    property XSDRootName: String read FXSDRootName write SetXSDRootName;
    property FileName: String read FFileName write SetFileName;
  end;


  TXSDCustomObject = class(TPersistent)
  private
    FHas: Boolean;
    Fid: String;
    FLibrary: TXSDLibrary;
    FParent: TXSDCustomObject;
    FName: NCName;
    FTypeApplied: Boolean;
    FTypeName: String;
    FRef: String;
    FTypeObject: TXSDCustomObject;
    FRefObject: TXSDCustomObject;
    FAssigned: Boolean;
    FInternalDataType: TkoProcessDataType;
    function GetClassName: String;
    procedure SetClassName(const Value: String);
    procedure SetHas(const Value: Boolean);
    procedure Setid(const Value: String);
    procedure SetParent(const Value: TXSDCustomObject);
    procedure SetName(const Value: String);
    procedure SetTypeApplied(const Value: Boolean);
    procedure SetTypeName(const Value: String);


    procedure SetIsRef(const Value: Boolean);
    function GetXPath: String;
    procedure SetXPath(const Value: String); virtual;
    procedure SetAssigned(const Value: Boolean);
    function GetLibrary: TXSDLibrary;
    function GetLibraryName: String;
    procedure SetRef(const Value: String);
  protected
    function GetName: NCName; Virtual;
    function GetTypeObj: TXSDCustomObject; virtual;
    function GetRefObj: TXSDCustomObject; virtual;
    procedure InternalAssignTyped(); virtual;
    function GetIsTypeObject: Boolean; virtual;
    function GetIsRef: Boolean; virtual;
    function GetStringAttribute(ANode: IXMLNode; AAtrubute: String): string;
    function GetVariantAttribute(ANode: IXMLNode; AAtrubute: String): Variant;
    function GetIntAttribute(ANode: IXMLNode; AAtrubute: String): Integer;
    function GetBoolAttribute(ANode: IXMLNode; AAtrubute: String): Boolean;
    function GetXPathName: NCName; virtual;
  public
    property Parent: TXSDCustomObject read FParent write SetParent;
    property OwnerLibrary: TXSDLibrary read GetLibrary;
    procedure Assign(Source: TXSDCustomObject); virtual;
    property Assigned: Boolean read FAssigned write SetAssigned;
    function GetPrecept(AParent: IkoProcessCustomPrecept):
      IkoProcessCustomPrecept; virtual; abstract;

    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil); virtual;
    procedure LoadObject(AXmlNode: IXMLNode); virtual;
    procedure Afterload; virtual;
    procedure AssignTyped();
  published
    property LibraryName: String read GetLibraryName;
    property id: String read Fid write Setid;
    property ClassName: String read GetClassName write SetClassName;
    property Has: Boolean read FHas write SetHas;
    property Name: NCName read GetName write SetName;
    property XPathName: NCName read GetXPathName;
    property TypeApplied: Boolean read FTypeApplied write SetTypeApplied;
    property Type_: String read FTypeName write SetTypeName;
    property TypeObj: TXSDCustomObject read GetTypeObj;
    property RefObj: TXSDCustomObject read GetRefObj;
    property IsTypeObject: Boolean read GetIsTypeObject;
    property IsRef: Boolean read GetIsRef write SetIsRef;
    property Ref: String read FRef write SetRef;
    property XPath: String read GetXPath write SetXPath;
  end;

  TXSDObjectType = (otUnknown, otCollection, otElement, otAttribute);

  TXSDObject = class (TXSDCustomObject)
  private
    FRefXPath: String;
    FParent: TXSDObject;
    FAnnotation: TXSDAnnotation;
    procedure Setid(const Value: String);

    procedure SetRefXPath(const Value: String);
    procedure SetParent(const Value: TXSDObject);
    procedure SetAnnotationText(const Value: String);
    function GetLevel: Integer;


  protected
    function GetAnnotationText: String; virtual;
    function GetIsRef: Boolean; override;
    function GetObjectType: TXSDObjectType; virtual;
  public
    property Annotation: TXSDAnnotation read FAnnotation;
    property ObjectType: TXSDObjectType read GetObjectType;
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil); virtual;
    destructor Destroy; override;
    procedure LoadObject(AXmlNode: IXMLNode); override;
    procedure Assign(Source: TXSDCustomObject); override;
    function GetTextValue(AValue: Variant): Variant; virtual;
    function IsCollection: Boolean; virtual;

  published
    property RefXPath: String read FRefXPath write SetRefXPath;
    property AnnotationText: String read GetAnnotationText write SetAnnotationText;
    property Level: Integer read GetLevel;
  end;


 (*<annotation
  id = ID
  {any attributes with non-schema namespace . . .}>
  Content: (appinfo | documentation)*
</annotation>
<appinfo
  source = anyURI
  {any attributes with non-schema namespace . . .}>
  Content: ({any})*
</appinfo>
<documentation
  source = anyURI
  xml:lang = language
  {any attributes with non-schema namespace . . .}>
  Content: ({any})*
</documentation>*)

  TXSDAnnotation = class (TXSDCustomObject)
  private
    Fappinfo: String;
    FDocumentationStrList: TStringList;
    procedure Setdocumentation(const Value: String);
    procedure Setappinfo(const Value: String);
    function GetDocumentation: String;
  protected
    procedure LoadObject(AXmlNode: IXMLNode); override;
  public
    procedure Assign(Source: TXSDCustomObject); override;
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
      override;
    destructor Destroy; override;
  published

    property Appinfo: String read Fappinfo write Setappinfo;
    property Documentation: String read GetDocumentation write SetDocumentation;
  end;


  (* abstract = boolean : false
  block = (#all | List of (extension | restriction | substitution))
  default = string
  //final = (#all | List of (extension | restriction))
  //fixed = string
  form = (qualified | unqualified)
  id = ID
  maxOccurs = (nonNegativeInteger | unbounded)  : 1
  minOccurs = nonNegativeInteger : 1
  //name = NCName
  nillable = boolean : false
  ref = QName
  substitutionGroup = QName
  type = QName
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, ((simpleType | complexType)?, (unique | key | keyref)*)

//http://msdn.microsoft.com/ru-ru/library/ms256118(v=vs.90).aspx


  {<selector
  id = ID
  xpath = a subset of XPath expression, see below
  xpathDefaultNamespace = (anyURI | (##defaultNamespace | ##targetNamespace | ##local))
>
  Content: (annotation?)
</selector>
<field
  id = ID
  xpath = a subset of XPath expression, see below
  xpathDefaultNamespace = (anyURI | (##defaultNamespace | ##targetNamespace | ##local))
  any attributes with non-schema namespace . . .>
  Content: (annotation?)
</field>  }

  TXSDElementKeyLookType = (ltSelector, ltField);

  TXSDElementKeyLook = class (TXSDObject)
  private
    FLookType: TXSDElementKeyLookType;
    FXpath: String;
    FElementKey: TXSDElementKey;
    procedure SetLookType(const Value: TXSDElementKeyLookType);
    function GetElement: TXSDElement;
    procedure SetXpath(const Value: String); override;
  public
    procedure LoadObject(AXmlNode: IXMLNode); override;
  published

    property Xpath: String read FXpath write SetXpath;
    property ElementKey: TXSDElementKey read FElementKey;

    property Element: TXSDElement read GetElement;
  end;

  TXSDElementKey = class (TXSDObject)
  private
    FTypeKey: TkoProcessKeyType;
    Frefer: QName;
    FElement: TXSDElement;
    FField: TXSDElementKeyLook;
    FSelector: TXSDElementKeyLook;
    procedure SetTypeKey(const Value: TkoProcessKeyType);
    procedure Setrefer(const Value: QName);
    function GetFieldPath: String;
    function GetSelectorPath: String;
  public
    procedure LoadObject(AXmlNode: IXMLNode); override;
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
      override;
    destructor Destroy; override;
  published
    property ref: QName read Fref write Setref;
    property refer: QName read Frefer write Setrefer;
    property TypeKey: TkoProcessKeyType read FTypeKey write SetTypeKey;

    property Selector: TXSDElementKeyLook read FSelector;
    property Field: TXSDElementKeyLook read FField;
    property SelectorPath: String read GetSelectorPath;
    property FieldPath: String read GetFieldPath;
    property Element: TXSDElement read FElement;
  end;

  TXSDElement = class (TXSDObject)
  private

    FAttributes: TXSDAttributeCollection;

    FAbstract: boolean;
    Fdefault: String;
    FElementType: String;
    FmaxOccurs: integer;
    FminOccurs: integer;
    FsubstitutionGroup: QName;
    Fnillable: boolean;

    FcomplexType: TXSDComplexType;
    FSimpleType: TXSDSimpleType;
    FFixed: Variant;
    FIsFixed: Boolean;
    FKeys: TXSDElementKeyCollection;


    procedure SetAbstract(const Value: boolean);
    procedure Setdefault(const Value: String);
    procedure SetElementType(const Value: String);
    procedure SetmaxOccurs(const Value: integer);
    procedure SetminOccurs(const Value: integer);
    procedure Setnillable(const Value: boolean);
    procedure SetsubstitutionGroup(const Value: QName);
    procedure SetFixed(const Value: Variant);
    procedure SetIsFixed(const Value: Boolean);
    function GetCollection: TXSDElementObjectCollection;
  protected
    procedure LoadObject(AXmlNode: IXMLNode); override;
    procedure InternalAssignTyped; override;
    function GetXPathName: string; override;
    function GetObjectType: TXSDObjectType; override;
  public
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil); override;
    destructor Destroy; override;
    procedure Assign(Source: TXSDCustomObject); override;
    function GetPrecept(AParent: IkoProcessCustomPrecept):
      IkoProcessCustomPrecept; override;
    function GetTextValue(AValue: Variant): Variant; override;
    property Collection: TXSDElementObjectCollection read GetCollection;
  published
    property Fixed: Variant read FFixed write SetFixed;
    property Abstract: boolean read FAbstract write SetAbstract;
    property default: String read Fdefault write Setdefault;
    property ElementType: String read FElementType write SetElementType;
    property maxOccurs: integer read FmaxOccurs write SetmaxOccurs;
    property minOccurs: integer read FminOccurs write SetminOccurs;
    property nillable: boolean read Fnillable write Setnillable;
    property substitutionGroup: QName read FsubstitutionGroup write SetsubstitutionGroup;
    property SimpleType: TXSDSimpleType read FSimpleType;
    property Attributes: TXSDAttributeCollection read FAttributes;
    property complexType: TXSDComplexType read FcomplexType;
    property Keys: TXSDElementKeyCollection read FKeys;
    property IsFixed: Boolean read FIsFixed write SetIsFixed;
  end;

(*
<complexType
  abstract = boolean : false
  block = (#all | List of (extension | restriction))
  final = (#all | List of (extension | restriction))
  id = ID
  mixed = boolean
  name = NCName
  defaultAttributesApply = boolean : true
  {any attributes with non-schema namespace . . .}>
  Content:
  (annotation?, (simpleContent | complexContent | (openContent?, (group | all | choice | sequence)?, ((attribute | attributeGroup)*, anyAttribute?),)
</complexType>

*)

  TXSDComplexContentRestriction = class(TXSDObject)
  private
    FBase: String;
    FFirstBase: String;
    FAttributes: TXSDAttributeCollection;
    FCollection: TXSDElementObjectCollection;
    procedure SetBase(const Value: String);
    procedure SetFirstBase(const Value: String);
  protected
    function GetTypeObj: TXSDCustomObject; override;
  public
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
      override;
    destructor Destroy; override;
  published
    procedure LoadObject(AXmlNode: IXMLNode); override;
    property Base: String read FBase write SetBase;
    property FirstBase: String read FFirstBase write SetFirstBase;
    property Collection: TXSDElementObjectCollection read FCollection;
    property Attributes: TXSDAttributeCollection read FAttributes;
  end;

  { TODO -ogrig -cbag : Проблема при загрузки заявки. Требуется проверка }

  TXSDComplexContentExtension = class(TXSDObject)
  private
    FBase: String;
    FAttributes: TXSDAttributeCollection;
    FCollection: TXSDElementObjectCollection;
    FFirstBase: String;
    procedure SetBase(const Value: String);
    procedure SetFirstBase(const Value: String);

  protected
    function GetTypeObj: TXSDCustomObject; override;
    procedure InternalAssignTyped; override;
  public
    procedure LoadObject(AXmlNode: IXMLNode); override;
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
      override;
    destructor Destroy; override;
  published

    property Base: String read FBase write SetBase;
    property FirstBase: String read FFirstBase write SetFirstBase;
    property Collection: TXSDElementObjectCollection read FCollection;
    property Attributes: TXSDAttributeCollection read FAttributes;

  end;

  TXSDComplexContent = class (TXSDObject)
  private
    FRestruction: TXSDComplexContentRestriction;
    FExtension: TXSDComplexContentExtension;
  protected
    procedure InternalAssignTyped; override;
  public
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
      override;
    destructor Destroy; override;
  published

    property Restriction: TXSDComplexContentRestriction read FRestruction;
    property Extension: TXSDComplexContentExtension read FExtension;
    procedure LoadObject(AXmlNode: IXMLNode); override;
  end;

  TXSDSimpleType = class (TXSDObject)
  private
    FAnotations: TXSDAnnotationCollection;
    FRestruction: TXSDRestriction;
    procedure SetHas(const Value: Boolean);
  protected
    procedure LoadObject(AXmlNode: IXMLNode); override;
    function GetIsTypeObject: Boolean; override;
    procedure InternalAssignTyped; override;
    procedure Assign(Source: TXSDCustomObject); override;
  public
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil); override;
    destructor Destroy; override;
    function GetTextValue(AValue: Variant): Variant; override;
  published
    property Restruction: TXSDRestriction read FRestruction;
  end;

  TXSDSimpleContentExtension = class (TXSDObject)
  private
    FAttributes: TXSDAttributeCollection;
    FBase: String;
    procedure SetBase(const Value: String);
  published
  public
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
      override;
    destructor Destroy; override;
    procedure LoadObject(AXmlNode: IXMLNode); override;
  published

    property Base: String read FBase write SetBase;
    property Attributes: TXSDAttributeCollection read FAttributes;
  end;

  TXSDSimpleContent = class (TXSDObject)
  private
    FRestriction: TXSDRestriction;
    FExtension: TXSDSimpleContentExtension;
  protected
    function GetTypeObj: TXSDCustomObject; override;
  public
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
      override;
    procedure InternalAssignTyped; override;
    destructor Destroy; override;
    procedure LoadObject(AXmlNode: IXMLNode); override;

  published
    property Restriction: TXSDRestriction read FRestriction;
    property Extension: TXSDSimpleContentExtension read FExtension;
  end;

  TXSDComplexType = class (TXSDObject)
  private
    Fmixed: boolean;
    FAnotations: TXSDAnnotationCollection;
    FCollection: TXSDElementObjectCollection;
    FAttributes: TXSDAttributeCollection;
    FdefaultAttributesApply: boolean;
    FComplexContent: TXSDComplexContent;
    FSimpleContent: TXSDSimpleContent;
    procedure Setmixed(const Value: boolean);
    procedure SetName(const Value: String);
    procedure SetdefaultAttributesApply(const Value: boolean);
    procedure SetComplexContent(const Value: TXSDComplexContent);
    procedure SetSimpleContent(const Value: TXSDSimpleContent);
  protected

    procedure LoadObject(AXmlNode: IXMLNode); override;
    function GetIsTypeObject: Boolean; override;
    procedure InternalAssignTyped; override;
    function GetXPathName: string; override;
  public
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil); override;
    destructor Destroy; override;
    procedure Assign(Source: TXSDCustomObject); override;
    property Anotations: TXSDAnnotationCollection read FAnotations;
    property Collection: TXSDElementObjectCollection read FCollection;
    property Attributes: TXSDAttributeCollection read FAttributes;
  published
    property SimpleContent: TXSDSimpleContent read FSimpleContent write SetSimpleContent;
    property ComplexContent: TXSDComplexContent read FComplexContent write SetComplexContent;
    property defaultAttributesApply: boolean read FdefaultAttributesApply write SetdefaultAttributesApply;
    property mixed: boolean read Fmixed write Setmixed;
  end;

  TXSDEnumeration = class (TXSDObject)
  private
    Fvalue: Variant;
    procedure Setvalue(const Value: Variant);
    procedure LoadObject(AXmlNode: IXMLNode); override;
  published
    property value: Variant read Fvalue write Setvalue;
  end;


  {minExclusive | minInclusive | maxExclusive | maxInclusive | totalDigits
  | fractionDigits | length | minLength | maxLength | enumeration |
  whiteSpace | pattern)}

  TXSDRestriction = class (TXSDObject)
  private
    Flength: Integer;
    FmaxLength: Integer;
    FminLength: Integer;
    FfractionDigits: Integer;
    FmaxExclusive: Variant;
    FmaxInclusive: Variant;
    FminExclusive: Variant;
    FminInclusive: Variant;
    FtotalDigits: Integer;
    Fenumeration: TXSDEnumerationCollection;
    Fbase: String;
    FfirstBase: String;
    FPattern: String;
    procedure SetfractionDigits(const Value: Integer);
    procedure Setlength(const Value: Integer);
    procedure SetmaxExclusive(const Value: Variant);
    procedure SetmaxInclusive(const Value: Variant);
    procedure SetmaxLength(const Value: Integer);
    procedure SetminExclusive(const Value: Variant);
    procedure SetminInclusive(const Value: Variant);
    procedure SetminLength(const Value: Integer);
    procedure SettotalDigits(const Value: Integer);
    procedure Setbase(const Value: String);
    function GetParentElement: TXSDElement;
    procedure SetPattern(const Value: String);
  protected
    procedure InternalAssignTyped; override;
    function GetTypeObj: TXSDCustomObject; override;
  public
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
      override;
    destructor Destroy; override;
    procedure Assign(Source: TXSDCustomObject); override;


  published
    procedure LoadObject(AXmlNode: IXMLNode); override;
    property base: String read Fbase write Setbase;
    property firstBase: String read FfirstBase;
    property minExclusive: Variant read FminExclusive write SetminExclusive;
    property minInclusive: Variant read FminInclusive write SetminInclusive;
    property maxExclusive: Variant read FmaxExclusive write SetmaxExclusive;
    property maxInclusive: Variant read FmaxInclusive write SetmaxInclusive;
    property totalDigits: Integer read FtotalDigits write SettotalDigits;
    property fractionDigits: Integer read FfractionDigits write SetfractionDigits;
    property length: Integer read Flength write Setlength;
    property minLength: Integer read FminLength write SetminLength;
    property maxLength: Integer read FmaxLength write SetmaxLength;
    property Pattern: String read FPattern write SetPattern;
    property enumeration: TXSDEnumerationCollection read Fenumeration;
    property ParentElement: TXSDElement read GetParentElement;

        //| whiteSpace | pattern)*
  end;

  TkoXSDAttributePrecept = class(TkoXSDPrecept, IkoProcessPrecept)
  private
    function GetXSDElement: TXSDAttribute;
    function GetXSDRestruction: TkoXSDElementRestructPrecept;
  protected
    function GetHasValue: Boolean; override;
  public
    function GetIsFixed: Boolean; override;
    function GetAnnotation: string; override;
    function GetFixedValue: Variant; override;
    function GetValueType: TkoProcessDataType; override;
    function GetMaxOccurs: Integer; override;
    function GetMinOccurs: Integer; override;

    function GetRestruction: IkoProcessPreceptRestruction;  override;
    function GetRequired: Boolean; override;
    function GetDependenceOnParent: Boolean; override;
    function GetPreceptInfoString: string; override;
    procedure WriteLinkInfoToXml(AXmlNode: IXMLNode); override;
    function GetIsRealObject: Boolean; override;
    function getVisibleName: string; override;

  published
    property Restruction: TkoXSDElementRestructPrecept read GetXSDRestruction;
    property LinkObject: TXSDAttribute read GetXSDElement;

  end;

  TXSDAttribute = class (TXSDObject)
  private
    Fuse: TXSDUse;
    Fdefault: string;
    Ffixed: string;
    FSimpleType: TXSDSimpleType;
    procedure Setdefault(const Value: string);
    procedure Setfixed(const Value: string);
    procedure Setname(const Value: NCName);
    procedure Setref(const Value: QName);
    procedure Setuse(const Value: TXSDUse);
    function GetRestruction: TXSDRestriction;
  protected

    procedure LoadObject(AXmlNode: IXMLNode); override;
    procedure InternalAssignTyped; override;
    function GetObjectType: TXSDObjectType; override;
  public
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil); override;
    destructor Destroy; override;
    procedure Assign(Source: TXSDCustomObject); override;
    function GetPrecept(AParent: IkoProcessCustomPrecept): IkoProcessCustomPrecept; override;
    function GetTextValue(AValue: Variant): Variant; override;
  published
    property SimpleType: TXSDSimpleType read FSimpleType;
    property default: string read Fdefault write Setdefault;
    property fixed: string read Ffixed write Setfixed;
    property use: TXSDUse read Fuse write Setuse;
    property Restruction: TXSDRestriction read GetRestruction;
  end;


  TXSDObjectCollection = class (TXSDObject)
  private
    FList: TObjectList;
    FCollectionType: TprCollectionType;
    function GetCount: Integer;
    function GetItems(Index: Integer): TXSDCustomObject;
    procedure SetItems(Index: Integer; const Value: TXSDCustomObject);
    procedure Insert(Index: Integer; AXSDElement: TXSDCustomObject);
  protected
    procedure InternalAssignTyped; override;
    procedure Add(AXSDElement: TXSDCustomObject); virtual;
    function IndexOf(AXSDElement: TXSDCustomObject): Integer;

  public

    destructor Destroy; override;
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil); override;
    procedure Clear; virtual;
    procedure LoadObject(AXmlNode: IXMLNode); override;
    function IsCollection: Boolean; override;
    property Items[Index: Integer]: TXSDCustomObject read
      GetItems write SetItems; default;
  published
    property Count: Integer read GetCount;
    property CollectionType: TprCollectionType read FCollectionType write FCollectionType;
  end;

  TXSDElementKeyCollection = class (TXSDObjectCollection)
  private
    function GetElementKey(Index: Integer): TXSDElementKey;
  published
  public
    procedure LoadObject(AXmlNode: IXMLNode); override;
    procedure Assign(Source: TXSDCustomObject); override;
    property Items[Index: Integer]: TXSDElementKey read GetElementKey;
  end;

  TXSDEnumerationCollection = class (TXSDObjectCollection)
  private
    function Getenumeration(Index: Integer): TXSDEnumeration;
    procedure Setenumeration(Index: Integer; const Value: TXSDEnumeration);
  protected
    procedure LoadObject(AXmlNode: IXMLNode); override;

  published
  public
    procedure Add(Aenumeration: TXSDenumeration);
    procedure Assign(Source: TXSDCustomObject); override;
    property Items[Index: Integer]: TXSDenumeration read
      Getenumeration write Setenumeration; default;
  end;


  TXSDTypedCollection = class (TXSDObjectCollection)
  protected
    procedure Add(AXSDElement: TXSDCustomObject); override;
  public
    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
      override;

  end;

  TXSDIncludeCollection = class (TXSDObjectCollection)
  private
    function GetLibrary(Index: Integer): TXSDLibrary;
    procedure SetLibrary(Index: Integer; const Value: TXSDLibrary);
  protected
    procedure LoadObject(AXmlNode: IXMLNode); override;
  published
  public
    procedure Add(AIncludeLib: TXSDLibrary);
    property Items[Index: Integer]: TXSDLibrary read
      GetLibrary write SetLibrary; default;
  end;

  TkoXSDAttributePreceptCollection = class (TkoXSDPrecept, IkoProcessPreceptCollection)
  published
  private

    function GetLinkObject: TXSDAttributeCollection;
  published
  public
    function GetCollectionType: TprCollectionType;

    procedure SetLinkObject(const Value: TObject); override;
    function GetCount: Integer;
    function GetItem(Index: Integer): IkoProcessCustomPrecept;
    function GetIsRealObject: Boolean; override;
    function getVisibleName: string; override;
    property LinkObject: TXSDAttributeCollection read GetLinkObject;
  end;

  TXSDAttributeCollection = class (TXSDObjectCollection)
  private
    function GetAttribute(Index: Integer): TXSDAttribute;
    procedure SetAttribute(Index: Integer; const Value: TXSDAttribute);
  protected
    procedure LoadObject(AXmlNode: IXMLNode); override;
  published
  public

    procedure Add(AAttribute: TXSDAttribute);
    procedure Assign(Source: TXSDCustomObject); override;
    function GetPrecept(AParent: IkoProcessCustomPrecept): IkoProcessCustomPrecept; override;
    property Items[Index: Integer]: TXSDAttribute read
      GetAttribute write SetAttribute; default;
    function AttributeByName(AName: String): TXSDAttribute;
  end;

  TXSDAnnotationCollection = class (TXSDObjectCollection)
  private
    function GetAnnotation(Index: Integer): TXSDAnnotation;
    procedure SetAnnotation(Index: Integer; const Value: TXSDAnnotation);
  protected
    procedure LoadObject(AXmlNode: IXMLNode); override;
    function GetAnnotationText: string; override;
  public
    procedure Add(AAnnotation: TXSDAnnotation);
    property Items[Index: Integer]: TXSDAnnotation read
      GetAnnotation write SetAnnotation; default;
  end;


  TXSDComplexTypeCollection = class (TXSDObjectCollection)
  private
    function GetComplexType(Index: Integer): TXSDComplexType;
    procedure SetComplexType(Index: Integer; const Value: TXSDComplexType);
  protected
    procedure LoadObject(AXmlNode: IXMLNode); override;
  published
  public
    procedure Add(AElement: TXSDComplexType);
    property Items[Index: Integer]: TXSDComplexType read
      GetComplexType write SetComplexType; default;
  end;

  TXSDSimpleTypeCollection = class (TXSDObjectCollection)
  private
    function GetSimpleType(Index: Integer): TXSDSimpleType;
    procedure SetSimpleType(Index: Integer; const Value: TXSDSimpleType);
  protected
    procedure LoadObject(AXmlNode: IXMLNode); override;
  published
  public
    procedure Add(AElement: TXSDSimpleType);
    property Items[Index: Integer]: TXSDSimpleType read
      GetSimpleType write SetSimpleType; default;
  end;

  TXSDElementCollection = class (TXSDObjectCollection)
  private
    function GetElement(Index: Integer): TXSDElement;
    procedure SetElement(Index: Integer; const Value: TXSDElement);
  protected
    procedure LoadObject(AXmlNode: IXMLNode); override;
  published
  public

    function GetElementByName(AName: String): TXSDElement;
    procedure Add(AElement: TXSDElement);
    procedure Assign(Source: TXSDCustomObject); override;
    property Items[Index: Integer]: TXSDElement read
      GetElement write SetElement; default;
  end;

  TXSDElementObjectPreceptCollection = class (TkoXSDPrecept, IkoProcessPreceptCollection)
  private
    function GetLinkObject: TXSDElementObjectCollection;
  protected
    function GetName: string; override;
  public
    function GetCollectionType: TprCollectionType;
    function GetCount: Integer;
    function GetItem(Index: Integer): IkoProcessCustomPrecept;
    function GetIsRealObject: Boolean; override;

    procedure WriteLinkInfoToXml(AXmlNode: IXMLNode); override;
    function getVisibleName: string; override;
  published
    property Count: Integer read GetCount;
    property CollectionType: TprCollectionType read GetCollectionType;
    property LinkObject: TXSDElementObjectCollection read GetLinkObject;
  end;

  TXSDElementObjectCollection = class (TXSDObjectCollection)
  private
    function GetElement(Index: Integer): TXSDObject;
  protected
    procedure LoadObject(AXmlNode: IXMLNode); override;
    procedure InternalAssignTyped; override;
  public
    function GetElementByName(AName: String): TXSDObject;
    procedure Add(AObject: TXSDObject);
    procedure Assign(Source: TXSDCustomObject); override;
    function GetPrecept(AParent: IkoProcessCustomPrecept): IkoProcessCustomPrecept; override;
    function GetIndexOfName(AName: String): Integer;
    property Items[Index: Integer]: TXSDObject read
      GetElement; default;
  end;

  TXSDLibraries = class(TcsCustomList)
  private
    function GetItem(Index: Integer): TXSDLibrary;
  public
    procedure LoadLibrariesFromResource(AStringArray: array of string);
    property Items[Index: Integer]: TXSDLibrary read GetItem;
    function GetLibByName(AName: String): TXSDLibrary;
  end;

  TXSDLibrary = class (TXSDObject)
  private
    FXSDFileName: String;
    FLoaded: Boolean;
    FInclude: TXSDIncludeCollection;
    FElements: TXSDElementObjectCollection;
    FAnnotations: TXSDAnnotationCollection;
    FGlobalNameSpace: String;
    FComplexTypes: TXSDComplexTypeCollection;
    FTypedObjs: TXSDTypedCollection;
    FSimpleTypes: TXSDSimpleTypeCollection;
    FXSDStorage: TkoXSDStorage;
    FtargetNamespace: String;
    procedure SetXSDFileName(const Value: String);
    procedure SetLoaded(const Value: Boolean);
    procedure SetGlobalNameSpace(const Value: String);
    procedure SetComplexTypes(const Value: TXSDComplexTypeCollection);
    procedure SetTypedObjs(const Value: TXSDTypedCollection);
    procedure SetSimpleTypes(const Value: TXSDSimpleTypeCollection);
    procedure SetXSDStorage(const Value: TkoXSDStorage);
    procedure SettargetNamespace(const Value: String);
  protected
    procedure LoadObject(AXmlNode: IXMLNode); override;
    procedure LoadNameObject(AXmlNode: IXMLNode);
    procedure LoadInternalObject(AXmlNode: IXMLNode);
    function GetAnnotationText: string; override;
  public

    constructor Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil); override;
    destructor Destroy; override;
    procedure LoadXSD(AXSDFile: String = '');
    procedure LoadXSDFromResource(AResourceName: String);

    //procedure LoadElements(AXmlNode: IXMLNode);
    procedure Clear;
    property Loaded: Boolean read FLoaded write SetLoaded;
    property XSDStorage: TkoXSDStorage read FXSDStorage write SetXSDStorage;
  published
    procedure ApplyTypedObjects;
    procedure Afterload; override;
    property XSDFileName: String read FXSDFileName write SetXSDFileName;
    property GlobalNameSpace: String read FGlobalNameSpace write SetGlobalNameSpace;
    property targetNamespace: String read FtargetNamespace write SettargetNamespace;
    property Include: TXSDIncludeCollection read FInclude;
    property Elements: TXSDElementObjectCollection read FElements;
    property Annotations: TXSDAnnotationCollection read FAnnotations;
    property ComplexTypes: TXSDComplexTypeCollection read FComplexTypes write SetComplexTypes;
    property SimpleTypes: TXSDSimpleTypeCollection read FSimpleTypes write SetSimpleTypes;
    function GetTypeByName(AName: String): TXSDObject;
    function GetRefByName(AName: String): TXSDObject;
    property TypedObjs: TXSDTypedCollection read FTypedObjs write SetTypedObjs;
    function GetXSDElementByXMLNode(AXmlNode: IXMLNode; AParentNode: IXMLNode = nil): TXSDObject;
    function GetXSDElementByXPath(AXpath: String): TXSDObject;
  end;

procedure CheckXSD(AXSDFile: String);

implementation

procedure CheckXSD(AXSDFile: String);
var
  xdsf: IXMLDocument;
begin
  if not Ctext(ExtractFileDir(ExtractFileDir(AXSDFile)),
    ExtractFilePath(ParamStr(0))+LIBRARY_PATH+'\XSD') then
  begin
    raise Exception.CreateFmt('Пакет словаря XSD должен находится в папке "%s"',
     [ExtractFilePath(ParamStr(0))+LIBRARY_PATH+'\XSD']);
  end;

  xdsf := NewXMLDocument;
  xdsf.LoadFromFile(AXSDFile);
  if not CText(xdsf.DocumentElement.LocalName, 'Schema') then
  begin
    raise Exception.Create('Файл не соответствует стандарту XSD');
  end;

end;



{ TkoXSDLinkElement }

procedure TkoXSDStorage.AfterReadXML;
begin
  inherited;
  XSDLib.LoadXSD(GetFullFileName);
end;

constructor TkoXSDStorage.Create(AOwner: TkoProcessor; AParent: TkoProcessorElement);
begin
  inherited;
  FXSDLib := TXSDLibrary.Create(nil);
  FXSDLib.XSDStorage := Self;
end;

destructor TkoXSDStorage.Destroy;
begin

  FreeNil(FXSDLib);
  inherited;
end;

class function TkoXSDStorage.GetConnectionInfoClass: TkoProcessStorageConnectionInfoClass;
begin
  Result := TkoXSDConnectionInfo;
end;

function TkoXSDStorage.GetDataLinkClass(
  APrecept: IkoProcessCustomPrecept): TkoProcessorDataLinkClass;
begin
  if Precept is TkoXSDElementPrecept then
    Result := TkoXSDElementDataLink;
  if Precept is TkoXSDAttributePrecept then
    Result := TkoXSDAttributeDataLink;
end;

function TkoXSDStorage.GetFullFileName: String;
var
  repodir: String;
begin
  if Self.ProcessorSchema.FileStorageRepositoryDir <> '' then
    repodir := Self.ProcessorSchema.FileStorageRepositoryDir
  else
    repodir := ExtractFilePath(ParamStr(0))+'\Library\';
  Result := repodir + 'XSD\'+ FXSDPackageDir + '\' + FFileName;
end;

function TkoXSDStorage.GetPreceptByXMLNode(
  IXMLNode: IXMLNode): IkoProcessCustomPrecept;
var
  strl: TStringList;
  xpath: string;
  i: Integer;
  isEndPAth: Boolean;
  res: IkoProcessCustomPrecept;
  nextName: String;
  name: String;
  function GetNextElementByName(APrec: IkoProcessCustomPrecept;
    AName: String): IkoProcessCustomPrecept;
  var
    i: Integer;
    pr: IkoProcessCustomPrecept;
  begin
    Result := nil;
    for i := 0 to APrec.ChildCount - 1 do
    begin
      if Supports(APrec.Child[i], IkoProcessCustomPrecept) then
      begin
        pr := APrec.Child[i] as IkoProcessCustomPrecept;
        if CText(pr.Name, AName) then
        begin
          Result := pr;
          Exit;
        end;
      end;
    end;
  end;
begin
  strl := TStringList.Create;
  Result := nil;
  try
    xpath := IXMLNode.Attributes['xpath'];
    StrToList(xpath, strl, '/');
    res := Precept;
    for i := 0 to strl.Count - 1 do
    begin
      name := strl.Strings[i];
      if name = '' then Continue;
      nextName := '';
      isEndPAth := i = strl.Count - 1;
      if not isEndPAth then
        nextName := strl.Strings[i + 1];

      if isEndPAth then
      begin
        if CText(res.Name, name) then
          Continue
        else
          Exit;
      end
      else
      begin
        res := GetNextElementByName(res, nextName);
      end;
    end;
    Result := res;
  finally
    FreeNil(strl);
  end;
end;

function TkoXSDStorage.InternalGetPrecept: IkoProcessCustomPrecept;
var
  rootel: TXSDCustomObject;
begin
  if FXSDRootName = '' then raise EkoProcessExcteption.Create(
    'Не установенно имя первичного элемента');
  rootel := FXSDLib.Elements.GetElementByName(FXSDRootName);
  if rootel = nil then raise EkoProcessExcteption.CreateFmt(
    'Не найден основной элемент с именем ''%s'' в билиотеке', [FXSDRootName]);
  Result := rootel.GetPrecept(nil);
  if TkoXSDPrecept(Result).RefCount > 0 then
    sleep(0);
end;

procedure TkoXSDStorage.ReadXML(AXMLNode: IXMLNode);
begin
  inherited;
end;

procedure TkoXSDStorage.SetFullFileName(const Value: String);
begin
  CheckXSD(Value);
  FFileName := ExtractFileName(Value);
  FXSDPackageDir := ExtractFileName(ExtractFileDir(Value));
  FXSDLib.XSDFileName := Value;
end;


procedure TkoXSDStorage.SetFileName(const Value: String);
begin
  FFileName := Value;
end;


procedure TkoXSDStorage.SetXSDPackageDir(const Value: String);
begin
  FXSDPackageDir := Value;
end;

procedure TkoXSDStorage.SetXSDRootName(const Value: String);
begin
  FXSDRootName := Value;
end;

{ TXSDLibrary }

procedure TXSDLibrary.Afterload;
begin
  inherited;
  ApplyTypedObjects;
end;

procedure TXSDLibrary.ApplyTypedObjects;
var
  i: Integer;
  ty: TXSDCustomObject;
begin
  for i := 0 to Include.Count - 1 do
  begin
    Include[i].ApplyTypedObjects;
  end;
  for i := 0 to FComplexTypes.Count - 1 do
  begin
    FComplexTypes[i].AssignTyped();
  end;
  for i := 0 to TypedObjs.Count - 1 do
  begin
    TypedObjs[i].AssignTyped();
  end;

  for i := 0 to FSimpleTypes.Count - 1 do
  begin
    FSimpleTypes[i].AssignTyped();
  end;

end;

procedure TXSDLibrary.Clear;
begin
  FInclude.Clear;
  FElements.Clear;
  FAnnotations.Clear;
end;

constructor TXSDLibrary.Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
begin
  inherited;
  FInclude := TXSDIncludeCollection.Create(Self, Self);
  FElements := TXSDElementObjectCollection.Create(Self, Self);
  FAnnotations := TXSDAnnotationCollection.Create(Self, Self);
  FComplexTypes := TXSDComplexTypeCollection.Create(Self, Self);
  FTypedObjs := TXSDTypedCollection.Create(Self, self);
  FSimpleTypes := TXSDSimpleTypeCollection.Create(Self, self);
end;

destructor TXSDLibrary.Destroy;
begin
  FreeNil(FElements);
  FreeNil(FInclude);
  FreeNil(FAnnotations);
  FreeNil(FComplexTypes);
  FreeNil(FTypedObjs);
  FreeNil(FSimpleTypes);
  inherited;
end;

function TXSDLibrary.GetAnnotationText: string;
begin
  Result := Annotations.AnnotationText;
end;

function TXSDLibrary.GetRefByName(AName: String): TXSDObject;
var
  i: Integer;
  na, na1: String;
begin
  Result := nil;
  na1 := RightStr(AName,
      Length(AName) -
        pos(':', AName));
  for i := 0 to FElements.Count - 1 do
  begin
    na := RightStr(FElements[i].Name,
      Length(FElements[i].Name) -
        pos(':', FElements[i].Name));
    if CText(na, na1) then
    begin
      Result := FElements[i];
      Exit;
    end;
  end;
end;

function TXSDLibrary.GetTypeByName(AName: String): TXSDObject;
var
  i: Integer;
  na, na1: String;
begin
  Result := nil;
  na1 := RightStr(AName,
      Length(AName) -
        pos(':', AName));
  for i := 0 to FComplexTypes.Count - 1 do
  begin
    na := RightStr(FComplexTypes[i].Name,
      Length(FComplexTypes[i].Name) -
        pos(':', FComplexTypes[i].Name));
    if CText(na, na1) then
    begin
      Result := FComplexTypes[i];
      Exit;
    end;
  end;
  for i := 0 to FSimpleTypes.Count - 1 do
  begin
    na := RightStr(FSimpleTypes[i].Name,
      Length(FSimpleTypes[i].Name) -
        pos(':', FSimpleTypes[i].Name));
    if CText(na, na1) then
    begin
      Result := FSimpleTypes[i];
      Exit;
    end;
  end;
  for i := 0 to Include.Count - 1 do
  begin
    Result := Include[i].GetTypeByName(na1);
    if Result <> nil then Exit;
    
  end;
end;

function TXSDLibrary.GetXSDElementByXMLNode(AXmlNode: IXMLNode; AParentNode: IXMLNode = nil): TXSDObject;
var
  i: Integer;
  xsdNode: TXSDObject;
  j: Integer;
  curXPath: String;
  xsdel: TXSDElement;
  founded: Boolean;
  strSrcXpath: TStringList;
  parXml: IXMLNode;
  first: Boolean;
  xsdcol: TXSDElementObjectCollection;
  j1: Integer;
begin
  Result := nil;
  strSrcXpath := TStringList.Create;
  try
    parXml := AXmlNode;
    xsdNode := nil;
    first := True;
    while parXml <> nil do
    begin
      if parXml.NodeName <> '#document' then
        strSrcXpath.Insert(0, parXml.NodeName);
      if (first) and (AParentNode <> nil) then
        parXml := AParentNode
      else
        parXml := parXml.ParentNode;
      first := False;
    end;
    curXPath := '';
    for i := 0 to strSrcXpath.Count - 1 do
    begin
      curXPath := curXPath + '/';
      curXPath := curXPath + strSrcXpath[i];

      if xsdNode = nil then
      begin
        for j := 0 to FElements.Count - 1 do
        begin
          if curXPath = FElements[j].XPath then
          begin
            xsdNode := FElements[j];
            Continue;
          end;
        end;
      end
      else if xsdNode is TXSDElement then
      begin
        founded := False;
        xsdel := xsdNode as TXSDElement;
        for j := 0 to xsdel.FcomplexType.Collection.Count - 1 do
        begin
          if xsdel.FcomplexType.Collection[j] is TXSDElementObjectCollection then
          begin
            xsdcol := xsdel.FcomplexType.Collection[j] as TXSDElementObjectCollection;
            for j1 := 0 to xsdcol.Count - 1 do
            begin
              if xsdcol.Items[j1].XPath = curXPath then
              begin
                xsdNode := xsdcol.Items[j1];
                founded := True;
                Break;
              end;
            end;
          end
          else if xsdel.FcomplexType.Collection[j].XPath = curXPath then
          begin
            xsdNode := xsdel.FcomplexType.Collection[j];
            founded := True;
            Break;
          end;
        end;
        if founded then Continue;
        for j := 0 to xsdel.FcomplexType.FComplexContent.FExtension.Collection.Count - 1 do
        begin
          if xsdel.FcomplexType.FComplexContent.FExtension.Collection[j].XPath = curXPath then
          begin
            xsdNode := xsdel.FcomplexType.FComplexContent.FExtension.Collection[j];
            founded := True;
            Break;
          end;
        end;
        if founded then Continue;
        for j := 0 to xsdel.Attributes.Count - 1 do
        begin
          if xsdel.Attributes[j].XPath = curXPath then
          begin
            xsdNode := xsdel.Attributes[j];
            founded := True;
            Break;
          end;
        end;
        if founded then Continue;
      end;
    end;
    if xsdNode <> nil then
      if curXPath = xsdNode.XPath then
        Result := xsdNode;
  finally
    FreeNil(strSrcXpath);
  end;

end;

function TXSDLibrary.GetXSDElementByXPath(AXpath: String): TXSDObject;
var
  i: Integer;
  j1: Integer;
  j: Integer;
  strSrcXpath: TStringList;
  curXPath: String;
  xsdel: TXSDElement;
  founded: Boolean;
  xsdNode: TXSDObject;
   xsdcol: TXSDElementObjectCollection;
begin
  Result := nil;
  for i := 0 to Elements.Count - 1 do
  begin
    if CText(Elements[i].XPath, AXpath) then
    begin
      Result := Elements[i];
      Exit;
    end;
  end;
  strSrcXpath := TStringList.Create;
  try

    xsdNode := nil;

    StrToList(AXpath, strSrcXpath, '/');

    curXPath := '';
    for i := 0 to strSrcXpath.Count - 1 do
    begin
      if strSrcXpath[i] = '' then Continue;

      curXPath := curXPath + '/';
      curXPath := curXPath + strSrcXpath[i];

      if xsdNode = nil then
      begin
        for j := 0 to FElements.Count - 1 do
        begin
          if curXPath = FElements[j].XPath then
          begin
            xsdNode := FElements[j];
            Continue;
          end;
        end;
      end
      else if xsdNode is TXSDElement then
      begin
        founded := False;
        xsdel := xsdNode as TXSDElement;
        for j := 0 to xsdel.FcomplexType.Collection.Count - 1 do
        begin
          if xsdel.FcomplexType.Collection[j] is TXSDElementObjectCollection then
          begin
            xsdcol := xsdel.FcomplexType.Collection[j] as TXSDElementObjectCollection;
            for j1 := 0 to xsdcol.Count - 1 do
            begin
              if xsdcol.Items[j1].XPath = curXPath then
              begin
                xsdNode := xsdcol.Items[j1];
                founded := True;
                Break;
              end;
            end;
          end
          else if xsdel.FcomplexType.Collection[j].XPath = curXPath then
          begin
            xsdNode := xsdel.FcomplexType.Collection[j];
            founded := True;
            Break;
          end;
        end;
        if founded then Continue;
        for j := 0 to xsdel.FcomplexType.FComplexContent.FExtension.Collection.Count - 1 do
        begin
          if xsdel.FcomplexType.FComplexContent.FExtension.Collection[j].XPath = curXPath then
          begin
            xsdNode := xsdel.FcomplexType.FComplexContent.FExtension.Collection[j];
            founded := True;
            Break;
          end;
        end;
        if founded then Continue;
        for j := 0 to xsdel.Attributes.Count - 1 do
        begin
          if xsdel.Attributes[j].XPath = curXPath then
          begin
            xsdNode := xsdel.Attributes[j];
            founded := True;
            Break;
          end;
        end;
        if founded then Continue;
      end;
    end;
    if xsdNode <> nil then
      if curXPath = xsdNode.XPath then
        Result := xsdNode;
  finally
    FreeNil(strSrcXpath);
  end;
end;

procedure TXSDLibrary.LoadInternalObject(AXmlNode: IXMLNode);
begin
  inherited;
  FInclude.LoadObject(AXmlNode);
  FElements.LoadObject(AXmlNode);
  FComplexTypes.LoadObject(AXmlNode);
  FSimpleTypes.LoadObject(AXmlNode);
  FAnnotations.LoadObject(AXmlNode);
end;

procedure TXSDLibrary.LoadNameObject(AXmlNode: IXMLNode);
var
  ndSchema: IXMLNode;
begin
  inherited;
  ndSchema := AXmlNode;
  GlobalNameSpace := AXmlNode.Prefix;
   if AXmlNode.HasAttribute('targetNamespace') then
    targetNamespace := AXmlNode.Attributes['targetNamespace'];

  if AXmlNode.HasAttribute('schemaLocation') then
    XSDFileName := AXmlNode.Attributes['schemaLocation'];

end;

procedure TXSDLibrary.LoadObject(AXmlNode: IXMLNode);

begin
  inherited;
  LoadNameObject(AXmlNode);
  LoadInternalObject(AXmlNode);

end;

procedure TXSDLibrary.LoadXSD(AXSDFile: String = '');
var
  xdoc: IXMLDocument;
begin
  if AXSDFile <> '' then
    FXSDFileName := AXSDFile;
  xdoc := NewXMLDocument();
  try
    if FileExists(FXSDFileName) then
    begin
      xdoc.LoadFromFile(FXSDFileName);
      LoadObject(xdoc.DocumentElement);
      FLoaded := True;
      Afterload;
    end
    else
      raise Exception.Create('Отсутсвует файл схемы: '+FXSDFileName);
  finally
    xdoc := nil;
  end;
end;

procedure TXSDLibrary.LoadXSDFromResource(AResourceName: String);
var
  xdoc: IXMLDocument;
  strm: TResourceStream;
begin
  FXSDFileName := AResourceName;
  strm := TResourceStream.Create(HInstance, AResourceName, RT_RCDATA);
  xdoc := NewXMLDocument();
  try
    xdoc.LoadFromStream(strm);
    LoadObject(xdoc.DocumentElement);
    FLoaded := True;
    Afterload;
  finally
    FreeNil(strm);
    xdoc := nil;
  end;
end;

procedure TXSDLibrary.SetComplexTypes(const Value: TXSDComplexTypeCollection);
begin
  FComplexTypes := Value;
end;

procedure TXSDLibrary.SetGlobalNameSpace(const Value: String);
begin
  FGlobalNameSpace := Value;
end;

procedure TXSDLibrary.SetLoaded(const Value: Boolean);
begin
  FLoaded := Value;
  if Value then
  begin
    Clear;
    LoadXSD(XSDFileName);

  end;
end;

procedure TXSDLibrary.SetSimpleTypes(const Value: TXSDSimpleTypeCollection);
begin
  FSimpleTypes := Value;
end;

procedure TXSDLibrary.SettargetNamespace(const Value: String);
begin
  FtargetNamespace := Value;
end;

procedure TXSDLibrary.SetTypedObjs(const Value: TXSDTypedCollection);
begin
  FTypedObjs := Value;
end;

procedure TXSDLibrary.SetXSDFileName(const Value: String);
begin
  FXSDFileName := Value;
  FXSDFileName := ReplaceStr(FXSDFileName, '/', '\');
end;

procedure TXSDLibrary.SetXSDStorage(const Value: TkoXSDStorage);
begin
  FXSDStorage := Value;
end;

{ TXSDElement }

procedure TXSDObject.Assign(Source: TXSDCustomObject);
var
  xsdo: TXSDObject;
begin
  inherited Assign(Source);
  xsdo := TXSDObject(Source);
  FRefXPath := xsdo.RefXPath;
  if (xsdo <> nil) and (FAnnotation <> nil) then
    FAnnotation.Assign(xsdo.FAnnotation);
  {else
    Note(ClassName); }
end;

constructor TXSDObject.Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
begin
  inherited;
  FAnnotation := TXSDAnnotation.Create(ALibrary, self);
end;

destructor TXSDObject.Destroy;
begin
  FreeNil(FAnnotation);
  inherited;
end;

function TXSDObject.GetAnnotationText: String;
begin
  Result := '';
  if FAnnotation.Has then Result := FAnnotation.documentation;

end;

function TXSDObject.GetIsRef: Boolean;
begin
  Result := FRef <> '';

end;

function TXSDObject.GetLevel: Integer;
var
  obj: TXSDCustomObject;
begin
  Result := 0;
  obj := Parent;
  while obj <> nil do
  begin
    Inc(Result);
    obj := obj.Parent;
  end;

end;

function TXSDObject.GetObjectType: TXSDObjectType;
begin
  Result := otUnknown;
  if IsCollection then
    Result := otCollection;
end;

function TXSDObject.GetTextValue(AValue: Variant): Variant;
begin
  Result := AValue;
end;

function TXSDObject.IsCollection: Boolean;
begin
  Result := False;
end;

procedure TXSDObject.LoadObject(AXmlNode: IXMLNode);
var
  annnd: IXMLNode;
begin
  inherited LoadObject(AXmlNode);
  if AXmlNode.HasAttribute('id') then
    id := aXmlNode.Attributes['id'];
  if AXmlNode.HasAttribute('name') then
    Name:= aXmlNode.Attributes['name'];
  annnd := AXmlNode.ChildNodes.FindNode('annotation');

  if AXmlNode.HasAttribute('ref') then
    ref:= aXmlNode.Attributes['ref'];

  if annnd <> nil then
  begin
    FAnnotation.LoadObject(annnd);
  end;
  Has := True;
end;

procedure TXSDObject.SetAnnotationText(const Value: String);
begin

end;


procedure TXSDObject.Setid(const Value: String);
begin
  Fid := Value;
end;

procedure TXSDObject.SetParent(const Value: TXSDObject);
begin
  FParent := Value;
end;

procedure TXSDObject.SetRefXPath(const Value: String);
begin
  FRefXPath := Value;
end;

{ TXSDElement }

procedure TXSDElement.Assign(Source: TXSDCustomObject);
var
  el: TXSDElement;
  attr : TXSDAttribute;
  i: Integer;
begin
  inherited Assign(Source);
  el := TXSDElement(Source);
 
  el.AssignTyped;// grig

  FmaxOccurs := el.maxOccurs;
  FminOccurs := el.minOccurs;
  FsubstitutionGroup := el.substitutionGroup;
  FAbstract := el.FAbstract;
  Fdefault := el.Fdefault;
  Fnillable := el.nillable;
  FcomplexType.Assign(el.complexType);
  FSimpleType.Assign(el.SimpleType);
  FAttributes.Assign(el.FAttributes);

end;

constructor TXSDElement.Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
begin
  inherited;
  FIsFixed := False;
  FAttributes := TXSDAttributeCollection.Create(ALibrary, Self);
  FcomplexType := TXSDComplexType.Create(ALibrary, Self);
  FSimpleType := TXSDSimpleType.Create(ALibrary, Self);
  FKeys := TXSDElementKeyCollection.Create(ALibrary, Self);
  maxOccurs := 1;
  minOccurs := 1;
end;

destructor TXSDElement.Destroy;
begin
  FreeNil(FAttributes);
  FreeNil(FcomplexType);
  FreeNil(FSimpleType);
  FreeNil(FKeys);
  inherited;
end;

function TXSDElement.GetCollection: TXSDElementObjectCollection;
begin
  Result := FcomplexType.Collection;
end;

function TXSDElement.GetObjectType: TXSDObjectType;
begin
  Result := otElement;
end;

function TXSDElement.GetPrecept(AParent: IkoProcessCustomPrecept): IkoProcessCustomPrecept;
var
  res: TkoProcessPrecept;
  i: Integer;
begin
  Result := TkoXSDElementPrecept.Create(FLibrary.XSDStorage, AParent);
  Result.SetLinkObject(Self);
  if Attributes.Count > 0 then
  begin
    for i := 0 to Attributes.Count - 1 do
      Result.AddChild(Attributes.Items[i].GetPrecept(Result));
  end;
  if complexType.Collection.Count > 0 then
  begin
    Result.AddChild(complexType.Collection.GetPrecept(Result));
  end;
end;

function TXSDElement.GetTextValue(AValue: Variant): Variant;
var
  i: Integer;
  s1, s2: string;
begin
  Result := inherited GetTextValue(AValue);
  if SimpleType.FRestruction.Fenumeration.Count > 0 then
  begin
    s1 := V2S(AValue);
    for i := 0 to SimpleType.FRestruction.Fenumeration.Count - 1 do
    begin
      s2 := V2S(SimpleType.FRestruction.Fenumeration.Items[i].value);
      if CText(s1, s2) then
      begin
        Result := SimpleType.FRestruction.Fenumeration.Items[i].AnnotationText;
        Exit;
      end;
    end;
  end;
end;

function TXSDElement.GetXPathName: string;
begin
  Result := Name;
end;

procedure TXSDElement.InternalAssignTyped;
var
  ctype: TXSDComplexType;
  attr: TXSDAttribute;
  refel: TXSDElement;
  stype: TXSDSimpleType;
  i: integer;
begin

  inherited InternalAssignTyped;
  if Ref <> '' then
  begin

    refel := FLibrary.FElements.GetElementByName(Ref) as TXSDElement;

    if refel <> nil then
    begin
    refel.AssignTyped;
      Assign(refel);
    end;
  end;
  if TypeObj is TXSDComplexType then
  begin
    ctype := TypeObj as TXSDComplexType;

    ctype.AssignTyped;
    FcomplexType.Assign(ctype);
    FcomplexType.AssignTyped;
    FAttributes.Assign(FcomplexType.FAttributes);
  end;
  if TypeObj is TXSDSimpleType then
  begin
    stype := FTypeObject as TXSDSimpleType;
    stype.AssignTyped;
    SimpleType.Assign(stype);
    SimpleType.AssignTyped;
  end;

end;

(*
<annotation
  id = ID
  {any attributes with non-schema namespace . . .}>
  Content: (appinfo | documentation)*
</annotation>
<appinfo
  source = anyURI
  {any attributes with non-schema namespace . . .}>
  Content: ({any})*
</appinfo>
<documentation
  source = anyURI
  xml:lang = language
  {any attributes with non-schema namespace . . .}>
  Content: ({any})*
</documentation>
*)

procedure TXSDElement.LoadObject(AXmlNode: IXMLNode);
var
  st, ct: IXMLNode;
begin
  inherited LoadObject(AXmlNode);
  if AXmlNode.HasAttribute('name') then
    Name := GetStringAttribute(AXmlNode, 'name');
  if AXmlNode.HasAttribute('Abstract') then
    Abstract:= GetBoolAttribute(AXmlNode, 'Abstract');
  if AXmlNode.HasAttribute('default') then
    default:= GetStringAttribute(AXmlNode, 'default');
  if AXmlNode.HasAttribute('ElementType') then
    ElementType:= GetStringAttribute(AXmlNode, 'ElementType');
  if AXmlNode.HasAttribute('maxOccurs') then
    maxOccurs:= GetIntAttribute(AXmlNode, 'maxOccurs');
  if AXmlNode.HasAttribute('minOccurs') then
    minOccurs:= GetIntAttribute(AXmlNode, 'minOccurs');
  if AXmlNode.HasAttribute('ref') then
    ref:= GetStringAttribute(AXmlNode, 'ref');
  if AXmlNode.HasAttribute('substitutionGroup') then
    substitutionGroup:= GetStringAttribute(AXmlNode, 'substitutionGroup');
  if AXmlNode.HasAttribute('nillable') then
    nillable:= GetBoolAttribute(AXmlNode, 'nillable');

  
  ct := AXmlNode.ChildNodes.FindNode('complexType');
  if ct <> nil then
  begin
    FcomplexType.LoadObject(ct);
    FAttributes.Assign(FcomplexType.FAttributes); //grig!!!!
  end;
  if AXmlNode.HasAttribute('fixed') then
    Fixed := GetVariantAttribute(AXmlNode, 'fixed');
  st := AXmlNode.ChildNodes.FindNode('simpleType');
  if st <> nil then
    FSimpleType.LoadObject(st);
  if (AXmlNode.ChildNodes.FindNode('key') <> nil) or
    (AXmlNode.ChildNodes.FindNode('keyref') <> nil) then
    FKeys.LoadObject(AXmlNode);

end;

procedure TXSDElement.SetAbstract(const Value: boolean);
begin
  FAbstract := Value;
end;

procedure TXSDElement.Setdefault(const Value: String);
begin
  Fdefault := Value;
end;

procedure TXSDElement.SetElementType(const Value: String);
begin
  FElementType := Value;
end;

procedure TXSDElement.SetFixed(const Value: Variant);
begin
  FFixed := Value;
  FIsFixed := True;
end;

procedure TXSDElement.SetIsFixed(const Value: Boolean);
begin
  FIsFixed := Value;
end;

procedure TXSDElement.SetmaxOccurs(const Value: integer);
begin
  FmaxOccurs := Value;
end;

procedure TXSDElement.SetminOccurs(const Value: integer);
begin
  FminOccurs := Value;
end;

procedure TXSDElement.Setnillable(const Value: boolean);
begin
  Fnillable := Value;
end;

procedure TXSDElement.SetsubstitutionGroup(const Value: QName);
begin
  FsubstitutionGroup := Value;
end;


{ TXSDElementCollection }

procedure TXSDObjectCollection.Add(AXSDElement: TXSDCustomObject);
begin
  FList.Add(AXSDElement);
end;

function TXSDObjectCollection.IndexOf(AXSDElement: TXSDCustomObject): Integer;
begin
  Result := FList.IndexOf(AXSDElement);
end;

procedure TXSDObjectCollection.Insert(Index: Integer; AXSDElement: TXSDCustomObject);
begin
  FList.Insert(Index, AXSDElement);
end;

procedure TXSDObjectCollection.Clear;
begin
  FList.Clear;
end;

constructor TXSDObjectCollection.Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
begin
  inherited;
  FList := TObjectList.Create(True);
end;

destructor TXSDObjectCollection.Destroy;
begin
  FreeNil(FList);
  inherited;
end;

function TXSDObjectCollection.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TXSDObjectCollection.GetItems(Index: Integer): TXSDCustomObject;
begin
  Result := TXSDCustomObject(FList.Items[Index]);
end;

procedure TXSDObjectCollection.InternalAssignTyped;
var
  i: Integer;
begin
  inherited;
  for i := 0 to Count - 1 do
  begin
    Items[i].AssignTyped;
  end;
end;

function TXSDObjectCollection.IsCollection: Boolean;
begin
  Result := True;
end;

procedure TXSDObjectCollection.LoadObject(AXmlNode: IXMLNode);
begin
  inherited LoadObject(AXmlNode);
end;

procedure TXSDObjectCollection.SetItems(Index: Integer;
  const Value: TXSDCustomObject);
begin

end;

{ TXSDElementCollection }

procedure TXSDElementCollection.Add(AElement: TXSDElement);
begin
  inherited Add(AElement);
end;

procedure TXSDElementCollection.Assign(Source: TXSDCustomObject);
var
  e: TXSDElement;
  s: TXSDElementCollection;
  i: Integer;
begin
  inherited;
  s := Source as TXSDElementCollection;
  for i := 0 to s.Count - 1 do
  begin
    e := TXSDElement.Create(FLibrary, Self);
    e.Assign(s.Items[i]);
    Add(e);
  end;

end;

function TXSDElementCollection.GetElement(Index: Integer): TXSDElement;
begin
  Result := TXSDElement(inherited Items[Index]);
end;

function TXSDElementCollection.GetElementByName(AName: String): TXSDElement;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    if Items[i].Name = AName then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
end;

procedure TXSDElementCollection.LoadObject(AXmlNode: IXMLNode);
var
  el: TXSDElement;
  seqnd: IXMLNode;
  cho: IXMLNode;

  procedure LoadObjects(AXmlNode: IXMLNode);
  var
    nd: IXMLNode;
    ndlst: IXMLNodeList;
    i: Integer;
  begin
    if CText(nd.LocalName, 'choice') or
          CText(nd.LocalName, 'sequence') or
          CText(nd.LocalName, 'all') or
          CText(nd.LocalName, 'group') then
        begin

          if CText(nd.LocalName, 'choice') then
            CollectionType := prChoice;
          if CText(nd.LocalName, 'all') then
            CollectionType := prAll;
          if CText(nd.LocalName, 'group') then
            CollectionType := prGroup;
          if CText(nd.LocalName, 'sequence') then
            CollectionType := prSequence;
        end;

    ndlst := AXmlNode.ChildNodes;
    for i := 0 to ndlst.Count - 1 do
    begin
      nd := ndlst.Nodes[i];
        { TODO : Делаем }
        if CText(nd.LocalName, 'Element') then
        begin
          el := TXSDElement.Create(FLibrary, Self);
          el.LoadObject(nd);
          //lib.XSDFileName := nd.Attributes['schemaLocation'];
          Add(el);
        end;
    end;
  end;
begin
  inherited;
  cho := AXmlNode.ChildNodes.FindNode('choice');
  seqnd := AXmlNode.ChildNodes.FindNode('sequence');
  if seqnd <> nil then
  begin
    CollectionType := prSequence;
    LoadObjects(seqnd);
  end
  else if cho <> nil then
  begin
    CollectionType := prChoice;
    LoadObjects(cho);
  end
  else
  begin
    LoadObjects(AXmlNode);
    CollectionType := prAll;
  end;
end;

procedure TXSDElementCollection.SetElement(Index: Integer;
  const Value: TXSDElement);
begin

end;

{ TXSDIncludeCollection }

procedure TXSDIncludeCollection.Add(AIncludeLib: TXSDLibrary);
begin
  inherited Add(AIncludeLib);
end;

function TXSDIncludeCollection.GetLibrary(Index: Integer): TXSDLibrary;
begin
  Result := TXSDLibrary(inherited Items[Index]);
end;

procedure TXSDIncludeCollection.LoadObject(AXmlNode: IXMLNode);
var
  nd: IXMLNode;
  lib: TXSDLibrary;
  ndl: IXMLNodeList;
  i: Integer;
begin
  inherited;
  ndl := AXmlNode.ChildNodes;
  for i := 0 to ndl.Count - 1 do
  begin
    nd := ndl.Nodes[i];
    try
      if CText(nd.LocalName, 'Include') then
      begin
        lib := TXSDLibrary.Create(FLibrary, Self);
        //lib.XSDFileName :=
        lib.LoadObject(nd);
        Add(lib);
        lib.XSDFileName := ExtractFilePath(FLibrary.XSDFileName) +(lib.XSDFileName);
        lib.LoadXSD();
      end;
      if CText(nd.LocalName, 'redefine') then
      begin
        lib := TXSDLibrary.Create(FLibrary, Self);
        //lib.XSDFileName :=
        lib.LoadNameObject(nd);
        Add(lib);
        lib.XSDFileName := ExtractFilePath(FLibrary.XSDFileName) +(lib.XSDFileName);
        lib.LoadXSD();
        lib.LoadInternalObject(nd);
      end;
    finally

    end;

  end;
end;

procedure TXSDIncludeCollection.SetLibrary(Index: Integer;
  const Value: TXSDLibrary);
begin

end;

{ TXSDAttributeCollection }

procedure TXSDAttributeCollection.Add(AAttribute: TXSDAttribute);
begin
  if AttributeByName(AAttribute.Name) <> nil then
    sleep(0);
  if CText('X', AAttribute.Name) then
    sleep(0);


  inherited Add(AAttribute);
end;

procedure TXSDAttributeCollection.Assign(Source: TXSDCustomObject);
var
  a: TXSDAttribute;
  s: TXSDAttributeCollection;
  i: Integer;
begin
  inherited;
  s := Source as TXSDAttributeCollection;
  for i := 0 to s.Count - 1 do
  begin
    a := TXSDAttribute.Create(FLibrary, Self);
    a.Assign(s.Items[i]);
    Add(a);
  end;
end;

function TXSDAttributeCollection.AttributeByName(AName: String): TXSDAttribute;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if CText(AName, Items[i].Name) then
    begin
      Result := Items[i];
      Exit;
    end;
  end;

end;

function TXSDAttributeCollection.GetAttribute(Index: Integer): TXSDAttribute;
begin
  Result := TXSDAttribute(inherited Items[Index]);
end;

function TXSDAttributeCollection.GetPrecept(
  AParent: IkoProcessCustomPrecept): IkoProcessCustomPrecept;
begin
  Result := TkoXSDAttributePreceptCollection.Create(FLibrary.XSDStorage, AParent);
  Result.LinkObject := Self;
end;

procedure TXSDAttributeCollection.LoadObject(AXmlNode: IXMLNode);
var
  nd: IXMLNode;
  attr: TXSDAttribute;
  nodes: IXMLNodeList;
  i: Integer;
begin
  inherited;
  nodes := AXmlNode.ChildNodes;
  for i := 0 to nodes.Count - 1 do
  begin
      nd := nodes.nodes[i];
      if CText(nd.LocalName, 'attribute') then
      begin
        attr := TXSDAttribute.Create(FLibrary, Self);
        attr.LoadObject(nd);
        //lib.XSDFileName := nd.Attributes['schemaLocation'];
        Add(attr);
      end;

  end;


end;

procedure TXSDAttributeCollection.SetAttribute(Index: Integer;
  const Value: TXSDAttribute);
begin
  inherited SetItems(Index, Value);
end;

{ TXSDAnnotationCollection }

procedure TXSDAnnotationCollection.Add(AAnnotation: TXSDAnnotation);
begin
  inherited Add(AAnnotation);
end;

function TXSDAnnotationCollection.GetAnnotation(Index: Integer): TXSDAnnotation;
begin
  Result := TXSDAnnotation(inherited Items[Index]);
end;

function TXSDAnnotationCollection.GetAnnotationText: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
  begin
    Result := Result+Items[i].Documentation+#13#10;
  end;
end;

procedure TXSDAnnotationCollection.LoadObject(AXmlNode: IXMLNode);
var
  nd: IXMLNode;
  ann: TXSDAnnotation;
  nds: IXMLNodeList;
  i: Integer;
begin
  inherited;
  nds := AXmlNode.ChildNodes;

  for i := 0 to nds.Count - 1 do
  begin
      nd := nds.Nodes[i];
      if CText(nd.LocalName, 'annotation') then
      begin
        ann := TXSDAnnotation.Create(FLibrary, Self);
        //lib.XSDFileName :=
        ann.LoadObject(nd);
        Add(ann);
      end;

  end;
end;

procedure TXSDAnnotationCollection.SetAnnotation(Index: Integer;
  const Value: TXSDAnnotation);
begin
  inherited SetItems(Index, Value);
end;

{ TXSDAnnotation }

procedure TXSDAnnotation.Assign(Source: TXSDCustomObject);
var
  ann: TXSDAnnotation;
begin
  inherited;
  ann := TXSDAnnotation(Source);
  FDocumentationStrList.Assign(ann.FDocumentationStrList);
  Fappinfo := ann.Fappinfo;
end;

constructor TXSDAnnotation.Create(ALibrary: TXSDLibrary; AParent: TXSDObject);
begin
  inherited;
  FDocumentationStrList := TStringList.Create();
end;

destructor TXSDAnnotation.Destroy;
begin
  FreeNil(FDocumentationStrList);
  inherited;
end;

function TXSDAnnotation.GetDocumentation: String;
begin
  Result := FDocumentationStrList.Text;
end;

procedure TXSDAnnotation.LoadObject(AXmlNode: IXMLNode);
var
  nd: IXMLNode;
  nds: IXMLNodeList;
  i: Integer;
  strDoc: String;
begin
  inherited LoadObject(AXmlNode);
  nds := AXmlNode.ChildNodes;
  for i := 0 to nds.Count - 1 do
  begin
    nd := AXmlNode.ChildNodes[i];
    if (nd.LocalName = 'documentation') then
    begin
      strDoc := nd.Text;
      strDoc := StringReplace(strDoc, #10, '', []);
      strDoc := StringReplace(strDoc, #13, '', []);
      strDoc := StringReplace(strDoc, #9, '', []);
      strDoc := Trim(strDoc);
      FDocumentationStrList.Add(strDoc);
    end;
  end;



  nd := AXmlNode.ChildNodes.FindNode('Appinfo');
  if nd <> nil then
    Appinfo := nd.Text;
end;

procedure TXSDAnnotation.Setappinfo(const Value: String);
begin
  Fappinfo := Value;
end;

procedure TXSDAnnotation.Setdocumentation(const Value: String);
begin
  FDocumentationStrList.Text := Value;
end;

{ TXSDComplexTypeCollection }

procedure TXSDComplexTypeCollection.Add(AElement: TXSDComplexType);
begin
  inherited Add(AElement);
end;

function TXSDComplexTypeCollection.GetComplexType(
  Index: Integer): TXSDComplexType;
begin
  Result := TXSDComplexType(inherited Items[Index]);
end;

procedure TXSDComplexTypeCollection.LoadObject(AXmlNode: IXMLNode);
var
  nd: IXMLNode;
  nds: IXMLNodeList;
  cty: TXSDComplexType;
  i: Integer;
begin
  inherited;
  nds := AXmlNode.ChildNodes;
  for i := 0 to nds.Count - 1 do
  begin
    nd := nds.Nodes[i];
    if CText(nd.LocalName, 'complexType') then
    begin
      cty := TXSDComplexType.Create(FLibrary, Self);
      //lib.XSDFileName :=
      cty.LoadObject(nd);
      Add(cty);
    end;
  end;
end;

procedure TXSDComplexTypeCollection.SetComplexType(Index: Integer;
  const Value: TXSDComplexType);
begin
  inherited SetItems(Index, Value);
end;

{ TXSDComplexType }

procedure TXSDComplexType.Assign(Source: TXSDCustomObject);
var
  ctype: TXSDComplexType;
  el: TXSDElement;
  col: TXSDElementObjectCollection;
  i: Integer;
begin
  inherited Assign(Source);
  ctype := TXSDComplexType(Source);
  Collection.CollectionType := ctype.Collection.CollectionType;
  for i := 0 to ctype.Collection.Count - 1 do
  begin
    Has := True;
    if ctype.Collection[i] is TXSDElement then
    begin
      el := TXSDElement.Create(OwnerLibrary, Self);
      el.Assign(ctype.Collection[i]);
      Collection.Add(el);
      Collection.Has := True;
    end;
    if ctype.Collection[i] is TXSDElementObjectCollection then
    begin
      col := TXSDElementObjectCollection.Create(OwnerLibrary, Self);
      col.Assign(ctype.Collection[i]);
      Collection.Add(col);
      Collection.Has := True;
    end;
  end;
  Attributes.Assign(ctype.Attributes);
  FComplexContent.Assign(ctype.ComplexContent);
  FSimpleContent.Assign(ctype.SimpleContent);
  //Name := '';
end;

constructor TXSDComplexType.Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
begin
  inherited;
  FAnotations := TXSDAnnotationCollection.Create(ALibrary, Self);
  FCollection := TXSDElementObjectCollection.Create(ALibrary, Self);
  FAttributes := TXSDAttributeCollection.Create(ALibrary, Self);
  FComplexContent := TXSDComplexContent.Create(ALibrary, Self);
  FSimpleContent := TXSDSimpleContent.Create(ALibrary, Self);
  Has := False;
end;

destructor TXSDComplexType.Destroy;
begin
  FreeNil(FCollection);
  FreeNil(FAnotations);
  FreeNil(FAttributes);
  FreeNil(FComplexContent);
  FreeNil(FSimpleContent);
  inherited;
end;

function TXSDComplexType.GetIsTypeObject: Boolean;
begin
  Result := True;
end;

function TXSDComplexType.GetXPathName: string;
begin
  Result := inherited;
  //if TypeApplied then
  begin
    Result := '';
  end;
end;

procedure TXSDComplexType.InternalAssignTyped;
begin
  inherited;
  if Name = 'tRegister' then
    sleep(0);
  FComplexContent.AssignTyped;
  FSimpleContent.AssignTyped;
end;

procedure TXSDComplexType.LoadObject(AXmlNode: IXMLNode);
var
  chnd: IXMLNode;
  procedure LoadsimpleContent(AXmlNode: IXMLNode);
  begin
    FSimpleContent.LoadObject(AXmlNode);
  end;
  procedure LoadcomplexContent(AXmlNode: IXMLNode);
  begin
    FComplexContent.LoadObject(AXmlNode);
  end;
begin
  inherited;

  if Name = 'tObjectLot' then
  begin
    Sleep(0);
  end;
  

  if AXmlNode.HasAttribute('mixed') then
    Fmixed := AXmlNode.Attributes['mixed'];
  if AXmlNode.HasAttribute('defaultAttributesApply') then
    defaultAttributesApply := AXmlNode.Attributes['defaultAttributesApply'];

  FAnotations.LoadObject(AXmlNode);
  FCollection.LoadObject(AXmlNode);
  FAttributes.LoadObject(AXmlNode);
  //simpleContent | complexContent
  chnd := AXmlNode.ChildNodes.FindNode('simpleContent');
  if chnd <> nil then
  begin
    LoadsimpleContent(chnd);
    Attributes.Assign(SimpleContent.Extension.Attributes);
  end;
  chnd := AXmlNode.ChildNodes.FindNode('complexContent');
  if chnd <> nil then
  begin
    LoadcomplexContent(chnd);
    Attributes.Assign(ComplexContent.Extension.Attributes);
    Collection.Assign(ComplexContent.Extension.Collection);
    Collection.Assign(ComplexContent.Restriction.Collection);
  end;

  Has := True;
end;


procedure TXSDComplexType.SetComplexContent(const Value: TXSDComplexContent);
begin
  FComplexContent := Value;
end;

procedure TXSDComplexType.SetdefaultAttributesApply(const Value: boolean);
begin
  FdefaultAttributesApply := Value;
end;

procedure TXSDComplexType.Setmixed(const Value: boolean);
begin
  Fmixed := Value;
end;

procedure TXSDComplexType.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TXSDComplexType.SetSimpleContent(const Value: TXSDSimpleContent);
begin
  FSimpleContent := Value;
end;

{ TXSDAttribute }


procedure TXSDAttribute.Assign(Source: TXSDCustomObject);
var
  attr: TXSDAttribute;
begin
  inherited Assign(Source);
  attr := Source as TXSDAttribute;
  use := attr.use;
  default := attr.default;
  fixed := attr.fixed;
  SimpleType.Assign(attr.SimpleType);
end;

constructor TXSDAttribute.Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
begin
  inherited;
  FSimpleType := TXSDSimpleType.Create(ALibrary, Self);
end;

destructor TXSDAttribute.Destroy;
begin
  FreeNil(FSimpleType);
  inherited;
end;

function TXSDAttribute.GetObjectType: TXSDObjectType;
begin
  Result := otAttribute;
end;

function TXSDAttribute.GetPrecept(
  AParent: IkoProcessCustomPrecept): IkoProcessCustomPrecept;
begin
  Result := TkoXSDAttributePrecept.Create(FLibrary.XSDStorage, AParent);
  Result.LinkObject := Self;
end;

function TXSDAttribute.GetRestruction: TXSDRestriction;
begin
  Result := nil;
  if SimpleType.Has and SimpleType.Restruction.Has then
  Result := SimpleType.Restruction;
end;

function TXSDAttribute.GetTextValue(AValue: Variant): Variant;
var
  i: Integer;
  s1, s2: string;
begin
  Result := inherited GetTextValue(AValue);
  if SimpleType.FRestruction.Fenumeration.Count > 0 then
  begin
    s1 := V2S(AValue);
    for i := 0 to SimpleType.FRestruction.Fenumeration.Count - 1 do
    begin
      s2 := V2S(SimpleType.FRestruction.Fenumeration.Items[i].value);
      if CText(s1, s2) then
      begin
        Result := SimpleType.FRestruction.Fenumeration.Items[i].AnnotationText;
        Exit;
      end;
    end;
  end;

end;

procedure TXSDAttribute.InternalAssignTyped;
var
  stype: TXSDSimpleType;
begin
  inherited;
  if TypeObj is TXSDSimpleType then
  begin
    stype := FTypeObject as TXSDSimpleType;
    SimpleType.Assign(stype);
    SimpleType.Has := True;
  end;
end;

procedure TXSDAttribute.LoadObject(AXmlNode: IXMLNode);
var
  st: IXMLNode;
  ustr: string;
begin
  inherited LoadObject(AXmlNode);
  Fname := GetStringAttribute(AXmlNode, 'name');
  //Fuse :=
  ustr := GetStringAttribute(AXmlNode, 'use');
  if ustr <> '' then
  begin
    if CText(ustr, 'optional') then
      use := xsdOptional
    else if CText(ustr, 'prohibited') then
      use := xsdProhibited
    else if CText(ustr, 'required') then
      use := xsdRequired;
  end;
  Fdefault := GetStringAttribute(AXmlNode, 'default');
  Ffixed := GetStringAttribute(AXmlNode, 'fixed');
  st := AXmlNode.ChildNodes.FindNode('simpleType');
  if Name = 'CodeType' then
    sleep(0);
  if st <> nil then
    FSimpleType.LoadObject(st);


end;

procedure TXSDAttribute.Setdefault(const Value: string);
begin
  Fdefault := Value;
end;

procedure TXSDAttribute.Setfixed(const Value: string);
begin
  Ffixed := Value;
end;

procedure TXSDAttribute.Setname(const Value: NCName);
begin
  Fname := Value;
end;

procedure TXSDAttribute.Setref(const Value: QName);
begin
  Fref := Value;
end;

procedure TXSDAttribute.Setuse(const Value: TXSDUse);
begin
  Fuse := Value;
end;

{ TXSDSimpleType }

procedure TXSDSimpleType.Assign(Source: TXSDCustomObject);
var
  stype: TXSDSimpleType;
begin
  inherited;
  stype := Source as TXSDSimpleType;
  Has := stype.Has;

  if stype.Restruction.Has then
  begin
    Restruction.Assign(stype.Restruction);
  end;

end;

constructor TXSDSimpleType.Create(ALibrary: TXSDLibrary; AParent: TXSDObject = nil);
begin
  inherited;
  FRestruction := TXSDRestriction.Create(ALibrary, Self);
end;

destructor TXSDSimpleType.Destroy;
begin
  FreeNil(FRestruction);
  inherited;
end;

function TXSDSimpleType.GetIsTypeObject: Boolean;
begin
  Result := True;
end;

function TXSDSimpleType.GetTextValue(AValue: Variant): Variant;
var
  i: Integer;
  s1, s2: string;
begin
  Result := inherited GetTextValue(AValue);
  if FRestruction.Fenumeration.Count > 0 then
  begin
    s1 := V2S(AValue);
    for i := 0 to FRestruction.Fenumeration.Count - 1 do
    begin
      s2 := V2S(FRestruction.Fenumeration.Items[i].value);
      if CText(s1, s2) then
      begin
        Result := FRestruction.Fenumeration.Items[i].AnnotationText;
        Exit;
      end;
    end;
  end;
end;

procedure TXSDSimpleType.InternalAssignTyped;
begin
  inherited;

  FRestruction.AssignTyped;
end;

procedure TXSDSimpleType.LoadObject(AXmlNode: IXMLNode);
var
  res: IXMLNode;
begin
  inherited LoadObject(AXmlNode);
  if Name = 's255' then
      Sleep(0);
  res := AXmlNode.ChildNodes.FindNode('restriction');
  if res <> nil then
  begin
    Restruction.LoadObject(res);
  end;

end;

procedure TXSDSimpleType.SetHas(const Value: Boolean);
begin
  FHas := Value;
end;

{ TXSDCustomObject }

procedure TXSDCustomObject.Afterload;
begin

end;

procedure TXSDCustomObject.Assign(Source: TXSDCustomObject);
var
  xsd: TXSDCustomObject;
begin
  //inherited Assign(Source);
  if not CText(Source.ClassName, Self.ClassName) then
  begin
    Source.AssignTo(Self);
  end;
  if FAssigned then Exit;
  FAssigned := true;
  xsd := TXSDCustomObject(Source);
  xsd.AssignTyped; //grig1

  FTypeApplied := xsd.FTypeApplied;
  if Name = 'Area' then
    Sleep(0);

  Type_ :=
    xsd.Type_;
  FHas := xsd.Has;
  if Name = '' then
    Name := xsd.Name;
  FInternalDataType := Source.FInternalDataType;
end;

procedure TXSDCustomObject.AssignTyped();
begin
  if not FLibrary.Loaded then Exit;
  if FTypeApplied then Exit;
  FTypeApplied := True;
 // if {(TypeObj <> nil) or} true  then  //IsRef
  begin
    InternalAssignTyped;
  end;

end;

constructor TXSDCustomObject.Create(ALibrary: TXSDLibrary; AParent: TXSDObject);
begin
  inherited Create;
  FInternalDataType := vtUnknown;
  FLibrary := ALibrary;
  FParent := AParent;
  FTypeObject := nil;
end;

function TXSDCustomObject.GetClassName: String;
begin
  Result := inherited ClassName;
end;

function TXSDCustomObject.GetIsRef: Boolean;
begin
  Result := False;
end;

function TXSDCustomObject.GetIsTypeObject: Boolean;
begin
  Result := False;
end;

function TXSDCustomObject.GetLibrary: TXSDLibrary;
begin
  Result := nil;
  if FLibrary <> Self then
    Result := FLibrary;

end;

function TXSDCustomObject.GetLibraryName: String;
begin
  Result := '';
  if OwnerLibrary <> nil then
    Result := OwnerLibrary.FXSDFileName;
end;

function TXSDCustomObject.GetName: NCName;
begin
  Result := FName;
end;

function TXSDCustomObject.GetRefObj: TXSDCustomObject;
begin
  Result := nil;
  if FRef <> '' then
  begin
    if FRefObject = nil then
    begin
      FRefObject := FLibrary.GetRefByName(FRef);
    end;
  end;
  Result := FRefObject;
end;

function TXSDCustomObject.GetTypeObj: TXSDCustomObject;
begin
  Result := nil;
  if FTypeName <> '' then
  begin
    if FTypeObject = nil then
    begin
      FTypeObject := FLibrary.GetTypeByName(FTypeName);
    end;
  end;
  Result := FTypeObject;
end;

procedure TXSDCustomObject.InternalAssignTyped;
begin
  sleep(0);
end;

function TXSDCustomObject.GetStringAttribute(ANode: IXMLNode;
  AAtrubute: String): string;
begin
  Result := '';
  if ANode.HasAttribute(AAtrubute) then
    Result := ANode.AttributeNodes.FindNode(AAtrubute).NodeValue;
end;

function TXSDCustomObject.GetVariantAttribute(ANode: IXMLNode;
  AAtrubute: String): Variant;
begin
  if ANode.HasAttribute(AAtrubute) then
    Result := ANode.AttributeNodes.FindNode(AAtrubute).NodeValue;
end;


procedure TXSDCustomObject.SetXPath(const Value: String);
begin

end;

function TXSDCustomObject.GetXPath: String;
var
  par: TXSDCustomObject;
begin
  par := Self.Parent;
  Result := '';
  if XPathName <> '' then
    Result := XPathName;
  while par <> nil do
  begin

    if par.XPathName <> '' then
    begin
      //if Result <> '' then
        Result := par.XPathName+'/'+Result;
    end;
      //Result := par.Name+'('+par.ClassName+')'+'/'+Result;
    par := par.Parent;
  end;
  Result := '/'+Result;
end;


function TXSDCustomObject.GetXPathName: NCName;
begin
  Result := Name;
end;

function TXSDCustomObject.GetBoolAttribute(ANode: IXMLNode;
  AAtrubute: String): Boolean;
begin
  Result := False;
  if ANode.HasAttribute(AAtrubute) then Result := ANode.Attributes[AAtrubute];
end;

function TXSDCustomObject.GetIntAttribute(ANode: IXMLNode;
  AAtrubute: String): Integer;
begin
  Result := -1;
  if ANode.HasAttribute(AAtrubute) then
  begin
    try
      if ctext(ANode.Attributes[AAtrubute], 'Unbounded') then
        exit;
      Result := ANode.Attributes[AAtrubute];
    except
      on e: Exception do
      begin
        Note(ANode.XML);
      end;
    end;
  end;
end;

procedure TXSDCustomObject.LoadObject(AXmlNode: IXMLNode);
begin
  Has := True;
  Type_ := GetStringAttribute(AXmlNode, 'type');
  if Type_ <> '' then
    FLibrary.TypedObjs.Add(Self);
end;

procedure TXSDCustomObject.SetAssigned(const Value: Boolean);
begin
  FAssigned := Value;
end;

procedure TXSDCustomObject.SetClassName(const Value: String);
begin

end;

procedure TXSDCustomObject.SetHas(const Value: Boolean);
begin
  FHas := Value;
end;

procedure TXSDCustomObject.Setid(const Value: String);
begin
  Fid := Value;
end;

procedure TXSDCustomObject.SetIsRef(const Value: Boolean);
begin

end;

procedure TXSDCustomObject.SetName(const Value: NCName);
begin
  FName := Value;
end;

procedure TXSDCustomObject.SetParent(const Value: TXSDCustomObject);
begin
  FParent := Value;
end;

procedure TXSDCustomObject.SetRef(const Value: String);
begin
  FRef := Value;
  if FRef <> '' then
    FLibrary.FTypedObjs.Add(Self);
end;

procedure TXSDCustomObject.SetTypeApplied(const Value: Boolean);
begin
  FTypeApplied := Value;
end;
{
string normalizedString token
byte unsignedByte
base64Binary hexBinary
integer positiveInteger negativeInteger nonNegativeInteger nonPositiveInteger
int unsignedInt
long unsignedLong
short unsignedShort
decimal float double
boolean
time dateTime duration
date gMonth gYear gYearMonth gDay gMonthDay
Name QName NCName
anyURI
language
ID IDREF IDREFS ENTITY ENTITIES NOTATION NMTOKEN NMTOKENS
}

function GetInternalDataType(AString: String): TkoProcessDataType;
begin
  Result := vtUnknown;
  if CText(AString, 'string') or
    CText(AString, 'normalizedString') or
    CText(AString, 'token')or
    CText(AString, 'Name') or
    CText(AString, 'QName') or
    CText(AString, 'NCName') then
      Result := vtString

  else if CText(AString, 'byte') or
    CText(AString, 'unsignedByte') then
      Result := vtByte

  else if CText(AString, 'integer') or
    CText(AString, 'positiveInteger') or
    CText(AString, 'negativeInteger') or
    CText(AString, 'nonNegativeInteger') or
    CText(AString, 'nonPositiveInteger') or
    CText(AString, 'int') or
    CText(AString, 'unsignedInt') then
      Result := vtInteger

   else if CText(AString, 'base64Binary') or
    CText(AString, 'hexBinary') then
      Result := vtBinary

   else if CText(AString, 'decimal') or
    CText(AString, 'float') or
    CText(AString, 'double') then
      Result := vtString

   else if CText(AString, 'boolean') then
      Result := vtBoolean

    else if CText(AString, 'time') or
    CText(AString, 'dateTime') or
    CText(AString, 'duration') or
    CText(AString, 'date') or
    CText(AString, 'gMonth') or
    CText(AString, 'gYear') or
    CText(AString, 'gYearMonth') or
    CText(AString, 'gDay') or
    CText(AString, 'gMonthDay') then
      Result := vtDateTime;


  
end;

procedure TXSDCustomObject.SetTypeName(const Value: String);
begin

  FTypeName := Value;
  if (Trim(Value) <> '') and (Pos(':', Value) = 0) then
  begin
    FLibrary.TypedObjs.Add(Self)
  end else if (FInternalDataType = vtUnknown) and
   (Trim(Value) <> '') and (Pos(':', Value) > 0) then

  begin
    FInternalDataType := GetInternalDataType(
      ReplaceStr(Trim(Value), FLibrary.FGlobalNameSpace+':', ''));
  end;
end;

{ TXSDTypedCollection }

procedure TXSDTypedCollection.Add(AXSDElement: TXSDCustomObject);
begin
  if IndexOf(AXSDElement) >= 0 then Exit;

  inherited;

end;

constructor TXSDTypedCollection.Create(ALibrary: TXSDLibrary;
  AParent: TXSDObject);
begin
  inherited;
  FList.OwnsObjects := False;
end;

{ TXSDSimpleTypeCollection }

procedure TXSDSimpleTypeCollection.Add(AElement: TXSDSimpleType);
begin
  inherited Add(AElement);
end;

function TXSDSimpleTypeCollection.GetSimpleType(Index: Integer): TXSDSimpleType;
begin
  Result := TXSDSimpleType(inherited Items[Index]);
end;

procedure TXSDSimpleTypeCollection.LoadObject(AXmlNode: IXMLNode);
var
  nd: IXMLNode;
  nds: IXMLNodeList;
  sty: TXSDSimpleType;
  i: Integer;
begin
  inherited;
  nds := AXmlNode.ChildNodes;

  for i := 0 to nds.Count - 1 do
  begin
    nd := nds.Nodes[i];
      if CText(nd.LocalName, 'simpleType') then
      begin
        sty := TXSDSimpleType.Create(FLibrary, Self);
        //lib.XSDFileName :=
        sty.LoadObject(nd);
        Add(sty);
      end;
  end;

end;

procedure TXSDSimpleTypeCollection.SetSimpleType(Index: Integer;
  const Value: TXSDSimpleType);
begin
  inherited SetItems(Index, Value);
end;

{ TXSDEenumeration }

procedure TXSDEnumeration.LoadObject(AXmlNode: IXMLNode);
begin
  inherited;
  value := GetVariantAttribute(AXmlNode, 'value');
end;

procedure TXSDEnumeration.Setvalue(const Value: Variant);
begin
  Fvalue := Value;
end;

{ TXSDRestruction }

procedure TXSDRestriction.Assign(Source: TXSDCustomObject);
var
  restr: TXSDRestriction;
  i: Integer;
  enum: TXSDEnumeration;
begin
  inherited Assign(Source);
  restr := Source as TXSDRestriction;
  length := restr.length;
  maxLength := restr.maxLength;
  minLength := restr.minLength;
  fractionDigits := restr.fractionDigits;
  maxExclusive := restr.maxExclusive;
  maxInclusive := restr.maxInclusive;
  minExclusive := restr.minExclusive;
  minInclusive := restr.minInclusive;
  totalDigits := restr.totalDigits;

  //enumeration: TXSDEnumerationCollection;
  base := restr.base;
  for i := 0 to restr.enumeration.Count - 1 do
  begin
    Has := True;
    enum := TXSDEnumeration.Create(OwnerLibrary, Self);
    enum.value := restr.enumeration[i].value;
    enum.Annotation.Has := true;
    enum.Annotation.Documentation := restr.enumeration[i].Annotation.Documentation;
    enumeration.Add(enum);
    enumeration.Has := true;
  end;

end;

constructor TXSDRestriction.Create(ALibrary: TXSDLibrary; AParent: TXSDObject);
begin
  inherited;
  Fenumeration := TXSDEnumerationCollection.Create(ALibrary, Self);
  FmaxExclusive := Null;
  FmaxInclusive := Null;
  FminExclusive := Null;
  FminInclusive := Null;
end;

destructor TXSDRestriction.Destroy;
begin
  FreeNil(Fenumeration);
  inherited;
end;

function TXSDRestriction.GetParentElement: TXSDElement;
begin
  Result := nil;
end;

function TXSDRestriction.GetTypeObj: TXSDCustomObject;
begin
  Result := inherited;
  if base <> '' then
    Result := FLibrary.GetTypeByName(base);

end;

procedure TXSDRestriction.InternalAssignTyped;
var
  tobj: TXSDCustomObject;
  st: TXSDSimpleType;
  ct: TXSDComplexType;
  procedure Assign(ARestr: TXSDRestriction);
  var
    //restr: TXSDRestriction;
    i: Integer;
    enum: TXSDEnumeration;
  begin
    //ARestr := st.Restruction;
    if ARestr.base = 's255' then
      Sleep(0);
    if length <= 0 then length := ARestr.length;
    if maxLength <= 0 then maxLength := ARestr.maxLength;
    if minLength <= 0 then minLength := ARestr.minLength;
    if fractionDigits <= 0 then fractionDigits := ARestr.fractionDigits;
    if maxExclusive <= 0 then maxExclusive := ARestr.maxExclusive;
    if maxInclusive <= 0 then maxInclusive := ARestr.maxInclusive;
    if minExclusive <= 0 then minExclusive := ARestr.minExclusive;
    if minInclusive <= 0 then minInclusive := ARestr.minInclusive;
    if totalDigits <= 0 then totalDigits := ARestr.totalDigits;
    //enumeration: TXSDEnumerationCollection;

    for i := 0 to ARestr.enumeration.Count - 1 do
    begin
      enum := TXSDEnumeration.Create(OwnerLibrary, Self);
      enum.value := ARestr.enumeration[i].value;
      enum.Annotation.Has := true;
      enum.Annotation.Documentation := ARestr.enumeration[i].Annotation.Documentation;
      enumeration.Add(enum);
      enumeration.Has := True;
    end;
    base := ARestr.base;
  end;
begin
  inherited InternalAssignTyped;
  if base <> '' then
  begin

    tobj := FLibrary.GetTypeByName(base);
    if tobj <> nil then
    begin
      tobj.AssignTyped;
      if (tobj is TXSDSimpleType) then
      begin
        st := tobj as TXSDSimpleType;
        Assign(st.Restruction);
      end;
      if (tobj is TXSDComplexType) then
      begin
        ct := tobj as TXSDComplexType;
        if ct.SimpleContent.Has then
        begin
          if ct.SimpleContent.Restriction.Has then
            Assign(ct.SimpleContent.Restriction);
          if ct.SimpleContent.Extension.has then
            base := ct.SimpleContent.Extension.Base;
          Has := True;
        end;
      end;
    end;

  end;

end;

procedure TXSDRestriction.LoadObject(AXmlNode: IXMLNode);
  function GetSubNodeValue(ANode: IXMLNode; ASubNodeName: string): Variant;
  var
    snode: IXMLNode;
  begin
    Result := Unassigned;
    snode := ANode.ChildNodes.FindNode(ASubNodeName);
    if snode <> nil then
      Result := snode.Attributes['value'];
  end;
begin
  inherited LoadObject(AXmlNode);
  if AXmlNode.HasAttribute('base') then
    base := GetStringAttribute(AXmlNode, 'base');
  FInternalDataType := GetInternalDataType(
      ReplaceStr(Trim(base), FLibrary.FGlobalNameSpace+':', ''));
  //if (base <> '') and (Pos(OwnerLibrary.GlobalNameSpace + ':', base) = 0) then
  if Parent is TXSDSimpleContent then
    FLibrary.TypedObjs.Add(Self);

  if AXmlNode.ChildNodes.FindNode('minExclusive') <> nil then
  minExclusive := GetSubNodeValue(AXmlNode, 'minExclusive');
  if AXmlNode.ChildNodes.FindNode('minInclusive') <> nil then
  minInclusive := GetSubNodeValue(AXmlNode, 'minInclusive');
  if AXmlNode.ChildNodes.FindNode('maxExclusive') <> nil then
  maxExclusive := GetSubNodeValue(AXmlNode, 'maxExclusive');
  if AXmlNode.ChildNodes.FindNode('maxInclusive') <> nil then
  maxInclusive := GetSubNodeValue(AXmlNode, 'maxInclusive');
  if AXmlNode.ChildNodes.FindNode('totalDigits') <> nil then
  totalDigits := GetSubNodeValue(AXmlNode, 'totalDigits');
  if AXmlNode.ChildNodes.FindNode('fractionDigits') <> nil then
  fractionDigits := GetSubNodeValue(AXmlNode, 'fractionDigits');
  if AXmlNode.ChildNodes.FindNode('length') <> nil then
  length := GetSubNodeValue(AXmlNode, 'length');
  if AXmlNode.ChildNodes.FindNode('minLength') <> nil then
  minLength := GetSubNodeValue(AXmlNode, 'minLength');
  if AXmlNode.ChildNodes.FindNode('maxLength') <> nil then
  maxLength := GetSubNodeValue(AXmlNode, 'maxLength');
  if AXmlNode.ChildNodes.FindNode('pattern') <> nil then
  Pattern := GetSubNodeValue(AXmlNode, 'pattern');
  if AXmlNode.ChildNodes.FindNode('enumeration') <> nil then
  begin
    Fenumeration.LoadObject(AXmlNode);
  end;
end;

procedure TXSDRestriction.Setbase(const Value: String);
begin
  Fbase := Value;
  if FfirstBase = '' then FfirstBase := Value;
  if Fbase = 's255' then
      Sleep(0);
end;

procedure TXSDRestriction.SetfractionDigits(const Value: Integer);
begin
  FfractionDigits := Value;
end;

procedure TXSDRestriction.Setlength(const Value: Integer);
begin
  Flength := Value;
end;

procedure TXSDRestriction.SetmaxExclusive(const Value: Variant);
begin
  FmaxExclusive := Value;
end;

procedure TXSDRestriction.SetmaxInclusive(const Value: Variant);
begin
  FmaxInclusive := Value;
end;

procedure TXSDRestriction.SetmaxLength(const Value: Integer);
begin
  FmaxLength := Value;
end;

procedure TXSDRestriction.SetminExclusive(const Value: Variant);
begin
  FminExclusive := Value;
end;

procedure TXSDRestriction.SetminInclusive(const Value: Variant);
begin
  FminInclusive := Value;
end;

procedure TXSDRestriction.SetminLength(const Value: Integer);
begin
  FminLength := Value;
end;

procedure TXSDRestriction.SetPattern(const Value: String);
begin
  FPattern := Value;
end;

procedure TXSDRestriction.SettotalDigits(const Value: Integer);
begin
  FtotalDigits := Value;
end;

{ TXSDEenumerationCollection }

procedure TXSDEnumerationCollection.Add(Aenumeration: TXSDenumeration);
begin
  inherited add(Aenumeration);
end;

procedure TXSDEnumerationCollection.Assign(Source: TXSDCustomObject);
var
  e: TXSDEnumeration;
  s: TXSDEnumerationCollection;
  i: Integer;
begin
  inherited;
  s := Source as TXSDEnumerationCollection;
  for i := 0 to s.Count - 1 do
  begin
    e := TXSDEnumeration.Create(FLibrary, Self);
    e.Assign(s.Items[i]);
    Add(e);
  end;
end;

function TXSDEnumerationCollection.Getenumeration(
  Index: Integer): TXSDEnumeration;
begin
  Result := TXSDEnumeration(inherited Items[Index]);
end;

procedure TXSDEnumerationCollection.LoadObject(AXmlNode: IXMLNode);
var
  nd: IXMLNode;
  nds: IXMLNodeList;
  en: TXSDEnumeration;
  i: Integer;

begin
  inherited LoadObject(AXmlNode);
  nds := AXmlNode.ChildNodes;
  for i := 0 to nds.Count - 1 do
  begin
    nd := nds.Nodes[i];
    if CText(nd.LocalName, 'enumeration')  then
    begin
      en := TXSDEnumeration.Create(FLibrary, Self);
      en.LoadObject(nd);
      Add(en);
    end;
  end;
end;

procedure TXSDEnumerationCollection.Setenumeration(Index: Integer;
  const Value: TXSDEnumeration);
begin

end;


{ TXSDComplexContent }

constructor TXSDComplexContent.Create(ALibrary: TXSDLibrary;
  AParent: TXSDObject);
begin
  inherited;
  FRestruction := TXSDComplexContentRestriction.Create(ALibrary, Self);
  FExtension := TXSDComplexContentExtension.Create(ALibrary, Self);
end;

destructor TXSDComplexContent.Destroy;
begin
  FreeNil(FExtension);
  FreeNil(FRestruction);
  inherited;
end;

procedure TXSDComplexContent.InternalAssignTyped;
begin
  inherited;
  FRestruction.AssignTyped;
  FExtension.AssignTyped;
end;

procedure TXSDComplexContent.LoadObject(AXmlNode: IXMLNode);
var
  ch: IXMLNode;
begin
  inherited;
  ch := AXmlNode.ChildNodes.FindNode('restriction');
  if ch <> nil then
    Restriction.LoadObject(ch);

  ch := AXmlNode.ChildNodes.FindNode('extension');
  if ch <> nil then
  begin
    Extension.LoadObject(ch);
  end;

end;

{ TXSDComplexContentRestruction }

constructor TXSDComplexContentRestriction.Create(ALibrary: TXSDLibrary;
  AParent: TXSDObject);
begin
  inherited;
  FAttributes := TXSDAttributeCollection.Create(ALibrary, Self);
  FCollection := TXSDElementObjectCollection.Create(ALibrary, Self);
end;

destructor TXSDComplexContentRestriction.Destroy;
begin
  FreeNil(FAttributes);
  FreeNil(FCollection);
  inherited;
end;

function TXSDComplexContentRestriction.GetTypeObj: TXSDCustomObject;
begin
  Result := inherited GetTypeObj;
  if FBase <> '' then
  begin
    if FTypeObject = nil then
    begin
      FTypeObject := FLibrary.GetTypeByName(FBase);

    end;
  end;
  Result := FTypeObject;

end;

procedure TXSDComplexContentRestriction.LoadObject(AXmlNode: IXMLNode);
begin
  inherited;
  if AXmlNode.HasAttribute('base') then
  begin
    Base := AXmlNode.Attributes['base'];
    FLibrary.TypedObjs.Add(Self);
  end;

  FAttributes.LoadObject(AXmlNode);
  FCollection.LoadObject(AXmlNode);
end;

procedure TXSDComplexContentRestriction.SetBase(const Value: String);
begin
  FBase := Value;
  FFirstBase := Value;
end;

procedure TXSDComplexContentRestriction.SetFirstBase(const Value: String);
begin
  FFirstBase := Value;
end;

{ TXSDSimpleContent }

constructor TXSDSimpleContent.Create(ALibrary: TXSDLibrary;
  AParent: TXSDObject);
begin
  inherited;
  FRestriction := TXSDRestriction.Create(ALibrary, Self);
  FExtension := TXSDSimpleContentExtension.Create(ALibrary, Self);
end;

destructor TXSDSimpleContent.Destroy;
begin
  FreeNil(FRestriction);
  FreeNil(FExtension);
  inherited;
end;

function TXSDSimpleContent.GetTypeObj: TXSDCustomObject;
begin
  Result := FTypeObject;

end;

procedure TXSDSimpleContent.InternalAssignTyped;
var
  el: TXSDElement;
begin
  inherited;
  if restriction.base = 'tCadastral_Number' then
    sleep(0);

  if restriction.Has then
  begin
    if (Parent <> nil) and (Parent is TXSDComplexType) and
      (Parent.Parent <> nil) and (Parent.Parent is TXSDElement) then
    begin
      Restriction.AssignTyped;
      el := Parent.Parent as TXSDElement;
      sleep(0);
      el.SimpleType.Has := True;
      el.SimpleType.Restruction.Assign(Restriction);
    end;

  end;

  if extension.Has then
  begin
    if Parent <> nil then
      sleep(0);
  end;

end;

procedure TXSDSimpleContent.LoadObject(AXmlNode: IXMLNode);
var
  ch: IXMLNode;
begin
  inherited;
  ch := AXmlNode.ChildNodes.FindNode('restriction');
  if ch <> nil then
  begin
    restriction.LoadObject(ch);
    FLibrary.TypedObjs.Add(Self);
  end;

  ch := AXmlNode.ChildNodes.FindNode('extension');
  if ch <> nil then
  begin
    Extension.LoadObject(ch);
    FLibrary.TypedObjs.Add(Self);
  end;

end;

{ TXSDComplexContentExtension }

constructor TXSDComplexContentExtension.Create(ALibrary: TXSDLibrary;
  AParent: TXSDObject);
begin
  inherited;
  FAttributes := TXSDAttributeCollection.Create(ALibrary, Self);
  FCollection := TXSDElementObjectCollection.Create(ALibrary, Self);
end;

destructor TXSDComplexContentExtension.Destroy;
begin
  FreeNil(FAttributes);
  FreeNil(FCollection);
  inherited;
end;

function TXSDComplexContentExtension.GetTypeObj: TXSDCustomObject;
begin
  Result := inherited GetTypeObj;
  if FBase <> '' then
  begin
    if FTypeObject = nil then
    begin
      FTypeObject := FLibrary.GetTypeByName(FBase);

    end;
  end;
  Result := FTypeObject;
end;

procedure TXSDComplexContentExtension.InternalAssignTyped;
var
  ct: TXSDComplexContent;
  tobj: TXSDComplexType;
  ctype: TXSDComplexType;
  el: TXSDElement;
  col: TXSDElementObjectCollection;
  I: Integer;
  attr: TXSDAttribute;
begin
  inherited InternalAssignTyped;
  { TODO -ogrig -cДоработка : При применении расширения проверять совпадение объекта }

  if Base = 'tDocument' then
    Sleep(0);

  tobj := TypeObj as TXSDComplexType;
  if (tobj <> nil) Then
  begin

    tobj.AssignTyped;
    if tobj.SimpleContent.Has then
      Base := tobj.SimpleContent.Extension.Base;
    if tobj.ComplexContent.Has then
      Base := tobj.ComplexContent.Extension.Base;

    for I := 0 to Attributes.Count -1 do
    begin
      attr := tobj.Attributes.AttributeByName(Attributes.Items[i].Name);
    end;
    for I := 0 to tobj.Attributes.Count -1 do
    begin
      attr := TXSDAttribute.Create(FLibrary, Self);
      attr.Assign(tobj.Attributes.Items[i]);
      Attributes.Add(attr);
    end;
    for I := 0 to tobj.FCollection.Count -1 do
    begin
      if tobj.FCollection.Items[i] is TXSDElement then
      begin
        el := TXSDElement.Create(FLibrary, Self);
        el.Assign(tobj.FCollection.Items[i]);
        FCollection.Insert(i, el);
      end;
      if tobj.FCollection.Items[i] is TXSDElementObjectCollection then
      begin
        col := TXSDElementObjectCollection.Create(FLibrary, Self);
        col.Assign(tobj.FCollection.Items[i]);
        FCollection.Insert(i, col);
      end;
    end;
  end;

  if (Parent <> nil) and (Parent is TXSDComplexContent) and (tobj <> nil) then
  begin
    ct := Parent as TXSDComplexContent;
    if (ct.Parent <> nil) and (ct.Parent is TXSDComplexType) then
    begin
      ctype := ct.Parent as TXSDComplexType;
      if ctype.Collection.Count > 0 then
        Sleep(0);
      {for I := 0 to Attributes.Count -1 do
      begin
        attr := tobj.Attributes.AttributeByName(Attributes.Items[i].Name);
      end;}
      for I := tobj.Attributes.Count -1 downto 0 do
      begin
        attr := TXSDAttribute.Create(FLibrary, Self);
        attr.Assign(tobj.Attributes.Items[i]);
        ctype.Attributes.Insert(0, attr);
      end;
      for I := tobj.FCollection.Count -1 downto 0 do
      begin
        {el := TXSDElement.Create(FLibrary, Self);
        el.Assign(tobj.FCollection.Items[i]);
        ctype.FCollection.Insert(0, el);}
        if tobj.FCollection.Items[i] is TXSDElement then
        begin
          el := TXSDElement.Create(FLibrary, Self);
          el.Assign(tobj.FCollection.Items[i]);
          ctype.FCollection.Insert(0, el);
        end;
        if tobj.FCollection.Items[i] is TXSDElementObjectCollection then
        begin
          col := TXSDElementObjectCollection.Create(FLibrary, Self);
          col.Assign(tobj.FCollection.Items[i]);
          ctype.FCollection.Insert(0, col);
        end;
      end;
    end;

  end;

end;

procedure TXSDComplexContentExtension.LoadObject(AXmlNode: IXMLNode);
begin
  inherited;


  if AXmlNode.HasAttribute('base') then
  begin
    Base := AXmlNode.Attributes['base'];
    FLibrary.TypedObjs.Add(Self);
  end;

  FAttributes.LoadObject(AXmlNode);
  FCollection.LoadObject(AXmlNode);
end;

procedure TXSDComplexContentExtension.SetBase(const Value: String);
begin
  FBase := Value;
  if FFirstBase = '' then
    FFirstBase := Value;
end;

procedure TXSDComplexContentExtension.SetFirstBase(const Value: String);
begin
  FFirstBase := Value;
end;

{ TXSDSimpleContentExtension }

constructor TXSDSimpleContentExtension.Create(ALibrary: TXSDLibrary;
  AParent: TXSDObject);
begin
  inherited;
  FAttributes := TXSDAttributeCollection.Create(ALibrary, Self);
end;

destructor TXSDSimpleContentExtension.Destroy;
begin
  FreeNil(FAttributes);
  inherited;
end;

procedure TXSDSimpleContentExtension.LoadObject(AXmlNode: IXMLNode);
begin
  inherited;
  if AXmlNode.HasAttribute('base') then
  begin
    Base := AXmlNode.Attributes['base'];
  end;
  if (base <> '') and (Pos(OwnerLibrary.GlobalNameSpace + ':', base) = 0) then
    FLibrary.TypedObjs.Add(Self);
end;

procedure TXSDSimpleContentExtension.SetBase(const Value: String);
begin
  FBase := Value;
end;

{ TkoXSDPrecept }

destructor TkoXSDPrecept.Destroy;
begin

  inherited Destroy;
end;

function TkoXSDPrecept.GetHasValue: Boolean;
begin
  Result := False;
end;

function TkoXSDPrecept.GetName: string;
begin
  Result := LinkObject.Name;
end;

function TkoXSDPrecept.GetParent: TkoXSDPrecept;
begin
  Result := TkoXSDPrecept(inherited Parent);
end;

function TkoXSDPrecept.GetPreceptInfoString: string;
begin
  Result := XPath;
end;

function TkoXSDPrecept.getVisibleName: string;
begin
  Result := Name;
end;

function TkoXSDPrecept.GetXPath: String;
begin
  Result := Name;
  if Parent <> nil then
    Result := Parent.XPath+'/'+Result;
end;

function TkoXSDPrecept.GetXSDObject: TXSDCustomObject;
begin
  Result := TXSDCustomObject(inherited LinkObject);
end;

procedure TkoXSDPrecept.SetXPath(const Value: String);
begin
  FXPath := Value;
end;

procedure TkoXSDPrecept.SetXSDObject(const Value: TXSDCustomObject);
begin
  LinkObject := Value;
end;

procedure TkoXSDPrecept.WriteLinkInfoToXml(AXmlNode: IXMLNode);
begin
  with AXmlNode do
  begin
    Attributes['xpath'] := XPath;
    Attributes['Name'] := Name;
    if Parent <> nil then
    begin
      Attributes['ParentIndex'] := Parent.IndexOfPrecept(Self);
    end;
  end;

end;

{ TkoXSDElementPrecept }

constructor TkoXSDElementPrecept.Create(AStorage: TkoProcessStorage;
  AParent: IkoProcessCustomPrecept);
begin
  inherited;
end;

destructor TkoXSDElementPrecept.Destroy;
begin
  if FRestruction <> nil then
    FRestruction := nil;
  inherited;
end;

function TkoXSDElementPrecept.GetAnnotation: string;
begin
  Result := LinkObject.AnnotationText;
end;

function TkoXSDElementPrecept.GetDependenceOnParent: Boolean;
begin
  Result := False;
end;

function TkoXSDElementPrecept.GetFixedValue: Variant;
begin
  Result := LinkObject.Fixed;
end;

function TkoXSDElementPrecept.GetHasValue: Boolean;
begin
  Result := LinkObject.SimpleType.Has;
end;

function TkoXSDElementPrecept.GetIsFixed: Boolean;
begin
  Result := LinkObject.IsFixed;
end;

function TkoXSDElementPrecept.GetMaxOccurs: Integer;
begin
  Result := LinkObject.maxOccurs;
end;

function TkoXSDElementPrecept.GetMinOccurs: Integer;
begin
  Result := LinkObject.minOccurs;
end;

function TkoXSDElementPrecept.GetRequired: Boolean;
begin
  Result := MinOccurs >= 1;
end;

function TkoXSDElementPrecept.GetRestruction: IkoProcessPreceptRestruction;
begin
  Result := nil;
  if LinkObject.SimpleType.Restruction.Has and (FRestruction = nil) then
  begin
    FRestruction := TkoXSDElementRestructPrecept.Create(Storage, nil);
    FRestruction.LinkObject := LinkObject.SimpleType.Restruction;
    FRestruction.Precept := Self;
  end;
  Result := FRestruction;
end;

function TkoXSDElementPrecept.GetValueType: TkoProcessDataType;
begin
  Result := vtNone;
end;

function TkoXSDElementPrecept.GetXSDElement: TXSDElement;
begin
  Result := TXSDElement(inherited LinkObject);
end;

function TkoXSDElementPrecept.GetXSDRestruction: TkoXSDElementRestructPrecept;
begin
  Result := TkoXSDElementRestructPrecept(inherited Restruction);
end;

procedure TkoXSDElementPrecept.SetLinkObject(const Value: TObject);
begin
  inherited;
  Restruction;
end;

procedure TkoXSDElementPrecept.WriteLinkInfoToXml(AXmlNode: IXMLNode);
begin
  inherited WriteLinkInfoToXml(AXmlNode);
  AXmlNode.Attributes['Type'] := 'Element';
end;

{ TXSDElementKey }

constructor TXSDElementKey.Create(ALibrary: TXSDLibrary; AParent: TXSDObject);
begin
  inherited;
  FField := TXSDElementKeyLook.Create(ALibrary, Self);
  FSelector := TXSDElementKeyLook.Create(ALibrary, Self);
end;

destructor TXSDElementKey.Destroy;
begin
  FreeNil(FField);
  FreeNil(FSelector);
  inherited;
end;

function TXSDElementKey.GetFieldPath: String;
begin
  Result := Field.Xpath;
end;

function TXSDElementKey.GetSelectorPath: String;
begin
  Result := Selector.Xpath;
end;

procedure TXSDElementKey.LoadObject(AXmlNode: IXMLNode);
var
  nd: IXMLNode;
begin
  inherited;
  if CText(AXmlNode.LocalName, 'key')  then
    FTypeKey := ktKey
  else
    FTypeKey := ktKeyRef;
  FRefer := GetStringAttribute(AXmlNode, 'refer');
  if Frefer <> '' then
    sleep(0);
  nd := AXmlNode.ChildNodes.FindNode('selector');
  if nd <> nil then Selector.LoadObject(nd);
  nd := AXmlNode.ChildNodes.FindNode('field');
  if nd <> nil then field.LoadObject(nd);
end;

procedure TXSDElementKey.Setrefer(const Value: QName);
begin
  Frefer := Value;
end;

procedure TXSDElementKey.SetTypeKey(const Value: TkoProcessKeyType);
begin
  FTypeKey := Value;
end;

{ TXSDElementKeyLook }

function TXSDElementKeyLook.GetElement: TXSDElement;
begin
  Result := nil;
  if Parent is TXSDElementKey then
  begin
    Result := TXSDElementKey(Parent).Element;
  end;
end;

procedure TXSDElementKeyLook.LoadObject(AXmlNode: IXMLNode);
var
  nd: IXMLNode;
begin
  inherited;
  Xpath := GetStringAttribute(AXmlNode, 'xpath');


end;

procedure TXSDElementKeyLook.SetLookType(const Value: TXSDElementKeyLookType);
begin
  FLookType := Value;
end;

procedure TXSDElementKeyLook.SetXpath(const Value: String);
begin
  FXpath := Value;
end;

{ TXSDElementKeyCollection }

procedure TXSDElementKeyCollection.Assign(Source: TXSDCustomObject);
begin
  inherited;

end;

function TXSDElementKeyCollection.GetElementKey(Index: Integer): TXSDElementKey;
begin
  Result := TXSDElementKey(inherited Items[Index]);
end;

procedure TXSDElementKeyCollection.LoadObject(AXmlNode: IXMLNode);
var
  nd: IXMLNode;
  nds: IXMLNodeList;
  key: TXSDElementKey;
  i: Integer;
begin
  inherited LoadObject(AXmlNode);

  nds := AXmlNode.ChildNodes;
  for i := 0 to nds.Count - 1 do
  begin
    nd := nds.Nodes[i];
    if CText(nd.LocalName, 'key') or CText(nd.LocalName, 'keyref') then
    begin
      key := TXSDElementKey.Create(OwnerLibrary, Self);
      key.FElement := Parent as TXSDElement;
      key.LoadObject(nd);
      Add(key);
    end;

  end;
end;

{ TXSDElementObjectCollection }

procedure TXSDElementObjectCollection.Add(AObject: TXSDObject);
begin
  inherited Add(AObject);
end;

procedure TXSDElementObjectCollection.Assign(Source: TXSDCustomObject);
var
  e: TXSDObject;
  s: TXSDElementObjectCollection;
  i: Integer;

  cl: TXSDObjectClass;

begin
  inherited Assign(Source);
  s := Source as TXSDElementObjectCollection;
  Ref := s.Ref;
  CollectionType := s.CollectionType;
  for i := 0 to s.Count - 1 do
  begin
    cl := TXSDObjectClass(s.Items[i].ClassType);
    e := cl.Create(FLibrary, Self);
    e.Assign(s.Items[i]);
    Insert(i, e);
    //Add(e);
  end;
end;

function TXSDElementObjectCollection.GetElement(Index: Integer): TXSDObject;
begin
  Result := TXSDObject(inherited Items[Index]);
end;

function TXSDElementObjectCollection.GetElementByName(
  AName: String): TXSDObject;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    if Items[i].Name = AName then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
end;

function TXSDElementObjectCollection.GetIndexOfName(AName: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
  begin
    if CText(Items[i].Name, AName) then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

function TXSDElementObjectCollection.GetPrecept(
  AParent: IkoProcessCustomPrecept): IkoProcessCustomPrecept;
var
  prec: IkoProcessPrecept;
  i: Integer;
begin
  Result := TXSDElementObjectPreceptCollection.Create(FLibrary.XSDStorage, AParent);
  Result.LinkObject := Self;
  for i := 0 to Count - 1  do
  begin
    Result.AddChild(Items[i].GetPrecept(Result));
  end;
end;

procedure TXSDElementObjectCollection.InternalAssignTyped;
begin
  inherited;
  if RefObj <> nil then
    Assign(RefObj);
end;

procedure TXSDElementObjectCollection.LoadObject(AXmlNode: IXMLNode);
var

  colnd: IXMLNode;

  procedure LoadObjects(AXmlNode: IXMLNode);
  var
    nd: IXMLNode;
    nds: IXMLNodeList;
    el: TXSDElement;
    col: TXSDElementObjectCollection;
    i: Integer;
  begin

    nds := AXmlNode.ChildNodes;
    for i := 0 to nds.Count - 1 do
    begin
        nd := nds.Nodes[i];
        { TODO : Делаем }
        if CText(nd.LocalName, 'Element') then
        begin
          el := TXSDElement.Create(FLibrary, Self);
          el.LoadObject(nd);
          //lib.XSDFileName := nd.Attributes['schemaLocation'];
          Add(el);
        end;
        if CText(nd.LocalName, 'choice') or
          CText(nd.LocalName, 'sequence') or
          CText(nd.LocalName, 'all') or
          CText(nd.LocalName, 'group') then
        begin
          col := TXSDElementObjectCollection.Create(FLibrary, Self);
          if nd.Attributes['name'] = 'gObject' then
            Sleep(0);
          if CText(nd.LocalName, 'choice') then
            col.CollectionType := prChoice;
          if CText(nd.LocalName, 'all') then
            col.CollectionType := prAll;
          if CText(nd.LocalName, 'group') then
            col.CollectionType := prGroup;
          if CText(nd.LocalName, 'sequence') then
            col.CollectionType := prSequence;
          col.LoadObject(nd);

          //lib.XSDFileName := nd.Attributes['schemaLocation'];
          Add(col);
        end;
    end;
  end;
begin
  inherited;

   if CText(AXmlNode.LocalName, 'choice') or
    CText(AXmlNode.LocalName, 'sequence') or
    CText(AXmlNode.LocalName, 'all') or
    CText(AXmlNode.LocalName, 'group') then
    begin
      colnd := AXmlNode;
    end else
      LoadObjects(AXmlNode);


  {colnd := AXmlNode.ChildNodes.FindNode('choice');
  if colnd = nil then
  colnd := AXmlNode.ChildNodes.FindNode('sequence');
  if (colnd = nil) then
  begin


  end;
  if colnd = nil then
    colnd := AXmlNode;}


  if colnd <> nil then
  begin
    if CText(colnd.LocalName, 'choice') then
            CollectionType := prChoice;
    if CText(colnd.LocalName, 'all') then
        CollectionType := prAll;
    if CText(colnd.LocalName, 'group') then
        CollectionType := prGroup;
    if CText(colnd.LocalName, 'sequence') then
        CollectionType := prSequence;
    LoadObjects(colnd);
  end;

end;

{ TXSDElementObjectPreceptCollection }

function TXSDElementObjectPreceptCollection.GetCollectionType: TprCollectionType;
begin
  Result := LinkObject.CollectionType;
end;

function TXSDElementObjectPreceptCollection.GetCount: Integer;
begin
  Result := ChildCount;
end;

function TXSDElementObjectPreceptCollection.GetIsRealObject: Boolean;
begin
  Result := False;
end;

function TXSDElementObjectPreceptCollection.GetItem(
  Index: Integer): IkoProcessCustomPrecept;
begin
  Result := Child[Index];
end;

function TXSDElementObjectPreceptCollection.GetLinkObject: TXSDElementObjectCollection;
begin
  Result := TXSDElementObjectCollection(inherited LinkObject);
end;

function TXSDElementObjectPreceptCollection.GetName: string;
var
  i: integer;
begin
  i := 0;
  if Parent <> nil then
    i := Parent.IndexOfPrecept(Self);
  Result := format(':Collection %d:', [i]);
end;

function TXSDElementObjectPreceptCollection.getVisibleName: string;
begin
  Result := 'Список ';
  case GetCollectionType of
    prSequence: Result := Result + 'фиксированный';
    prAll: Result := Result + 'фиксированный';
    prGroup: Result := Result + 'группа';
    prChoice: Result := Result + 'выбор подэлемента';
    prAny: Result := Result + 'без ограничений';
  end;
end;

procedure TXSDElementObjectPreceptCollection.WriteLinkInfoToXml(
  AXmlNode: IXMLNode);
begin
  inherited WriteLinkInfoToXml(AXmlNode);
  AXmlNode.Attributes['IsCollection'] := True;
end;

{ TkoXSDAttributePreceptCollection }

function TkoXSDAttributePreceptCollection.GetCollectionType: TprCollectionType;
begin
  Result := prSequence;
end;

function TkoXSDAttributePreceptCollection.GetCount: Integer;
begin
  Result := ChildCount;
end;

function TkoXSDAttributePreceptCollection.GetIsRealObject: Boolean;
begin
  Result := False;
end;

function TkoXSDAttributePreceptCollection.GetItem(
  Index: Integer): IkoProcessCustomPrecept;
begin
  Result := Child[Index];
end;

function TkoXSDAttributePreceptCollection.GetLinkObject: TXSDAttributeCollection;
begin
  Result := TXSDAttributeCollection(inherited LinkObject);
end;

function TkoXSDAttributePreceptCollection.getVisibleName: string;
begin
  Result := 'Список ';
  case GetCollectionType of
    prSequence: Result := 'фиксированный';
    prAll: Result := 'фиксированный';
    prGroup: Result := 'группа';
    prChoice: Result := 'выбор подэлемента';
    prAny: Result := 'без ограничений';
  end;
end;

procedure TkoXSDAttributePreceptCollection.SetLinkObject(const Value: TObject);
var
  i: Integer;
begin
  inherited;
  for i := 0 to LinkObject.Count - 1 do
  begin
    AddChild(LinkObject.Items[i].GetPrecept(Self));
  end;

end;

{ TkoXSDAttributePrecept }

function TkoXSDAttributePrecept.GetAnnotation: string;
begin
  Result := LinkObject.AnnotationText
end;

function TkoXSDAttributePrecept.GetDependenceOnParent: Boolean;
begin
  Result := True;
end;

function TkoXSDAttributePrecept.GetFixedValue: Variant;
begin
  Result := LinkObject.Ffixed;
end;

function TkoXSDAttributePrecept.GetHasValue: Boolean;
begin

end;

function TkoXSDAttributePrecept.GetIsFixed: Boolean;
begin
  Result := LinkObject.fixed <> '';
end;

function TkoXSDAttributePrecept.GetIsRealObject: Boolean;
begin
  Result := True;
end;

function TkoXSDAttributePrecept.GetMaxOccurs: Integer;
begin
  Result := 1;

end;

function TkoXSDAttributePrecept.GetMinOccurs: Integer;
begin
  if LinkObject.use = xsdOptional then
    Result := 0
  else
    Result := 1;
end;

function TkoXSDAttributePrecept.GetPreceptInfoString: string;
begin
  Result := LinkObject.XPath;
end;

function TkoXSDAttributePrecept.GetRequired: Boolean;
begin
  Result := LinkObject.use = xsdRequired;
end;

function TkoXSDAttributePrecept.GetRestruction: IkoProcessPreceptRestruction;
begin
  Result := nil;
  if (LinkObject.Restruction <> nil) and
    LinkObject.Restruction.Has and (FRestruction = nil) then
  begin
    FRestruction := TkoXSDElementRestructPrecept.Create(Storage, nil);
    FRestruction.LinkObject := LinkObject.Restruction;
    FRestruction.Precept := Self;
  end;
  Result := FRestruction;

end;

function TkoXSDAttributePrecept.GetValueType: TkoProcessDataType;
begin
  if (LinkObject.Restruction <> nil) and LinkObject.Restruction.Has and
    (LinkObject.Restruction.FInternalDataType <> vtUnknown) then
  Result := LinkObject.SimpleType.Restruction.FInternalDataType
  else
    Result := LinkObject.FInternalDataType;
end;

function TkoXSDAttributePrecept.getVisibleName: string;
begin
  Result := Name;
end;

function TkoXSDAttributePrecept.GetXSDElement: TXSDAttribute;
begin
  Result := TXSDAttribute(inherited LinkObject);
end;

function TkoXSDAttributePrecept.GetXSDRestruction: TkoXSDElementRestructPrecept;
begin
  Result := TkoXSDElementRestructPrecept(inherited Restruction);
end;

procedure TkoXSDAttributePrecept.WriteLinkInfoToXml(AXmlNode: IXMLNode);
begin
  inherited;
  with AXmlNode do
  begin
    Attributes['Type'] := 'Attribute';
  end;
end;

{ TkoXSDElementRestructedPrecept }

function TkoXSDElementRestructPrecept.GetEnumeration: IkoEnumProcessPrecept;
var
  i: Integer;
begin
  Result := nil;
  if LinkObject.enumeration.Has and (FEnumeration = nil) then
  begin
    FEnumeration := TkoProcessEnumPreceptCollection.Create(FStorage, nil);
    for i := 0 to LinkObject.enumeration.Count - 1 do
    begin
      FEnumeration.AddEnum(LinkObject.enumeration.Items[i].Fvalue,
        LinkObject.enumeration.Items[i].AnnotationText);
    end;
  end;
  Result := FEnumeration;
end;

function TkoXSDElementRestructPrecept.GetfractionDigits: Integer;
begin

end;

function TkoXSDElementRestructPrecept.Getlength: Integer;
begin

end;

function TkoXSDElementRestructPrecept.GetLinkObject: TXSDRestriction;
begin
  Result := TXSDRestriction(inherited LinkObject);
end;

function TkoXSDElementRestructPrecept.GetMax: Variant;
begin
  Result := null;
  if not VarIsNull(LinkObject.maxExclusive) then
  begin
    Result := LinkObject.maxExclusive;
    Exit;
  end;
  if not VarIsNull(LinkObject.maxInclusive) then
  begin
    Result := LinkObject.maxInclusive;
    Exit;
  end;
end;

function TkoXSDElementRestructPrecept.GetMaxIncude: Boolean;
begin
  Result := not VarIsNull(LinkObject.maxInclusive);
end;

function TkoXSDElementRestructPrecept.GetmaxLength: Integer;
begin
  Result := LinkObject.maxLength;
end;

function TkoXSDElementRestructPrecept.GetMin: Variant;
begin
  Result := null;
  if not VarIsNull(LinkObject.minExclusive) then
  begin
    Result := LinkObject.minExclusive;
    Exit;
  end;
  if not VarIsNull(LinkObject.minInclusive) then
  begin
    Result := LinkObject.minInclusive;
    Exit;
  end;
end;

function TkoXSDElementRestructPrecept.GetMinIncude: Boolean;
begin
  Result := not VarIsNull(LinkObject.minInclusive);
end;

function TkoXSDElementRestructPrecept.GetminLength: Integer;
begin
  Result := LinkObject.minLength;
end;

function TkoXSDElementRestructPrecept.GetPattern: String;
begin
  Result := LinkObject.Pattern;
end;

function TkoXSDElementRestructPrecept.GettotalDigits: Integer;
begin
  Result := LinkObject.totalDigits;
end;

procedure TkoXSDElementRestructPrecept.SetLinkObject(const Value: TObject);
begin
  inherited SetLinkObject(Value);
  Enumeration;
end;

procedure TkoXSDElementRestructPrecept.SetPrecept(
  const Value: IkoProcessPrecept);
begin
  inherited;
end;

{ TkoXSDConnectionInfo }

function TkoXSDConnectionInfo.CheckParametrs: Boolean;
begin
  Result := FXMLFileName <> '';

  
end;

procedure TkoXSDConnectionInfo.SetXMLFileName(const Value: String);
begin
  FXMLFileName := Value;
end;

{ TXSDLibraries }

function TXSDLibraries.GetItem(Index: Integer): TXSDLibrary;
begin
  Result := TXSDLibrary(inherited Items[Index]);
end;

function TXSDLibraries.GetLibByName(AName: String): TXSDLibrary;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    if CText(Items[i].FXSDFileName, AName) then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
end;

procedure TXSDLibraries.LoadLibrariesFromResource(
  AStringArray: array of string);
var
  i: Integer;
  lib: TXSDLibrary;
begin
  csPrint('Загрузка справочников из ресурса модуля');
  for i := low(AStringArray) to High(AStringArray) do
  begin
    csPrint('--'+AStringArray[i]);
    lib := TXSDLibrary.Create(nil);
    lib.LoadXSDFromResource(AStringArray[i]);
    Add(lib);
  end;
end;

initialization

  csProcessorStoragesClasses.RegisterClass(TkoXSDStorage);

finalization


end.
