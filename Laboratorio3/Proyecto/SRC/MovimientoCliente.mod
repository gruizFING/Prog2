(*4317743 4585215*)
IMPLEMENTATION MODULE MovimientoCliente;

FROM Storage IMPORT ALLOCATE,DEALLOCATE;
FROM Avion IMPORT TAsiento,TClaseAsiento;
FROM Fecha IMPORT Fecha,FechaToString,CopiaFecha,DestruirFecha;
FROM Linea IMPORT TIdLinea, TDuracion;
FROM TextIO IMPORT WriteString,WriteLn;
FROM WholeIO IMPORT WriteCard;
FROM IOChan  IMPORT ChanId;

TYPE
	MovimientoCliente = POINTER TO Nodomovcliente;
	Nodomovcliente = RECORD	
		idlin: TIdLinea;
		fecha: Fecha;
		asiento: TAsiento;
		dur: TDuracion;
		estado: TEstadoMovimiento;
	END;
		
		
		

PROCEDURE CrearMovimientoCliente (idLin: TIdLinea; f: Fecha;
                                  asiento: TAsiento; dur: TDuracion;
                                  estado: TEstadoMovimiento): MovimientoCliente;
VAR
	movcliente: MovimientoCliente;
BEGIN
	NEW(movcliente);
	movcliente^.idlin := idLin;
	movcliente^.fecha := CopiaFecha(f);
	movcliente^.asiento := asiento;
	movcliente^.dur := dur;
	movcliente^.estado := estado;
	RETURN(movcliente);
END CrearMovimientoCliente;



PROCEDURE CambiarEstadoMovimientoCliente (estado: TEstadoMovimiento;
                                          VAR m: MovimientoCliente);
BEGIN
	m^.estado := estado;
END CambiarEstadoMovimientoCliente;



PROCEDURE ObtenerIdLineaMovimientoCliente (m: MovimientoCliente): TIdLinea;
BEGIN
	RETURN(m^.idlin);
END ObtenerIdLineaMovimientoCliente;



PROCEDURE ObtenerFechaMovimientoCliente (m: MovimientoCliente): Fecha;
BEGIN
	RETURN(m^.fecha);
END ObtenerFechaMovimientoCliente;


PROCEDURE ObtenerDuracionMovimientoCliente (m: MovimientoCliente): TDuracion;
BEGIN
	RETURN (m^.dur)
END ObtenerDuracionMovimientoCliente;


PROCEDURE ObtenerAsientoMovimientoCliente (m: MovimientoCliente): TAsiento;
BEGIN
	RETURN(m^.asiento);
END ObtenerAsientoMovimientoCliente;



PROCEDURE ObtenerEstadoMovimientoCliente(m:MovimientoCliente):TEstadoMovimiento;
BEGIN
	RETURN(m^.estado);
END ObtenerEstadoMovimientoCliente;



PROCEDURE ImprimirMovimientoCliente (cid: ChanId; m: MovimientoCliente);
VAR
	fch : ARRAY [0..7] OF CHAR;
BEGIN
	WriteCard(cid,m^.asiento.num,1);
	WriteString(cid,"-");
	IF (m^.asiento.clase = PRIMERA) THEN
		WriteString(cid,"PRIMERA");
	ELSE
		WriteString(cid,"TURISTA");
	END;
	WriteString(cid,"-");
	FechaToString(m^.fecha,fch);
	WriteString(cid,fch);
	WriteString(cid,"-");
	WriteString(cid,m^.idlin);
	WriteString(cid,"-");
	CASE m^.estado OF
		M_COMPRA: WriteString(cid,"COMPRA") |
		M_RESERVA: WriteString(cid,"RESERVA") |
		M_CANCELA: WriteString(cid,"CANCELA") |
		M_MULTA: WriteString(cid,"MULTA")
	END;
	WriteLn(cid);
END ImprimirMovimientoCliente;



PROCEDURE DestruirMovimientoCliente (VAR m: MovimientoCliente);
BEGIN
	IF m <> NIL THEN
		DestruirFecha(m^.fecha);
		DISPOSE(m);
		m := NIL
	END
END DestruirMovimientoCliente;



END MovimientoCliente.
	