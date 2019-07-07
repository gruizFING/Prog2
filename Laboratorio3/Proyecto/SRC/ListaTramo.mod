(*4317743 4585215*)
IMPLEMENTATION MODULE ListaTramo;

FROM Tramo      IMPORT Tramo,DestruirTramo;
FROM Storage    IMPORT ALLOCATE,DEALLOCATE;

TYPE
	ListaTramo = POINTER TO NodoTramo;
	NodoTramo = RECORD
		t   : Tramo;
		sig : ListaTramo
	END;

PROCEDURE CrearListaTramo (): ListaTramo;
BEGIN
	RETURN NIL
END CrearListaTramo;


PROCEDURE AgregarListaTramo (t: Tramo; VAR l: ListaTramo);
VAR
	nodo,lpos : ListaTramo;
BEGIN
	NEW(nodo);
	nodo^.t := t;
	nodo^.sig := NIL;
	IF l = NIL THEN
		l := nodo
	ELSE
		lpos := l;
		WHILE lpos^.sig <> NIL DO
			lpos := lpos^.sig
		END;
		lpos^.sig := nodo
	END
END AgregarListaTramo;


PROCEDURE EsVaciaListaTramo (l: ListaTramo): BOOLEAN;
BEGIN
	RETURN (l = NIL)
END EsVaciaListaTramo;


PROCEDURE ObtenerPrimeroListaTramo (l: ListaTramo): Tramo;
BEGIN
	RETURN l^.t
END ObtenerPrimeroListaTramo;


PROCEDURE ObtenerRestoListaTramo (l: ListaTramo): ListaTramo;
BEGIN
	RETURN l^.sig
END ObtenerRestoListaTramo;


PROCEDURE DestruirListaTramo (VAR l: ListaTramo);
VAR
	aux : ListaTramo;
BEGIN
	WHILE l <> NIL DO
		aux := l;
		l := l^.sig;
		DestruirTramo(aux^.t);
		DISPOSE(aux)
	END
END DestruirListaTramo;

END ListaTramo.	