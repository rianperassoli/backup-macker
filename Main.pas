unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.IOUtils,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage, FileCtrl, UiTypes;

type
  TMainForm = class(TForm)
    pnlMain: TPanel;
    btnStart: TButton;
    pnlFields: TPanel;
    edtPathOrigin: TLabeledEdit;
    btnSelectOriginPath: TImage;
    btnSelectDestinationPath: TImage;
    edtPathDestination: TLabeledEdit;
    pnlIgnoreFolders: TPanel;
    lblIgnoreFolders: TLabel;
    memIgnoreFolders: TMemo;
    lblHelp: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnSelectOriginPathClick(Sender: TObject);
    procedure btnSelectDestinationPathClick(Sender: TObject);
  private
    function ValidationPaths: Boolean;
    function IsEmptyFolder(APath: string): Boolean;
    function SelectFolder: string;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

function TMainForm.ValidationPaths: Boolean;
begin
  Result := True;

  if Trim(edtPathOrigin.Text) = EmptyStr then
  begin
    MessageDlg('O diretório de origem é inválido.', mtInformation, [mbOK], 0);
    edtPathOrigin.SetFocus;
    Exit(False);
  end
  else if Trim(edtPathDestination.Text) = EmptyStr then
  begin
    MessageDlg('O diretório de destino é inválido.', mtInformation, [mbOK], 0);
    edtPathDestination.SetFocus;
    Exit(False);
  end
  else if not System.SysUtils.DirectoryExists(edtPathOrigin.Text) then
  begin
    edtPathOrigin.SelectAll;
    MessageDlg('A pasta de origem não existe.', mtInformation, [mbOK], 0);
    edtPathOrigin.SetFocus;
    Exit(False);
  end
  else if not System.SysUtils.DirectoryExists(edtPathDestination.Text) then
  begin
    edtPathDestination.SelectAll;
    MessageDlg('A pasta de destino não existe.', mtInformation, [mbOK], 0);
    edtPathDestination.SetFocus;
    Exit(False);
  end
  else if edtPathOrigin.Text = edtPathDestination.Text then
  begin
    edtPathDestination.SelectAll;
    MessageDlg('Não é possivel selecionar a mesma pasta para origem e destino.', mtInformation, [mbOK], 0);
    edtPathDestination.SetFocus;
    Exit(False);
  end
  else if IsEmptyFolder(edtPathOrigin.Text) then
  begin
    edtPathOrigin.SelectAll;
    MessageDlg('A pasta de origem está vazia', mtInformation, [mbOK], 0);
    edtPathOrigin.SetFocus;
    Exit(False);
  end;
end;

procedure TMainForm.btnSelectDestinationPathClick(Sender: TObject);
begin
  edtPathDestination.Text := SelectFolder;

  btnStart.SetFocus;
end;

procedure TMainForm.btnSelectOriginPathClick(Sender: TObject);
begin
  edtPathOrigin.Text := SelectFolder;

  edtPathDestination.SetFocus;
end;

procedure TMainForm.btnStartClick(Sender: TObject);
begin
  if ValidationPaths then
  begin
    showmessage('bora');
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  edtPathOrigin.SetFocus;
end;

function TMainForm.IsEmptyFolder(APath: string): Boolean;
begin
  Result := TDirectory.IsEmpty(APath);
end;

function TMainForm.SelectFolder: string;
var
  sPath: String;
begin
  Result := EmptyStr;

  if SelectDirectory('Selecione uma pasta', '', sPath) then
    Result := sPath;
end;

end.

