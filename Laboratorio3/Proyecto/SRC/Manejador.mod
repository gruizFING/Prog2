(*4317743 4585215*)
IMPLEMENTATION MODULE Manejador;

FROM Avion      IMPORT Avion,CrearAvion,TRangoIdAvion,TAsiento,TDscAvion,TRangoAsiento,TClaseAsiento,ObtenerAsientosAvion,ObtenerIdAvion,ImprimirInfoAvion;
FROM Cliente    IMPORT Cliente,TNomCliente,TApellCliente,TIdNacionalidad,TIdPasaporte,ObtenerPuntosCliente,SumarPuntosCliente,ObtenerPasaporteCliente,ObtenerNacionalidadCliente,ImprimirInfoCliente,CrearCliente,
                       AsignarHistorialCliente;
FROM Fecha      IMPORT Fecha,TDiaSemana,CrearFechaNula,EsNulaFecha,DiaSemanaFecha,EsMenorFecha,FechaToString,DestruirFecha,EsMayorFecha,IncFecha,CopiaFecha,IgualesFecha,CrearFecha;
FROM Linea      IMPORT Linea,TIdLinea,TIdAeropuerto,TTipoLinea,TDuracion,TModoPago,CrearLineaDiaria,CrearLineaSemanal,ObtenerAvionLinea,ObtenerTipoLinea,ObtenerDiaSemanaLinea,ObtenerDuracionLinea,ObtenerIdLinea,
		       ImprimirInfoLinea,EvaluarCondicionLinea,ObtenerOrigenLinea,ObtenerHoraSalidaLinea,ObtenerDestinoLinea,CopiaLinea;
FROM ImpresionResultado IMPORT ImpresionResultado,CrearImpresionResultado,AsignarCodigoImpresionResultado,CodigoResultado,AsignarParamImpresionResultado,ImprimirImpresionResultado,DestruirImpresionResultado;
FROM WholeStr IMPORT CardToStr,IntToStr,ConvResults,StrToCard;
FROM Storage  IMPORT ALLOCATE,DEALLOCATE;
FROM ListaClientes IMPORT ListaClientes,CrearListaClientes,PerteneceClienteListaClientes,ObtenerClienteListaClientes,EsVaciaListaClientes,ObtenerPrimerClienteListaClientes,ObtenerRestoListaClientes,DestruirListaClientes,
			  AgregarClienteListaClientes;
FROM VuelosFuturos IMPORT VuelosFuturos,CrearVuelosFuturos,EstaDisponibleAsientoVuelosFuturos,ComprarVuelosFuturos,HayDisponiblesVuelosFuturos,DestruirVuelosFuturos,ImprimirInfoVueloVuelosFuturos,SepararHastaFechaVuelosFuturos,
			  AnularReservasVuelosFuturos,ReservarVuelosFuturos,EstaReservadoClienteVuelosFuturos,CancelarVuelosFuturos,ObtenerListaVuelosFuturos,SuplantarVuelosFuturos;
FROM VuelosHoy IMPORT VuelosHoy,CrearVuelosHoy,ListarVuelosVuelosHoy,DestruirVuelosHoy,SuplantarVuelosHoy,ObtenerListaVuelosHoy;
FROM ListaLineas IMPORT ListaLineas,CrearListaLineas,PerteneceLineaListaLineas,AgregarLineaListaLineas,ObtenerLineaListaLineas,EsVaciaListaLineas,ObtenerPrimerLineaListaLineas,ObtenerRestoListaLineas,DestruirListaLineas,
                        ObtenerTamanioListaLineas,EliminarLineaListaLineas;
FROM Vuelo IMPORT ImprimirInfoVuelo,TEstadoAsiento;
FROM DicAviones IMPORT DicAviones,CrearDicAviones,TRangoCantAviones,ObtenerTamanioDicAviones,InsertarAvionDicAviones,PerteneceAvionDicAviones,ObtenerAvionDicAviones,DestruirDicAviones,EsVacioDicAviones;
FROM TextIO IMPORT WriteString,WriteLn,ReadChar,SkipLine;
FROM WholeIO IMPORT WriteCard;
FROM ListaVuelos IMPORT ListaVuelos,ObtenerCantVuelosListaVuelos,EsVaciaListaVuelos,ObtenerPrimerVueloListaVuelos,ObtenerRestoListaVuelos,CrearListaVuelos,InsertarVueloListaVuelos;
FROM Condicion   IMPORT Condicion;
FROM ListaOrdenLinea IMPORT ListaOrdenLinea,EsVaciaListaOrdenLinea,ObtenerPrimeroListaOrdenLinea,ObtenerRestoListaOrdenLinea;
FROM IOChan IMPORT ChanId;
FROM StdChans IMPORT StdOutChan;
FROM SeqFile    IMPORT Rewrite,OpenWrite,OpenRead,Close;
FROM ChanConsts IMPORT write,old,read;
FROM RndFile    IMPORT OpenResults;
FROM OrdenLinea IMPORT TOrdenForma,TOrdenarPor,ObtenerFormaOrdenLinea,ObtenerPorOrdenLinea;
FROM Strings  IMPORT Compare,CompareResults,Delete,Length,Equal;
FROM MovimientoCliente IMPORT TEstadoMovimiento,MovimientoCliente,CrearMovimientoCliente;
FROM IOResult  IMPORT ReadResults,ReadResult;
FROM Historial IMPORT Historial,CrearHistorial,AgregarMovimientoHistorial,EsVacioHistorial;
FROM Vuelo IMPORT CrearVuelo,Vuelo,MarcarAsientoVuelo;
FROM Combinacion IMPORT Combinacion,EsVaciaCombinacion,ExisteAeropuertoCombinacion,ObtenerUltimoCombinacion,PonerTramoCombinacion,CopiaCombinacion,SacarTramoCombinacion,CrearCombinacion;
FROM Tramo  IMPORT Tramo,CrearTramo,ObtenerHoraLlegadaTramo;
FROM Hora   IMPORT Hora,CrearHora,IgualesHora,CopiaHora,SumarMinutos,EsMenorHora,EsMayorHora;
FROM ABBCombinaciones IMPORT ABBCombinaciones,AgregarABBCombinaciones,CrearABBCombinaciones,EnOrdenABBCombinaciones,DestruirABBCombinaciones;
FROM ListaCombinacion IMPORT ListaCombinacion,EsVaciaListaCombinacion,ImprimirListaCombinacion;


TYPE
	Manejador = POINTER TO TManejador;
	TManejador = RECORD
		fecha : Fecha;
		ListaC: ListaClientes;
		ListaL: ListaLineas;
		DicA  : DicAviones;
		VF    : VuelosFuturos;
		VH    : VuelosHoy;
	END;




PROCEDURE CrearManejador (): Manejador;
VAR
	m: Manejador;
BEGIN
	NEW(m);
	m^.fecha  := CrearFechaNula();
	m^.ListaC := CrearListaClientes();
	m^.ListaL := CrearListaLineas();
	m^.DicA   := CrearDicAviones();
	m^.VF     := CrearVuelosFuturos();
	m^.VH     := CrearVuelosHoy();
	RETURN(m);
END CrearManejador;



PROCEDURE AltaCliente (pais: TIdNacionalidad; pasaporte: TIdPasaporte;
                       nombre: TNomCliente; apellido: TApellCliente;
                       VAR man: Manejador;      VAR ir: ImpresionResultado);
VAR
	cliente: Cliente;
BEGIN
	IF NOT (PerteneceClienteListaClientes(pasaporte,pais,man^.ListaC)) THEN
		cliente := CrearCliente(pais,pasaporte,nombre,apellido);
		AgregarClienteListaClientes(cliente,man^.ListaC);
		ir := CrearImpresionResultado();
		AsignarCodigoImpresionResultado(ALTA_CLIENTE,ir);
		AsignarParamImpresionResultado(1,pasaporte,ir);
		AsignarParamImpresionResultado(2,pais,ir);
		ImprimirImpresionResultado(ir);
		DestruirImpresionResultado(ir);
	ELSE
		ir := CrearImpresionResultado();
		AsignarCodigoImpresionResultado(ERROR_CLIENTE_EXISTENTE,ir);
		AsignarParamImpresionResultado(1,pasaporte,ir);
		AsignarParamImpresionResultado(2,pais,ir);
		ImprimirImpresionResultado(ir);
		DestruirImpresionResultado(ir);
	END;
END AltaCliente;



PROCEDURE AltaAvion (cantAsientoPrimera, cantAsientoTurista: TRangoAsiento;
                     dsc: TDscAvion;
                     VAR man: Manejador; VAR ir: ImpresionResultado);
VAR
	tam : TRangoCantAviones;
	av  : Avion;
	str : ARRAY[0..2] OF CHAR;
BEGIN
	tam := ObtenerTamanioDicAviones(man^.DicA);
	av  := CrearAvion(tam,cantAsientoPrimera,cantAsientoTurista,dsc);
	InsertarAvionDicAviones(av,man^.DicA);
	ir := CrearImpresionResultado();
	AsignarCodigoImpresionResultado(ALTA_AVION,ir);
	CardToStr(tam,str);
	AsignarParamImpresionResultado(1,str,ir);
	ImprimirImpresionResultado(ir);
	DestruirImpresionResultado(ir)
END AltaAvion;



PROCEDURE AltaLinea (idLin: TIdLinea; idAv: TRangoIdAvion;
                     orig, dest: TIdAeropuerto;
                     hora: CARDINAL; dur: TDuracion; tipo: TTipoLinea;
                     dia: TDiaSemana;
                     VAR man: Manejador; VAR ir: ImpresionResultado);
VAR
	av  : Avion;
	lin : Linea;
	str : ARRAY[0..2] OF CHAR;	
BEGIN
	ir := CrearImpresionResultado();
	IF NOT PerteneceLineaListaLineas(idLin,man^.ListaL) THEN
		IF PerteneceAvionDicAviones(idAv,man^.DicA) THEN
			av := ObtenerAvionDicAviones(idAv,man^.DicA);
			IF tipo = DIARIA THEN
				lin := CrearLineaDiaria(idLin,av,orig,dest,hora,dur)
			ELSE
				lin := CrearLineaSemanal(idLin,av,orig,dest,hora,dur,dia)
			END;
			AgregarLineaListaLineas(lin,man^.ListaL);
			AsignarCodigoImpresionResultado(ALTA_LINEA,ir);
			AsignarParamImpresionResultado(1,idLin,ir)
		ELSE
			AsignarCodigoImpresionResultado(ERROR_AVION_NO_EXISTE,ir);
			CardToStr(idAv,str);
			AsignarParamImpresionResultado(1,str,ir)
		END
	ELSE
		AsignarCodigoImpresionResultado(ERROR_LINEA_EXISTENTE,ir);
		AsignarParamImpresionResultado(1,idLin,ir)
	END;
	ImprimirImpresionResultado(ir);
	DestruirImpresionResultado(ir)
