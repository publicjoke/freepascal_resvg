unit resvg;

{$mode objfpc}{$H+}

{$PACKRECORDS C}

interface

uses
  ctypes, Types, Classes, Graphics, GraphType;

const
{$IF Defined(WINDOWS)}
  resvg_dynlib = 'resvg.dll';
{$ELSEIF Defined(UNIX)}
  resvg_dynlib = 'resvg.so';
{$ELSE}
  {$ERROR Unsupported platform}
{$ENDIF}

type
  resvg_options = Pointer;
  resvg_render_tree = Pointer;
  resvg_image = Pointer;

  resvg_error = (
    RESVG_OK = 0,
    RESVG_ERROR_NOT_AN_UTF8_STR,
    RESVG_ERROR_FILE_OPEN_FAILED,
    RESVG_ERROR_INVALID_FILE_SUFFIX,
    RESVG_ERROR_MALFORMED_GZIP,
    RESVG_ERROR_INVALID_SIZE,
    RESVG_ERROR_PARSING_FAILED
  );

  resvg_color = record
    r: Byte;
    g: Byte;
    b: Byte;
  end;
  p_resvg_color = ^resvg_color;

  resvg_fit_to_type = (
    RESVG_FIT_TO_ORIGINAL,
    RESVG_FIT_TO_WIDTH,
    RESVG_FIT_TO_HEIGHT,
    RESVG_FIT_TO_ZOOM
  );

  resvg_fit_to = record
    fit_type: resvg_fit_to_type;
    value: Single;
  end;

  resvg_shape_rendering = (
    RESVG_SHAPE_RENDERING_OPTIMIZE_SPEED,
    RESVG_SHAPE_RENDERING_CRISP_EDGES,
    RESVG_SHAPE_RENDERING_GEOMETRIC_PRECISION
  );

  resvg_text_rendering = (
    RESVG_TEXT_RENDERING_OPTIMIZE_SPEED,
    RESVG_TEXT_RENDERING_OPTIMIZE_LEGIBILITY,
    RESVG_TEXT_RENDERING_GEOMETRIC_PRECISION
  );

  resvg_image_rendering = (
    RESVG_IMAGE_RENDERING_OPTIMIZE_QUALITY,
    RESVG_IMAGE_RENDERING_OPTIMIZE_SPEED
  );

  resvg_rect = record
    x: Double;
    y: Double;
    width: Double;
    height: Double;
  end;

  resvg_size = record
    width: UInt32;
    height: UInt32;
  end;

  resvg_transform = record
    a: Double;
    b: Double;
    c: Double;
    d: Double;
    e: Double;
    f: Double;
  end;

procedure resvg_init_log; cdecl; external resvg_dynlib;

function resvg_options_create: resvg_options; cdecl; external resvg_dynlib;
procedure resvg_options_set_file_path(opt: resvg_options; path: PAnsiChar); cdecl; external resvg_dynlib;
procedure resvg_options_set_dpi(opt: resvg_options; dpi: Double); cdecl; external resvg_dynlib;
procedure resvg_options_set_font_family(opt: resvg_options; family: PAnsiChar); cdecl; external resvg_dynlib;
procedure resvg_options_set_font_size(opt: resvg_options; size: Double); cdecl; external resvg_dynlib;
procedure resvg_options_set_serif_family(opt: resvg_options; family: PAnsiChar); cdecl; external resvg_dynlib;
procedure resvg_options_set_sans_serif_family(opt: resvg_options; family: PAnsiChar); cdecl; external resvg_dynlib;
procedure resvg_options_set_cursive_family(opt: resvg_options; family: PAnsiChar); cdecl; external resvg_dynlib;
procedure resvg_options_set_fantasy_family(opt: resvg_options; family: PAnsiChar); cdecl; external resvg_dynlib;
procedure resvg_options_set_monospace_family(opt: resvg_options; family: PAnsiChar); cdecl; external resvg_dynlib;
procedure resvg_options_set_languages(opt: resvg_options; languages: PAnsiChar); cdecl; external resvg_dynlib;
procedure resvg_options_set_shape_rendering_mode(opt: resvg_options; mode: resvg_shape_rendering); cdecl; external resvg_dynlib;
procedure resvg_options_set_text_rendering_mode(opt: resvg_options; mode: resvg_text_rendering); cdecl; external resvg_dynlib;
procedure resvg_options_set_image_rendering_mode(opt: resvg_options; mode: resvg_image_rendering); cdecl; external resvg_dynlib;
procedure resvg_options_set_keep_named_groups(opt: resvg_options; keep: cbool); cdecl; external resvg_dynlib;
procedure resvg_options_load_font_data(opt: resvg_options; data: PByte; len: SizeUInt); cdecl; external resvg_dynlib;
procedure resvg_options_load_font_file(opt: resvg_options; file_path: PAnsiChar); cdecl; external resvg_dynlib;
procedure resvg_options_load_system_fonts(opt: resvg_options); cdecl; external resvg_dynlib;
procedure resvg_options_destroy(opt: resvg_options); cdecl; external resvg_dynlib;

