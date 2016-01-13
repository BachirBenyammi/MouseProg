program test;

uses
  Crt, Affiche, Initial, USouris;

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
      TesterExitCurseur :=  (((X div 8 >= MinX) and (X div 8 <= MaxX))
        and ( (Y div 7 >= MinY) and (Y div 7 <= MaxY)))
          and (Souris.EtatBtn1 = 1);
end;

procedure TesterExclusionCurseur;
{Si le curseur est dans la zone d'exclusion
alors initialiser ‡a position}
begin
  with Curseur do
    with ZoneExclusion do
      if ((X div 8 >= MinX) and (X div 8 <= MaxX))
        and ( (Y div 7 >= MinY) and (Y div 7 <= MaxY)) then
          InitialCurseurPos;
end;

Procedure DessinerCurseurLogiciel;
begin
  with Curseur do
    begin
      TypeCurseur := Logiciel;
      Operand1 := $00ff; {00ff}
      Operand2 := $2500; {ff00}
    end;
  DessinerCurseurTexte;
end;

procedure DessinerCurseurMaleriel;
begin
  with Curseur do
    begin
      TypeCurseur := Materiel;
      Operand1 := 4; {0}
      Operand2 := 7; {7}
    end;
  DessinerCurseurTexte;
end;

begin
 if not InitialDriver then exit;
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
	      'l': DessinerCurseurLogiciel;
	      'm': DessinerCurseurMaleriel;
              {'s': SauverEtatSouris;
              'r': RestaurerEtatSouris;}
              '+': Sensibilite := Sensibilite + 5;
              '-': Sensibilite := Sensibilite - 5;
              '7': Seuil := Seuil + 5;
              '8': Seuil := Seuil - 5;
            end;

            case Key of
              'f':
                begin
                  TesterExclusionCurseur;
                  AfficherCurseur;
                end;
              'c': CacherCurseur;
              'a': ActiverDriver;
              'd': DesactiverDriver;
              '-', '+', '7', '8': DefinirSensibiliteSouris;
            end;
          end;
      end;
    Actualisation;
  until (key = Echap) or TesterExitCurseur;
  Finalisation;
end.