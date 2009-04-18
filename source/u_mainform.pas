unit u_mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, tiQuery, tiQueryXMLLight, Client_AutoMap_Svr,
  Client_BOM, xml_db  , RTTICtrls, Grids, tiBaseMediator, tiFormMediator,
  tiMediators, tiListMediators;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCreateClient: TButton;
    btnReadClients: TButton;
    btnDelete: TButton;
    lbPhone: TListBox;
    lbClient: TListBox;
    sgClients: TStringGrid;
    sgPhoneNumbers: TStringGrid;
    procedure btnCreateClientClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnReadClientsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbClientClick(Sender: TObject);
    procedure sgClientsSelection(Sender: TObject; aCol, aRow: Integer);
  private
    { private declarations }
    MyClientList: TClients;
    procedure UpdateClients;
    FMediator: TFormMediator;
    FPhoneMediator: TFormMediator;
    procedure SetupMediators;
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

uses
  tiObject;

{ TForm1 }


procedure TForm1.FormCreate(Sender: TObject);
var
  XmlDB: TXMLDB;
begin
  XmlDB := TXMLDB.Create;
  try
    XmlDB.CreateDatabase('dbxml.xml');
  finally
    XmlDB.Free;
  end;
  RegisterMappings;

  RegisterFallBackMediators;
  RegisterFallBackListmediators;

  MyClientList := TClients.CreateNew('','');

  MyClientList.Read;
  MyClientList.Clear;
  MyClientList.Read;

  Writeln(MyClientList.AsDebugString);
{  if MyClientList.Count > 0 then
    ShowMessage('Ci sono diversi clienti');}
  UpdateClients;
  SetupMediators;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if FPhoneMediator.Active then
    FPhoneMediator.Active:= False;
  FMediator.Active:= False;
  if MyClientList.Dirty then
    MyClientList.Save;
  MyClientList.Free;
end;

procedure TForm1.lbClientClick(Sender: TObject);
var
  i: integer;
begin
  lbPhone.Clear;
  for i := 0 to MyClientList.Items[lbClient.ItemIndex].PhoneNumbers.Count - 1 do
  begin
    lbPhone.Items.Add(MyClientList.Items[lbClient.ItemIndex].PhoneNumbers.Items[i].NumberText);
  end;
end;


procedure TForm1.sgClientsSelection(Sender: TObject; aCol, aRow: Integer);
var
  c: TClient;
begin
  c := TClient(TStringGridMediator(FMediator.FindByComponent(sgClients).Mediator).SelectedObject);
  if Assigned(c) then
  begin
    FPhoneMediator.Subject := c.PhoneNumbers;
    if not FPhoneMediator.Active then
      FPhoneMediator.Active := True;
  end;
end;

procedure TForm1.UpdateClients;
var
  i: integer;
begin
  if MyClientList.Count > 0 then
  begin
    lbClient.Clear;
    for i := 0 to pred(MyClientList.Count) do
    begin
      lbClient.Items.Add(MyClientList.Items[i].ClientName);
    end;
  end;
end;

procedure TForm1.SetupMediators;
begin
  if not Assigned(FMediator) then
  begin
    FMediator := TFormMediator.Create(self);
    FMediator.AddComposite('ClientName(150);ClientID(100);OID(36)', sgClients);
//    FMediator.AddComposite('NumberType(30);NumberText(30)', sgPhoneNumbers);
  end;
  FMediator.Subject := MyClientList;
  FMediator.Active := True;

  if not Assigned(FPhoneMediator) then
  begin
    FPhoneMediator := TFormMediator.Create(self);
    FPhoneMediator.AddComposite('NumberType(30);NumberText(30)', sgPhoneNumbers);
  end;
//  FPhoneMediator.Subject := MyClientList.Items[0].PhoneNumbers;
//  FPhoneMediator.Active := True;
end;

       procedure TForm1.btnCreateClientClick(Sender: TObject);
var
  MyClient: TClient;
  myPhoneNumber: TPhoneNumber;
begin
  MyClient := TClient.CreateNew('','');
  MyClient.ClientID:='XXXX-YYYY';
  MyClient.ClientName:='Antonio';

  myPhoneNumber := TPhoneNumber.CreateNew('','');
  myPhoneNumber.NumberType:='Telefono-fisso';
  myPhoneNumber.NumberText:='0773-723180';

  MyClient.PhoneNumbers.Add(myPhoneNumber);

  myPhoneNumber := TPhoneNumber.CreateNew('','');
  myPhoneNumber.NumberType:='Telefono-fisso';
  myPhoneNumber.NumberText:='339-8843931';

  MyClient.PhoneNumbers.Add(myPhoneNumber);
  MyClientList.Add(MyClient);

  MyClient := TClient.CreateNew('','');
  MyClient.ClientID:='ZZZZ-WWWW';
  MyClient.ClientName:='Simone';

  myPhoneNumber := TPhoneNumber.CreateNew('','');
  myPhoneNumber.NumberType:='Telefono-fisso';
  myPhoneNumber.NumberText:='0773-725052';

  MyClient.PhoneNumbers.Add(myPhoneNumber);
  MyClientList.Add(MyClient);

  MyClientList.Save;
end;

procedure TForm1.btnDeleteClick(Sender: TObject);
var
  c: TClient;
  M: TMediatorView;
begin
  M:=FMediator.FindByComponent(sgClients).Mediator;
  c := TClient(TStringGridMediator(M).SelectedObject);
  if Assigned(c) then
    begin
      MyClientList.Extract(c);
      C.Deleted:=True;
      C.Dirty:=True;
      C.Save;
      C.Free;
      M.ObjectToGui;
    end;


{     MyClientList.Items[lbClient.ItemIndex].Deleted:=True;
  MyClientList.Items[lbClient.ItemIndex].Dirty:=True;
  MyClientList.Dirty:= True;
  MyClientList.Save;
  MyClientList.Clear;
  MyClientList.Read;}
//  UpdateClients;
//  WriteLn(MyClientList.AsDebugString);
end;

procedure TForm1.btnReadClientsClick(Sender: TObject);
var
  i: integer;
begin
  lbClient.Clear;
  FMediator.Active:=False;
  FPhoneMediator.Active:=false;
  MyClientList.Clear;
  MyClientList.Read;
  UpdateClients;
  if MyClientList.Count > 0 then
    ShowMessage('Ci sono diversi clienti nella lista');
//  FMediator.Active:=False;
  FMediator.Active:=True;
  FPhoneMediator.Active:= True;
  WriteLn(MyClientList.AsDebugString);
end;

initialization
  {$I u_mainform.lrs}

end.

