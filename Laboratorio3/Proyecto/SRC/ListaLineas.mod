(*4317743 4585215*)
IMPLEMENTATION MODULE ListaLineas;
FROM Linea IMPORT Linea, TIdLinea,ObtenerIdLinea,DestruirLinea;
FROM Storage IMPORT ALLOCATE,DEALLOCATE;
FROM Strings IMPORT Equal;

TYPE
	ListaLineas = POINTER TO NodoListaLineas;
	NodoListaLineas = RECORD
		lin : Linea;
		sig : ListaLineas
	END;	
		
		
PROCEDURE CrearListaLineas (): ListaLineas;
BEGIN
	RETURN NIL
END CrearListaLineas;


PROCEDURE AgregarLineaListaLineas (lin: Linea; VAR l: ListaLineas);
VAR
	Nodo,lpos : ListaLineas;
BEGIN
	NEW(Nodo);
	Nodo^.lin := lin;
	Nodo^.sig := NIL;
	IF l = NIL THEN
		l := Nodo
	ELSE
		lpos := l;
		WHILE lpos^.sig <> NIL DO
			lpos := lpos^.sig
		END;
		lpos^.sig := Nodo
	END
END AgregarLineaListaLineas;


PROCEDURE EsVaciaListaLineas (l: ListaLineas): BOOLEAN;
BEGIN
	RETURN (l = NIL)
END EsVaciaListaLineas;

		
PROCEDURE PerteneceLineaListaLineas (id: TIdLinea; l: ListaLineas): BOOLEAN;	
BEGIN	
	IF l = NIL THEN
		RETURN FALSE
	ELSIF Equal(id,ObtenerIdLinea(l^.lin)) THEN
		RETURN TRUE
	ELSE
		RETURN (PerteneceLineaListaLineas(id,l^.sig))
	END
END PerteneceLineaListaLineas;

PROCEDURE ObtenerPrimerLineaListaLineas (l: ListaLineas): Linea;
BEGIN
	RETURN (l^.lin)
END ObtenerPrimerLineaListaLineas;

PROCEDURE ObtenerRestoListaLineas (l: ListaLineas): ListaLineas;
BEGIN
	RETURN (l^.sig)
END ObtenerRestoListaLineas;

PROCEDURE ObtenerLineaListaLineas (id: TIdLinea; l: ListaLineas): Linea;
BEGIN
	WHILE (NOT Equal(id,ObtenerIdLinea(l^.lin))) DO
		l := l^.sig
	END;
	RETURN (l^.lin)
END ObtenerLineaListaLineas;


PROCEDURE ObtenerTamanioListaLineas (l: ListaLineas): CARDINAL;
VAR
	tam : CARDINAL;
BEGIN
	IF l = NIL THEN
		tam := 0
	ELSE
		tam := 1 + ObtenerTamanioListaLineas(l^.sig)
	END;
	RETURN tam
END ObtenerTamanioListaLineas;


PROCEDURE EliminarLineaListaLineas (id: TIdLinea; VAR l: ListaLineas);
VAR
	lpos,aBorrar : ListaLineas;
BEGIN
	IF Equal(id,ObtenerIdLinea(l^.lin)) THEN
		aBorrar := l;
		l := l^.sig;
		DestruirLinea(aBorrar^.lin);
		DISPOSE(aBorrar)
	ELSE
		lpos := l;
		WHILE NOT Equal(id,ObtenerIdLinea(lpos^.sig^.lin)) DO
			lpos := lpos^.sig
		END;
		aBorrar := lpos^.sig;
		lpos^.sig := aBorrar^.sig;
		DestruirLinea(aBorrar^.lin);
		DISPOSE(aBorrar)
	END
END EliminarLineaListaLineas;		
	

PROCEDURE DestruirListaLineas (VAR l: ListaLineas);
VAR
	q : ListaLineas;
BEGIN
	WHILE l <> NIL DO
		q := l;
		l := l^.sig;
		DestruirLinea(q^.lin);
		DISPOSE(q)
	END	
END DestruirListaLineas; 		

	
END ListaLineas.				