END AltaLinea;





PROCEDURE Iniciar (f: Fecha; VAR man: Manejador; VAR ir: ImpresionResultado);
VAR
	str : ARRAY [0 ..7] OF CHAR;
BEGIN
	IF (EsNulaFecha(man^.fecha)) THEN
		man^.fecha := f;
		ir := CrearImpresionResultado();
		FechaToString(f,str);
		AsignarCodigoImpresionResultado(INICIAR,ir);
		AsignarParamImpresionResultado(1,str,ir);
		ImprimirImpresionResultado(ir);
		DestruirImpresionResultado(ir);
	ELSE
		ir := CrearImpresionResultado();
		AsignarCodigoImpresionResultado(ERROR_FECHA_YA_INICIALIZADA,ir);
		ImprimirImpresionResultado(ir);
		DestruirImpresionResultado(ir);
	END;
END Iniciar;



PROCEDURE SiguienteDia (VAR man: Manejador; VAR ir: ImpresionResultado);
VAR
	cantTurista,cantPrimera: CARDINAL;
	str: ARRAY [0..7] OF CHAR;
	liberadas : CARDINAL;
	listaux : ListaVuelos;
	fechaaux : Fecha;
	
BEGIN
	ir := CrearImpresionResultado();
	IF NOT (EsNulaFecha(man^.fecha)) THEN
		IncFecha(man^.fecha);
		listaux := SepararHastaFechaVuelosFuturos(man^.fecha,man^.VF);
		SuplantarVuelosHoy(listaux,man^.VH);
		fechaaux := CopiaFecha(man^.fecha);
		IncFecha(fechaaux);
		AnularReservasVuelosFuturos(fechaaux,man^.VF,cantTurista,cantPrimera);
		FechaToString(man^.fecha,str);
		liberadas := cantTurista + cantPrimera;
		AsignarCodigoImpresionResultado(SIGUIENTE_DIA,ir);
		AsignarParamImpresionResultado(1,str,ir);
		CardToStr(liberadas,str);
		AsignarParamImpresionResultado(2,str,ir);
		ImprimirImpresionResultado(ir);
	ELSE
		AsignarCodigoImpresionResultado(ERROR_FECHA_NO_INICIALIZADA,ir);
		ImprimirImpresionResultado(ir);
	END;
	DestruirImpresionResultado(ir);
END SiguienteDia;



PROCEDURE Comprar (pais: TIdNacionalidad; pasaporte: TIdPasaporte;
                   idLin: TIdLinea; f: Fecha; modo: TModoPago;
                   clase: TClaseAsiento; numero: CARDINAL;
                   VAR man: Manejador; VAR ir: ImpresionResultado);
VAR
	
	lin     : Linea;
	tlin    : TTipoLinea;
	dsfecha : TDiaSemana;
	av      : Avion;
	asiento : TAsiento;
	cant,ascomprado : TRangoAsiento;
	puntosv,puntosvg,puntosc,efect : INTEGER;
	puntosvreal,puntosvgreal,efectreal : REAL;
	dur     : CARDINAL;
	c       : Cliente;
	str : ARRAY[0..7] OF CHAR;
BEGIN	
	ir := CrearImpresionResultado();
	IF NOT EsNulaFecha(man^.fecha) THEN
		IF PerteneceLineaListaLineas(idLin,man^.ListaL) THEN
			lin  := ObtenerLineaListaLineas(idLin,man^.ListaL);
			tlin := ObtenerTipoLinea(lin);
			dsfecha := DiaSemanaFecha(f);
			IF (tlin = DIARIA) OR (ObtenerDiaSemanaLinea(lin) = dsfecha) THEN
				IF PerteneceClienteListaClientes(pasaporte,pais,man^.ListaC) THEN
					c := ObtenerClienteListaClientes(pasaporte,pais,man^.ListaC);
					IF numero > 0 THEN
						av   := ObtenerAvionLinea(lin);
						cant :=	ObtenerAsientosAvion(av,clase);
						IF numero <= cant THEN
							IF EsMenorFecha(man^.fecha,f) THEN
								asiento.clase := clase;
								asiento.num   := numero;
								IF EstaDisponibleAsientoVuelosFuturos(lin,f,asiento,man^.VF) OR
							   	   EstaReservadoClienteVuelosFuturos(c,lin,f,asiento,man^.VF) THEN	
						                	IF modo = PUNTOS THEN
										dur := ObtenerDuracionLinea(lin);
										IF clase = PRIMERA THEN
											puntosvreal  := (FLOAT(dur) / 60.0) * 150.0;
											puntosvgreal := (FLOAT(dur) / 60.0) * 15.0
										ELSE
											puntosvreal  := (FLOAT(dur) / 60.0) * 100.0;
											puntosvgreal := (FLOAT(dur) / 60.0) * 10.0;
										END;
										puntosv  := VAL(INTEGER,puntosvreal);
										puntosvg := VAL(INTEGER,puntosvgreal);
										puntosc := ObtenerPuntosCliente(c);
										IF puntosc >= puntosv THEN
											ascomprado := ComprarVuelosFuturos(c,lin,f,asiento,man^.VF);
											SumarPuntosCliente(-puntosv,c);
											SumarPuntosCliente(puntosvg,c);
											AsignarCodigoImpresionResultado(COMPRAR,ir);
											CardToStr(ascomprado,str);
											AsignarParamImpresionResultado(1,str,ir);
											IF clase = PRIMERA THEN
												AsignarParamImpresionResultado(2,'PRIMERA',ir)
											ELSE
												AsignarParamImpresionResultado(2,'TURISTA',ir)
											END;
											FechaToString(f,str);
											AsignarParamImpresionResultado(3,str,ir);
											AsignarParamImpresionResultado(4,idLin,ir);
											AsignarParamImpresionResultado(5,pasaporte,ir);											
											AsignarParamImpresionResultado(6,pais,ir);
											IntToStr(puntosv,str);
											AsignarParamImpresionResultado(7,str,ir);
											AsignarParamImpresionResultado(8,'PUNTOS',ir);
											IntToStr(puntosvg,str);
											AsignarParamImpresionResultado(9,str,ir)
				                                                ELSE
											AsignarCodigoImpresionResultado(ERROR_PUNTOS_INSUFICIENTES_COMPRA,ir);
											AsignarParamImpresionResultado(1,pasaporte,ir);											
											AsignarParamImpresionResultado(2,pais,ir)
										END
									ELSE
										dur := ObtenerDuracionLinea(lin);
										IF clase = PRIMERA THEN
											puntosvgreal := (FLOAT(dur) / 60.0) * 15.0;
											efectreal    := (FLOAT(dur) / 60.0) * 120.0	
										ELSE
											puntosvgreal := (FLOAT(dur) / 60.0) * 10.0;
											efectreal    := (FLOAT(dur) / 60.0) * 80.0
										END;
										puntosvg := VAL(INTEGER,puntosvgreal);
										efect    := VAL(INTEGER,efectreal);
										ascomprado := ComprarVuelosFuturos(c,lin,f,asiento,man^.VF);
										SumarPuntosCliente(puntosvg,c);
										AsignarCodigoImpresionResultado(COMPRAR,ir);
										CardToStr(ascomprado,str);
										AsignarParamImpresionResultado(1,str,ir);
										IF clase = PRIMERA THEN
											AsignarParamImpresionResultado(2,'PRIMERA',ir)
										ELSE
											AsignarParamImpresionResultado(2,'TURISTA',ir)
										END;
										FechaToString(f,str);
										AsignarParamImpresionResultado(3,str,ir);
										AsignarParamImpresionResultado(4,idLin,ir);
										AsignarParamImpresionResultado(5,pasaporte,ir);											
										AsignarParamImpresionResultado(6,pais,ir);
										IntToStr(efect,str);
										AsignarParamImpresionResultado(7,str,ir);
										AsignarParamImpresionResultado(8,'EFECTIVO',ir);
										IntToStr(puntosvg,str);
										AsignarParamImpresionResultado(9,str,ir)
				                                        END
								ELSE
									AsignarCodigoImpresionResultado(ERROR_ASIENTO_NO_DISPONIBLE,ir);
									CardToStr(numero,str);
									AsignarParamImpresionResultado(1,str,ir);
									IF clase = PRIMERA THEN
										AsignarParamImpresionResultado(2,'PRIMERA',ir)
									ELSE
										AsignarParamImpresionResultado(2,'TURISTA',ir)
									END;
									FechaToString(f,str);
									AsignarParamImpresionResultado(3,str,ir);
									AsignarParamImpresionResultado(4,idLin,ir)
								END
							ELSE
								AsignarCodigoImpresionResultado(ERROR_FECHA_TARDIA,ir);
								FechaToString(f,str);
								AsignarParamImpresionResultado(1,str,ir)
							END
						ELSE
							AsignarCodigoImpresionResultado(ERROR_ASIENTO_NO_EXISTE,ir);
							CardToStr(numero,str);
							AsignarParamImpresionResultado(1,str,ir);
							IF clase = PRIMERA THEN
								AsignarParamImpresionResultado(2,'PRIMERA',ir)
							ELSE
								AsignarParamImpresionResultado(2,'TURISTA',ir)
							END;
							AsignarParamImpresionResultado(3,idLin,ir)
						END
					ELSE
						asiento.clase := clase;
						asiento.num   := numero;
						IF EsMenorFecha(man^.fecha,f) THEN
							IF HayDisponiblesVuelosFuturos(lin,f,clase,man^.VF) THEN	
						                IF modo = PUNTOS THEN
									dur := ObtenerDuracionLinea(lin);
									IF clase = PRIMERA THEN
										puntosvreal  := (FLOAT(dur) / 60.0) * 150.0;
										puntosvgreal := (FLOAT(dur) / 60.0) * 15.0
									ELSE
										puntosvreal  := (FLOAT(dur) / 60.0) * 100.0;
										puntosvgreal := (FLOAT(dur) / 60.0) * 10.0;
									END;
									puntosv  := VAL(INTEGER,puntosvreal);
									puntosvg := VAL(INTEGER,puntosvgreal);
									puntosc := ObtenerPuntosCliente(c);
									IF puntosc >= puntosv THEN
										ascomprado := ComprarVuelosFuturos(c,lin,f,asiento,man^.VF);
										SumarPuntosCliente(-puntosv,c);
										SumarPuntosCliente(puntosvg,c);
										AsignarCodigoImpresionResultado(COMPRAR,ir);
										CardToStr(ascomprado,str);
										AsignarParamImpresionResultado(1,str,ir);
										IF clase = PRIMERA THEN
											AsignarParamImpresionResultado(2,'PRIMERA',ir)
										ELSE
											AsignarParamImpresionResultado(2,'TURISTA',ir)
										END;
										FechaToString(f,str);
										AsignarParamImpresionResultado(3,str,ir);
										AsignarParamImpresionResultado(4,idLin,ir);
										AsignarParamImpresionResultado(5,pasaporte,ir);											
										AsignarParamImpresionResultado(6,pais,ir);
										IntToStr(puntosv,str);
										AsignarParamImpresionResultado(7,str,ir);
										AsignarParamImpresionResultado(8,'PUNTOS',ir);
										IntToStr(puntosvg,str);
										AsignarParamImpresionResultado(9,str,ir)
				                                        ELSE
										AsignarCodigoImpresionResultado(ERROR_PUNTOS_INSUFICIENTES_COMPRA,ir);
										AsignarParamImpresionResultado(1,pasaporte,ir);											
										AsignarParamImpresionResultado(2,pais,ir)
									END
								ELSE
									dur := ObtenerDuracionLinea(lin);
									IF clase = PRIMERA THEN
										puntosvgreal := (FLOAT(dur) / 60.0) * 15.0;
										efectreal    := (FLOAT(dur) / 60.0) * 120.0	
									ELSE
										puntosvgreal := (FLOAT(dur) / 60.0) * 10.0;
										efectreal    := (FLOAT(dur) / 60.0) * 80.0
									END;
									puntosvg := VAL(INTEGER,puntosvgreal);
									efect    := VAL(INTEGER,efectreal);
									ascomprado := ComprarVuelosFuturos(c,lin,f,asiento,man^.VF);
									SumarPuntosCliente(puntosvg,c);
									AsignarCodigoImpresionResultado(COMPRAR,ir);
									CardToStr(ascomprado,str);
									AsignarParamImpresionResultado(1,str,ir);
									IF clase = PRIMERA THEN
										AsignarParamImpresionResultado(2,'PRIMERA',ir)
									ELSE
										AsignarParamImpresionResultado(2,'TURISTA',ir)
									END;
									FechaToString(f,str);
									AsignarParamImpresionResultado(3,str,ir);
									AsignarParamImpresionResultado(4,idLin,ir);
									AsignarParamImpresionResultado(5,pasaporte,ir);											
									AsignarParamImpresionResultado(6,pais,ir);
									IntToStr(efect,str);
									AsignarParamImpresionResultado(7,str,ir);
									AsignarParamImpresionResultado(8,'EFECTIVO',ir);
									IntToStr(puntosvg,str);
									AsignarParamImpresionResultado(9,str,ir)
				                                END
							ELSE
								AsignarCodigoImpresionResultado(ERROR_NO_HAY_ASIENTOS_DISPONIBLES,ir);
								IF clase = PRIMERA THEN
									AsignarParamImpresionResultado(1,'PRIMERA',ir)
								ELSE
									AsignarParamImpresionResultado(1,'TURISTA',ir)
								END;
								FechaToString(f,str);
								AsignarParamImpresionResultado(2,str,ir);
								AsignarParamImpresionResultado(3,idLin,ir)
							END
						ELSE
							AsignarCodigoImpresionResultado(ERROR_FECHA_TARDIA,ir);
							FechaToString(f,str);
							AsignarParamImpresionResultado(1,str,ir)		
						END
					END
				ELSE
					AsignarCodigoImpresionResultado(ERROR_CLIENTE_NO_EXISTE,ir);
					AsignarParamImpresionResultado(1,pasaporte,ir);
					AsignarParamImpresionResultado(2,pais,ir)
				END
			ELSE
				AsignarCodigoImpresionResultado(ERROR_LINEA_FECHA,ir);
				FechaToString(f,str);
				AsignarParamImpresionResultado(1,str,ir);
				AsignarParamImpresionResultado(2,idLin,ir)
			END
		ELSE
			AsignarCodigoImpresionResultado(ERROR_LINEA_NO_EXISTE,ir);
			AsignarParamImpresionResultado(1,idLin,ir)
		END
	ELSE
		AsignarCodigoImpresionResultado(ERROR_FECHA_NO_INICIALIZADA,ir)
	END;
	ImprimirImpresionResultado(ir);
	DestruirImpresionResultado(ir)
