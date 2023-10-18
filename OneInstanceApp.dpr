program OneInstanceApp;

uses
  uOneInstance in 'uOneInstance.pas',
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {FrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