function resvg_parse_tree_from_file(file_path: PAnsiChar; opt: resvg_options; var tree: resvg_render_tree): cint; cdecl; external resvg_dynlib;
function resvg_parse_tree_from_data(data: Pointer; len: SizeUint; opt: resvg_options; var tree: resvg_render_tree): cint; cdecl; external resvg_dynlib;
function resvg_is_image_empty(tree: resvg_render_tree): cbool; cdecl; external resvg_dynlib;
function resvg_get_image_size(tree: resvg_render_tree): resvg_size; cdecl; external resvg_dynlib;
function resvg_get_image_viewbox(tree: resvg_render_tree): resvg_rect; cdecl; external resvg_dynlib;
function resvg_get_image_bbox(tree: resvg_render_tree; var bbox: resvg_rect): cbool; cdecl; external resvg_dynlib;
function resvg_node_exists(tree: resvg_render_tree; id: PAnsiChar): cbool; cdecl; external resvg_dynlib;
function resvg_get_node_transform(tree: resvg_render_tree; id: PAnsiChar; var ts: resvg_transform): cbool; cdecl; external resvg_dynlib;
function resvg_get_node_bbox(tree: resvg_render_tree; id: PAnsiChar; var bbox: resvg_rect): cbool; cdecl; external resvg_dynlib;
procedure resvg_tree_destroy(tree: resvg_render_tree); cdecl; external resvg_dynlib;

function resvg_image_get_data(image: resvg_image; var len: SizeUInt): Pointer; cdecl; external resvg_dynlib;
function resvg_image_get_width(image: resvg_image): Uint32; cdecl; external resvg_dynlib;
function resvg_image_get_height(image: resvg_image): Uint32; cdecl; external resvg_dynlib;
procedure resvg_image_destroy(image: resvg_image); cdecl; external resvg_dynlib;

function resvg_render(tree: resvg_render_tree; fit_to: resvg_fit_to; background: p_resvg_color = nil): resvg_image; cdecl; external resvg_dynlib;
function resvg_render_node(tree: resvg_render_tree; id: PAnsiChar; fit_to: resvg_fit_to; background: p_resvg_color = nil): resvg_image;  cdecl; external resvg_dynlib;

