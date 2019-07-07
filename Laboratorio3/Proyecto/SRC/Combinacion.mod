(*4317743 4585215*)
IMPLEMENTATION MODULE Combinacion;

FROM Storage          IMPORT ALLOCATE,DEALLOCATE;
FROM Avion            IMPORT TClaseAsiento;
FROM Linea            IMPORT Linea,TIdAeropuerto,ObtenerOrigenLinea,ObtenerDestinoLinea,
			     ObtenerDuracionLinea;
FROM ListaTramo       IMPORT ListaTramo,CrearListaTramo,AgregarListaTramo;
FROM Tramo            IMPORT Tramo,ObtenerLineaTramo,CopiaTramo,DestruirTramo;
FROM Strings          IMPORT Equal;

TYPE
	Combinacion = POINTER TO NodoStackCombinacion;
	NodoStackCombinacion = RECORD
		info : Tramo;
		sig  : Combinacion
	END;
	
PROCEDURE CrearCombinacion(): Combinacion;
BEGIN
	RETURN NIL
END CrearCombinacion;


PROCEDURE CopiaCombinacion (c: Combinacion): Combinacion;
VAR
	cres,nodo,aux : Combinacion;
BEGIN
	aux := c;
	NEW(cres);
	nodo := cres;
	WHILE aux <> NIL DO
		nodo^.info := CopiaTramo(aux^.info);
		IF aux^.sig <> NIL THEN
			NEW(nodo^.sig);
			nodo := nodo^.sig;
			aux := aux^.sig
		ELSE
			nodo^.sig := NIL;
			aux := aux^.sig
		END
	END;
	RETURN(cres);
END CopiaCombinacion;


PROCEDURE PonerTramoCombinacion (t: Tramo; VAR c: Combinacion);
VAR
	nodo :  Combinacion;
BEGIN
	NEW(nodo);
	nodo^.info := t;
	nodo^.sig  := c;
	c := nodo;
END PonerTramoCombinacion;


PROCEDURE EsVaciaCombinacion (c: Combinacion): BOOLEAN;
BEGIN
	RETURN (c = NIL)
END EsVaciaCombinacion;


PROCEDURE ExisteAeropuertoCombinacion (aero: TIdAeropuerto;
                                       c: Combinacion): BOOLEAN;
VAR
	lpos : Combinacion;
	res  : BOOLEAN;
	aeroOrig,aeroDest : TIdAeropuerto;
BEGIN
	res := FALSE;
	IF c <> NIL THEN
		lpos := c;
		WHILE (lpos <> NIL) AND (res = FALSE) DO
			aeroOrig := ObtenerOrigenLinea(ObtenerLineaTramo(lpos^.info));
			aeroDest := ObtenerDestinoLinea(ObtenerLineaTramo(lpos^.info));
			IF (Equal(aeroOrig,aero)) OR (Equal(aeroDest,aero)) THEN
				res := TRUE
			END;
			lpos := lpos^.sig
		END
	END;
	RETURN res
END ExisteAeropuertoCombinacion;


PROCEDURE ObtenerUltimoCombinacion (c: Combinacion): Tramo;
BEGIN
	RETURN (c^.info)
END ObtenerUltimoCombinacion;


PROCEDURE ObtenerTramosCombinacion (c: Combinacion): ListaTramo;
VAR
	lres : ListaTramo;
BEGIN
	IF c = NIL THEN
		lres := CrearListaTramo()
	ELSE
		lres := ObtenerTramosCombinacion(c^.sig);
		AgregarListaTramo(c^.info,lres)
	END;
	RETURN lres	
END ObtenerTramosCombinacion;


PROCEDURE ObtenerPrecioCombinacion (c: Combinacion;
                                    clase: TClaseAsiento): CARDINAL;
VAR
	efectreal : REAL;
	dur       : CARDINAL;
	lpos      : Combinacion;
	linactual : Linea;
BEGIN
	efectreal := 0.0;
	IF c <> NIL THEN
		lpos := c;
		WHILE (lpos <> NIL) DO
			linactual := ObtenerLineaTramo(lpos^.info);
			dur := ObtenerDuracionLinea(linactual);
			IF clase = PRIMERA THEN
				efectreal := efectreal + ((FLOAT(dur) / 60.0) * 120.0)	
			ELSE						
				efectreal := efectreal + ((FLOAT(dur) / 60.0) * 80.0)
			END;
			lpos := lpos^.sig
		END
	END;
	RETURN VAL(CARDINAL,efectreal)
END ObtenerPrecioCombinacion;  	
	

PROCEDURE SacarTramoCombinacion (VAR c: Combinacion);
BEGIN
	c := c^.sig;
END SacarTramoCombinacion;



PROCEDURE DestruirCombinacion (VAR c: Combinacion);
VAR
	aux : Combinacion;
BEGIN
	aux := c;
	WHILE c <> NIL DO
		c := c^.sig;
		DestruirTramo(aux^.info);
		DISPOSE(aux);
		aux := c;
	END;
END DestruirCombinacion;


END Combinacion.	