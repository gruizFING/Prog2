(*4317743 4585215*)
IMPLEMENTATION MODULE Tramo;

FROM Fecha      IMPORT Fecha,CopiaFecha;
FROM Hora       IMPORT Hora,DestruirHora,CopiaHora;
FROM Linea      IMPORT Linea,CopiaLinea;
FROM Storage    IMPORT ALLOCATE,DEALLOCATE;

TYPE
	Tramo = POINTER TO TTramo;
	TTramo = RECORD
		l : Linea;
		fS,fL : Fecha;
		hs,hl : Hora
	END;
	
PROCEDURE CrearTramo (l: Linea; fchSal, fchLle: Fecha;
                      horSal, horLle: Hora): Tramo;
VAR
	t : Tramo;
BEGIN
	NEW(t);
	t^.l  := l;
	t^.fS := fchSal;
	t^.fL := fchLle;
	t^.hs := horSal;
	t^.hl := horLle;
	RETURN t
END CrearTramo;


PROCEDURE CopiaTramo (t: Tramo): Tramo;
VAR
	copia : Tramo;
BEGIN
	NEW(copia);
	copia^.l  := CopiaLinea(t^.l);
	copia^.fS := CopiaFecha(t^.fS);
	copia^.fL := CopiaFecha(t^.fL);
	copia^.hs := CopiaHora(t^.hs);
	copia^.hl := CopiaHora(t^.hl);
	RETURN copia
END CopiaTramo;


PROCEDURE ObtenerLineaTramo (t: Tramo): Linea;
BEGIN
	RETURN t^.l
END ObtenerLineaTramo;


PROCEDURE ObtenerFechaSalidaTramo (t: Tramo): Fecha;
BEGIN
	RETURN t^.fS
END ObtenerFechaSalidaTramo;


PROCEDURE ObtenerHoraSalidaTramo (t: Tramo): Hora;
BEGIN
	RETURN t^.hs
END ObtenerHoraSalidaTramo;


PROCEDURE ObtenerFechaLlegadaTramo (t: Tramo): Fecha;
BEGIN
	RETURN t^.fL
END ObtenerFechaLlegadaTramo;


PROCEDURE ObtenerHoraLlegadaTramo (t: Tramo): Hora;
BEGIN
	RETURN t^.hl
END ObtenerHoraLlegadaTramo;


PROCEDURE DestruirTramo (VAR t: Tramo);
BEGIN
	IF t <> NIL THEN
		DestruirHora(t^.hs);
		DestruirHora(t^.hl);
		DISPOSE(t);
		t := NIL
	END
END DestruirTramo;


END Tramo.