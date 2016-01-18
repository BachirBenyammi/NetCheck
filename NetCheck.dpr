program NetCheck;

uses
  Forms,
  SysUtils,
  UMain in 'UMain.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Connection check';
  Application.CreateForm(TMainForm, MainForm);
  Application.Minimize;
  Application.Run;
end.
