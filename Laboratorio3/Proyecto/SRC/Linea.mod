(*4317743 4585215*)
IMPLEMENTATION MODULE Linea;

FROM Storage  IMPORT ALLOCATE,DEALLOCATE;
FROM TextIO   IMPORT WriteString,WriteLn;
FROM WholeIO IMPORT WriteCard;
FROM Avion  IMPORT Avion,ObtenerIdAvion;
FROM Fecha  IMPORT TDiaSemana;
FROM WholeStr IMPORT CardToStr,StrToCard,ConvResults;
FROM Strings  IMPORT Compare,Equal,CompareResults;
FROM IOChan   IMPORT ChanId;
FROM Condicion  IMPORT Condicion,TCondPor,TCondOperador,TValor,EsVaciaCondicion,
		       EsOperadorCondicion,ObtenerPorCondicion,ObtenerOperadorCondicion,
		       ObtenerValorCondicion,ObtenerOperLogCondicion,TCondOperLog,
		       ObtenerIzqCondicion,ObtenerDerCondicion,ObtenerSubCondicion;

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


PROCEDURE CopiaLinea (l: Linea): Linea;
VAR
	copia : Linea;
BEGIN
	NEW(copia);
	copia^.id := l^.id;
	copia^.av := l^.av;
	copia^.orig := l^.orig;
	copia^.dest := l^.dest;
	copia^.hora := l^.hora;
	copia^.dur  := l^.dur;
	copia^.tipoLinea := l^.tipoLinea;
	IF copia^.tipoLinea = SEMANAL THEN
		copia^.dia := l^.dia
	END;
	RETURN copia
END CopiaLinea;


PROCEDURE EvaluarCondicionLinea (l: Linea; c: Condicion): BOOLEAN;
VAR
	res  : BOOLEAN;
	nom  : TCondPor;
	oper : TCondOperador;
	val  : TValor;
	idav,idavlin : CARDINAL;
	r    : ConvResults;
	hora,dur : CARDINAL;
	str : ARRAY [0..8] OF CHAR;
