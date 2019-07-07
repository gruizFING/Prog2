(*4317743 4585215*)
IMPLEMENTATION MODULE Hora;

FROM Linea IMPORT THora;
FROM Storage IMPORT ALLOCATE,DEALLOCATE;


TYPE
	Hora = POINTER TO NodoHora;
	NodoHora = RECORD
		hora,min : CARDINAL
	END;
	
PROCEDURE CrearHora (h: THora): Hora;
VAR
	H : Hora;
BEGIN
	NEW(H);
	H^.hora := (h DIV 100);
	H^.min  := (h MOD 100);
	RETURN H
END CrearHora;


PROCEDURE CopiaHora (h: Hora): Hora;
VAR
	copia : Hora;
BEGIN
	NEW(copia);
	copia^.hora := h^.hora;
	copia^.min  := h^.min;
	RETURN copia
END CopiaHora;


PROCEDURE SumarMinutos (m: CARDINAL; VAR h: Hora);
VAR
	incHoras : CARDINAL;
BEGIN
	WITH h^ DO
		min := min + m;
		IF min >= 60 THEN
			incHoras := (min DIV 60);
			min := (min MOD 60);
			hora := hora + incHoras;			 	
			IF hora >= 24 THEN
				hora := (hora MOD 24)
			END
		END
	END
END SumarMinutos;


PROCEDURE HoraToString (h: Hora; VAR s: ARRAY OF CHAR);
BEGIN
	WITH h^ DO
		IF hora >= 10 THEN
			s[0] := CHR(hora DIV 10 + ORD('0'));
			s[1] := CHR(hora MOD 10 + ORD('0'))
		ELSE
			s[0] := CHR(ORD('0'));
			s[1] := CHR(hora + ORD('0'))
		END;
		IF min >= 10 THEN	
			s[2] := CHR( min DIV 10 + ORD('0'));
			s[3] := CHR( min MOD 10 + ORD('0'))
		ELSE
			s[2] := CHR(ORD('0'));
			s[3] := CHR(min + ORD('0'))
		END
	END
END HoraToString;


PROCEDURE IgualesHora (h1, h2: Hora): BOOLEAN;
BEGIN
	IF (h1^.hora = h2^.hora) AND (h1^.min = h2^.min) THEN
		RETURN TRUE
	ELSE
		RETURN FALSE
	END
END IgualesHora;


PROCEDURE EsMenorHora (h1, h2: Hora): BOOLEAN;
BEGIN
	IF h1^.hora < h2^.hora THEN
		RETURN TRUE
	ELSIF h1^.hora = h2^.hora THEN
		IF h1^.min < h2^.min THEN
			RETURN TRUE
		ELSE
			RETURN FALSE
		END
	ELSE
		RETURN FALSE
	END
END EsMenorHora;


PROCEDURE EsMayorHora (h1, h2: Hora): BOOLEAN;
BEGIN
	IF h1^.hora > h2^.hora THEN
		RETURN TRUE
	ELSIF h1^.hora = h2^.hora THEN
		IF h1^.min > h2^.min THEN
			RETURN TRUE
		ELSE
			RETURN FALSE
		END
	ELSE
		RETURN FALSE
	END
END EsMayorHora;


PROCEDURE DestruirHora (VAR h: Hora);
BEGIN
	IF h <> NIL THEN
		DISPOSE(h);
		h := NIL
	END
END DestruirHora;

END Hora.