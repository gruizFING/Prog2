(*4317743 4585215*)
IMPLEMENTATION MODULE VuelosFuturos;

FROM Avion            IMPORT Avion,TRangoAsiento,TAsiento,TClaseAsiento,ObtenerAsientosAvion;
FROM Cliente          IMPORT Cliente;
FROM Fecha            IMPORT Fecha,IgualesFecha,EsMenorFecha;
FROM Linea            IMPORT Linea,ObtenerAvionLinea,ObtenerIdLinea,TIdLinea;
FROM ListaVuelos      IMPORT ListaVuelos,PerteneceVueloListaVuelos,EliminarVueloListaVuelos,
			     ObtenerVueloListaVuelos,ObtenerRestoListaVuelos,
			     ObtenerPrimerVueloListaVuelos,DestruirListaVuelos,
			     EsVaciaListaVuelos,InsertarVueloListaVuelos,CrearListaVuelos;
FROM Vuelo            IMPORT Vuelo,CrearVuelo,ComprarVuelo,CancelarVuelo,
			     ObtenerDisponiblesVuelo,ObtenerFechaVuelo,
			     AnularReservasVuelo,ObtenerLineaVuelo,ReservarVuelo,
			     ImprimirInfoVuelo,EstaCompradoClienteVuelo,DestruirVuelo,
			     EstaReservadoClienteVuelo,EstaDisponibleAsientoVuelo,
			     TEstadoAsiento,ObtenerEstadoVuelo;
FROM Storage          IMPORT ALLOCATE,DEALLOCATE;
FROM IOChan           IMPORT ChanId;
FROM StdChans         IMPORT StdOutChan;

TYPE
	VuelosFuturos = POINTER TO TVuelosFuturos;
	TVuelosFuturos = RECORD
		ListaVF : ListaVuelos
	END;


	
PROCEDURE CrearVuelosFuturos (): VuelosFuturos;
VAR
	vf : VuelosFuturos;
BEGIN
	NEW(vf);
	vf^.ListaVF := CrearListaVuelos();
	RETURN vf
END CrearVuelosFuturos;


PROCEDURE SuplantarVuelosFuturos(lv: ListaVuelos; VAR vf: VuelosFuturos);
BEGIN
	IF EsVaciaListaVuelos(vf^.ListaVF) THEN
		vf^.ListaVF := lv
	ELSE
		DestruirListaVuelos(vf^.ListaVF);
		vf^.ListaVF := lv
	END
END SuplantarVuelosFuturos;


PROCEDURE ComprarVuelosFuturos (cli: Cliente;  lin: Linea; f: Fecha;
                                asiento: TAsiento;
                                VAR vF: VuelosFuturos): TRangoAsiento;
VAR
	v : Vuelo;
	sincompras : BOOLEAN;
	cantasprim,cantastur : TRangoAsiento;
	cont1 : CARDINAL;
	asientoaux : TAsiento;
	estvuel : TEstadoAsiento;
	av : Avion;
BEGIN
	IF NOT (PerteneceVueloListaVuelos(ObtenerIdLinea(lin),f,vF^.ListaVF)) THEN
		v := CrearVuelo(lin,f);
		InsertarVueloListaVuelos(v,vF^.ListaVF)
	ELSE
		v := ObtenerVueloListaVuelos(ObtenerIdLinea(lin),f,vF^.ListaVF);
		av := ObtenerAvionLinea(lin);
		cantasprim := ObtenerAsientosAvion(av,PRIMERA);
		cantastur  := ObtenerAsientosAvion(av,TURISTA);
		sincompras := TRUE;
		cont1 := 1;
		asientoaux.clase := PRIMERA;
		WHILE sincompras AND (cont1 <= cantasprim) DO
			asientoaux.num := cont1;
			estvuel := ObtenerEstadoVuelo(asientoaux,v);
			IF estvuel = V_COMPRA THEN
				sincompras := FALSE
			ELSE
				cont1 := cont1 + 1
			END
		END;
		cont1 := 1;
		asientoaux.clase := TURISTA;
		WHILE sincompras AND (cont1 <= cantastur) DO
			asientoaux.num := cont1;
			estvuel := ObtenerEstadoVuelo(asientoaux,v);
			IF estvuel = V_COMPRA THEN
				sincompras := FALSE
			ELSE
				cont1 := cont1 + 1
			END
		END;
		IF sincompras THEN
			EliminarVueloListaVuelos(ObtenerIdLinea(lin),f,vF^.ListaVF);
			InsertarVueloListaVuelos(v,vF^.ListaVF)
		END
	END;
	RETURN ComprarVuelo(cli,asiento,v);
END ComprarVuelosFuturos;



PROCEDURE ReservarVuelosFuturos (cli: Cliente; lin: Linea; f: Fecha;
                                 asiento: TAsiento;
                                 VAR vF: VuelosFuturos): TRangoAsiento;