END Comprar;





PROCEDURE Reservar (pais: TIdNacionalidad; pasaporte: TIdPasaporte;
                    idLin: TIdLinea; f: Fecha;
                    clase: TClaseAsiento; numero: CARDINAL;
                    VAR man: Manejador; VAR ir: ImpresionResultado);
VAR
	cant : TRangoAsiento;
	reservado : CARDINAL;
	asiento : TAsiento;
	disp : BOOLEAN;
	fechaaux : Fecha;
	str : ARRAY [0..7] OF CHAR;
	dsfecha: TDiaSemana;
	tlin: TTipoLinea;
	linea: Linea;
	avion: Avion;
	cliente: Cliente;
BEGIN
	ir := CrearImpresionResultado();
	IF NOT (EsNulaFecha(man^.fecha)) THEN
		IF (PerteneceLineaListaLineas(idLin,man^.ListaL)) THEN
			linea := ObtenerLineaListaLineas(idLin,man^.ListaL);
			tlin := ObtenerTipoLinea(linea);
			dsfecha := DiaSemanaFecha(f);
			IF (tlin = DIARIA) OR (ObtenerDiaSemanaLinea(linea) = dsfecha) THEN
				IF (PerteneceClienteListaClientes(pasaporte,pais,man^.ListaC)) THEN
					IF (numero > 0) THEN
						avion := ObtenerAvionLinea(linea);
						cant := ObtenerAsientosAvion(avion,clase);
						IF (numero <= cant) THEN
							fechaaux := CopiaFecha(man^.fecha);
							IncFecha(fechaaux);
							IncFecha(fechaaux);
							IF (IgualesFecha(fechaaux,f)) OR (EsMayorFecha(f,fechaaux)) THEN
								asiento.num   := numero;
								asiento.clase := clase;
								disp := EstaDisponibleAsientoVuelosFuturos(linea,f,asiento,man^.VF);
								IF (disp) THEN
									cliente := ObtenerClienteListaClientes(pasaporte,pais,man^.ListaC);
									reservado := ReservarVuelosFuturos(cliente,linea,f,asiento,man^.VF);
									AsignarCodigoImpresionResultado(RESERVAR,ir);
									CardToStr(reservado,str);
									AsignarParamImpresionResultado(1,str,ir);
									IF (asiento.clase = TURISTA) THEN
										AsignarParamImpresionResultado(2,'TURISTA',ir);
									ELSE
										AsignarParamImpresionResultado(2,'PRIMERA',ir);
									END;
									FechaToString(f,str);
									AsignarParamImpresionResultado(3,str,ir);
									AsignarParamImpresionResultado(4,idLin,ir);
									AsignarParamImpresionResultado(5,pasaporte,ir);
									AsignarParamImpresionResultado(6,pais,ir);
								ELSE
									AsignarCodigoImpresionResultado(ERROR_ASIENTO_NO_DISPONIBLE,ir);
									CardToStr(numero,str);
									AsignarParamImpresionResultado(1,str,ir);	
							        	IF (asiento.clase = TURISTA) THEN
										AsignarParamImpresionResultado(2,'TURISTA',ir);
									ELSE
										AsignarParamImpresionResultado(2,'PRIMERA',ir);
									END;
									FechaToString(f,str);
									AsignarParamImpresionResultado(3,str,ir);	
									AsignarParamImpresionResultado(4,idLin,ir);
								END;
							ELSE
								AsignarCodigoImpresionResultado(ERROR_FECHA_TARDIA,ir);
								FechaToString(f,str);
								AsignarParamImpresionResultado(1,str,ir)
							END
						ELSE
							AsignarCodigoImpresionResultado(ERROR_ASIENTO_NO_EXISTE,ir);
							CardToStr(numero,str);
							AsignarParamImpresionResultado(1,str,ir);
							IF (clase = TURISTA) THEN
								AsignarParamImpresionResultado(2,'TURISTA',ir);
							ELSE
								AsignarParamImpresionResultado(2,'PRIMERA',ir);
							END;
							AsignarParamImpresionResultado(3,idLin,ir);
						END;
					ELSE
						asiento.clase := clase;
						asiento.num := numero;
						fechaaux := CopiaFecha(man^.fecha);
						IncFecha(fechaaux);
						IncFecha(fechaaux);
						IF (IgualesFecha(fechaaux,f)) OR (EsMayorFecha(f,fechaaux)) THEN
							IF HayDisponiblesVuelosFuturos(linea,f,clase,man^.VF) THEN
								cliente := ObtenerClienteListaClientes(pasaporte,pais,man^.ListaC);
								reservado := ReservarVuelosFuturos(cliente,linea,f,asiento,man^.VF);
								AsignarCodigoImpresionResultado(RESERVAR,ir);
								CardToStr(reservado,str);
								AsignarParamImpresionResultado(1,str,ir);
								IF (asiento.clase = TURISTA) THEN
									AsignarParamImpresionResultado(2,'TURISTA',ir);
								ELSE
									AsignarParamImpresionResultado(2,'PRIMERA',ir);
								END;
								FechaToString(f,str);
								AsignarParamImpresionResultado(3,str,ir);
								AsignarParamImpresionResultado(4,idLin,ir);
								AsignarParamImpresionResultado(5,pasaporte,ir);
								AsignarParamImpresionResultado(6,pais,ir);
							ELSE
								AsignarCodigoImpresionResultado(ERROR_NO_HAY_ASIENTOS_DISPONIBLES,ir);	
								IF (asiento.clase = TURISTA) THEN
									AsignarParamImpresionResultado(1,'TURISTA',ir);
								ELSE
									AsignarParamImpresionResultado(1,'PRIMERA',ir);
								END;
					                	FechaToString(f,str);
								AsignarParamImpresionResultado(2,str,ir);
					        	        AsignarParamImpresionResultado(3,idLin,ir)	
					                END;
						ELSE
							AsignarCodigoImpresionResultado(ERROR_FECHA_TARDIA,ir);
							FechaToString(f,str);
							AsignarParamImpresionResultado(1,str,ir);
						END;
					END;
				ELSE
					AsignarCodigoImpresionResultado(ERROR_CLIENTE_NO_EXISTE,ir);
				        AsignarParamImpresionResultado(1,pasaporte,ir);
	                                AsignarParamImpresionResultado(2,pais,ir);
				END;
			ELSE
				AsignarCodigoImpresionResultado(ERROR_LINEA_FECHA,ir);
				FechaToString(f,str);
				AsignarParamImpresionResultado(1,str,ir);
	                        AsignarParamImpresionResultado(2,idLin,ir);
			END;
		ELSE
			AsignarCodigoImpresionResultado(ERROR_LINEA_NO_EXISTE,ir);
			AsignarParamImpresionResultado(1,idLin,ir);
		END;
	ELSE
		AsignarCodigoImpresionResultado(ERROR_FECHA_NO_INICIALIZADA,ir);
	END;
	ImprimirImpresionResultado(ir);
	DestruirImpresionResultado(ir);
