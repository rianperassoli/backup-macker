program backup_maker;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Backup Maker';
  TStyleManager.TrySetStyle('Metropolis UI Blue');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
