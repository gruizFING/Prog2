(*4317743 4585215*)
IMPLEMENTATION MODULE Vuelo;

FROM Storage IMPORT ALLOCATE,DEALLOCATE;
FROM Fecha   IMPORT Fecha,CopiaFecha,FechaToString,DestruirFecha;
FROM Linea   IMPORT Linea,ObtenerDuracionLinea,ObtenerAvionLinea,ObtenerIdLinea,
                    TIdLinea,TDuracion;
FROM Avion   IMPORT Avion,TAsiento,TRangoAsiento,ObtenerAsientosAvion,TClaseAsiento;
FROM Cliente IMPORT Cliente,EditarMovimiento,ObtenerHistorialCliente,
                    SumarPuntosCliente;
FROM MovimientoCliente IMPORT MovimientoCliente,TEstadoMovimiento,
                              ObtenerIdLineaMovimientoCliente,
			      ObtenerFechaMovimientoCliente,
			      ObtenerAsientoMovimientoCliente,
			      ObtenerEstadoMovimientoCliente;
FROM Historial IMPORT Historial,EsVacioHistorial,ObtenerPrimerMovimientoHistorial,
                      ObtenerRestoHistorial;
FROM Strings IMPORT Equal;
FROM STextIO IMPORT WriteString,WriteLn,WriteChar;


TYPE
	ListaAsientos = POINTER TO NodoAsiento;
	NodoAsiento = RECORD
		CASE estado : TEstadoAsiento OF
			V_DISPONIBLE : |
			V_RESERVA,V_COMPRA : c : Cliente
		END;
		sig    : ListaAsientos
	END;
	
	Vuelo = POINTER TO TipoVuelo;
	TipoVuelo = RECORD
		lin : Linea;
		asientosPrimera,asientosTurista : ListaAsientos;
		f   : Fecha
	END;
	

PROCEDURE CrearVuelo (lin: Linea; f: Fecha): Vuelo;
VAR
	i : CARDINAL;
	v : Vuelo;
	cantasprim,cantastur : TRangoAsiento;
	av : Avion;
	aux : ListaAsientos;
BEGIN
	NEW(v);
	v^.lin := lin;
	v^.f   := CopiaFecha(f);
	av := ObtenerAvionLinea(v^.lin);
	cantasprim := ObtenerAsientosAvion(av,PRIMERA);
	cantastur := ObtenerAsientosAvion(av,TURISTA);
	IF cantasprim = 0 THEN
		v^.asientosPrimera := NIL
	ELSE
		NEW(v^.asientosPrimera);
		aux := v^.asientosPrimera;
		FOR i := 1 TO cantasprim DO
			aux^.estado := V_DISPONIBLE;
			IF i <> cantasprim THEN
				NEW(aux^.sig);
				aux := aux^.sig
			ELSE
				aux^.sig := NIL
			END
		END
	END;
	IF cantastur = 0 THEN
		v^.asientosTurista := NIL
	ELSE 	
	        NEW(v^.asientosTurista);
		aux := v^.asientosTurista;
		FOR i := 1 TO cantastur DO
			aux^.estado := V_DISPONIBLE;
			IF i <> cantastur THEN
				NEW(aux^.sig);
				aux := aux^.sig
			ELSE
				aux^.sig := NIL
			END
		END
	END;
	RETURN v
END CrearVuelo;


PROCEDURE ComprarVuelo (cli: Cliente; asiento: TAsiento;
                        VAR v: Vuelo): TRangoAsiento;
VAR
	dur: TDuracion;
	i: TRangoAsiento;
	aux: ListaAsientos;
BEGIN
	IF (asiento.clase = PRIMERA) THEN
		aux := v^.asientosPrimera;
	ELSE
		aux := v^.asientosTurista;
	END;
	i := 1;
	IF (asiento.num <> 0) THEN
		dur := ObtenerDuracionLinea(v^.lin);
		EditarMovimiento(ObtenerIdLinea(v^.lin),v^.f,asiento,dur,M_COMPRA,cli);
		WHILE (i < asiento.num) DO
			aux := aux^.sig;
			i := i + 1;
		END;
		aux^.estado := V_COMPRA;
		aux^.c := cli;
	ELSE
		WHILE (aux^.estado <> V_DISPONIBLE) DO
			aux := aux^.sig;
			i := i + 1
		END;
		asiento.num := i;
		dur := ObtenerDuracionLinea(v^.lin);
		EditarMovimiento(ObtenerIdLinea(v^.lin),v^.f,asiento,dur,M_COMPRA,cli);
		aux^.estado := V_COMPRA;
		aux^.c := cli;
	END;
	RETURN (asiento.num);
