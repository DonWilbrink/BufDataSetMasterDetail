unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, Forms, Controls, Graphics, Dialogs,
  DBCtrls, DBGrids, StdCtrls;

type

  { TmainForm }

  TmainForm = class(TForm)
    bdsPlaten: TBufDataset;
    bdsTracks: TBufDataset;
    dsPlaten: TDataSource;
    dsTracks: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBNavigator1: TDBNavigator;
    DBNavigator2: TDBNavigator;
    procedure bdsPlatenAfterPost(DataSet: TDataSet);
    procedure bdsPlatenBeforeInsert(DataSet: TDataSet);
    procedure bdsTracksAfterPost(DataSet: TDataSet);
    procedure bdsTracksFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    fn1: string;
    fn2: string;
  public

  end;

var
  mainForm: TmainForm;

implementation

{$R *.lfm}

{ TmainForm }

procedure TmainForm.FormCreate(Sender: TObject);
begin
  fn1 := 'platen.bds';
  if FileExists(fn1) then
  begin
    bdsPlaten.LoadFromFile(fn1);
    bdsPlaten.Active := True;
    bdsPlaten.First;
  end
  else
  begin
    bdsPlaten.CreateDataset;
    bdsPlaten.Active := True;
    bdsPlaten.SaveToFile(fn1);
  end;
  fn2 := 'tracks.bds';
  if FileExists(fn2) then
  begin
    bdsTracks.LoadFromFile(fn2);
    bdsTracks.Active := True;
    bdsTracks.First;
  end
  else
  begin
    bdsTracks.CreateDataset;
    bdsTracks.Active := True;
    bdsTracks.SaveToFile(fn2);
  end;

end;

procedure TmainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  bdsPlaten.SaveToFile(fn1);
  bdsTracks.SaveToFile(fn2);
  CloseAction := caFree;
end;

procedure TmainForm.bdsTracksFilterRecord(DataSet: TDataSet; var Accept: Boolean
  );
begin
  Accept := (bdsTracks.FieldByName('AlbumID').AsInteger = bdsPlaten.FieldByName('ID').AsInteger);
end;

procedure TmainForm.bdsTracksAfterPost(DataSet: TDataSet);
begin
  bdsTracks.First;
end;

procedure TmainForm.bdsPlatenAfterPost(DataSet: TDataSet);
begin
  bdsTracks.Filtered := False;
  bdsTracks.Filtered := True;
  bdsTracks.First;
end;

procedure TmainForm.bdsPlatenBeforeInsert(DataSet: TDataSet);
begin
  DBGrid2.Clear;
end;

procedure TmainForm.DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType
  );
begin
  if ((Button = nbNext) or (Button = nbPrior) or (Button = nbFirst) or (Button = nbLast)) then
  begin
    bdsTracks.Filtered := False;
    bdsTracks.Filtered := True;
    bdsTracks.First;
  end;
end;

end.

