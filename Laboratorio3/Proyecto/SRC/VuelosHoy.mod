(*4317743 4585215*)
IMPLEMENTATION MODULE VuelosHoy;

FROM STextIO IMPORT WriteString,WriteLn;
FROM ListaVuelos IMPORT DestruirListaVuelos,ObtenerPrimerVueloListaVuelos,
			ObtenerRestoListaVuelos,ListaVuelos,EsVaciaListaVuelos,
			CrearListaVuelos;
FROM Vuelo IMPORT ObtenerDisponiblesVuelo,ObtenerLineaVuelo,Vuelo,
		  TEstadoAsiento,ObtenerEstadoVuelo,ObtenerClienteVuelo;
FROM Linea IMPORT ObtenerAvionLinea,Linea,ImprimirInfoLinea;
FROM Avion IMPORT TRangoAsiento,TClaseAsiento,Avion,ObtenerAsientosAvion,
		  TAsiento;
FROM SWholeIO IMPORT WriteCard;
FROM Cliente IMPORT Cliente,ObtenerNombreCliente,ObtenerApellCliente,
		    ObtenerPasaporteCliente,ObtenerNacionalidadCliente;
FROM Storage IMPORT ALLOCATE,DEALLOCATE;
FROM IOChan           IMPORT ChanId;
FROM StdChans         IMPORT StdOutChan;

TYPE
	VuelosHoy = POINTER TO Nodovueloshoy;
	Nodovueloshoy = RECORD
		vuelos: ListaVuelos;
	END;


PROCEDURE CrearVuelosHoy ():VuelosHoy;
VAR
	vh : VuelosHoy;
BEGIN
	NEW(vh);
	vh^.vuelos := CrearListaVuelos();
	RETURN vh
END CrearVuelosHoy;



PROCEDURE SuplantarVuelosHoy(list : ListaVuelos; VAR vuelosHoy : VuelosHoy);
BEGIN
	IF EsVaciaListaVuelos(vuelosHoy^.vuelos) THEN
		vuelosHoy^.vuelos := list
	ELSE
		DestruirListaVuelos(vuelosHoy^.vuelos);
		vuelosHoy^.vuelos := list
	END
END SuplantarVuelosHoy;



PROCEDURE ListarVuelosVuelosHoy (vH: VuelosHoy);
VAR
	vuelo: Vuelo;
	dispPRI,dispTUR,asientosPRI,asientosTUR: TRangoAsiento;
	lin: Linea;
	avion: Avion;
	i: CARDINAL;
	asiento: TAsiento;
	estado: TEstadoAsiento;
	c: Cliente;
	cid : ChanId;
BEGIN
	cid := StdOutChan();
	WHILE NOT (EsVaciaListaVuelos(vH^.vuelos)) DO
		vuelo := ObtenerPrimerVueloListaVuelos(vH^.vuelos);
		dispPRI := ObtenerDisponiblesVuelo(PRIMERA,vuelo);
		dispTUR := ObtenerDisponiblesVuelo(TURISTA,vuelo);
		lin := ObtenerLineaVuelo(vuelo);
		avion := ObtenerAvionLinea(lin);
		asientosPRI := ObtenerAsientosAvion(avion,PRIMERA);
		asientosTUR := ObtenerAsientosAvion(avion,TURISTA);
		IF (asientosPRI <> dispPRI) OR (asientosTUR <> dispTUR) THEN
			ImprimirInfoLinea(cid,lin);
			WriteString('Primera:');
			WriteLn();
			IF (asientosPRI <> dispPRI) THEN
				i := 1;
				asiento.clase := PRIMERA;
				REPEAT
					asiento.num := i;
					estado := ObtenerEstadoVuelo(asiento,vuelo);
					IF (estado = V_COMPRA) THEN
						WriteString('Asiento: ');
						WriteCard(i,1);
						WriteString('-');
						WriteString('Cliente: ');
						c := ObtenerClienteVuelo(asiento,vuelo);
						WriteString(ObtenerNombreCliente(c));
					        WriteString("-");
						WriteString(ObtenerApellCliente(c));
						WriteString("-");
						WriteString(ObtenerPasaporteCliente(c));
						WriteString('-');
						WriteString(ObtenerNacionalidadCliente(c));
						WriteLn();
					END;
					i := i + 1;
				UNTIL (i > asientosPRI);
			END;
			WriteString('Turista:');
			WriteLn();	
			IF (asientosTUR <> dispTUR) THEN
				i := 1;
				asiento.clase := TURISTA;
				REPEAT
					asiento.num := i;
					estado := ObtenerEstadoVuelo(asiento,vuelo);
					IF (estado = V_COMPRA) THEN
						WriteString('Asiento: ');
						WriteCard(i,1);
						WriteString('-');
						WriteString('Cliente: ');
						c := ObtenerClienteVuelo(asiento,vuelo);
						WriteString(ObtenerNombreCliente(c));
					        WriteString("-");
						WriteString(ObtenerApellCliente(c));
						WriteString("-");
						WriteString(ObtenerPasaporteCliente(c));
						WriteString('-');
						WriteString(ObtenerNacionalidadCliente(c));
						WriteLn();
					END;
					i := i + 1;
				UNTIL (i > asientosTUR);
			END;
		END;
		vH^.vuelos := ObtenerRestoListaVuelos(vH^.vuelos);
	 END;
END ListarVuelosVuelosHoy;



PROCEDURE EsVacioVuelosHoy(v:VuelosHoy):BOOLEAN;
BEGIN
	RETURN(v = NIL);
END EsVacioVuelosHoy;


PROCEDURE ObtenerListaVuelosHoy (v: VuelosHoy): ListaVuelos;
BEGIN
	RETURN v^.vuelos
END ObtenerListaVuelosHoy;

PROCEDURE DestruirVuelosHoy ( VAR vH: VuelosHoy);
BEGIN
	DestruirListaVuelos(vH^.vuelos);
	DISPOSE(vH);
	vH := NIL
END DestruirVuelosHoy;


END VuelosHoy.	