VAR
	vuelo: Vuelo;
	num: TRangoAsiento;
	idlin: TIdLinea;
BEGIN
	idlin := ObtenerIdLinea(lin);
	IF NOT (PerteneceVueloListaVuelos(idlin,f,vF^.ListaVF)) THEN
		vuelo := CrearVuelo(lin,f);
		InsertarVueloListaVuelos(vuelo,vF^.ListaVF);
		num := ReservarVuelo(cli,asiento,vuelo)
	ELSE
		vuelo := ObtenerVueloListaVuelos(idlin,f,vF^.ListaVF);
		num := ReservarVuelo(cli,asiento,vuelo)
	END;
	RETURN(num);
END ReservarVuelosFuturos;



PROCEDURE CancelarVuelosFuturos (cli: Cliente; lin: Linea; f: Fecha;
                              asiento: TAsiento; VAR vF: VuelosFuturos);
VAR
	v : Vuelo;
	cantasprim,cantastur : TRangoAsiento;
	av  : Avion;
BEGIN
	v := ObtenerVueloListaVuelos(ObtenerIdLinea(lin),f,vF^.ListaVF);
	CancelarVuelo(cli,asiento,v);
	av  := ObtenerAvionLinea(lin);
	cantasprim := ObtenerAsientosAvion(av,PRIMERA);
	cantastur  := ObtenerAsientosAvion(av,TURISTA);
	IF (ObtenerDisponiblesVuelo(PRIMERA,v) = cantasprim) AND
	      (ObtenerDisponiblesVuelo(TURISTA,v) = cantastur)  THEN
		EliminarVueloListaVuelos(ObtenerIdLinea(lin),f,vF^.ListaVF)
	END
END CancelarVuelosFuturos;



PROCEDURE SepararHastaFechaVuelosFuturos (f: Fecha;
                                          VAR vF: VuelosFuturos): ListaVuelos;
VAR
	aux1,VH : ListaVuelos;
	lin     : TIdLinea;
BEGIN
	VH   := CrearListaVuelos();
	aux1 := vF^.ListaVF;
	WHILE (NOT EsVaciaListaVuelos(aux1)) AND (EsMenorFecha(ObtenerFechaVuelo(ObtenerPrimerVueloListaVuelos(aux1)),f)) DO
		lin := ObtenerIdLinea(ObtenerLineaVuelo(ObtenerPrimerVueloListaVuelos(aux1)));
		EliminarVueloListaVuelos(lin,ObtenerFechaVuelo(ObtenerPrimerVueloListaVuelos(aux1)),vF^.ListaVF);
		aux1 := ObtenerRestoListaVuelos(aux1)
	END;
	WHILE (NOT EsVaciaListaVuelos(aux1)) AND (IgualesFecha(ObtenerFechaVuelo(ObtenerPrimerVueloListaVuelos(aux1)),f)) DO
		InsertarVueloListaVuelos(ObtenerPrimerVueloListaVuelos(aux1),VH);
		aux1 := ObtenerRestoListaVuelos(aux1)
	END;
	vF^.ListaVF := aux1;
	RETURN VH
END SepararHastaFechaVuelosFuturos;
	



PROCEDURE AnularReservasVuelosFuturos (f: Fecha; VAR vF: VuelosFuturos;
                                       VAR cantTurista,
                                           cantPrimera: CARDINAL);
VAR
	vFaux       : ListaVuelos;
	vactual     : Vuelo;
	linactual   : Linea;
	avactual    : Avion;
	cantasprim,cantastur,
	cantTur,cantPrim      : TRangoAsiento;
BEGIN
	cantTurista := 0;
	cantPrimera := 0;
	IF NOT (EsVaciaListaVuelos(vF^.ListaVF)) THEN
		vFaux := vF^.ListaVF;
		WHILE NOT (EsVaciaListaVuelos(vFaux)) AND IgualesFecha(ObtenerFechaVuelo(ObtenerPrimerVueloListaVuelos(vFaux)),f) DO
			vactual := ObtenerPrimerVueloListaVuelos(vFaux);	
			AnularReservasVuelo(vactual,cantTur,cantPrim);
			cantTurista := cantTurista + cantTur;
			cantPrimera := cantPrimera + cantPrim;
			linactual   := ObtenerLineaVuelo(vactual);
			avactual    := ObtenerAvionLinea(linactual);
			cantasprim  := ObtenerAsientosAvion(avactual,PRIMERA);
			cantastur   := ObtenerAsientosAvion(avactual,TURISTA);
			IF (ObtenerDisponiblesVuelo(PRIMERA,vactual) = cantasprim) AND
	   		   (ObtenerDisponiblesVuelo(TURISTA,vactual) = cantastur)  THEN
				EliminarVueloListaVuelos(ObtenerIdLinea(linactual),f,vF^.ListaVF);
				vFaux := ObtenerRestoListaVuelos(vFaux)
			ELSIF NOT (EsVaciaListaVuelos(vFaux)) THEN
				vFaux := ObtenerRestoListaVuelos(vFaux);
			END
		END
	END