END Reservar;



PROCEDURE Cancelar (pais: TIdNacionalidad; pasaporte: TIdPasaporte;
                    idLin: TIdLinea; f: Fecha;
                    clase: TClaseAsiento; numero: CARDINAL;
                    VAR man: Manejador; VAR ir: ImpresionResultado);
VAR
	cliente : Cliente;
	asiento : TAsiento;
	str: ARRAY [0..7] OF CHAR;
	linea: Linea;
	tlin: TTipoLinea;
	dsfecha: TDiaSemana;
BEGIN
	ir := CrearImpresionResultado();
	IF NOT (EsNulaFecha(man^.fecha)) THEN
		IF (PerteneceLineaListaLineas(idLin,man^.ListaL)) THEN
			linea := ObtenerLineaListaLineas(idLin,man^.ListaL);
			tlin := ObtenerTipoLinea(linea);
			dsfecha := DiaSemanaFecha(f);
			IF (tlin = DIARIA) OR (ObtenerDiaSemanaLinea(linea) = dsfecha) THEN
				IF (PerteneceClienteListaClientes(pasaporte,pais,man^.ListaC)) THEN
					cliente := ObtenerClienteListaClientes(pasaporte,pais,man^.ListaC);
					asiento.num := numero;
					asiento.clase := clase;
					IF (EstaReservadoClienteVuelosFuturos(cliente,linea,f,asiento,man^.VF)) THEN
						CancelarVuelosFuturos(cliente,linea,f,asiento,man^.VF);
						AsignarCodigoImpresionResultado(CANCELAR,ir);
						CardToStr(numero,str);
						AsignarParamImpresionResultado(1,str,ir);
						IF (clase = PRIMERA) THEN
							AsignarParamImpresionResultado(2,'PRIMERA',ir);
						ELSE
							AsignarParamImpresionResultado(2,'TURISTA',ir);
						END;
						FechaToString(f,str);
						AsignarParamImpresionResultado(3,str,ir);
						AsignarParamImpresionResultado(4,idLin,ir);
						AsignarParamImpresionResultado(5,pasaporte,ir);
						AsignarParamImpresionResultado(6,pais,ir);
					ELSE
						AsignarCodigoImpresionResultado(ERROR_ASIENTO_NO_RESERVADO_POR_CLIENTE,ir);
						AsignarParamImpresionResultado(1,pasaporte,ir);
						AsignarParamImpresionResultado(2,pais,ir);
						CardToStr(numero,str);
						AsignarParamImpresionResultado(3,str,ir);
						IF (clase = PRIMERA) THEN
							AsignarParamImpresionResultado(4,'PRIMERA',ir);
						ELSE
							AsignarParamImpresionResultado(4,'TURISTA',ir);
						END;
						FechaToString(f,str);
						AsignarParamImpresionResultado(5,str,ir);
						AsignarParamImpresionResultado(6,idLin,ir);
					END;
				ELSE
					AsignarCodigoImpresionResultado(ERROR_CLIENTE_NO_EXISTE,ir);
					AsignarParamImpresionResultado(1,pasaporte,ir);
					AsignarParamImpresionResultado(2,pais,ir);
				END;
			ELSE
				AsignarCodigoImpresionResultado(ERROR_LINEA_FECHA,ir);
				FechaToString(f,str);
				AsignarParamImpresionResultado(1,str,ir);
				AsignarParamImpresionResultado(2,idLin,ir);
			END;
		ELSE
			AsignarCodigoImpresionResultado(ERROR_LINEA_NO_EXISTE,ir);
			AsignarParamImpresionResultado(1,idLin,ir);
		END;
	ELSE
		AsignarCodigoImpresionResultado(ERROR_FECHA_NO_INICIALIZADA,ir);
	END;
	ImprimirImpresionResultado(ir);
	DestruirImpresionResultado(ir);
END Cancelar;



PROCEDURE ListarClientes (man: Manejador);
VAR
	cact   : Cliente;
	pasac  : TIdPasaporte;
	paisac : TIdNacionalidad;
	lpos   : ListaClientes;
	cid    : ChanId;
BEGIN
	cid := StdOutChan();
	WriteString(cid,"Clientes:");WriteLn(cid);
	WITH man^ DO
		lpos := ListaC;
		WHILE NOT EsVaciaListaClientes(lpos) DO
			cact   := ObtenerPrimerClienteListaClientes(lpos);
			pasac  := ObtenerPasaporteCliente(cact);
			paisac := ObtenerNacionalidadCliente(cact);
			WriteString(cid,pasac);WriteString(cid,"-");
			WriteString(cid,paisac);WriteLn(cid);
			lpos := ObtenerRestoListaClientes(lpos)
		END
	END
END ListarClientes;