END ComprarVuelo;


PROCEDURE ReservarVuelo (cli: Cliente; asiento: TAsiento;
                         VAR v: Vuelo): TRangoAsiento;			
VAR
      cont : TRangoAsiento;
      listpos    : ListaAsientos;
BEGIN
	IF asiento.clase = PRIMERA THEN
		listpos := v^.asientosPrimera
	ELSE
		listpos := v^.asientosTurista
	END;
	cont := 1;
	IF asiento.num <> 0 THEN
		EditarMovimiento(ObtenerIdLinea(v^.lin),v^.f,asiento,
		                 ObtenerDuracionLinea(v^.lin),M_RESERVA,cli);
		WHILE cont < asiento.num DO
			listpos := listpos^.sig;
			cont := cont + 1
		END;
		listpos^.estado := V_RESERVA;
		listpos^.c      := cli
	ELSE
		WHILE listpos^.estado <> V_DISPONIBLE DO
			listpos := listpos^.sig;
			cont := cont + 1
		END;
		listpos^.estado := V_RESERVA;
		listpos^.c      := cli;
		asiento.num := cont;
		EditarMovimiento(ObtenerIdLinea(v^.lin),v^.f,asiento,
		                 ObtenerDuracionLinea(v^.lin),M_RESERVA,cli)
	END;
	RETURN (asiento.num)
END ReservarVuelo;


PROCEDURE CancelarVuelo (cli: Cliente; asiento: TAsiento; VAR v: Vuelo);
VAR
	cont : CARDINAL;
	lpos : ListaAsientos;
BEGIN
	IF asiento.clase = PRIMERA THEN
		lpos := v^.asientosPrimera
	ELSE
		lpos := v^.asientosTurista
	END;
	EditarMovimiento(ObtenerIdLinea(v^.lin),v^.f,asiento,
		            	ObtenerDuracionLinea(v^.lin),M_CANCELA,cli);
	cont := 1;
	WHILE cont < asiento.num DO
		lpos := lpos^.sig;
		cont := cont + 1
	END;
	lpos^.estado := V_DISPONIBLE
END CancelarVuelo;


PROCEDURE AnularReservasVuelo(VAR v : Vuelo;
                              VAR cantTurista, cantPrimera: TRangoAsiento);
VAR
	aux: ListaAsientos;
	i: TRangoAsiento;
	asientoaux: TAsiento;
	dur: TDuracion;
	id: TIdLinea;
	puntos : REAL;
BEGIN
	cantTurista := 0;
	cantPrimera := 0;
	aux := v^.asientosPrimera;
	i := 1;
	WHILE (aux <> NIL) DO
		IF (aux^.estado = V_RESERVA) THEN
			asientoaux.num := i;
			asientoaux.clase := PRIMERA;
			dur := ObtenerDuracionLinea(v^.lin);
			id := ObtenerIdLinea(v^.lin);
			EditarMovimiento(id,v^.f,asientoaux,dur,M_MULTA,aux^.c);
			puntos := -((FLOAT(dur) / 60.0) * 15.0);
			SumarPuntosCliente(VAL(INTEGER,puntos),aux^.c);
			aux^.estado := V_DISPONIBLE;
			aux := aux^.sig;
			i := i + 1;
			cantPrimera := cantPrimera + 1;
		ELSE
			aux := aux^.sig;
			i := i + 1;
		END;
	END;
	aux := v^.asientosTurista;
	i := 1;
	WHILE (aux <> NIL) DO
		IF (aux^.estado = V_RESERVA) THEN
			asientoaux.num := i;
			asientoaux.clase := TURISTA;
			dur := ObtenerDuracionLinea(v^.lin);
			id := ObtenerIdLinea(v^.lin);
			EditarMovimiento(id,v^.f,asientoaux,dur,M_MULTA,aux^.c);
			puntos := -((FLOAT(dur) / 60.0) * 10.0);
			SumarPuntosCliente(VAL(INTEGER,puntos),aux^.c);
			aux^.estado := V_DISPONIBLE;
			aux := aux^.sig;
			i := i + 1;
			cantTurista := cantTurista + 1;
		ELSE
			aux := aux^.sig;
			i := i + 1;
		END;
	END;