END AnularReservasVuelosFuturos;



PROCEDURE EstaCompradoClienteVuelosFuturos(cli: Cliente; linea: Linea; f: Fecha;
                                           asiento: TAsiento;
                                           vF: VuelosFuturos): BOOLEAN;
VAR
	vuelo : Vuelo;
	idlin : TIdLinea;
BEGIN
	idlin := ObtenerIdLinea(linea);
	IF PerteneceVueloListaVuelos(idlin,f,vF^.ListaVF) THEN
		vuelo := ObtenerVueloListaVuelos(idlin,f,vF^.ListaVF);
		RETURN (EstaCompradoClienteVuelo(cli,asiento,vuelo))
	ELSE
		RETURN FALSE
	END
END EstaCompradoClienteVuelosFuturos;



PROCEDURE EstaReservadoClienteVuelosFuturos(cli: Cliente; linea: Linea;
                                            f: Fecha; asiento: TAsiento;
                                            vF: VuelosFuturos): BOOLEAN;
VAR
	vuelo : Vuelo;
	idlin : TIdLinea;
BEGIN
	idlin := ObtenerIdLinea(linea);
	IF PerteneceVueloListaVuelos(idlin,f,vF^.ListaVF) THEN
		vuelo := ObtenerVueloListaVuelos(idlin,f,vF^.ListaVF);
       		RETURN (EstaReservadoClienteVuelo(cli,asiento,vuelo))
	ELSE
		RETURN FALSE
	END
END EstaReservadoClienteVuelosFuturos;



PROCEDURE EstaDisponibleAsientoVuelosFuturos (linea: Linea; f: Fecha;
                                              asiento: TAsiento;
                                              vF: VuelosFuturos): BOOLEAN;
VAR
	vuelo : Vuelo;
	idlin : TIdLinea;
BEGIN
	idlin := ObtenerIdLinea(linea);
	IF PerteneceVueloListaVuelos(idlin,f,vF^.ListaVF) THEN
		vuelo := ObtenerVueloListaVuelos(idlin,f,vF^.ListaVF);
       		RETURN (EstaDisponibleAsientoVuelo(asiento,vuelo))
	ELSE
		RETURN TRUE
	END		
END EstaDisponibleAsientoVuelosFuturos;



PROCEDURE HayDisponiblesVuelosFuturos (linea: Linea; f: Fecha;
                                       clase: TClaseAsiento;
                                       vF: VuelosFuturos): BOOLEAN;
VAR
	vuelo: Vuelo;
	disp,cant: TRangoAsiento;
	idlin : TIdLinea;
	av : Avion;
BEGIN
	idlin := ObtenerIdLinea(linea);
	IF PerteneceVueloListaVuelos(idlin,f,vF^.ListaVF) THEN
		vuelo := ObtenerVueloListaVuelos(idlin,f,vF^.ListaVF);
       		disp := ObtenerDisponiblesVuelo(clase,vuelo);
		RETURN (disp > 0)
	ELSE
		av := ObtenerAvionLinea(linea);
		cant := ObtenerAsientosAvion(av,clase);
		IF cant > 0 THEN
			RETURN TRUE
		ELSE
			RETURN FALSE
		END
	END
END HayDisponiblesVuelosFuturos;



PROCEDURE ImprimirInfoVueloVuelosFuturos(linea: Linea; f: Fecha;
                                         vf:VuelosFuturos);
VAR
	v : Vuelo;
	idlin : TIdLinea;
	cid   : ChanId;
BEGIN
	cid  := StdOutChan();
	idlin := ObtenerIdLinea(linea);
	IF PerteneceVueloListaVuelos(idlin,f,vf^.ListaVF) THEN
		v := ObtenerVueloListaVuelos(ObtenerIdLinea(linea),f,vf^.ListaVF);
		ImprimirInfoVuelo(cid,v)
	ELSE
		v := CrearVuelo(linea,f);
		ImprimirInfoVuelo(cid,v);
		DestruirVuelo(v)
	END
END ImprimirInfoVueloVuelosFuturos;


PROCEDURE ObtenerListaVuelosFuturos (vF: VuelosFuturos): ListaVuelos;
BEGIN
	RETURN vF^.ListaVF
END ObtenerListaVuelosFuturos;



PROCEDURE DestruirVuelosFuturos (VAR vF: VuelosFuturos);			
BEGIN
	DestruirListaVuelos(vF^.ListaVF);
	DISPOSE(vF);
	vF := NIL
END DestruirVuelosFuturos;	
	

	
END VuelosFuturos.