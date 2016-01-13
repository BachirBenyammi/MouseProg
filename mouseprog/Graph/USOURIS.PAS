Unit USouris;

Interface

Uses
  dos, Curseurs;

procedure TesterDriver;
procedure ActiverDriver;
procedure DesactiverDriver;
procedure LirePosCurseur;
procedure DefinirPosCurseur;
procedure LireDistance;
procedure DefinirZoneDeplacement;
procedure DefinirZoneExclusion;
procedure AfficherCurseur;
procedure CacherCurseur;
procedure DessinerCurseurGraph;
procedure DessinerCurseurTexte;
procedure LireSensibiliteSouris;
procedure DefinirSensibiliteSouris;
function LireTailleBuffer: word;
procedure SauverEtatSouris;
procedure RestaurerEtatSouris;

const
  Logiciel = 0;
  Materiel = 1;

var
  Driver : record {les infos du driver}
    DrvExiste: boolean;
    Version: string;
    TypeDrv: string;
    Irq: byte;
  end;

  Souris : record {les infos de la souris}
    NBrBtns: byte;
    EtatBtn1, EtatBtn2: byte;
    AncienEB1, AncienEB2: byte;
  end;

  Curseur : record {les infos du curseur}
    Seuil: word;
    AncienSeuil: word;
    X,Y: word;
    DistanceX, DistanceY: word;
    Sensibilite: byte;
    AncienSensibilite: byte;
    CurseurGraph: TCurseur;
    TypeCurseur: word;
    Operand1, Operand2: word;
  end;

  ZoneExclusion: record {la zone d'exclusion}
    MinX, MinY, MaxX, MaxY: word;
  end;

  ZoneDeplacement: record {la zone de deplacement}
    MinX, MinY, MaxX, MaxY: word;
  end;

  ZoneExit: record {la zone d'exit}
    MinX, MinY, MaxX, MaxY: word;
  end;

  reg: registers; {les registres du travaille}
  {CurseurType: boolean;}

  BufferEtatSouris: array[0..999] of word; {Le buffer d'état de la souris}
  TailleBuffer: word; {La taille du buffer d'état de la souris}

Implementation

procedure TesterDriver;
{Réinitialise et lire les infos de la souris}
{*******************************************************
Int33h, Fct 00h   Réinitialisation du driver de souris
Entrée :AX = 0000h
Sortie :
	AX = FFFFh : un driver de souris est installé
	BX = Nombre de boutons de la Souris
	AX = 0000h : erreur, aucun driver n'est installé
********************************************************
Int 33h, Fct 24h   Lire le type de souris
Entrée :AX=0024h
Sortie :
	BH = Partie entière du numéro de version
	BL = Partie décimale du numéro de version
	CH = Type de souris
		1 = Souris bus
		2 = Souris série
		3 = Souris InPort
		4 = Souris PS/2
		5 = Souris HP
	CL = Numéro IRQ
		0 = PS/2
		2, 3, 4, 5 ou 7 = Numéro PC
********************************************************}
var
  VerH, VerL: string;
begin
  with Driver do
    with reg do
     begin
       ax := 0;
       intr ($33, reg);
       Souris.NbrBtns := bl;
       DrvExiste := (ax <> 0);
       if not DrvExiste then exit;

       ax := $24;
       intr($33, reg);
       str(bl, VerL);
       str(bh, VerH);
       Version := VerH + '.' + VerL;
       Irq := cl;
       case ch of
         1: TypeDrv :='Souris Bus';
         2: TypeDrv :='Souris Série';
         3: TypeDrv :='Souris InPort';
         4: TypeDrv :='Souris PS/2';
         5: TypeDrv :='Souris HP';
       end;
     end;
end;

procedure ActiverDriver;
{Activer le driver}
{********************************************************
Int 33h, Fct 20h    Activer le driver de la souris
Entrée :AX = 0020h
Sortie :
	AX = FFFFh : Erreur
	AX = 0020h : Tout va bien
********************************************************}
begin
  reg.ax := $20;
  intr($33, reg);
end;

Procedure DesactiverDriver;
{Désactiver le driver}
{********************************************************
Int 33h, Fct 1Fh    Désactiver le driver de la souris
Entrée :AX = 001Fh
Sortie :
	AX = FFFFh : Erreur
	AX = 001Fh : Tout va bien
	ES:BX = Adresses de segment et d'offset du driver de souris antérieur
********************************************************}
begin
  reg.ax := $1f;
  intr($33, reg);
end;

procedure LirePosCurseur;
{Lire la position et l'état du boutons}
{********************************************************
Int 33h, Fct 03h   Lire la position et l'état des boutons de la souris
Entrée :AX = 0003h
Sortie :
	BX = Etat des boutons de la Souris
		Bit Signification
		0   1 = bouton gauche de la souris appuyé
		1   1 = bouton droit de la souris appuyé
		2   1 = bouton central de la souris appuyé
		Autre	Aucune
	CX = Position horizontale de la Souris
	DX = Position verticale de la souris
********************************************************}
begin
  with Souris do
    with Curseur do
      with reg do
        begin
          ax := $3;
          intr($33, reg);
	  EtatBtn1 := bl and 1;
   	  EtatBtn2 := bl and 2;
          x := cx;
          y := dx;
        end;
end;

procedure DefinirPosCurseur;
{Déplacer le curseur}
{********************************************************
Int 33h, Fct 04h    Déplacement du curseur de la souris
Entrée :
	AX = 0004h
	CX = Position horizontale de la Souris
	DX = Position verticale de la souris
Sortie :Aucune
********************************************************}
begin
  with Curseur do
    with reg do
      begin
        ax := $04;
        cx := x;
        dx := y;
      end;
  intr($33, reg);
end;

procedure LireDistance;
{Lire la distance de déplacement}
{********************************************************
Int 33h, Fct 0Bh    Lire les distances de déplacement
Entrée :AX = 000Bh
Sortie :
	CX = Distance horizontale
	DX = Distance verticale
********************************************************}
begin
  with reg do
    with Curseur do
      begin
        ax := $0b;
        intr($33, reg);
        DistanceX := cx;
        DistanceY := dx;
    end;
end;

procedure DefinirZoneDeplacement;
{Fixer la zone de deplacement}
{********************************************************
Int 33h, Fct 07h (08h)    Définir la zone de déplacement horizontale (verticale ) pour le curseur de la souris
Entrée :
	AX = 0007h (0008h)
	CX = position horizontale minimale de la souris
	DX = position horizontale maximale de la souris
Sortie :Aucune
********************************************************}
begin
  with ZoneDeplacement do
    with reg do
      begin
        ax := $07;
        cx := MinX;
        dx := MaxX;
        intr($33, reg);

        ax := $08;
        cx := MinY;
        dx := MaxY;
        intr($33, reg);
      end;
end;

procedure DefinirZoneExclusion;
{Fixer la zone d'exclusion}
{********************************************************
Int 33h, Fct 10h    Définir la zone d'exclusion
Entrée :
	AX = 0010h
	CX = Ordonnée X du coin supérieur gauche
	DX = Ordonnée Y du coin supérieur gauche
	SI = Ordonnée X du coin inférieur droit
	DI = Ordonnée Y du coin inférieur droit
Sortie :Aucune
********************************************************}
begin
  with ZoneExclusion do
    with reg do
    begin
      ax := $10;
      cx := MinX;
      dx := MinY;
      si := MaxX;
      di := MaxY;
    end;
  intr($33, reg);
end;

procedure AfficherCurseur;
{Afficher le curseur}
{********************************************************
Int 33h, Fct 01h    Afficher le curseur de la souris
Entrée :AX = 0001h
Sortie :Aucune
********************************************************}
begin
  reg. ax := 1;
  intr($33, reg);
  DefinirZoneExclusion;
end;

procedure CacherCurseur;
{Cacher le curseur}
{********************************************************
Int 33h, Fct 02h    Masquer le curseur de la souris
Entrée :AX = 0002h
Sortie :Aucune
********************************************************}
begin
  reg. ax := 2;
  intr($33, reg);
end;

procedure DessinerCurseurGraph;
{Afficher le curseur en mode graphique}
{********************************************************
Int 33h, Fct 09h    Définit le curseur de la souris en mode graphique
Entrée :
	AX = 0009h
	BX = Distance du point de référence au bord gauche du tableau de bits
	CX = Distance du point de référence au bord supérieur du tableau de bits
	ES:DX	= Adresses de segment et d'offset du tableau de bits dans la mémoire
Sortie :Aucune
********************************************************}
begin
  CacherCurseur;
  with Curseur do
    with reg do
      begin
        ax := $09;
        bx := 0;
        cx := 0;
        es := seg(CurseurGraph);
        dx := ofs(CurseurGraph);
      end;
  intr($33, reg);
  AfficherCurseur;
end;

procedure DessinerCurseurTexte;
{Afficher le curseur en mode texte}
{********************************************************
Int 33h, Fct 0Ah    Définit le curseur de la souris en mode de texte
Entrée :
	AX = 000Ah
	BX = Type de curseur de la Souris
		0 = curseur logiciel
		1 = curseur électronique
	CX = Masque AND pour le curseur logiciel ou la ligne de départ du curseur électronique
	DX = Masque XOR pour le curseur logiciel ou la ligne finale du curseur électronique
Sortie :Aucune
********************************************************}
begin
  with reg do
    with Curseur do
      begin
        ax := $0a;
        bx := TypeCurseur;
        cx := Operand1;
        dx := Operand2;
      end;
  intr($33, reg);
end;

procedure LireSensibiliteSouris;
{Lire la sensibilitité de la souris}
{********************************************************
Int 33h, Fct 1Bh    Lire la sensibilité de la souris
Entrée :AX = 001Bh
Sortie :
	BX = Nombre de mickeys représentant huit points horizontalement
	CX = Nombre de mickeys représentant huit points verticalement
	DX = Seuil pour le doublement de la vitesse de la souris
********************************************************}
begin
  with Curseur do
    with reg do
      begin
        ax := $1b;
        intr($33, reg);
        {Sensibilite := bx;}
        Sensibilite := cx;
        Seuil := dx;
      end;
end;

procedure DefinirSensibiliteSouris;
{Fixer la sensibilite de la souris}
{********************************************************
Int 33h, Fct 1Ah    Définir la sensibilité de la souris
Entrée :
	AX = 001Ah
	BX = Nombre de mickeys représentant huit points horizontalement
	CX = Nombre de mickeys représentant huit points verticalement
	DX = Seuil pour le doublement de la vitesse de la souris
Sortie :Aucune
********************************************************}
begin
  with Curseur do
    with reg do
      begin
        ax := $1a;
        bh := 0;
        bl := Sensibilite;
        ch := 0;
        cl := Sensibilite;
        dx := Seuil;
      end;
  intr($33, reg);
end;

function LireTailleBuffer: word;
{Lire la taille du buffer d'état de la souris}
{********************************************************
Int 33h, Fct 15h    Lire la taille du buffer d'état de la souris
Entrée : AX = 0015h
Sortie : BX = Taille du buffer d'état de la souris en octets
********************************************************}
begin
  with reg do
    begin
      ax := $15;
      intr($33, reg);
      TailleBuffer := bx;
    end;
  LireTailleBuffer := TailleBuffer;
end;

procedure SauverEtatSouris;
{Sauvegarder état de la souris}
{********************************************************
Int 33h, Fct 16h    Sauvegarder état de la souris
Entrée :
	AX = 0016h
	ES:DX = Adresses de segment et d'offset du buffer
Sortie :Aucune
********************************************************}
begin
  with reg do
    begin
      ax := $16;
      bx := TailleBuffer;
      es := seg(BufferEtatSouris);
      dx := ofs(BufferEtatSouris);
    end;
  intr($33, reg);
end;

procedure RestaurerEtatSouris;
{Restaurer l'état de la souris}
{********************************************************
Int 33h, Fct 17h    Restaurer l'état de la souris
Entrée :
	AX = 0017h
	ES:DX = Adresses de segment et d'offset du buffer d'état de la souris
Sortie :Aucune
********************************************************}
begin
  with reg do
    begin
      ax := $17;
      bx := TailleBuffer;
      es :=  seg(BufferEtatSouris);
      dx :=  ofs(BufferEtatSouris);
    end;
  intr($33, reg);
end;

end.