END AnularReservasVuelo;


PROCEDURE EstaReservadoClienteVuelo(cli:Cliente; asiento:TAsiento;
                                    vuelo:Vuelo): BOOLEAN;
VAR
	fmov,fvue : ARRAY [0..7] OF CHAR;
	hist : Historial;
	movactual : MovimientoCliente;
	idlinmov,idlinvue : TIdLinea;
	fechamov : Fecha;
	asimov   : TAsiento;
	estmov   : TEstadoMovimiento;
	encontro : BOOLEAN;
BEGIN
	hist := ObtenerHistorialCliente(cli);
	encontro := FALSE;
	WHILE (NOT EsVacioHistorial(hist)) AND (encontro = FALSE) DO
		movactual := ObtenerPrimerMovimientoHistorial(hist);
		idlinmov  := ObtenerIdLineaMovimientoCliente(movactual);
		fechamov  := ObtenerFechaMovimientoCliente(movactual);
		FechaToString(fechamov,fmov);
		FechaToString(vuelo^.f,fvue);
	        asimov    := ObtenerAsientoMovimientoCliente(movactual);
		estmov    := ObtenerEstadoMovimientoCliente(movactual);
		idlinvue  := ObtenerIdLinea(vuelo^.lin);
	        IF (Equal(idlinmov,idlinvue)) AND (Equal(fmov,fvue)) THEN
			IF (estmov = M_RESERVA) AND (asimov.clase = asiento.clase)
			    AND (asimov.num = asiento.num) THEN
				encontro := TRUE
			END;
		END;
		hist := ObtenerRestoHistorial(hist)
	END;
	RETURN encontro
END EstaReservadoClienteVuelo;


PROCEDURE EstaCompradoClienteVuelo(cli:Cliente; asiento:TAsiento;
                                   vuelo:Vuelo): BOOLEAN;
VAR
	fmov,fvue : ARRAY [0..7] OF CHAR;
	hist : Historial;
	movactual : MovimientoCliente;
	idlinmov,idlinvue : TIdLinea;
	fechamov : Fecha;
	asimov   : TAsiento;
	estmov   : TEstadoMovimiento;
	encontro : BOOLEAN;
BEGIN
	hist := ObtenerHistorialCliente(cli);
	encontro := FALSE;
	WHILE (NOT EsVacioHistorial(hist)) AND (encontro = FALSE) DO
		movactual := ObtenerPrimerMovimientoHistorial(hist);
		idlinmov  := ObtenerIdLineaMovimientoCliente(movactual);
		fechamov  := ObtenerFechaMovimientoCliente(movactual);
		FechaToString(fechamov,fmov);
		FechaToString(vuelo^.f,fvue);
	        asimov    := ObtenerAsientoMovimientoCliente(movactual);
		estmov    := ObtenerEstadoMovimientoCliente(movactual);
		idlinvue  := ObtenerIdLinea(vuelo^.lin);
	        IF (Equal(idlinmov,idlinvue)) AND (Equal(fmov,fvue)) THEN
			IF (estmov = M_COMPRA) AND (asimov.clase = asiento.clase)
			    AND (asimov.num = asiento.num) THEN
				encontro := TRUE
			END;
		END;
		hist := ObtenerRestoHistorial(hist)
	END;
	RETURN encontro
END EstaCompradoClienteVuelo;


PROCEDURE EstaDisponibleAsientoVuelo(asiento:TAsiento;vuelo :Vuelo): BOOLEAN;
VAR
	lpos : ListaAsientos;
	cont : CARDINAL;
BEGIN
	IF asiento.clase = PRIMERA THEN
		lpos := vuelo^.asientosPrimera
	ELSE
		lpos := vuelo^.asientosTurista
	END;
	cont := 1;
	WHILE (lpos <> NIL) AND (cont < asiento.num) DO
		lpos := lpos^.sig;
		cont := cont + 1
	END;
	IF (cont = asiento.num) AND (lpos <> NIL) THEN
		IF lpos^.estado = V_DISPONIBLE THEN
			RETURN TRUE
		ELSE
			RETURN FALSE
		END
	ELSE
		RETURN FALSE
	END