PROCEDURE ListarLineas (ord: ListaOrdenLinea; man: Manejador);

	PROCEDURE ImprimirHoraLinea (lpos: ListaLineas; forma: TOrdenForma): ListaLineas;

	VAR
		lres,laux: ListaLineas;
		lin : Linea;
		i : CARDINAL;
		cid: ChanId;
		
	BEGIN
		cid := StdOutChan();
		laux := lpos;
		lin  := ObtenerPrimerLineaListaLineas(lpos);
		lres := CrearListaLineas();
		lpos := ObtenerRestoListaLineas(lpos);
		WHILE NOT EsVaciaListaLineas(lpos) DO
			IF forma = ASC THEN
				IF ObtenerHoraSalidaLinea(lin) > ObtenerHoraSalidaLinea(ObtenerPrimerLineaListaLineas(lpos)) THEN
					lin := ObtenerPrimerLineaListaLineas(lpos);
				END;
				lpos := ObtenerRestoListaLineas(lpos);
			ELSE
				IF ObtenerHoraSalidaLinea(lin) < ObtenerHoraSalidaLinea(ObtenerPrimerLineaListaLineas(lpos)) THEN
					lin := ObtenerPrimerLineaListaLineas(lpos);
				END;
				lpos := ObtenerRestoListaLineas(lpos);
			END;
		END;
		lpos := laux;
		i := 0;
		AgregarLineaListaLineas(lin,lres);
		WHILE NOT EsVaciaListaLineas(lpos) DO
			IF (ObtenerHoraSalidaLinea(lin) = ObtenerHoraSalidaLinea(ObtenerPrimerLineaListaLineas(lpos)))  AND NOT(Compare(ObtenerIdLinea(ObtenerPrimerLineaListaLineas(lpos)), ObtenerIdLinea(lin)) = equal) THEN
		        	AgregarLineaListaLineas(ObtenerPrimerLineaListaLineas(lpos),lres);
				i := i + 1;
			END;
			lpos := ObtenerRestoListaLineas(lpos);
		END;
		IF i = 0 THEN
			ImprimirInfoLinea(cid,lin);
		END;
		RETURN(lres);
	END ImprimirHoraLinea;
	
	PROCEDURE ImprimirIDLinea (lpos: ListaLineas; forma: TOrdenForma): Linea;

	VAR
		lin : Linea;
		cid: ChanId;
		
	BEGIN
		cid := StdOutChan();
		lin  := ObtenerPrimerLineaListaLineas(lpos);
		lpos := ObtenerRestoListaLineas(lpos);
		WHILE NOT EsVaciaListaLineas(lpos) DO
			IF forma = ASC THEN
				IF Compare(ObtenerIdLinea(lin),ObtenerIdLinea(ObtenerPrimerLineaListaLineas(lpos))) = greater THEN
					lin := ObtenerPrimerLineaListaLineas(lpos);
				END;
				lpos := ObtenerRestoListaLineas(lpos);
			ELSE
				IF Compare(ObtenerIdLinea(lin),ObtenerIdLinea(ObtenerPrimerLineaListaLineas(lpos))) = less THEN
					lin := ObtenerPrimerLineaListaLineas(lpos);
				END;
				lpos := ObtenerRestoListaLineas(lpos);
			END;
		END;
		ImprimirInfoLinea(cid,lin);
		RETURN(lin);	
	END ImprimirIDLinea;					
	
	
	PROCEDURE ImprimirAvionLinea (lpos: ListaLineas; forma: TOrdenForma): ListaLineas;

	VAR
		lres,laux: ListaLineas;
		idav1,idav2 : TRangoIdAvion;
		i : CARDINAL;
		cid : ChanId;
		lin : Linea;
		
	BEGIN
		cid := StdOutChan();
		laux := lpos;
		lin := ObtenerPrimerLineaListaLineas(lpos);
		idav1  := ObtenerIdAvion(ObtenerAvionLinea(ObtenerPrimerLineaListaLineas(lpos)));
		lres := CrearListaLineas();
		lpos := ObtenerRestoListaLineas(lpos);
		WHILE NOT EsVaciaListaLineas(lpos) DO
			idav2 := ObtenerIdAvion(ObtenerAvionLinea(ObtenerPrimerLineaListaLineas(lpos)));
			IF forma = ASC THEN
				IF idav1 > idav2 THEN
					lin := ObtenerPrimerLineaListaLineas(lpos);
					idav1 := idav2;
				END;
				lpos := ObtenerRestoListaLineas(lpos);
			ELSE
				IF idav1 < idav2 THEN
					lin := ObtenerPrimerLineaListaLineas(lpos);
					idav1 := idav2;
				END;
				lpos := ObtenerRestoListaLineas(lpos);
			END;
		END;
		lpos := laux;
		i := 0;
		AgregarLineaListaLineas(lin,lres);
		WHILE NOT EsVaciaListaLineas(lpos) DO
			IF (ObtenerIdAvion(ObtenerAvionLinea(lin)) = ObtenerIdAvion(ObtenerAvionLinea(ObtenerPrimerLineaListaLineas(lpos))))  AND NOT(Compare(ObtenerIdLinea(ObtenerPrimerLineaListaLineas(lpos)), ObtenerIdLinea(lin)) = equal) THEN
		        	AgregarLineaListaLineas(ObtenerPrimerLineaListaLineas(lpos),lres);
				i := i + 1;
			END;
			lpos := ObtenerRestoListaLineas(lpos);
		END;
		IF i = 0 THEN
			ImprimirInfoLinea(cid,lin);
		END;
		RETURN(lres);
	END ImprimirAvionLinea;
	
	PROCEDURE ImprimirOrigenLinea (lpos: ListaLineas; forma: TOrdenForma): ListaLineas;

	VAR
		lres,laux: ListaLineas;
		orig1,orig2 : TIdAeropuerto;
		i : CARDINAL;
		cid : ChanId;
		lin : Linea;
		
	BEGIN
		cid := StdOutChan();
		laux := lpos;
		lin := ObtenerPrimerLineaListaLineas(lpos);
		orig1  := ObtenerOrigenLinea(ObtenerPrimerLineaListaLineas(lpos));
		lres := CrearListaLineas();
		lpos := ObtenerRestoListaLineas(lpos);
		WHILE NOT EsVaciaListaLineas(lpos) DO
			orig2 := ObtenerOrigenLinea(ObtenerPrimerLineaListaLineas(lpos));
			IF forma = ASC THEN
				IF Compare(orig1,orig2) = greater THEN
					lin := ObtenerPrimerLineaListaLineas(lpos);
					orig1 := orig2;
				END;
				lpos := ObtenerRestoListaLineas(lpos);
			ELSE
				IF Compare(orig1,orig2) = less THEN
					lin := ObtenerPrimerLineaListaLineas(lpos);
					orig1 := orig2;
				END;
				lpos := ObtenerRestoListaLineas(lpos);
			END;
		END;
		lpos := laux;
		i := 0;
		AgregarLineaListaLineas(lin,lres);
		WHILE NOT EsVaciaListaLineas(lpos) DO
			IF (Compare(ObtenerOrigenLinea(lin),ObtenerOrigenLinea(ObtenerPrimerLineaListaLineas(lpos))) = equal)  AND NOT(Compare(ObtenerIdLinea(ObtenerPrimerLineaListaLineas(lpos)), ObtenerIdLinea(lin)) = equal) THEN
		        	AgregarLineaListaLineas(ObtenerPrimerLineaListaLineas(lpos),lres);
				i := i + 1;
			END;
			lpos := ObtenerRestoListaLineas(lpos);
		END;
		IF i = 0 THEN
			ImprimirInfoLinea(cid,lin);
		END;
		RETURN(lres);
	END ImprimirOrigenLinea;
	
	
	PROCEDURE ImprimirDestinoLinea (lpos: ListaLineas; forma: TOrdenForma): ListaLineas;

	VAR
		lres,laux: ListaLineas;
		dest1,dest2 : TIdAeropuerto;
		i : CARDINAL;
		cid : ChanId;
		lin : Linea;
		
	BEGIN
		cid := StdOutChan();
		laux := lpos;
		lin := ObtenerPrimerLineaListaLineas(lpos);
		dest1  := ObtenerDestinoLinea(ObtenerPrimerLineaListaLineas(lpos));
		lres := CrearListaLineas();
		lpos := ObtenerRestoListaLineas(lpos);
		WHILE NOT EsVaciaListaLineas(lpos) DO
			dest2 := ObtenerDestinoLinea(ObtenerPrimerLineaListaLineas(lpos));
			IF forma = ASC THEN
				IF Compare(dest1,dest2) = greater THEN
					lin := ObtenerPrimerLineaListaLineas(lpos);
					dest1 := dest2;
				END;
				lpos := ObtenerRestoListaLineas(lpos);
			ELSE
				IF Compare(dest1,dest2) = less THEN
					lin := ObtenerPrimerLineaListaLineas(lpos);
					dest1 := dest2;
				END;
				lpos := ObtenerRestoListaLineas(lpos);
			END;
		END;
		lpos := laux;
		i := 0;
		AgregarLineaListaLineas(lin,lres);
		WHILE NOT EsVaciaListaLineas(lpos) DO
			IF (Compare(ObtenerDestinoLinea(lin),ObtenerDestinoLinea(ObtenerPrimerLineaListaLineas(lpos))) = equal)  AND NOT(Compare(ObtenerIdLinea(ObtenerPrimerLineaListaLineas(lpos)), ObtenerIdLinea(lin)) = equal) THEN
		        	AgregarLineaListaLineas(ObtenerPrimerLineaListaLineas(lpos),lres);
				i := i + 1;
			END;
			lpos := ObtenerRestoListaLineas(lpos);
		END;
		IF i = 0 THEN
			ImprimirInfoLinea(cid,lin);
		END;
		RETURN(lres);
	END ImprimirDestinoLinea;
	
	
	PROCEDURE ImprimirDuracionLinea (lpos: ListaLineas; forma: TOrdenForma): ListaLineas;

	VAR
		lres,laux: ListaLineas;
		dur1,dur2 : TDuracion;
		i : CARDINAL;
		cid : ChanId;
		lin : Linea;
		
	BEGIN
		cid := StdOutChan();
		laux := lpos;
		lin := ObtenerPrimerLineaListaLineas(lpos);
		dur1  := ObtenerDuracionLinea(ObtenerPrimerLineaListaLineas(lpos));
		lres := CrearListaLineas();
		lpos := ObtenerRestoListaLineas(lpos);
		WHILE NOT EsVaciaListaLineas(lpos) DO
			dur2 := ObtenerDuracionLinea(ObtenerPrimerLineaListaLineas(lpos));
			IF forma = ASC THEN
				IF dur1 > dur2 THEN
					lin := ObtenerPrimerLineaListaLineas(lpos);
					dur1 := dur2;
				END;
				lpos := ObtenerRestoListaLineas(lpos);
			ELSE
				IF dur1 < dur2 THEN
					lin := ObtenerPrimerLineaListaLineas(lpos);
					dur1 := dur2;
				END;
				lpos := ObtenerRestoListaLineas(lpos);
			END;
		END;
		lpos := laux;
		i := 0;
		AgregarLineaListaLineas(lin,lres);
		WHILE NOT EsVaciaListaLineas(lpos) DO
			IF (ObtenerDuracionLinea(lin) = ObtenerDuracionLinea(ObtenerPrimerLineaListaLineas(lpos)))  AND NOT(Compare(ObtenerIdLinea(ObtenerPrimerLineaListaLineas(lpos)), ObtenerIdLinea(lin)) = equal) THEN
		        	AgregarLineaListaLineas(ObtenerPrimerLineaListaLineas(lpos),lres);
				i := i + 1;
			END;
			lpos := ObtenerRestoListaLineas(lpos);
		END;
		IF i = 0 THEN
			ImprimirInfoLinea(cid,lin);
		END;
		RETURN(lres);
	END ImprimirDuracionLinea;
	
	
	
VAR
	LLineasaux,Laux,lpos,lres : ListaLineas;
	LOrdaux : ListaOrdenLinea;
	cid : ChanId;
	lin : Linea;
	atributo : TOrdenarPor;
	forma : TOrdenForma;
	imprimio : BOOLEAN;
	
BEGIN
cid := StdOutChan();
WriteString(cid,'Lineas:');
WriteLn(cid);
IF NOT EsVaciaListaLineas(man^.ListaL) THEN

(*armo una copia limpia de la lista lineas*)
	LLineasaux := CrearListaLineas();
	Laux := man^.ListaL;
	WHILE NOT EsVaciaListaLineas(Laux) DO
		lin  := ObtenerPrimerLineaListaLineas(Laux);
		AgregarLineaListaLineas(CopiaLinea(lin),LLineasaux);
		Laux := ObtenerRestoListaLineas(Laux);
	END;
	
	WHILE NOT EsVaciaListaLineas(LLineasaux) DO
		lpos := LLineasaux;
		imprimio := FALSE;
		LOrdaux := ord;
		WHILE NOT imprimio DO
		        forma := ObtenerFormaOrdenLinea(ObtenerPrimeroListaOrdenLinea(LOrdaux));
			atributo := ObtenerPorOrdenLinea(ObtenerPrimeroListaOrdenLinea(LOrdaux));
			IF atributo = ORDEN_HORA THEN
				lpos := ImprimirHoraLinea(lpos,forma);
				IF EsVaciaListaLineas(ObtenerRestoListaLineas(lpos)) THEN
					imprimio := TRUE;
					EliminarLineaListaLineas(ObtenerIdLinea(ObtenerPrimerLineaListaLineas(lpos)),LLineasaux);
				ELSE
					LOrdaux := ObtenerRestoListaOrdenLinea(LOrdaux);	
				END;
			ELSIF atributo = ORDEN_ID THEN
				(*armo una copia limpia de lpos*)
				Laux := lpos;
				lres := CrearListaLineas();
				WHILE NOT EsVaciaListaLineas(Laux) DO
					lin  := ObtenerPrimerLineaListaLineas(Laux);
					AgregarLineaListaLineas(CopiaLinea(lin),lres);
					Laux := ObtenerRestoListaLineas(Laux);
				END;
				WHILE NOT EsVaciaListaLineas(lres) DO
					lin := ImprimirIDLinea(lres,forma);
					EliminarLineaListaLineas(ObtenerIdLinea(lin),LLineasaux);
					EliminarLineaListaLineas(ObtenerIdLinea(lin),lres);
					imprimio := TRUE;
				END;
			ELSIF atributo = ORDEN_AVION THEN
				lpos := ImprimirAvionLinea(lpos,forma);
				IF EsVaciaListaLineas(ObtenerRestoListaLineas(lpos)) THEN
					imprimio := TRUE;
					EliminarLineaListaLineas(ObtenerIdLinea(ObtenerPrimerLineaListaLineas(lpos)),LLineasaux);
				ELSE
					LOrdaux := ObtenerRestoListaOrdenLinea(LOrdaux);	
				END;
			ELSIF atributo = ORDEN_ORIGEN THEN
				lpos := ImprimirOrigenLinea(lpos,forma);
				IF EsVaciaListaLineas(ObtenerRestoListaLineas(lpos)) THEN
					imprimio := TRUE;
					EliminarLineaListaLineas(ObtenerIdLinea(ObtenerPrimerLineaListaLineas(lpos)),LLineasaux);
				ELSE
					LOrdaux := ObtenerRestoListaOrdenLinea(LOrdaux);	
				END;
			ELSIF atributo = ORDEN_DESTINO THEN
				lpos := ImprimirDestinoLinea(lpos,forma);	
			        IF EsVaciaListaLineas(ObtenerRestoListaLineas(lpos)) THEN
					imprimio := TRUE;
					EliminarLineaListaLineas(ObtenerIdLinea(ObtenerPrimerLineaListaLineas(lpos)),LLineasaux);
				ELSE
					LOrdaux := ObtenerRestoListaOrdenLinea(LOrdaux);	
				END;
			ELSIF atributo = ORDEN_DURACION THEN
				lpos := ImprimirDuracionLinea(lpos,forma);
				IF EsVaciaListaLineas(ObtenerRestoListaLineas(lpos)) THEN
					imprimio := TRUE;
					EliminarLineaListaLineas(ObtenerIdLinea(ObtenerPrimerLineaListaLineas(lpos)),LLineasaux);
				ELSE
					LOrdaux := ObtenerRestoListaOrdenLinea(LOrdaux);	
				END;
			END;
			IF EsVaciaListaOrdenLinea(LOrdaux) THEN
				WHILE NOT EsVaciaListaLineas(lpos) DO
					ImprimirInfoLinea(cid,ObtenerPrimerLineaListaLineas(lpos));
					EliminarLineaListaLineas(ObtenerIdLinea(ObtenerPrimerLineaListaLineas(lpos)),LLineasaux);
					lpos := ObtenerRestoListaLineas(lpos);
				END;
			        imprimio := TRUE;
			END;
					
		END;
	END;
