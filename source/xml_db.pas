unit xml_db;
{< Contains TXMLDBCreator.}

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  tiOPFManager,
  tiObject,
  tiQuery
  ;
  
type

  // -----------------------------------------------------------------
  // Object classes
  // -----------------------------------------------------------------
  
  {: Responsible for creating the xml database }
  TXMLDB = class(TtiObject)
  public
    procedure   CreateDatabase(APath: string);
    // ---> Construction Ahead
    constructor Create; override;
  end;

implementation

uses
  tiConstants,
  Dialogs,
  Controls
  ;


{ TXMLDB }

procedure TXMLDB.CreateDatabase(APath: string);
var
  lTable: TtiDBMetaDataTable;
begin
  // kill file if exists
  // set new default PL.
  GTIOPFManager.DefaultPersistenceLayerName := cTIPersistXMLLight;

  // create database
  GTIOPFManager.TestThenConnectDatabase(APath, '', '');

  if FileExists(APath) then
  begin
    if MessageDlg('Drop and recreate tables ?', mtConfirmation, mbOKCancel, 0) <> mrOK then
      exit;
  end;

  DeleteFile(APath);

  GTIOPFManager.DefaultPerLayer.CreateDatabase(APath, '', '');


  // create UsersTable
  lTable := TtiDBMetaDataTable.Create;
  try
    lTable.Name := 'client';
    lTable.AddField('OID', qfkString, 36);
    lTable.AddField('client_name', qfkString, 50);
    lTable.AddField('client_ID', qfkString, 25);
    GTIOPFManager.CreateTable(lTable);
  finally;
    lTable.free;
  end;

 lTable := TtiDBMetaDataTable.Create;
  try
    lTable.Name := 'phone_number';
    lTable.AddField('OID', qfkString, 36);
    lTable.AddField('client_OID', qfkString, 36);
    lTable.AddField('number_type', qfkString, 10);
    lTable.AddField('number_text', qfkString, 50);
    GTIOPFManager.CreateTable(lTable);
  finally;
    lTable.free;
  end;
end;

constructor TXMLDB.Create;
begin
  inherited Create;
  GTIOPFManager.DefaultPersistenceLayerName := cTIPersistXMLLight;
end;

end.

