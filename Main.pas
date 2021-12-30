unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.IOUtils, Types, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage, FileCtrl,
  UiTypes;

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
    function FolderIgnored(const AFolderPath: String): Boolean;
    function SelectFolder: string;
    procedure CopyFilesAndFolders(APathOrigin, APathDestination: string);
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
  else if (edtPathOrigin.Text = edtPathDestination.Text) then
  begin
    edtPathDestination.SelectAll;
    MessageDlg('Não é possivel selecionar a mesma pasta para origem e destino.', mtInformation, [mbOK], 0);
    edtPathDestination.SetFocus;
    Exit(False);
  end
  else if TDirectory.IsEmpty(edtPathOrigin.Text) then
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
    try
      CopyFilesAndFolders(edtPathOrigin.Text, edtPathDestination.Text);

      MessageDlg('Sucesso ao copiar dados.', mtInformation, [mbOK], 0);
    except
      on E: Exception do
        MessageDlg('Falha ao copiar dados. Erro: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TMainForm.FolderIgnored(const AFolderPath: String): Boolean;
begin
  Result := memIgnoreFolders.Lines.IndexOf(AFolderPath) >= 0;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  edtPathOrigin.SetFocus;
end;

function TMainForm.SelectFolder: string;
var
  sPath: string;
begin
  Result := EmptyStr;

  if SelectDirectory('Selecione uma pasta', '', sPath) then
    Result := sPath;
end;

procedure TMainForm.CopyFilesAndFolders(APathOrigin, APathDestination: string);
var
  oSearchRec: TSearchRec;
  bFineshed: Boolean;
begin
  APathOrigin := IncludeTrailingPathDelimiter(APathOrigin);
  APathDestination := IncludeTrailingPathDelimiter(APathDestination);

  bFineshed := FindFirst(APathOrigin + '*.*', faAnyFile, oSearchRec) <> 0;

  while not bFineshed do
  begin
    if (oSearchRec.Attr and faDirectory) = faDirectory then
    begin
      if (oSearchRec.Name <> '.') and (oSearchRec.Name <> '..') then
      begin
        if not FolderIgnored(APathOrigin + oSearchRec.Name) then
        begin
          System.SysUtils.ForceDirectories(APathDestination + oSearchRec.Name);
          CopyFilesAndFolders(APathOrigin + oSearchRec.Name, APathDestination + oSearchRec.Name);
        end;
      end;
    end
    else
    begin
      if not CopyFile(PChar(APathOrigin + oSearchRec.Name), PChar(APathDestination + oSearchRec.Name), False) then
      begin
        ShowMessage('Erro ao copiar: ' + APathOrigin + ' para: ' + APathDestination);
      end;
    end;

    bFineshed := FindNext(oSearchRec) <> 0;
  end;
end;

end.

