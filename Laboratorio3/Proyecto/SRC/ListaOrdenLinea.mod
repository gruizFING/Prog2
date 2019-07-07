(*4317743 4585215*)
IMPLEMENTATION MODULE ListaOrdenLinea;

FROM OrdenLinea IMPORT OrdenLinea,DestruirOrdenLinea;
FROM Storage IMPORT ALLOCATE,DEALLOCATE;


TYPE
	ListaOrdenLinea = POINTER TO Nodo;
	Nodo = RECORD;
		OrdLin : OrdenLinea;
		sig : ListaOrdenLinea;
	END;


PROCEDURE CrearListaOrdenLinea (): ListaOrdenLinea;
BEGIN
	RETURN(NIL);
END CrearListaOrdenLinea;



PROCEDURE AgregarListaOrdenLinea (o: OrdenLinea; VAR l: ListaOrdenLinea);
VAR
	aux,lpos : ListaOrdenLinea;
BEGIN
	NEW(aux);
	aux^.OrdLin := o;
	aux^.sig := NIL;
	IF l = NIL THEN
		l := aux;
	ELSE
		lpos := l;	
		WHILE lpos^.sig <> NIL DO
			lpos := lpos^.sig;			
		END;
	        lpos^.sig := aux;
	END;
END AgregarListaOrdenLinea;



PROCEDURE EsVaciaListaOrdenLinea (l: ListaOrdenLinea): BOOLEAN;
BEGIN
	RETURN(l = NIL);
END EsVaciaListaOrdenLinea;



PROCEDURE ObtenerPrimeroListaOrdenLinea (l: ListaOrdenLinea): OrdenLinea;
BEGIN
	RETURN(l^.OrdLin);
END ObtenerPrimeroListaOrdenLinea;



PROCEDURE ObtenerRestoListaOrdenLinea (l: ListaOrdenLinea): ListaOrdenLinea;
BEGIN
	RETURN(l^.sig);
END ObtenerRestoListaOrdenLinea;



PROCEDURE DestruirListaOrdenLinea (VAR l: ListaOrdenLinea);
VAR
	laux : ListaOrdenLinea;
BEGIN
	WHILE l <> NIL DO
		laux := l;
		l := l^.sig;
		DestruirOrdenLinea(laux^.OrdLin);
		DISPOSE(laux);
	END;
END DestruirListaOrdenLinea;



END ListaOrdenLinea.