END;
END ListarLineas;



PROCEDURE FiltrarLineas (c: Condicion; man: Manejador);
VAR
	linActual : Linea;
	lpos      : ListaLineas;
	cid       : ChanId;
BEGIN
	cid := StdOutChan();
	lpos := man^.ListaL;
	WriteString(cid,"Lineas:");WriteLn(cid);
	WHILE NOT EsVaciaListaLineas(lpos) DO
		linActual := ObtenerPrimerLineaListaLineas(lpos);
		IF EvaluarCondicionLinea(linActual,c) THEN
			ImprimirInfoLinea(cid,linActual)
		END;
		lpos := ObtenerRestoListaLineas(lpos)
	END
END FiltrarLineas;



PROCEDURE ListarVuelosHoy(man : Manejador; VAR ir: ImpresionResultado);
VAR
	cid : ChanId;
BEGIN
	cid := StdOutChan();
	IF NOT EsNulaFecha(man^.fecha) THEN
		WriteString(cid,'Planilla de Vuelos que Salen Hoy:');WriteLn(cid);
		ListarVuelosVuelosHoy(man^.VH)
	ELSE
		ir := CrearImpresionResultado();
		AsignarCodigoImpresionResultado(ERROR_FECHA_NO_INICIALIZADA,ir);
		ImprimirImpresionResultado(ir);
		DestruirImpresionResultado(ir)
	END
END ListarVuelosHoy;



PROCEDURE InfoCliente (pais: TIdNacionalidad; pasaporte: TIdPasaporte;
                       man: Manejador; VAR ir: ImpresionResultado);
VAR
	cid : ChanId;
BEGIN
	cid := StdOutChan();
	IF PerteneceClienteListaClientes(pasaporte,pais,man^.ListaC) THEN
		ImprimirInfoCliente(cid,ObtenerClienteListaClientes(pasaporte,pais,man^.ListaC))
	ELSE
		ir := CrearImpresionResultado();
		AsignarCodigoImpresionResultado(ERROR_CLIENTE_NO_EXISTE,ir);
		AsignarParamImpresionResultado(1,pasaporte,ir);
		AsignarParamImpresionResultado(2,pais,ir);
		ImprimirImpresionResultado(ir);
		DestruirImpresionResultado(ir)
	END
END InfoCliente;



PROCEDURE InfoLinea (idLin: TIdLinea; man: Manejador; VAR ir: ImpresionResultado);
VAR
	cid : ChanId;
BEGIN
	cid := StdOutChan();
	IF PerteneceLineaListaLineas(idLin,man^.ListaL) THEN
		ImprimirInfoLinea(cid,ObtenerLineaListaLineas(idLin,man^.ListaL))
	ELSE
        	ir := CrearImpresionResultado();
		AsignarCodigoImpresionResultado(ERROR_LINEA_NO_EXISTE,ir);
		AsignarParamImpresionResultado(1,idLin,ir);
		ImprimirImpresionResultado(ir);
		DestruirImpresionResultado(ir)
	END
END InfoLinea;



PROCEDURE InfoVuelo (idLin: TIdLinea; f: Fecha;
                     man: Manejador; VAR ir: ImpresionResultado);
VAR
	str : ARRAY [0..7] OF CHAR;
	dsfecha: TDiaSemana;
	tlin: TTipoLinea;
	linea: Linea;
BEGIN
	ir := CrearImpresionResultado();
	IF NOT (EsNulaFecha(man^.fecha)) THEN
		IF (PerteneceLineaListaLineas(idLin,man^.ListaL)) THEN
			linea := ObtenerLineaListaLineas(idLin,man^.ListaL);
			tlin := ObtenerTipoLinea(linea);
			dsfecha := DiaSemanaFecha(f);
			IF (tlin = DIARIA) OR (ObtenerDiaSemanaLinea(linea) = dsfecha) THEN
				IF EsMayorFecha(f,man^.fecha) THEN
					ImprimirInfoVueloVuelosFuturos(linea,f,man^.VF);
				ELSE
					AsignarCodigoImpresionResultado(ERROR_FECHA_TARDIA,ir);
					FechaToString(f,str);
					AsignarParamImpresionResultado(1,str,ir);
				END;
			ELSE
				AsignarCodigoImpresionResultado(ERROR_LINEA_FECHA,ir);
				FechaToString(f,str);
				AsignarParamImpresionResultado(1,str,ir);
				AsignarParamImpresionResultado(2,idLin,ir);
			END;
		ELSE
			AsignarCodigoImpresionResultado(ERROR_LINEA_NO_EXISTE,ir);
			AsignarParamImpresionResultado(1,idLin,ir);
		END;
	ELSE
		AsignarCodigoImpresionResultado(ERROR_FECHA_NO_INICIALIZADA,ir);
	END;
	ImprimirImpresionResultado(ir);
	DestruirImpresionResultado(ir);
END InfoVuelo;


PROCEDURE InfoAvion (avion: TRangoIdAvion; man: Manejador;
                                    VAR ir: ImpresionResultado);
VAR
	av : Avion;
	s  : ARRAY [0..2] OF CHAR;
	cid : ChanId;
BEGIN
	cid := StdOutChan();
	IF PerteneceAvionDicAviones(avion,man^.DicA) THEN
		av := ObtenerAvionDicAviones(avion,man^.DicA);
		ImprimirInfoAvion(cid,av);
		WriteLn(cid)
	ELSE
		ir := CrearImpresionResultado();
		AsignarCodigoImpresionResultado(ERROR_AVION_NO_EXISTE,ir);
		CardToStr(avion,s);
		AsignarParamImpresionResultado(1,s,ir);
		ImprimirImpresionResultado(ir);
		DestruirImpresionResultado(ir)
	END
END InfoAvion;

				
PROCEDURE BuscarCombinaciones (orig, dest: TIdAeropuerto; fecha: Fecha;
                               clase: TClaseAsiento; man: Manejador;
                               VAR ir: ImpresionResultado);


PROCEDURE EsValidaLinea (c : Combinacion;f : Fecha;clase : TClaseAsiento;lin : Linea;man : Manejador) : BOOLEAN;
VAR
	t : Tramo;
	destLin : TIdAeropuerto;
	HayAs,NoExA,T,res : BOOLEAN;
	hlT,hsL,haux,h1 : Hora;
	diaL,diaT,diaT2 : TDiaSemana;
	i : CARDINAL;
	f2 : Fecha;

BEGIN
	IF EsVaciaCombinacion(c) THEN
		HayAs := HayDisponiblesVuelosFuturos(lin,f,clase,man^.VF);
		IF (ObtenerTipoLinea(lin) = DIARIA) THEN
			T := TRUE
		ELSE
			diaL := ObtenerDiaSemanaLinea(lin);
			diaT := DiaSemanaFecha(f);
			T := diaL = diaT
		END;
		res := HayAs AND T
	ELSE
		destLin := ObtenerDestinoLinea(lin);
		NoExA   := NOT ExisteAeropuertoCombinacion(destLin,c);
		t := ObtenerUltimoCombinacion(c);
		hlT := ObtenerHoraLlegadaTramo(t);
		hsL := CrearHora(ObtenerHoraSalidaLinea(lin));
		f2 := CopiaFecha(f);                                               (*******)
		IF EsMenorHora(hsL,hlT) THEN                                   (*¡MIERDAAAAAA!*)
			IncFecha(f2)                                               (*******)
		END;
		HayAs := HayDisponiblesVuelosFuturos(lin,f2,clase,man^.VF);
		IF (ObtenerTipoLinea(lin) = DIARIA) THEN
			IF IgualesHora(hlT,hsL) THEN
				T := TRUE
			ELSE
				haux := CopiaHora(hlT);
				T := FALSE;
				i := 1;
				WHILE (i <= 720) AND (NOT T) DO
					SumarMinutos(1,haux);
					IF IgualesHora(haux,hsL) THEN
						T := TRUE
					END;
					i := i + 1
				END
			END
		ELSE
			diaT := DiaSemanaFecha(f);
			f2   := CopiaFecha(f);
			IncFecha(f2);
			diaT2 := DiaSemanaFecha(f2);
			diaL := ObtenerDiaSemanaLinea(lin);
			IF (diaL = diaT) THEN
				IF EsMenorHora(hlT,hsL) THEN
					haux := CopiaHora(hlT);
					T := FALSE;
					i := 1;
					WHILE (i <= 720) AND (NOT T) DO
						SumarMinutos(1,haux);
						IF IgualesHora(haux,hsL) THEN
							T := TRUE
						END;
						i := i + 1
					END;
				ELSIF IgualesHora(hlT,hsL) THEN
					T := TRUE
				ELSE
					T := FALSE
				END
			ELSIF (diaL = diaT2) THEN
				h1 := CrearHora(1200);
				IF EsMayorHora(hlT,h1) AND EsMenorHora(hsL,h1) THEN
					haux := CopiaHora(hlT);
					T := FALSE;
					i := 1;
					WHILE (i <= 720) AND (NOT T) DO
						SumarMinutos(1,haux);
						IF IgualesHora(haux,hsL) THEN
							T := TRUE
						END;
						i := i + 1
					END
				ELSE
					T := FALSE
				END
			ELSE
				T := FALSE
			END
		END;
		res := HayAs AND NoExA AND T
	END;
	RETURN res
END EsValidaLinea;
			

PROCEDURE ArmarCombinaciones (c : Combinacion;l : ListaLineas;f : Fecha;clase : TClaseAsiento;
                              dest,destF : TIdAeropuerto;VAR ABB : ABBCombinaciones);
