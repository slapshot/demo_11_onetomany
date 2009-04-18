program one_to_many;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, xml_db, Client_AutoMap_Svr,
  Client_BOM, u_mainform, RunTimeTypeInfoControls;

{$IFDEF WINDOWS}{$R one_to_many.rc}{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.



