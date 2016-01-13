Unit Initial;

Interface

uses Crt, USouris;

procedure InitialCurseurPos;
function InitialDriver: boolean;
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

procedure Initialisation;
begin
  Clrscr;
  with ZoneDeplacement do
    begin
      MinX := 2;
      MinY := 2;
      MaxX := GetMaxX - 2;
      MaxY := GetMaxY - 10;
    end;
  DefinirZoneDeplacement;

  with ZoneExclusion do
    begin
      MinX := GetMaxX - 12;
      MinY := GetMaxY - 15;
      MaxX := GetMaxX - 2;
      MaxY := GetMaxY - 10;
    end;
  DefinirZoneExclusion;

  with ZoneExit do
    begin
      MinX := 2;
      MinY := GetMaxY - 15;
      MaxX := 12;
      MaxY := GetMaxY - 10;
    end;
end;
end.