VAR
	lpos : ListaLineas;
	valida : BOOLEAN;
	linact : Linea;
	t          : Tramo;
	fechaS,fechaL : Fecha;
	HS,HL,haux : Hora;
	dur,dias,j : CARDINAL;
	NewDest : TIdAeropuerto;
BEGIN
	lpos := l;
	WHILE NOT EsVaciaListaLineas(lpos) DO
		linact := ObtenerPrimerLineaListaLineas(lpos);
		IF Equal(ObtenerOrigenLinea(linact),dest) THEN
			valida := EsValidaLinea(c,f,clase,linact,man);
			IF valida THEN
				HS  := CrearHora(ObtenerHoraSalidaLinea(linact));
				dur := ObtenerDuracionLinea(linact);
				HL  := CopiaHora(HS);
				SumarMinutos(dur,HL);
				fechaS := CopiaFecha(f);
				IF NOT EsVaciaCombinacion(c) THEN
					haux := ObtenerHoraLlegadaTramo(ObtenerUltimoCombinacion(c));
					IF EsMenorHora(HS,haux) THEN
						IncFecha(fechaS)
					END
				END;
				fechaL := CopiaFecha(fechaS);
				dias := dur DIV 1440;
				FOR j := 1 TO dias DO
					IncFecha(fechaL)
				END;
				IF EsMenorHora(HL,HS) THEN
					IncFecha(fechaL)
				END;						
				t := CrearTramo(linact,fechaS,fechaL,HS,HL);
				PonerTramoCombinacion(t,c);
				IF Equal(ObtenerDestinoLinea(linact),destF) THEN
					AgregarABBCombinaciones(CopiaCombinacion(c),clase,ABB);
					SacarTramoCombinacion(c);
				ELSE
					NewDest := ObtenerDestinoLinea(linact);
					ArmarCombinaciones(c,l,fechaL,clase,NewDest,destF,ABB);
					SacarTramoCombinacion(c)
				END
			END
		END;
		lpos := ObtenerRestoListaLineas(lpos)
	END;
END ArmarCombinaciones;
		

VAR
	ABB        : ABBCombinaciones;
	c          : Combinacion;
	ListaC     : ListaCombinacion;
	str        : ARRAY[0..7] OF CHAR;
	
BEGIN

	IF EsMayorFecha(fecha,man^.fecha) THEN
		ABB  := CrearABBCombinaciones();
		c    := CrearCombinacion();
		ArmarCombinaciones(c,man^.ListaL,fecha,clase,orig,dest,ABB);
		ListaC := EnOrdenABBCombinaciones(ABB);
		IF EsVaciaListaCombinacion(ListaC) THEN
			WriteString(StdOutChan(),'No existen combinaciones posibles.');
			WriteLn(StdOutChan())
		ELSE
			ImprimirListaCombinacion(ListaC,clase)
		END;
		DestruirABBCombinaciones(ABB)	
	ELSE
		ir := CrearImpresionResultado();
		AsignarCodigoImpresionResultado(ERROR_FECHA_TARDIA,ir);
		FechaToString(fecha,str);
		AsignarParamImpresionResultado(1,str,ir);
		ImprimirImpresionResultado(ir);
		DestruirImpresionResultado(ir)
	END
END BuscarCombinaciones;

	
			
			
PROCEDURE PersistirAerolinea (nomArch: NombreArchivo; man: Manejador;
                              VAR iR :ImpresionResultado);
VAR
	cid : ChanId;
	i,tam : CARDINAL;
	laux  : ListaLineas;
	s     : ARRAY[0..7] OF CHAR;
	lvaux : ListaVuelos;
	laux2 : ListaClientes;
	res : OpenResults;
BEGIN
	iR := CrearImpresionResultado();
     	IF NOT (EsNulaFecha(man^.fecha)) THEN
		OpenWrite(cid,nomArch,write+old,res);
		IF res = fileExists THEN
			Rewrite(cid)
		END;
		tam := ObtenerTamanioDicAviones(man^.DicA);
		WriteCard(cid,tam,1);WriteLn(cid);
		IF NOT EsVacioDicAviones(man^.DicA) THEN
			FOR i := 0 TO tam - 1 DO
				ImprimirInfoAvion(cid,ObtenerAvionDicAviones(i,man^.DicA));
				WriteLn(cid)
			END
		END;
		tam := ObtenerTamanioListaLineas(man^.ListaL);
		WriteCard(cid,tam,1);WriteLn(cid);
		laux := man^.ListaL;
		WHILE NOT EsVaciaListaLineas(laux) DO
			ImprimirInfoLinea(cid,ObtenerPrimerLineaListaLineas(laux));
			laux := ObtenerRestoListaLineas(laux)
		END;
		laux2 := man^.ListaC;
		tam  := 0;
		WHILE NOT EsVaciaListaClientes(laux2) DO
			tam := tam + 1;
			laux2 := ObtenerRestoListaClientes(laux2)
		END;
		WriteCard(cid,tam,1);WriteLn(cid);
		laux2 := man^.ListaC;
		WHILE NOT EsVaciaListaClientes(laux2) DO
			ImprimirInfoCliente(cid,ObtenerPrimerClienteListaClientes(laux2));
			WriteString(cid,"finCliente");WriteLn(cid);
			laux2 := ObtenerRestoListaClientes(laux2)
		END;
		FechaToString(man^.fecha,s);
		WriteString(cid,s);WriteLn(cid);
		lvaux := ObtenerListaVuelosHoy(man^.VH);
		tam := ObtenerCantVuelosListaVuelos(lvaux);
		tam := tam + ObtenerCantVuelosListaVuelos(ObtenerListaVuelosFuturos(man^.VF));
		WriteCard(cid,tam,1);
		IF tam > 0 THEN
			WriteLn(cid)
		END;
		WHILE NOT EsVaciaListaVuelos(lvaux) DO
			ImprimirInfoVuelo(cid,ObtenerPrimerVueloListaVuelos(lvaux));
			WriteString(cid,"finVuelo");
			lvaux := ObtenerRestoListaVuelos(lvaux);
			IF NOT EsVaciaListaVuelos(lvaux) THEN
				WriteLn(cid)
			ELSE
				IF ObtenerCantVuelosListaVuelos(ObtenerListaVuelosFuturos(man^.VF)) > 0 THEN
					WriteLn(cid)
				END
			END
		END;
		lvaux := ObtenerListaVuelosFuturos(man^.VF);
		WHILE NOT EsVaciaListaVuelos(lvaux) DO
			ImprimirInfoVuelo(cid,ObtenerPrimerVueloListaVuelos(lvaux));
			WriteString(cid,"finVuelo");
			lvaux := ObtenerRestoListaVuelos(lvaux);
			IF NOT EsVaciaListaVuelos(lvaux) THEN
				WriteLn(cid)
			END;
		END;
		Close(cid);
		AsignarCodigoImpresionResultado(PERSISTIR,iR);
		FechaToString(man^.fecha,s);
		AsignarParamImpresionResultado(1,s,iR);
		ImprimirImpresionResultado(iR)
	ELSE
	      	AsignarCodigoImpresionResultado(ERROR_FECHA_NO_INICIALIZADA,iR);
		ImprimirImpresionResultado(iR)
	END;
        DestruirImpresionResultado(iR)
END PersistirAerolinea;


PROCEDURE RecuperarAerolinea (nomArch: NombreArchivo; VAR man: Manejador;
                              VAR iR :ImpresionResultado);
VAR
	cid : ChanId;
	res : OpenResults;
	c   : CHAR;
	s1,s2 : ARRAY [0..3] OF CHAR;
	i,cantAt,cantAp,hora   : CARDINAL;
	s3   : TDscAvion;
	res2 : ConvResults;
	fin  : BOOLEAN;
	s4   : TNomCliente;
	s5   : TApellCliente;
	s6   : TIdPasaporte;
	s7   : TIdNacionalidad;
	s8   : ARRAY [0..20] OF CHAR;
	durA : ARRAY [0..20] OF CHAR;
	punt,cont : CARDINAL;
	cli  : Cliente;
	asi  : TAsiento;
	fch  : ARRAY [0..7] OF CHAR;
	f    : Fecha;
	idlin : TIdLinea;
	dur  : TDuracion;
	est  : TEstadoMovimiento;
	m    : MovimientoCliente;
	e    : TEstadoAsiento;
	readRes : ReadResults;
	vh,vf   : ListaVuelos;
	av : Avion;
	hist : Historial;
	v  : Vuelo;
	ori,dest : TIdAeropuerto;
	tlinea  : TTipoLinea;
	d : TDiaSemana;
	lin : Linea;
	
	
	