type
  TReSVGImage = class
  protected
    RawImage: TRawImage;

    function GetWidth: UInt32;
    function GetHeight: UInt32;
  public
    constructor Create;
    destructor Destroy; override;

    function LoadIntoRasterImage(Destination: TRasterImage; CopyData: Boolean): Boolean;

    function IsValid: Boolean;
    property Width: UInt32 read GetWidth;
    property Height: UInt32 read GetHeight;
  end;

  TReSVGRenderer = class
  protected
    fOptions: resvg_options;
    fParsedData: resvg_render_tree;

    fOriginalImageSize: resvg_size;
    fOriginalImageViewBox: resvg_rect;
    fOriginalImageBoundingBox: resvg_rect;
    fOriginalImageAspectRatio: Double;

    fParserError: string;

    function GetHasPrivateOptions: Boolean; virtual;
    function GetHasParsedSVG: Boolean;
    procedure SetHasParsedSVG(NewValue: Boolean);
  public
    constructor Create(UseGlobalOptions: Boolean = True); virtual;
    destructor Destroy; override;

    procedure Clear;

    class procedure ClearReSVGSize(var size: resvg_size);
    class procedure ClearReSVGRect(var rect: resvg_rect);
    class procedure MakeByteArrayFromString(const Source: string; var Destination: TByteDynArray);
    class procedure MakeByteArrayFromStream(Source: TStream; var Destination: TByteDynArray);

    procedure SetDPI(DPI: Double);

    procedure SetFontFamily(const Family: string);
    procedure SetFontSize(Size: Double);
    procedure SetFontSerifFamily(const Family: string);
    procedure SetFontSansSerifFamily(const Family: string);
    procedure SetFontCursiveFamily(const Family: string);
    procedure SetFontFantasyFamily(const Family: string);
    procedure SetFontMonospaceFamily(const Family: string);
    procedure LoadFontData(const Data: TByteDynArray); overload;
    procedure LoadFontData(Data: TStream); overload;

    procedure SetLanguages(const Languages: array of string);

    procedure SetShapeRenderingMode(Mode: resvg_shape_rendering);
    procedure SetTextRenderingMode(Mode: resvg_text_rendering);
    procedure SetImageRenderingMode(Mode: resvg_image_rendering);

    procedure SetKeepNamedGroups(Keep: Boolean);

    function Parse(const Data: TByteDynArray): Boolean; overload;
    function Parse(const Data: string): Boolean; overload;
    function Parse(Data: TStream): Boolean; overload;

    function IsNodeExists(const NodeName: string): Boolean;
    function GetNodeTransformation(const NodeName: string; out Transformation: resvg_transform): Boolean;
    function GetNodeBoundingBox(const NodeName: string; out Box: resvg_rect): Boolean;

    function Render(const FitTo: resvg_fit_to; UseBackgroundGolor: Boolean = False; BackgroundGolor: TColor = clWhite): TReSVGImage;
    function RenderNode(const NodeName: string; const FitTo: resvg_fit_to; UseBackgroundGolor: Boolean = False; BackgroundGolor: TColor = clWhite): TReSVGImage;

    property OriginalImageSize: resvg_size read fOriginalImageSize;
    property OriginalImageViewBox: resvg_rect read fOriginalImageViewBox;
    property OriginalImageBoundingBox: resvg_rect read fOriginalImageBoundingBox;
    property OriginalImageAspectRatio: Double read fOriginalImageAspectRatio;
    property ParserError: string read fParserError;
    property HasPrivateOptions: Boolean read GetHasPrivateOptions;
    property HasParsedSVG: Boolean read GetHasParsedSVG write SetHasParsedSVG;
  end;

implementation

uses
  Math;

var
  ReSVGGlobalOptions: resvg_options = nil;

{------------------------------------------ TReSVGImage ----------------------------------------}

constructor TReSVGImage.Create;
begin
  RawImage.Init;
end;

destructor TReSVGImage.Destroy;
begin
  RawImage.FreeData;

  inherited;
end;

function TReSVGImage.IsValid: Boolean;
begin
  Result:=Assigned(RawImage.Data);
end;

function TReSVGImage.GetWidth: UInt32;
begin
  Result:=RawImage.Description.Width;
end;

function TReSVGImage.GetHeight: UInt32;
begin
  Result:=RawImage.Description.Height;
end;

function TReSVGImage.LoadIntoRasterImage(Destination: TRasterImage; CopyData: Boolean): Boolean;
begin
  Result:=IsValid;
  if Result then begin
    Destination.LoadFromRawImage(RawImage, not CopyData);
    if not CopyData
      then RawImage.Init;
  end;
end;

{---------------------------------------- TReSVGRenderer ---------------------------------------}

constructor TReSVGRenderer.Create(UseGlobalOptions: Boolean = True);
begin
  fParsedData:=nil;
  Clear;

  if UseGlobalOptions
    then fOptions:=ReSVGGlobalOptions
  else begin
    fOptions:=resvg_options_create;
    if Assigned(fOptions)
      then resvg_options_load_system_fonts(fOptions);
  end;
end;

destructor TReSVGRenderer.Destroy;
begin
  HasParsedSVG:=False;
  if HasPrivateOptions
    then resvg_options_destroy(fOptions);

  inherited;
