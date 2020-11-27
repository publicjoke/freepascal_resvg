program resvg_test;

{$mode objfpc}{$H+}

uses
  {$if defined(LINUX)}
    {$DEFINE UseCThreads}
  {$endif}

  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$if not declared(useHeapTrace)}
  cmem,
  {$endIf}
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main
  { you can add units after this };

{$R *.res}

begin
  {$if declared(useHeapTrace)}
  setHeapTraceOutput('trace.log');
  {$endIf}
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

