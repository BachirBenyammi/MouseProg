Unit Initial;

Interface

uses Crt, Graph, USouris;

procedure InitialCurseurPos;
function InitialDriver: boolean;
function InitialGraph: boolean;
procedure Initialisation;

Implementation

procedure InitialCurseurPos;
begin
  with Curseur do
    with ZoneDeplacement do
      begin
        X := MinX + (MaxX-MinX) div 2;
        Y := MinY + (MaxY-MinY) div 2;
        DefinirPosCurseur;
      end;
end;

function InitialDriver: boolean;
begin
  clrscr;
  Writeln('Bienvenu dans notre programme !!');
  Writeln;
  Writeln('Lancer le teste du driver... ');
  TesterDriver;
  delay (500);
  with Driver do
    case DrvExiste of
      True:
        begin
          writeln('Driver existe     : oui');
          writeln('Version du driver : ' + Version);
          writeln('Type de souris    : ' + TypeDrv);
          writeln('Brouche IRQ       : ' , Irq);
          writeln('Nombre du boutons : ' , Souris.NbrBtns);
          writeln;
          writeln('Appuyer sur une touche pour continue ...');
        end;
      False:
        begin
          writeln('Driver non existe');
          writeln('Appuyer sur une touche pour quitter ...');
        end;
    end;
  InitialDriver := Driver.DrvExiste;
  readkey;
end;

function InitialGraph: boolean;
var
  GraphDriver, GraphMode: Integer;
begin
  GraphDriver := Detect;
  InitGraph(GraphDriver, GraphMode, ' ');
  InitialGraph := (GraphResult = grOk);
end;

procedure Initialisation;
begin
  with ZoneDeplacement do
    begin
      MinX := 20;
      MinY := 20;
      MaxX := GetMaxX - 20;
      MaxY := GetMaxY - 150;
    end;
  DefinirZoneDeplacement;

  with ZoneExclusion do
    begin
      MinX := GetMaxX - 70;
      MinY := GetMaxY - 200;
      MaxX := GetMaxX - 20;
      MaxY := GetMaxY - 150;
    end;
  DefinirZoneExclusion;

  with ZoneExit do
    begin
      MinX := 20;
      MinY := GetMaxY - 200;
      MaxX := 70;
      MaxY := GetMaxY - 150;
    end;
end;
end.