BEGIN
	DestruirManejador(man);
	man := CrearManejador();
	OpenRead(cid,nomArch,read+old,res);
	ReadChar(cid,c);SkipLine(cid);
	IF c <> '0' THEN
	    	ReadChar(cid,c);
		cont := 0;
		WHILE c = 'A' DO
			REPEAT
				ReadChar(cid,c)
			UNTIL (c = '-');
			i := 0;
			ReadChar(cid,c);
			REPEAT
          			s1[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = '-');
			Delete(s1,i,Length(s1) - i);
			i := 0;
			ReadChar(cid,c);
			REPEAT
				s2[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = '-');
			Delete(s2,i,Length(s2) - i);
			i := 0;
			ReadChar(cid,c);
			REPEAT
				s3[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = '.');
			Delete(s3,i,Length(s3) - i);
			StrToCard(s1,cantAp,res2);
			StrToCard(s2,cantAt,res2);
			av := CrearAvion(cont,cantAp,cantAt,s3);
                        InsertarAvionDicAviones(av,man^.DicA);
			cont := cont + 1;
			SkipLine(cid);
			ReadChar(cid,c);
			Delete(s1,0,Length(s1));
			Delete(s2,0,Length(s2));
			Delete(s3,0,Length(s3))	
		END;
		SkipLine(cid)
	ELSE
		ReadChar(cid,c);SkipLine(cid);
	END;
	IF c <> '0' THEN
		ReadChar(cid,c);
		WHILE c = 'L' DO
			REPEAT
				ReadChar(cid,c)
			UNTIL (c = ' ');
			i := 0;
			ReadChar(cid,c);
			REPEAT
				idlin[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = '-');
			Delete(idlin,i,Length(idlin) - i);
			i := 0;
			ReadChar(cid,c);
			REPEAT
				s1[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = '-');
			Delete(s1,i,Length(s1) - i);
			i := 0;
			ReadChar(cid,c);
			REPEAT
				ori[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = '-');
			Delete(ori,i,Length(ori) - i);
			i := 0;
			ReadChar(cid,c);
			REPEAT
				dest[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = '-');
			Delete(dest,i,Length(dest) - i);
			i := 0;
			ReadChar(cid,c);
			REPEAT
				s2[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = '-');
			Delete(s2,i,Length(s2) - i);
			i := 0;
			ReadChar(cid,c);
			REPEAT
				durA[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = '-');
			Delete(durA,i,Length(durA) - i);
			ReadChar(cid,c);
			IF c = 'D' THEN
				tlinea := DIARIA
			ELSE
				tlinea := SEMANAL
			END;
			StrToCard(durA,dur,res2);
			StrToCard(s1,i,res2);
			StrToCard(s2,hora,res2);
			av := ObtenerAvionDicAviones(i,man^.DicA);
			IF tlinea = SEMANAL THEN
				REPEAT
					ReadChar(cid,c)
				UNTIL (c = ' ');
				ReadChar(cid,c);
				IF c = 'L' THEN
					d := LUNES
				ELSIF c = 'M' THEN
					ReadChar(cid,c);
					IF c = 'A' THEN
						d := MARTES
				        ELSE
					      	d := MIERCOLES
				        END
				ELSIF c = 'J' THEN
					d := JUEVES
				ELSIF c = 'V' THEN
					d := VIERNES
				ELSIF c = 'S' THEN
					d := SABADO
				ELSE
					d := DOMINGO
				END;
				lin := CrearLineaSemanal(idlin,av,ori,dest,hora,dur,d)
			ELSE
				lin := CrearLineaDiaria(idlin,av,ori,dest,hora,dur)
			END;
			SkipLine(cid);
			ReadChar(cid,c);
			AgregarLineaListaLineas(lin,man^.ListaL);
			Delete(idlin,0,Length(idlin));
			Delete(s1,0,Length(s1));
			Delete(s2,0,Length(s2));
			Delete(dest,0,Length(dest));
		        Delete(ori,0,Length(ori));
			Delete(durA,0,Length(durA))
		END;
		SkipLine(cid)
	ELSE
		ReadChar(cid,c);SkipLine(cid)
	END;
	IF c <> '0' THEN
		ReadChar(cid,c);
		fin := FALSE;
		WHILE NOT fin DO
			REPEAT
				ReadChar(cid,c)
			UNTIL (c = "'");
			i := 0;
			REPEAT
				s4[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = "-");
			Delete(s4,i,Length(s4) - i);
			i := 0;
			ReadChar(cid,c);
			REPEAT
				s5[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = "-");
			Delete(s5,i,Length(s5) - i);
			i := 0;
			ReadChar(cid,c);
			REPEAT
				s6[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = "-");
			Delete(s6,i,Length(s6) - i);
			i := 0;
			ReadChar(cid,c);
			REPEAT
				s7[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = "-");
			Delete(s7,i,Length(s7) - i);
			i := 0;
			ReadChar(cid,c);
			REPEAT
				s8[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = ".");
			Delete(s8,i,Length(s8) - i);
			SkipLine(cid);
			SkipLine(cid);
			ReadChar(cid,c);
			cli := CrearCliente(s7,s6,s4,s5);
			StrToCard(s8,punt,res2);
			SumarPuntosCliente(punt,cli);
			hist := CrearHistorial();
			WHILE c <> 'f' DO
				i := 0;
				REPEAT
					s1[i] := c;
					ReadChar(cid,c);
					i := i + 1
				UNTIL (c = "-");
				Delete(s1,i,Length(s1) - i);
				ReadChar(cid,c);
				IF c = 'P' THEN
					asi.clase := PRIMERA
				ELSE
					asi.clase := TURISTA
				END;
				StrToCard(s1,i,res2);
				asi.num := i;
				REPEAT
					ReadChar(cid,c)
				UNTIL (c = "-");
				i := 0;
				ReadChar(cid,c);
				REPEAT
					fch[i] := c;
					ReadChar(cid,c);
					i := i + 1
				UNTIL (c = "-");
				f := CrearFecha(fch);
				i := 0;
				ReadChar(cid,c);
				REPEAT
					idlin[i] := c;
					ReadChar(cid,c);
					i := i + 1
				UNTIL (c = "-");
				Delete(idlin,i,Length(idlin) - i);				
				dur := ObtenerDuracionLinea(ObtenerLineaListaLineas(idlin,man^.ListaL));
				ReadChar(cid,c);
				CASE c OF
				       	'M' : est := M_MULTA     |
					'R' : est := M_RESERVA   |
					'C' : ReadChar(cid,c);
					      IF c = 'O' THEN
					              est := M_COMPRA
					      ELSE
					      	      est := M_CANCELA
					      END
			        END;
				m := CrearMovimientoCliente(idlin,f,asi,dur,est);
				AgregarMovimientoHistorial(m,hist);
				SkipLine(cid);
				ReadChar(cid,c);
				Delete(s1,0,4);
				Delete(idlin,0,Length(idlin))
			END;
			IF NOT EsVacioHistorial(hist) THEN
				AsignarHistorialCliente(hist,cli)
			END;
			AgregarClienteListaClientes(cli,man^.ListaC);
			SkipLine(cid);
			ReadChar(cid,c);
			IF c <> 'C' THEN
				fin := TRUE
			END;
			Delete(s4,0,Length(s4));
			Delete(s5,0,Length(s5));
			Delete(s6,0,Length(s6));
			Delete(s7,0,Length(s7));
			Delete(s8,0,Length(s8))
		END
	ELSE
		ReadChar(cid,c);
	END;
	FOR i := 0 TO 7 DO
		fch[i] := c;
		IF i < 7 THEN
			ReadChar(cid,c)
		ELSE
			SkipLine(cid)
		END
	END;
	man^.fecha := CrearFecha(fch);
	ReadChar(cid,c);
	IF ORD(c) <> ORD('0') THEN
		vh := CrearListaVuelos();
		vf := CrearListaVuelos();
		SkipLine(cid);
		fin := FALSE;
		WHILE NOT fin DO
			REPEAT
				ReadChar(cid,c)
			UNTIL c = ' ';
			i := 0;
			ReadChar(cid,c);
			REPEAT
				idlin[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = "-");
			Delete(idlin,i,Length(idlin) - i);
			i := 0;
			ReadChar(cid,c);
			REPEAT
				fch[i] := c;
				ReadChar(cid,c);
				i := i + 1
			UNTIL (c = ".");
			f := CrearFecha(fch);
			v := CrearVuelo(ObtenerLineaListaLineas(idlin,man^.ListaL),f);
			Delete(idlin,0,Length(idlin));
			SkipLine(cid);
			SkipLine(cid);
			ReadChar(cid,c);
			cont := 1;
			WHILE c <> 'T' DO
				IF c <> 'L' THEN
					IF c = 'R' THEN
						e := V_RESERVA
					ELSE
						e := V_COMPRA
					END;
					asi.num := cont;
					asi.clase := PRIMERA;
					i := 0;
					ReadChar(cid,c);
					ReadChar(cid,c);
					REPEAT
						s6[i] := c;
						ReadChar(cid,c);
						i := i + 1
					UNTIL (c = "-");
					Delete(s6,i,Length(s6) - i);
					i := 0;
					ReadChar(cid,c);
					REPEAT
						s7[i] := c;
						ReadChar(cid,c);
						i := i + 1
					UNTIL (c = "-");
					Delete(s7,i,Length(s7) - i);
					cli := ObtenerClienteListaClientes(s6,s7,man^.ListaC);
					MarcarAsientoVuelo(asi,e,cli,v);
					Delete(s6,0,Length(s6));
					Delete(s7,0,Length(s7));
					ReadChar(cid,c);
					cont := cont + 1;
					readRes := ReadResult(cid);
					IF readRes = endOfLine THEN
						SkipLine(cid);
						ReadChar(cid,c)
					END
				ELSE
					ReadChar(cid,c);
					cont := cont + 1;
					readRes := ReadResult(cid);
					IF readRes = endOfLine THEN
						SkipLine(cid);
						ReadChar(cid,c)
					END
				END
			END;
			SkipLine(cid);
			ReadChar(cid,c);
			cont := 1;
			WHILE c <> 'f' DO
				IF c <> 'L' THEN
					IF c = 'R' THEN
						e := V_RESERVA
					ELSE
						e := V_COMPRA
					END;
					asi.num := cont;
					asi.clase := TURISTA;
					i := 0;
					ReadChar(cid,c);
					ReadChar(cid,c);
					REPEAT
						s6[i] := c;
						ReadChar(cid,c);
						i := i + 1
					UNTIL (c = "-");
					Delete(s6,i,Length(s6) - i);
					i := 0;
					ReadChar(cid,c);
					REPEAT
						s7[i] := c;
						ReadChar(cid,c);
						i := i + 1
					UNTIL (c = "-");
					Delete(s7,i,Length(s7) - i);
					cli := ObtenerClienteListaClientes(s6,s7,man^.ListaC);
					MarcarAsientoVuelo(asi,e,cli,v);
					Delete(s6,0,Length(s6));
					Delete(s7,0,Length(s7));
					ReadChar(cid,c);
					cont := cont + 1;
					readRes := ReadResult(cid);
					IF readRes = endOfLine THEN
						SkipLine(cid);
						ReadChar(cid,c)
					END
				ELSE
					ReadChar(cid,c);
					cont := cont + 1;
					readRes := ReadResult(cid);
					IF readRes = endOfLine THEN
						SkipLine(cid);
						ReadChar(cid,c)
					END
					
				END
			END;
			IF IgualesFecha(f,man^.fecha) THEN
				InsertarVueloListaVuelos(v,vh)
			ELSE
				InsertarVueloListaVuelos(v,vf)
			END;
			SkipLine(cid);
			readRes := ReadResult(cid);
			IF readRes = endOfInput THEN
				fin := TRUE
			END
		END;
		SuplantarVuelosHoy(vh,man^.VH);
		SuplantarVuelosFuturos(vf,man^.VF)
	END;
	Close(cid);
	iR := CrearImpresionResultado();
	AsignarCodigoImpresionResultado(RECUPERAR,iR);
	FechaToString(man^.fecha,fch);
	AsignarParamImpresionResultado(1,fch,iR);
	ImprimirImpresionResultado(iR);
	DestruirImpresionResultado(iR);
END RecuperarAerolinea; 	
	


PROCEDURE DestruirManejador (VAR man: Manejador);
BEGIN
	IF man <> NIL THEN
		WITH man^ DO
			DestruirListaClientes(ListaC);
			DestruirDicAviones(DicA);
			DestruirListaLineas(ListaL);
			DestruirFecha(fecha);
			DestruirVuelosHoy(VH);
			DestruirVuelosFuturos(VF)
		END;
		DISPOSE(man);
		man := NIL
	END
END DestruirManejador;
		


END Manejador.	