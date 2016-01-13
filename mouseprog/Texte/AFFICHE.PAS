Unit Affiche;

Interface

uses
  Crt, USouris;

procedure OutTxtXY(x, y: integer; chaine: string);
procedure OutIntXY(x, y, valeur: integer);
procedure AfficherInfosSouris;
procedure AfficherAide;
procedure DessinerRect(x1, y1, x2, y2: word);
procedure DessinerSouris;
procedure DessinerZone;
procedure Actualisation;
procedure Finalisation;

Implementation

procedure OutTxtXY(x, y: integer; chaine: string);
begin
  GotoXY(x,y);
  Write(chaine);
end;

procedure OutIntXY(x, y, valeur: integer);
var
  chaine: string;
begin
  GotoXY(x,y);
  Write('     ');
  str(valeur,chaine);
  OutTxtXY(x, y, chaine);
end;

procedure AfficherInfosSouris;
begin
  with Souris do
    begin
      if AncienEB1 <> EtatBtn1 then
        begin
          OutIntXY(75, 18, EtatBtn1);
          AncienEB1 := EtatBtn1;
        end;
      if AncienEB2 <> EtatBtn2 then
        begin
          OutIntXY(75, 19, EtatBtn2);
          AncienEB2 := EtatBtn2;
        end;
    end;
  with Curseur do
    begin
      if (DistanceX <> 0) or (DistanceY <> 0) then
        begin
          OutIntXY(75, 20, X);
          OutIntXY(75, 21, Y);
          OutIntXY(75, 22, DistanceX);
          OutIntXY(75, 23, DistanceY);
        end;
      if (AncienSensibilite <> Sensibilite) then
        begin
          OutIntXY(75, 24, Sensibilite);
          AncienSensibilite := Sensibilite;
        end;
      if (AncienSeuil <> Seuil) then
        begin
          OutIntXY(75, 25, Seuil);
          AncienSeuil := Seuil;
        end;
    end;
end;

procedure AfficherAide;
begin
  OutTxtXY(1, GetMaxY-6, '[Echape]: Quitter  [+/-]: Sensibilite');
  OutTxtXY(1, GetMaxY-5, '[7/8]: Seuil  [L]ogiciel  [M]ateriel');
  OutTxtXY(1, GetMaxY-4, '[D]esactiver  [A]ctiver  a[F]ficher  [C]acher');
  OutTxtXY(1, GetMaxY-3, '(D): Deplacement  (E): Exclusion  (Q): Quitter');
end;

procedure DessinerRect(x1, y1, x2, y2: word);
var
  i: word;
begin
  for i:= x1 to x2 do
    begin
      OutTxtXY(i, y1, 'Í');
      OutTxtXY(i, y2, 'Í');
   end;
  for i:= y1 to y2 do
    begin
      OutTxtXY(x2, i, 'º');
      OutTxtXY(x1, i, 'º');
    end;
  OutTxtXY(x1, y1, 'É');
  OutTxtXY(x2, y1, '»');
  OutTxtXY(x1, y2, 'È');
  OutTxtXY(x2, y2, '¼');
end;

procedure DessinerSouris;
begin
  OutTxtXY(66, 18, 'Btn. 1 = ');
  OutTxtXY(66, 19, 'Btn. 2 = ');
  OutTxtXY(66, 20, 'X      = ');
  OutTxtXY(66, 21, 'Y      = ');
  OutTxtXY(66, 22, 'Dist.X = ');
  OutTxtXY(66, 23, 'Dist.Y = ');
  OutTxtXY(66, 24, 'Sens.  = ');
  OutTxtXY(66, 25, 'Seuil  = ');
end;

procedure DessinerZone;
begin
  with ZoneDeplacement do
    begin
      DessinerRect(MinX, MinY, MaxX, MaxY);
      OutTxtXY(MinX+1, MinY+1, 'D');
    end;
  with ZoneExclusion do
    begin
      DessinerRect(MinX, MinY, MaxX, MaxY);
      OutTxtXY(MaxX, MinY, '¶');
      OutTxtXY(MinX, MaxY, 'Ê');
      OutTxtXY(MinX+1, MinY+1, 'E');
    end;
  with ZoneExit do
    begin
      DessinerRect(MinX, MinY, MaxX, MaxY);
      OutTxtXY(MinX, MinY, 'Ì');
      OutTxtXY(MaxX, MaxY, 'Ê');
      OutTxtXY(MinX+1, MinY+1, 'Q');
    end;
  DessinerSouris;
  AfficherAide;
end;

procedure Actualisation;
{Actualiser les infos de la souris}
begin
  LireDistance;
  LirePosCurseur;
  LireSensibiliteSouris;
  AfficherInfosSouris
end;

procedure Finalisation;
{lorsqu'on termine le programme}
begin
  CacherCurseur;
  with ZoneDeplacement do
    begin
      MinX := 0;
      MinY := 0;
      MaxX := GetMaxX;
      MaxY := GetMaxY;
    end;
  DefinirZoneDeplacement;
end;

end.