end;

class procedure TReSVGRenderer.ClearReSVGSize(var size: resvg_size);
begin
  size.width:=0;
  size.height:=0;
end;

class procedure TReSVGRenderer.ClearReSVGRect(var rect: resvg_rect);
begin
  rect.x:=0.0;
  rect.y:=0.0;
  rect.width:=0.0;
  rect.height:=0.0;
end;

procedure TReSVGRenderer.Clear;
begin
  if Assigned(fParsedData) then begin
    resvg_tree_destroy(fParsedData);
    fParsedData:=nil;
  end;
  ClearReSVGSize(fOriginalImageSize);
  ClearReSVGRect(fOriginalImageViewBox);
  ClearReSVGRect(fOriginalImageBoundingBox);
  fOriginalImageAspectRatio:=0.0;
  fParserError:='';
end;

class procedure TReSVGRenderer.MakeByteArrayFromString(const Source: string; var Destination: TByteDynArray);
begin
  Destination:=nil;
  if Length(Source)>0 then begin
    SetLength(Destination, Length(Source));
    Move(Source[1], Destination[0], Length(Source));
  end;
end;

class procedure TReSVGRenderer.MakeByteArrayFromStream(Source: TStream; var Destination: TByteDynArray);
begin
  Destination:=nil;
  if Source.Size>0 then begin
    SetLength(Destination, Source.Size);
    Source.Position:=0;
    SetLength(Destination, Source.Read(Destination[0], Source.Size));
  end;
end;

function TReSVGRenderer.GetHasPrivateOptions: Boolean;
begin
  Result:=Assigned(fOptions) and (fOptions<>ReSVGGlobalOptions);
end;

function TReSVGRenderer.GetHasParsedSVG: Boolean;
begin
  Result:=Assigned(fParsedData);
end;

procedure TReSVGRenderer.SetHasParsedSVG(NewValue: Boolean);
begin
  if (GetHasParsedSVG<>NewValue) and (not NewValue)
    then Clear;
end;

procedure TReSVGRenderer.SetDPI(DPI: Double);
begin
  if HasPrivateOptions
    then resvg_options_set_dpi(fOptions, DPI);
end;

procedure TReSVGRenderer.SetFontFamily(const Family: string);
var
  str: UTF8String;
begin
  if HasPrivateOptions and (Family<>'') then begin
    str:=UTF8String(Family);
    resvg_options_set_font_family(fOptions, @str[1]);
  end;
end;

procedure TReSVGRenderer.SetFontSize(Size: Double);
begin
  if HasPrivateOptions
    then resvg_options_set_font_size(fOptions, Size);
end;

procedure TReSVGRenderer.SetFontSerifFamily(const Family: string);
var
  str: UTF8String;
begin
  if HasPrivateOptions and (Family<>'') then begin
    str:=UTF8String(Family);
    resvg_options_set_serif_family(fOptions, @str[1]);
  end;
end;

procedure TReSVGRenderer.SetFontSansSerifFamily(const Family: string);
var
  str: UTF8String;
begin
  if HasPrivateOptions and (Family<>'') then begin
    str:=UTF8String(Family);
    resvg_options_set_sans_serif_family(fOptions, @str[1]);
  end;
end;

procedure TReSVGRenderer.SetFontCursiveFamily(const Family: string);
var
  str: UTF8String;
begin
  if HasPrivateOptions and (Family<>'') then begin
    str:=UTF8String(Family);
    resvg_options_set_cursive_family(fOptions, @str[1]);
  end;
end;

procedure TReSVGRenderer.SetFontFantasyFamily(const Family: string);
var
  str: UTF8String;
begin
  if HasPrivateOptions and (Family<>'') then begin
    str:=UTF8String(Family);
    resvg_options_set_fantasy_family(fOptions, @str[1]);
  end;
end;

procedure TReSVGRenderer.SetFontMonospaceFamily(const Family: string);
var
  str: UTF8String;
begin
  if HasPrivateOptions and (Family<>'') then begin
    str:=UTF8String(Family);
    resvg_options_set_monospace_family(fOptions, @str[1]);
  end;
end;