END EstaDisponibleAsientoVuelo;


PROCEDURE ObtenerLineaVuelo (v: Vuelo): Linea;
BEGIN
	RETURN(v^.lin);
END ObtenerLineaVuelo;



PROCEDURE ObtenerFechaVuelo (v: Vuelo): Fecha;
BEGIN
	RETURN(v^.f);
END ObtenerFechaVuelo;



PROCEDURE ObtenerEstadoVuelo (asiento: TAsiento; v: Vuelo): TEstadoAsiento;
VAR
	aux: ListaAsientos;
	i: TRangoAsiento;
BEGIN
	IF (asiento.clase = PRIMERA) THEN
		aux := v^.asientosPrimera;
	ELSE
		aux := v^.asientosTurista;
	END;
	i := 1;
	WHILE (i <> asiento.num) DO
		aux := aux^.sig;
		i := i + 1;
	END;
	RETURN(aux^.estado);
END ObtenerEstadoVuelo;



PROCEDURE ObtenerClienteVuelo (asiento: TAsiento; v: Vuelo): Cliente;
VAR
	aux: ListaAsientos;
	i: TRangoAsiento;
BEGIN
	i := 1;
	IF (asiento.clase = PRIMERA) THEN
		aux := v^.asientosPrimera;
	ELSE
		aux := v^.asientosTurista;
	END;	
	WHILE (i < asiento.num) DO
		aux := aux^.sig;
		i := i + 1;
	END;
	RETURN(aux^.c);
END ObtenerClienteVuelo;



PROCEDURE ObtenerDisponiblesVuelo (clase : TClaseAsiento;
                                   v: Vuelo): TRangoAsiento;
VAR
	lpos : ListaAsientos;
	cont : CARDINAL;
BEGIN
	IF clase = PRIMERA THEN
		lpos := v^.asientosPrimera
	ELSE
		lpos := v^.asientosTurista
	END;
	cont := 0;
	WHILE lpos <> NIL DO
		IF lpos^.estado = V_DISPONIBLE THEN
			cont := cont + 1
		END;
		lpos := lpos^.sig
	END;
	RETURN cont
END ObtenerDisponiblesVuelo;


PROCEDURE ImprimirInfoVuelo (v: Vuelo);
VAR
	lpos : ListaAsientos;
	cont : CARDINAL;
BEGIN
        lpos := v^.asientosPrimera;
	WriteString("Primera:");WriteLn;
	cont := 1;
	WHILE lpos <> NIL DO
		CASE lpos^.estado OF
			V_DISPONIBLE : WriteChar('L')|
			V_RESERVA    : WriteChar('R')|
			V_COMPRA     : WriteChar('C')
		END;
		cont := cont + 1;
		IF cont = 11 THEN
			cont := 1;
			WriteLn
		END;
		lpos := lpos^.sig
	END;
	IF (cont > 1) AND (cont <= 10) THEN
		WriteLn
	END;
	lpos := v^.asientosTurista;
	WriteString("Turista:");WriteLn;
	cont := 1;
	WHILE lpos <> NIL DO
		CASE lpos^.estado OF
			V_DISPONIBLE : WriteChar('L')|
			V_RESERVA    : WriteChar('R')|
			V_COMPRA     : WriteChar('C')
		END;
		cont := cont + 1;
		IF cont = 11 THEN
			cont := 1;
			WriteLn
		END;
		lpos := lpos^.sig
	END;
	IF (cont > 1) AND (cont <= 10) THEN
		WriteLn
	END
END ImprimirInfoVuelo;


PROCEDURE DestruirVuelo (VAR v: Vuelo);
VAR
	aux: ListaAsientos;
BEGIN
	IF v <> NIL THEN
		DestruirFecha(v^.f);
		WHILE (v^.asientosPrimera <> NIL) DO
			aux := v^.asientosPrimera;
			v^.asientosPrimera := v^.asientosPrimera^.sig;
			DISPOSE(aux);
		END;
		WHILE (v^.asientosTurista <> NIL) DO
			aux := v^.asientosTurista;
			v^.asientosTurista := v^.asientosTurista^.sig;
			DISPOSE(aux);
		END;
		DISPOSE(v);
		v := NIL
	END
END DestruirVuelo;


END Vuelo.
	