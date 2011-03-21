unit socket_types;

{$mode objfpc}{$H+}

interface

uses
  {$IF defined(WIN32) or defined(WIN64)} //delphi ou lazarus sobre windows
  WinSock;
  {$ELSE}
  {$IF defined(FPC) AND (defined(UNIX) or defined(WINCE))}
  Sockets;
  {$IFEND}
  {$IFEND}

type

  //@exclude
  {$IF defined(FPC) AND (FPC_FULLVERSION >= 20400)}
  {$IFDEF UNIX}
  t_socklen = TSockLen;
  {$ELSE}
  t_socklen = tOS_INT;
  {$ENDIF}
  {$ELSE}
  t_socklen = Integer;
  {$IFEND}

  {:
  Enumera os tipos de porta.
  @value ptTCP = Porta cliente do tipo TCP.
  @value ptUDP = Porta cliente do tipo UDP.
  }
  TPortType = (ptTCP, ptUDP);

const
  MODE_NONBLOCKING = 1;
  MODE_BLOCKING = 0;

implementation

end.
