(*4317743 4585215*)
IMPLEMENTATION MODULE Linea;

FROM Storage  IMPORT ALLOCATE,DEALLOCATE;
FROM STextIO  IMPORT WriteString,WriteLn;
FROM SWholeIO IMPORT WriteCard;
FROM Avion  IMPORT Avion,ObtenerIdAvion,ObtenerAsientosAvion,
		   ObtenerDescripcionAvion,TClaseAsiento;
FROM Fecha  IMPORT TDiaSemana;
FROM WholeStr IMPORT CardToStr;

TYPE
	Linea = POINTER TO TLinea;
	TLinea = RECORD
        	id: TIdLinea;
	  	av: Avion;
		orig, dest: TIdAeropuerto;
		hora : THora;
		dur  : TDuracion;
	        CASE tipoLinea : TTipoLinea OF
			SEMANAL : dia : TDiaSemana |
			DIARIA :
		END
	END;
	
PROCEDURE CrearLineaDiaria (id: TIdLinea; av: Avion; orig, dest: TIdAeropuerto;
                            hora: THora;  dur: TDuracion): Linea;
VAR
	line : Linea;
BEGIN
	NEW(line);
	line^.id := id;
	line^.av := av;
	line^.orig := orig;
	line^.dest := dest;
	line^.hora := hora;
	line^.dur := dur;
	line^.tipoLinea := DIARIA;
	RETURN line
END CrearLineaDiaria;

PROCEDURE CrearLineaSemanal (id: TIdLinea; av: Avion;
                             orig, dest: TIdAeropuerto; hora: THora;
                             dur: TDuracion; dia: TDiaSemana): Linea;
VAR
	line : Linea;
BEGIN
	NEW(line);
	line^.id := id;
	line^.av := av;
	line^.orig := orig;
	line^.dest := dest;
	line^.hora := hora;
	line^.dur := dur;
	line^.tipoLinea := SEMANAL;
	line^.dia := dia;
	RETURN line
END CrearLineaSemanal;

PROCEDURE ObtenerIdLinea (lin: Linea): TIdLinea;
BEGIN
	RETURN (lin^.id)
END ObtenerIdLinea;

PROCEDURE ObtenerAvionLinea (lin: Linea): Avion;
BEGIN
	RETURN (lin^.av)
END ObtenerAvionLinea;

PROCEDURE ObtenerOrigenLinea (lin: Linea): TIdAeropuerto;
BEGIN
	RETURN (lin^.orig)
END ObtenerOrigenLinea;

PROCEDURE ObtenerDestinoLinea (lin: Linea): TIdAeropuerto;
BEGIN
	RETURN (lin^.dest)
END ObtenerDestinoLinea;

PROCEDURE ObtenerHoraSalidaLinea (lin: Linea): THora;
BEGIN
	RETURN (lin^.hora)
END ObtenerHoraSalidaLinea;

PROCEDURE ObtenerDuracionLinea (lin: Linea): TDuracion;
BEGIN
	RETURN (lin^.dur)
END ObtenerDuracionLinea;

PROCEDURE ObtenerTipoLinea (lin: Linea): TTipoLinea;
BEGIN
	RETURN (lin^.tipoLinea)
END ObtenerTipoLinea;

PROCEDURE ObtenerDiaSemanaLinea (lin: Linea): TDiaSemana;
BEGIN
	RETURN (lin^.dia)
END ObtenerDiaSemanaLinea;

PROCEDURE ImprimirInfoLinea(lin: Linea);
VAR
	s : ARRAY [0..3] OF CHAR;
BEGIN
	WriteString("Linea: ");
	WriteString(lin^.id);WriteString("-");
	WriteCard(ObtenerIdAvion(lin^.av),1);WriteString("-");
	WriteCard(ObtenerAsientosAvion(lin^.av,PRIMERA),1);WriteString("-");
	WriteCard(ObtenerAsientosAvion(lin^.av,TURISTA),1);WriteString("-");
	WriteString(ObtenerDescripcionAvion(lin^.av));WriteString("-");
	WriteString(lin^.orig);WriteString("-");
	WriteString(lin^.dest);WriteString("-");
	WITH lin^ DO
		IF hora <= 59 THEN
			s[0] := '0';
			s[1] := '0';
			s[2] := CHR((hora DIV 10) + ORD('0'));
			s[3] := CHR((hora MOD 10) + ORD('0'))
		ELSIF hora <= 959 THEN
			s[0] := '0';
			s[1] := CHR((hora DIV 100) + ORD('0'));
			s[2] := CHR(((hora MOD 100) DIV 10) + ORD('0'));
			s[3] := CHR((hora MOD 10) + ORD('0'))
		ELSE
			CardToStr(hora,s)
		END
	END;
	WriteString(s);WriteString("-");
	WriteCard(lin^.dur,1);WriteString("-");
	IF lin^.tipoLinea = DIARIA THEN
		WriteString("DIARIA.")
	ELSE
		WriteString("SEMANAL ");
		CASE lin^.dia  OF
			DOMINGO   : WriteString("DOMINGO.")  |
			LUNES     : WriteString("LUNES.")    |
			MARTES    : WriteString("MARTES.")   |
			MIERCOLES : WriteString("MIERCOLES.")|
			JUEVES    : WriteString("JUEVES.")   |
			VIERNES   : WriteString("VIERNES.")  |
			SABADO    : WriteString("SABADO.")
		END
	END;
	WriteLn	
END ImprimirInfoLinea;

PROCEDURE DestruirLinea (VAR lin: Linea);
BEGIN
	IF lin <> NIL THEN
		DISPOSE(lin);
		lin := NIL
	END;
END DestruirLinea;

END Linea.			
	