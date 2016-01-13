Unit Affiche;

Interface

uses
  Crt, Graph, USouris;

procedure OutTxtXY(x, y, TxtColor, BgColor: integer; chaine: string);
procedure OutIntXY(x, y, TxtColor, BgColor, valeur: integer);
procedure OutColorText(Chaine: string; pos, long: integer);
procedure AfficherInfosSouris;
procedure AfficherAide;
procedure DessinerRect(x1, y1, x2, y2, Color: word);
procedure DessinerSouris;
procedure DessinerZone;
procedure Actualisation;
procedure Finalisation;

Implementation

procedure OutTxtXY(x, y, TxtColor, BgColor: integer; chaine: string);
var
  color: word;
begin
  color := GetColor;
  SetColor(TxtColor);
  SetFillStyle(SoliDFill, BgColor);
  Bar(x-2, y-2, x+40, y+8);
  OutTextXY(x, y, chaine);
  SetColor(color);
end;

procedure OutIntXY(x, y, TxtColor, BgColor, valeur: integer);
var
  chaine: string;
begin
  str(valeur,chaine);
  OutTxtXY(x, y, TxtColor, BgColor, chaine);
end;

procedure OutColorText(Chaine: string; pos, long: integer);
var
   Color: word;
begin
  Color := GetColor;
 if pos > 0 then
   OutText(Copy(Chaine,0, pos));
 SetColor(Yellow);
 OutText(Copy(Chaine, pos+1, long));
 SetColor(Color);
 if length(Chaine) > pos + long +1 then
   OutText(Copy(Chaine, pos+long+1, length(Chaine)));
end;

procedure AfficherInfosSouris;
begin
  with Souris do
    begin
      if AncienEB1 <> EtatBtn1 then
        begin
          case EtatBtn1 of
            0: DessinerRect(505, 350, 555, 400, LightGray);
            1: DessinerRect(505, 350, 555, 400, Brown);
          end;
          AncienEB1 := EtatBtn1;
        end;
      if AncienEB2 <> EtatBtn2 then
        begin
          case EtatBtn2 of
            0: DessinerRect(560, 350, 610, 400, LightGray);
            2: DessinerRect(560, 350, 610, 400, Brown);
          end;
          AncienEB2 := EtatBtn2;
        end;
    end;
  with Curseur do
    begin
      if DistanceX <> 0 then
        begin
          OutIntXY(575, 410, Blue, Yellow, X);
          OutIntXY(575, 430, Blue, Yellow, DistanceX);
        end;
      if DistanceY <> 0 then
        begin
          OutIntXY(575, 420, Blue, Yellow, Y);
          OutIntXY(575, 440, Blue, Yellow, DistanceY);
        end;
      if AncienSensibilite <> Sensibilite then
        begin
          OutIntXY(575, 450, Blue, Yellow, Sensibilite);
          AncienSensibilite := Sensibilite;
        end;
      if AncienSeuil <> Seuil then
        begin
          OutIntXY(575, 460, Blue, Yellow, Seuil);
          AncienSeuil := Seuil;
        end;
    end;
end;

procedure AfficherAide;
begin
  MoveTo(10, GetMaxY-60);
  OutColorText('Echape: Quitter  ',0, 6);
  OutColorText('+/-: Sensibilite  ',0, 3);
  OutColorText('7/8: Seuil  ',0, 3);
  OutColorText('1-6: Changer',0, 5);

  MoveTo(10, GetMaxY-50);
  OutColorText('DESACTIVER  ', 0,1);
  OutColorText('ACTIVER  ', 0,1);
  OutColorText('AFFICHER  ', 1,1);
  OutColorText('CACHER', 0,1);

  DessinerRect(10, GetMaxY-20, 21, GetMaxY-12, Red);
  OutTextXY(26, GetMaxY-20, ': Deplacement');
  DessinerRect(150, GetMaxY-20, 160, GetMaxY-12, Blue);
  OutTextXY(165, GetMaxY-20, ': Exclusion');
  DessinerRect(270, GetMaxY-20, 280, GetMaxY-12, Green);
  OutTextXY(285, GetMaxY-20, ': Quitter');

  DessinerRect(10, GetMaxY-10, 21, GetMaxY-2, LightGray);
  OutTextXY(26, GetMaxY-10, ': Relache');
  DessinerRect(150, GetMaxY-10, 160, GetMaxY-2, Brown);
  OutTextXY(165, GetMaxY-10, ': Enfonce');
  DessinerRect(270, GetMaxY-10, 280, GetMaxY-2, Yellow);
  OutTextXY(285, GetMaxY-10, ': Souris');
end;

procedure DessinerRect(x1, y1, x2, y2, Color: word);
begin
  SetFillStyle(SolidFill, Color);
  Bar(X1, Y1, X2, Y2);
  Rectangle(X1, Y1, X2, Y2);
end;

procedure DessinerSouris;
begin
  SetFillStyle(SolidFill, Yellow);
  Bar3d(500, 340, 615, 475, 10, True);
  DessinerRect(505, 350, 555, 400, LightGray);
  DessinerRect(560, 350, 610, 400, LightGray);
  OutTxtXY(505, 410, blue, yellow, 'X      = ');
  OutTxtXY(505, 420, blue, yellow, 'Y      = ');
  OutTxtXY(505, 430, blue, yellow, 'Dist.X = ');
  OutTxtXY(505, 440, blue, yellow, 'Dist.Y = ');
  OutTxtXY(505, 450, blue, yellow, 'Sens.  = ');
  OutTxtXY(505, 460, blue, yellow, 'Seuil  = ');
end;

procedure DessinerZone;
begin
  SetFillStyle(SolidFill, Red);
  with ZoneDeplacement do
    Bar3D(MinX, MinY, MaxX, MaxY, 10, True);
  with ZoneExclusion do
    DessinerRect(MinX, MinY, MaxX, MaxY, Blue);
  with ZoneExit do
    DessinerRect(MinX, MinY, MaxX, MaxY, Green);
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
  CloseGraph;
end;

end.