procedure TReSVGRenderer.LoadFontData(const Data: TByteDynArray);
begin
  if HasPrivateOptions and (Length(Data)>0)
    then resvg_options_load_font_data(fOptions, @Data[0], Length(Data));
end;

procedure TReSVGRenderer.LoadFontData(Data: TStream);
var
  dt: TByteDynArray;
begin
  dt:=nil;
  MakeByteArrayFromStream(Data, dt);
  LoadFontData(dt);
end;

procedure TReSVGRenderer.SetLanguages(const Languages: array of string);
var
  str: UTF8String;
  i: SizeInt;
begin
  if HasPrivateOptions and (Length(Languages)>0) then begin
    str:='';
    for i:=0 to High(Languages) do
      if Languages[i]<>'' then begin
        str:=str+UTF8String(Languages[i]);
        if i<High(Languages)
          then str:=str+',';
      end;

    if str<>''
      then resvg_options_set_languages(fOptions, @str[1]);
  end;
end;

procedure TReSVGRenderer.SetShapeRenderingMode(Mode: resvg_shape_rendering);
begin
  if HasPrivateOptions
    then resvg_options_set_shape_rendering_mode(fOptions, Mode);
end;

procedure TReSVGRenderer.SetTextRenderingMode(Mode: resvg_text_rendering);
begin
  if HasPrivateOptions
    then resvg_options_set_text_rendering_mode(fOptions, Mode);
end;

procedure TReSVGRenderer.SetImageRenderingMode(Mode: resvg_image_rendering);
begin
  if HasPrivateOptions
    then resvg_options_set_image_rendering_mode(fOptions, Mode);
end;

procedure TReSVGRenderer.SetKeepNamedGroups(Keep: Boolean);
begin
  if HasPrivateOptions
    then resvg_options_set_keep_named_groups(fOptions, cbool(Keep));
end;

function TReSVGRenderer.Parse(const Data: TByteDynArray): Boolean;
var
  OldExceptionMask: TFPUExceptionMask;

  err: cint;
begin
  Result:=False;
  if Assigned(fOptions) and (Length(Data)>0) then begin
    Clear;

    OldExceptionMask:=GetExceptionMask;
    SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);

    err:=resvg_parse_tree_from_data(@Data[0], Length(Data), fOptions, fParsedData);

    fParserError:='';
    case resvg_error(err) of
      RESVG_ERROR_NOT_AN_UTF8_STR:
        fParserError:='The SVG content has not an UTF-8 encoding';

      RESVG_ERROR_FILE_OPEN_FAILED:
        fParserError:='Failed to read the file';

      RESVG_ERROR_INVALID_FILE_SUFFIX:
        fParserError:='Invalid file suffix';

      RESVG_ERROR_MALFORMED_GZIP:
        fParserError:='Not a GZip compressed data';

      RESVG_ERROR_INVALID_SIZE:
        fParserError:='SVG doesn''t have a valid size';

      RESVG_ERROR_PARSING_FAILED:
        fParserError:='Failed to parse an SVG data';
    end;

    if Assigned(fParsedData) then begin
      fOriginalImageSize:=resvg_get_image_size(fParsedData);
      if fOriginalImageSize.height<>0
        then fOriginalImageAspectRatio:=fOriginalImageSize.width/fOriginalImageSize.height;
      fOriginalImageViewBox:=resvg_get_image_viewbox(fParsedData);
      resvg_get_image_bbox(fParsedData, fOriginalImageBoundingBox);
    end;

    SetExceptionMask(OldExceptionMask);

    Result:=resvg_error(err)=RESVG_OK;
  end;
end;

function TReSVGRenderer.Parse(const Data: string): Boolean;
var
  dt: TByteDynArray;
begin
  dt:=nil;
  MakeByteArrayFromString(Data, dt);
  Result:=Parse(dt);
end;

function TReSVGRenderer.Parse(Data: TStream): Boolean;
var
  dt: TByteDynArray;
begin
  dt:=nil;
  MakeByteArrayFromStream(Data, dt);
  Result:=Parse(dt);
end;

function TReSVGRenderer.IsNodeExists(const NodeName: string): Boolean;
var
  str: UTF8String;
