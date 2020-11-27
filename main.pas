unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, Types, SysUtils, Forms, Graphics, ExtCtrls, Menus, Dialogs,
  resvg;

type
  TMainForm = class(TForm)
    DisplayedImage: TImage;
    MainMenu: TMainMenu;
    LoadFileMI: TMenuItem;
    GetSVGNameOD: TOpenDialog;
    RendQualityMI: TMenuItem;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LoadFileMIClick(Sender: TObject);
    procedure RendQualityMIClick(Sender: TObject);
  protected
    FileName: string;
    ImageData: TByteDynArray;
    Renderer: TReSVGRenderer;

    function ReparseImage: Boolean;
  end;

var
  MainForm: TMainForm;

implementation

uses
  Controls;

{$R *.lfm}

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  Renderer.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Renderer:=TReSVGRenderer.Create(False);
end;

procedure TMainForm.FormResize(Sender: TObject);
var
  FitTo: resvg_fit_to;
  Image: TReSVGImage;
  CurAspectRatio: Double;
  RenderingTime: TDateTime;
begin
  if Renderer.HasParsedSVG and (ClientWidth>0) and (ClientHeight>0) then begin
    CurAspectRatio:=ClientWidth/ClientHeight;
    if CurAspectRatio>Renderer.OriginalImageAspectRatio then begin
      FitTo.fit_type:=RESVG_FIT_TO_HEIGHT;
      FitTo.value:=ClientHeight;
    end else begin
      FitTo.fit_type:=RESVG_FIT_TO_WIDTH;
      FitTo.value:=ClientWidth;
    end;

    RenderingTime:=Now;
    Image:=Renderer.Render(FitTo, True, clWhite);
    RenderingTime:=RenderingTime-Now;
    Caption:=FileName+': rendering time as [secs:msecs]: '+FormatDateTime('ss:zzz', RenderingTime);

    if Assigned(Image) then begin
      if CurAspectRatio>Renderer.OriginalImageAspectRatio then begin
        DisplayedImage.Top:=0;
        DisplayedImage.Height:=ClientHeight;
        DisplayedImage.Left:=(ClientWidth-Image.Width) div 2;
        DisplayedImage.Width:=Image.Width;
      end else begin
        DisplayedImage.Left:=0;
        DisplayedImage.Width:=ClientWidth;
        DisplayedImage.Top:=(ClientHeight-Image.Height) div 2;
        DisplayedImage.Height:=Image.Height;
      end;

      Image.LoadIntoRasterImage(DisplayedImage.Picture.Bitmap, False);
      Image.Free;
    end else DisplayedImage.Picture.Clear;
  end;
end;

function TMainForm.ReparseImage: Boolean;
begin
  Result:=Renderer.Parse(ImageData);
end;

procedure TMainForm.LoadFileMIClick(Sender: TObject);
var
  fs: TFileStream;
begin
  if GetSVGNameOD.Execute then begin
    fs:=TFileStream.Create(GetSVGNameOD.FileName, fmOpenRead or fmShareExclusive);
    Renderer.MakeByteArrayFromStream(fs, ImageData);
    if not ReparseImage
      then ShowMessage('SVG renderer parsing error occured: '+Renderer.ParserError)
      else FileName:=ExtractFileName(fs.FileName);
    fs.Free;

    FormResize(nil);
  end;
end;

procedure TMainForm.RendQualityMIClick(Sender: TObject);
begin
  RendQualityMI.Checked:=not RendQualityMI.Checked;
  if RendQualityMI.Checked then begin
    Renderer.SetShapeRenderingMode(RESVG_SHAPE_RENDERING_GEOMETRIC_PRECISION);
    Renderer.SetTextRenderingMode(RESVG_TEXT_RENDERING_GEOMETRIC_PRECISION);
    Renderer.SetImageRenderingMode(RESVG_IMAGE_RENDERING_OPTIMIZE_QUALITY);
  end else begin
    Renderer.SetShapeRenderingMode(RESVG_SHAPE_RENDERING_OPTIMIZE_SPEED);
    Renderer.SetTextRenderingMode(RESVG_TEXT_RENDERING_OPTIMIZE_SPEED);
    Renderer.SetImageRenderingMode(RESVG_IMAGE_RENDERING_OPTIMIZE_SPEED);
  end;

  ReparseImage;
  FormResize(nil);
end;

end.

