unit uOneInstance;

interface

var
  BroadcastMessageResult: Cardinal;

implementation

uses
  WinApi.Windows,
  System.SysUtils;

procedure OneInstanceInit;
const
  cMessageUid = 'D972288D-A934-4781-BEBD-AEDBAA50157C';
var
  SecurityDesc: TSecurityDescriptor;
  SecurityAttr: TSecurityAttributes;
begin
  InitializeSecurityDescriptor(@SecurityDesc, SECURITY_DESCRIPTOR_REVISION);

  SetSecurityDescriptorDacl(@SecurityDesc, True, nil, False);

  SecurityAttr.nLength := SizeOf(SecurityAttr);
  SecurityAttr.lpSecurityDescriptor := @SecurityDesc;
  SecurityAttr.bInheritHandle := False;

  if CreateMutex(@SecurityAttr, False, PChar(cMessageUid)) = 0 then
  begin
    RaiseLastOSError;
  end;

  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    SendMessageTimeout(HWND_BROADCAST, RegisterWindowMessage(PChar(cMessageUid)), 0, 0, SMTO_ERRORONEXIT OR SMTO_ABORTIFHUNG, 600, BroadcastMessageResult);
    Halt(0);
  end
  else
  begin
    BroadcastMessageResult := RegisterWindowMessage(PChar(cMessageUid));
  end;
end;

initialization
  OneInstanceInit;
end.
