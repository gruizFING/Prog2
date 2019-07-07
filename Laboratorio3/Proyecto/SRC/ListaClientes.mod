(*4317743 4585215*)
IMPLEMENTATION MODULE ListaClientes;

FROM Cliente IMPORT Cliente,TIdPasaporte,TIdNacionalidad,
		    ObtenerNacionalidadCliente,
		    ObtenerPasaporteCliente,
		    ImprimirInfoCliente,
		    DestruirCliente;
FROM Strings IMPORT Equal;
FROM Storage IMPORT ALLOCATE,DEALLOCATE;
FROM IOChan           IMPORT ChanId;
FROM StdChans         IMPORT StdOutChan;



TYPE
	ListaClientes = POINTER TO NodoCliente;
	NodoCliente = RECORD
		cliente: Cliente;
		sig: ListaClientes;
	END;



PROCEDURE CrearListaClientes (): ListaClientes;
BEGIN
	RETURN(NIL);
END CrearListaClientes;



PROCEDURE AgregarClienteListaClientes (c: Cliente; VAR l: ListaClientes);
VAR
	laux,nodo: ListaClientes;
BEGIN
	NEW(laux);
	laux^.cliente := c;
	laux^.sig := NIL;
	IF (l = NIL) THEN
		l := laux;
	ELSE
		nodo := l;
		WHILE (nodo^.sig <> NIL) DO
			nodo := nodo^.sig;
		END;
		nodo^.sig := laux;
	END;
END AgregarClienteListaClientes;



PROCEDURE EsVaciaListaClientes (l: ListaClientes): BOOLEAN;
BEGIN
	RETURN(l = NIL);
END EsVaciaListaClientes;



PROCEDURE PerteneceClienteListaClientes (pasaporte: TIdPasaporte;
                                         nacionalidad: TIdNacionalidad;
                                         l: ListaClientes): BOOLEAN;
VAR
	pais: TIdNacionalidad;
	pas: TIdPasaporte;
BEGIN
	WHILE (l <> NIL) DO
		pais := ObtenerNacionalidadCliente(l^.cliente);
		pas := ObtenerPasaporteCliente(l^.cliente);
		IF (Equal(pas,pasaporte)) AND (Equal(nacionalidad,pais)) THEN
			RETURN(TRUE);
		ELSE
			l := l^.sig;
		END;
	END;
		RETURN(FALSE);
END PerteneceClienteListaClientes;



PROCEDURE ObtenerPrimerClienteListaClientes (l: ListaClientes): Cliente;
BEGIN
	RETURN(l^.cliente);
END ObtenerPrimerClienteListaClientes;



PROCEDURE ObtenerRestoListaClientes (l: ListaClientes): ListaClientes;
BEGIN
	RETURN(l^.sig);
END ObtenerRestoListaClientes;



PROCEDURE ObtenerClienteListaClientes (pasaporte: TIdPasaporte;
                                       nacionalidad: TIdNacionalidad;
                                       l: ListaClientes): Cliente;
VAR
	pas: TIdPasaporte;
	pais: TIdNacionalidad;
	encontro: BOOLEAN;
BEGIN
	encontro := FALSE;
	REPEAT
		pas := ObtenerPasaporteCliente(l^.cliente);
		pais := ObtenerNacionalidadCliente(l^.cliente);
		IF (Equal(pas,pasaporte)) AND (Equal(pais,nacionalidad)) THEN
			encontro := TRUE;
		ELSE
			l := l^.sig;
		END;
	UNTIL (encontro);
	RETURN(l^.cliente);
END ObtenerClienteListaClientes;



PROCEDURE ImprimirListaClientes(l: ListaClientes);
VAR
	cid : ChanId;
BEGIN
	cid := StdOutChan();
	WHILE l <> NIL DO
		ImprimirInfoCliente(cid,l^.cliente);
		l := l^.sig
	END
END ImprimirListaClientes;



PROCEDURE DestruirListaClientes (VAR l: ListaClientes);
VAR
	laux: ListaClientes;
BEGIN
	WHILE (l <> NIL) DO
		laux := l;
		l := l^.sig;
		DestruirCliente(laux^.cliente);
		DISPOSE(laux);
	END;
END DestruirListaClientes;
	


END ListaClientes.