begin
  Result:=Assigned(fParsedData) and (NodeName<>'');
  if Result then begin
    str:=UTF8String(NodeName);
    Result:=Boolean(resvg_node_exists(fParsedData, @str[1]));
  end;
end;

function TReSVGRenderer.GetNodeTransformation(const NodeName: string; out Transformation: resvg_transform): Boolean;
var
  str: UTF8String;
begin
  Result:=Assigned(fParsedData) and (NodeName<>'');
  if Result then begin
    str:=UTF8String(NodeName);
    Transformation.a:=0.0;
    Result:=Boolean(resvg_get_node_transform(fParsedData, @str[1], Transformation));
  end;
end;

function TReSVGRenderer.GetNodeBoundingBox(const NodeName: string; out Box: resvg_rect): Boolean;
var
  str: UTF8String;
begin
  Result:=Assigned(fParsedData) and (NodeName<>'');
  if Result then begin
    str:=UTF8String(NodeName);
    Box.x:=0.0;
    Result:=Boolean(resvg_get_node_bbox(fParsedData, @str[1], Box));
  end;
end;

function TReSVGRenderer.Render(const FitTo: resvg_fit_to; UseBackgroundGolor: Boolean = False; BackgroundGolor: TColor = clWhite): TReSVGImage;
var
  OldExceptionMask: TFPUExceptionMask;

  col: resvg_color;
  pcol: p_resvg_color;
  img: resvg_image;
  data: Pointer;
  data_len: SizeUInt;
begin
  Result:=nil;
  if Assigned(fParsedData) then begin
    OldExceptionMask:=GetExceptionMask;
    SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);

    if UseBackgroundGolor then begin
      RedGreenBlue(FPColorToTColorRef(TColorToFPColor(BackgroundGolor)), col.r, col.g, col.b);
      pcol:=@col;
    end else pcol:=nil;
    img:=resvg_render(fParsedData, FitTo, pcol);

    if Assigned(img) then begin
      data_len:=0;
      data:=resvg_image_get_data(img, data_len);

      Result:=TReSVGImage.Create;
      Result.RawImage.Description.Init_BPP32_R8G8B8A8_BIO_TTB(resvg_image_get_width(img), resvg_image_get_height(img));
      Result.RawImage.CreateData(False);
      Move(data^, Result.RawImage.Data^, data_len);
      resvg_image_destroy(img);
    end;

    SetExceptionMask(OldExceptionMask);
  end;
end;

function TReSVGRenderer.RenderNode(const NodeName: string; const FitTo: resvg_fit_to; UseBackgroundGolor: Boolean = False; BackgroundGolor: TColor = clWhite): TReSVGImage;
var
  OldExceptionMask: TFPUExceptionMask;

  str: UTF8String;
  col: resvg_color;
  pcol: p_resvg_color;
  img: resvg_image;
  data: Pointer;
  data_len: SizeUInt;
begin
  Result:=nil;
  if Assigned(fParsedData) and (NodeName<>'') then begin
    OldExceptionMask:=GetExceptionMask;
    SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);

    if UseBackgroundGolor then begin
      RedGreenBlue(FPColorToTColorRef(TColorToFPColor(BackgroundGolor)), col.r, col.g, col.b);
      pcol:=@col;
    end else pcol:=nil;
    str:=UTF8String(NodeName);
    img:=resvg_render_node(fParsedData, @str[1], FitTo, pcol);

    if Assigned(img) then begin
      data_len:=0;
      data:=resvg_image_get_data(img, data_len);

      Result:=TReSVGImage.Create;
      Result.RawImage.Description.Init_BPP32_R8G8B8A8_BIO_TTB(resvg_image_get_width(img), resvg_image_get_height(img));
      Result.RawImage.CreateData(False);
      Move(data^, Result.RawImage.Data^, data_len);
      resvg_image_destroy(img);
    end;

    SetExceptionMask(OldExceptionMask);
  end;
end;

initialization
  ReSVGGlobalOptions:=resvg_options_create;
  if Assigned(ReSVGGlobalOptions)
    then resvg_options_load_system_fonts(ReSVGGlobalOptions);

finalization
  if Assigned(ReSVGGlobalOptions)
    then resvg_options_destroy(ReSVGGlobalOptions);

end.
