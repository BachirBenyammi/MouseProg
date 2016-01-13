program test;

uses
  Crt, Graph, Affiche, Initial, Curseurs, USouris;

const
  Echap = #27;

var
 key: char;

function TesterExitCurseur: boolean;
{Returner True si :
 1-le curseur est dans la zone d'exit et
 2-l'utilisateur cliquer sur les 2 boutns}
begin
  with Curseur do
    with ZoneExit do
      TesterExitCurseur :=  (((X >= MinX) and (X <= MaxX))
        and ( (Y >= MinY) and (Y <= MaxY)))
          and (Souris.EtatBtn1 = 1);
end;

procedure TesterExclusionCurseur;
{Si le curseur est dans la zone d'exclusion
alors initialiser ‡a position}
begin
  with Curseur do
    with ZoneExclusion do
      if ((X >= MinX) and (X <= MaxX))
        and ( (Y >= MinY) and (Y <= MaxY)) then
          InitialCurseurPos;
end;

begin
 if not InitialDriver then exit;
  InitialGraph;
  Initialisation;
  DessinerZone;
  AfficherCurseur;

  repeat
    if KeyPressed then
      begin
        key := ReadKey;
        with Curseur do
          begin
            case Key of
              '1': CurseurGraph := Fleche;
              '2': CurseurGraph := Heure;
              '3': CurseurGraph := Plus;
              '4': CurseurGraph := Main;
              '5': CurseurGraph := Archi;
              '6': CurseurGraph := Arch;
              '+': Sensibilite := Sensibilite + 5;
              '-': Sensibilite := Sensibilite - 5;
              '7': Seuil := Seuil + 5;
              '8': Seuil := Seuil - 5;
            end;

            case Key of
              'a': ActiverDriver;
              'd': DesactiverDriver;
              'f':
                begin
                  TesterExclusionCurseur;
                  AfficherCurseur;
                end;
              'c': CacherCurseur;
              '1'..'6': DessinerCurseurGraph;
              '-', '+', '7', '8': DefinirSensibiliteSouris;	
              {'s': SauverEtatSouris;
              'r': RestaurerEtatSouris;}
            end;
          end;
      end;
    Actualisation;
  until (key = Echap) or TesterExitCurseur;
  Finalisation;
end.