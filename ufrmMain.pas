unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TFrmMain = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    function AppHookFunc(var Message: TMessage): Boolean;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses
  uOneInstance;

function TFrmMain.AppHookFunc(var Message: TMessage): Boolean;
var
  Proc, MySelf: Integer;
begin
  Result := False;
  //
  if Message.Msg = uOneInstance.BroadcastMessageResult then
  begin
    Proc := GetWindowThreadProcessId(GetForeGroundWindow);
    MySelf := GetCurrentThreadID;

    if (Proc <> MySelf) then
    begin
      AttachThreadInput(MySelf, Proc, True);
    end;

    SetForeGroundWindow(Handle);

    if (Proc <> MySelf) then
    begin
      AttachThreadInput(MySelf, Proc, False);
      Application.BringToFront;
    end;

    if IsIconic(Self.Handle) then
      ShowWindow(Self.Handle, SW_RESTORE);
    //
    Result := True;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  Application.HookMainWindow(AppHookFunc);
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  Application.UnHookMainWindow(AppHookFunc);
end;

end.