BEGIN
	IF EsVaciaCondicion(c) THEN
		res := TRUE
	ELSIF EsOperadorCondicion(c) THEN
		nom  := ObtenerPorCondicion(c);
		oper := ObtenerOperadorCondicion(c);
		val  := ObtenerValorCondicion(c);
		IF Equal(nom,COND_ID) THEN
			IF (Compare(l^.id,val) = equal) AND (oper = OP_IGUAL) THEN
				res := TRUE
			ELSIF (Compare(l^.id,val) = less) AND (oper = OP_MENOR) THEN
				res := TRUE
			ELSIF (Compare(l^.id,val) = greater) AND (oper = OP_MAYOR) THEN
				res := TRUE
			ELSE
				res := FALSE
			END
		ELSIF Equal(nom,COND_AVION) THEN
			StrToCard(val,idav,r);
			idavlin := ObtenerIdAvion(l^.av);
			IF (idav = idavlin) AND (oper = OP_IGUAL) THEN
				res := TRUE
			ELSIF (idavlin < idav) AND (oper = OP_MENOR) THEN
				res := TRUE
			ELSIF (idavlin > idav) AND (oper = OP_MAYOR) THEN
				res := TRUE
			ELSE
				res := FALSE
			END
		ELSIF Equal(nom,COND_ORIGEN) THEN
			IF (Compare(l^.orig,val) = equal) AND (oper = OP_IGUAL) THEN
				res := TRUE
			ELSIF (Compare(l^.orig,val) = less) AND (oper = OP_MENOR) THEN
				res := TRUE
			ELSIF (Compare(l^.orig,val) = greater) AND (oper = OP_MAYOR) THEN
				res := TRUE
			ELSE
				res := FALSE
			END
		ELSIF Equal(nom,COND_DESTINO) THEN	
			IF (Compare(l^.dest,val) = equal) AND (oper = OP_IGUAL) THEN
				res := TRUE
			ELSIF (Compare(l^.dest,val) = less) AND (oper = OP_MENOR) THEN
				res := TRUE
			ELSIF (Compare(l^.dest,val) = greater) AND (oper = OP_MAYOR) THEN
				res := TRUE
			ELSE
				res := FALSE
			END
		ELSIF Equal(nom,COND_HORA) THEN
			StrToCard(val,hora,r);
			IF (l^.hora = hora) AND (oper = OP_IGUAL) THEN
				res := TRUE
			ELSIF (l^.hora < hora) AND (oper = OP_MENOR) THEN
				res := TRUE
			ELSIF (l^.hora > hora) AND (oper = OP_MAYOR) THEN
				res := TRUE
			ELSE
				res := FALSE
			END
		ELSIF Equal(nom,COND_DURACION) THEN
			StrToCard(val,dur,r);
			IF (l^.dur = dur) AND (oper = OP_IGUAL) THEN
				res := TRUE
			ELSIF (l^.dur < dur) AND (oper = OP_MENOR) THEN
				res := TRUE
			ELSIF (l^.dur > dur) AND (oper = OP_MAYOR) THEN
				res := TRUE
			ELSE
				res := FALSE
			END
		ELSIF Equal(nom,COND_FRECUENCIA) THEN
			IF Equal(val,'DIARIA') AND (l^.tipoLinea = DIARIA) THEN
				res := TRUE
			ELSIF Equal(val,'SEMANAL') AND (l^.tipoLinea = SEMANAL) THEN
				res := TRUE
			ELSE
				res := FALSE
			END
		ELSE
			IF (l^.tipoLinea = DIARIA) THEN
				res := TRUE
			ELSE
				CASE l^.dia  OF
					DOMINGO   : str := "DOMINGO"|
					LUNES     : str := "LUNES"|
					MARTES    : str := "MARTES"|
					MIERCOLES : str := "MIERCOLES"|
					JUEVES    : str := "JUEVES"|
					VIERNES   : str := "VIERNES"|
					SABADO    : str := "SABADO"
				END;
				IF Equal(str,val) THEN
					res := TRUE
				ELSE
					res := FALSE
				END
			END
		END
	ELSE
		IF (ObtenerOperLogCondicion(c) = OP_AND) THEN
			res := EvaluarCondicionLinea(l,ObtenerIzqCondicion(c)) AND EvaluarCondicionLinea(l,ObtenerDerCondicion(c))
		ELSIF (ObtenerOperLogCondicion(c) = OP_OR) THEN
			res := EvaluarCondicionLinea(l,ObtenerIzqCondicion(c)) OR EvaluarCondicionLinea(l,ObtenerDerCondicion(c))
		ELSE
			res := NOT (EvaluarCondicionLinea(l,ObtenerSubCondicion(c)))
		END
	END;
	RETURN res
END EvaluarCondicionLinea;					
		                	


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

PROCEDURE ImprimirInfoLinea(cid: ChanId; lin: Linea);
VAR
	s : ARRAY [0..3] OF CHAR;
BEGIN
	WriteString(cid,"Linea: ");
	WriteString(cid,lin^.id);WriteString(cid,"-");
	WriteCard(cid,ObtenerIdAvion(lin^.av),1);WriteString(cid,"-");
	WriteString(cid,lin^.orig);WriteString(cid,"-");
	WriteString(cid,lin^.dest);WriteString(cid,"-");
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
	WriteString(cid,s);WriteString(cid,"-");
	WriteCard(cid,lin^.dur,1);WriteString(cid,"-");
	IF lin^.tipoLinea = DIARIA THEN
		WriteString(cid,"DIARIA.")
	ELSE
		WriteString(cid,"SEMANAL ");
		CASE lin^.dia  OF
			DOMINGO   : WriteString(cid,"DOMINGO.")  |
			LUNES     : WriteString(cid,"LUNES.")    |
			MARTES    : WriteString(cid,"MARTES.")   |
			MIERCOLES : WriteString(cid,"MIERCOLES.")|
			JUEVES    : WriteString(cid,"JUEVES.")   |
			VIERNES   : WriteString(cid,"VIERNES.")  |
			SABADO    : WriteString(cid,"SABADO.")
		END
	END;
	WriteLn(cid)	
END ImprimirInfoLinea;

PROCEDURE DestruirLinea (VAR lin: Linea);
BEGIN
	IF lin <> NIL THEN
		DISPOSE(lin);
		lin := NIL
	END;
END DestruirLinea;

END Linea.				