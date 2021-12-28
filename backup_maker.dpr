program backup_maker;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Backup Maker';
  TStyleManager.TrySetStyle('Metropolis UI Blue');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
