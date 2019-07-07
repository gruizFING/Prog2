(*4317743 4585215*)
IMPLEMENTATION MODULE Manejador;

FROM Avion      IMPORT Avion,CrearAvion,TRangoIdAvion,TAsiento,TDscAvion,TRangoAsiento,TClaseAsiento,ObtenerAsientosAvion;
FROM Cliente    IMPORT Cliente,TNomCliente,TApellCliente,TIdNacionalidad,TIdPasaporte,ObtenerPuntosCliente,SumarPuntosCliente,ObtenerPasaporteCliente,ObtenerNacionalidadCliente,ImprimirInfoCliente,CrearCliente;
FROM Fecha      IMPORT Fecha,TDiaSemana,CrearFechaNula,EsNulaFecha,DiaSemanaFecha,EsMenorFecha,FechaToString,DestruirFecha,EsMayorFecha,IncFecha,CopiaFecha,IgualesFecha;
FROM Linea      IMPORT Linea,TIdLinea,TIdAeropuerto,TTipoLinea,TDuracion,TModoPago,CrearLineaDiaria,CrearLineaSemanal,ObtenerAvionLinea,ObtenerTipoLinea,ObtenerDiaSemanaLinea,ObtenerDuracionLinea,ObtenerIdLinea,
		       ImprimirInfoLinea;
FROM ImpresionResultado IMPORT ImpresionResultado,CrearImpresionResultado,AsignarCodigoImpresionResultado,CodigoResultado,AsignarParamImpresionResultado,ImprimirImpresionResultado,DestruirImpresionResultado;
FROM WholeStr IMPORT CardToStr,IntToStr;
FROM Storage  IMPORT ALLOCATE,DEALLOCATE;
FROM ListaClientes IMPORT ListaClientes,CrearListaClientes,PerteneceClienteListaClientes,ObtenerClienteListaClientes,EsVaciaListaClientes,ObtenerPrimerClienteListaClientes,ObtenerRestoListaClientes,DestruirListaClientes,
			  AgregarClienteListaClientes;
FROM VuelosFuturos IMPORT VuelosFuturos,CrearVuelosFuturos,EstaDisponibleAsientoVuelosFuturos,ComprarVuelosFuturos,HayDisponiblesVuelosFuturos,DestruirVuelosFuturos,ImprimirInfoVueloVuelosFuturos,SepararHastaFechaVuelosFuturos,
			  AnularReservasVuelosFuturos,ReservarVuelosFuturos,EstaReservadoClienteVuelosFuturos,CancelarVuelosFuturos;
FROM VuelosHoy IMPORT VuelosHoy,CrearVuelosHoy,ListarVuelosVuelosHoy,DestruirVuelosHoy,SuplantarVuelosHoy;
FROM ListaLineas IMPORT ListaLineas,CrearListaLineas,PerteneceLineaListaLineas,AgregarLineaListaLineas,ObtenerLineaListaLineas,EsVaciaListaLineas,ObtenerPrimerLineaListaLineas,ObtenerRestoListaLineas,DestruirListaLineas;
FROM DicAviones IMPORT DicAviones,CrearDicAviones,TRangoCantAviones,ObtenerTamanioDicAviones,InsertarAvionDicAviones,PerteneceAvionDicAviones,ObtenerAvionDicAviones,DestruirDicAviones;
FROM STextIO IMPORT WriteString,WriteLn;
FROM ListaVuelos IMPORT ListaVuelos;






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
BEGIN
	WriteString("Clientes:");WriteLn;
	WITH man^ DO
		lpos := ListaC;
		WHILE NOT EsVaciaListaClientes(lpos) DO
			cact   := ObtenerPrimerClienteListaClientes(lpos);
			pasac  := ObtenerPasaporteCliente(cact);
			paisac := ObtenerNacionalidadCliente(cact);
			WriteString(pasac);WriteString("-");
			WriteString(paisac);WriteLn;
			lpos := ObtenerRestoListaClientes(lpos)
		END
	END
END ListarClientes;



PROCEDURE ListarLineas (man: Manejador);
VAR	
	linact  : Linea;
	idlin	: TIdLinea;
	lpos    : ListaLineas;
BEGIN
	WriteString("Lineas:");WriteLn;
	WITH man^ DO
		lpos := ListaL;
		WHILE NOT EsVaciaListaLineas(lpos) DO
			linact := ObtenerPrimerLineaListaLineas(lpos);
			idlin  := ObtenerIdLinea(linact);
			WriteString(idlin);WriteLn;
			lpos := ObtenerRestoListaLineas(lpos)
		END
	END
END ListarLineas;



PROCEDURE ListarVuelosHoy(man : Manejador; VAR ir: ImpresionResultado);
BEGIN
	IF NOT EsNulaFecha(man^.fecha) THEN
		WriteString('Planilla de Vuelos que Salen Hoy:');WriteLn();
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
BEGIN
	IF PerteneceClienteListaClientes(pasaporte,pais,man^.ListaC) THEN
		ImprimirInfoCliente(ObtenerClienteListaClientes(pasaporte,pais,man^.ListaC))
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
BEGIN
	IF PerteneceLineaListaLineas(idLin,man^.ListaL) THEN
		ImprimirInfoLinea(ObtenerLineaListaLineas(idLin,man^.ListaL))
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



PROCEDURE DestruirManejador (VAR man: Manejador);
BEGIN
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
END DestruirManejador;
		


END Manejador.	