(* 4317743 4585215 *)
MODULE Interprete;

FROM STextIO IMPORT WriteString,WriteLn;
FROM Strings IMPORT Equal;
FROM Comando IMPORT Comando,NombreComando,Parametro,
		    LeerComando,ObtenerNombreComando,ObtenerCantParamComando,
		    ObtenerParamComando,DestruirComando;
VAR
nomComando : NombreComando;
cantParam,i : CARDINAL;
Parami : Parametro;
com : Comando;

BEGIN
 com := LeerComando();
 nomComando := ObtenerNombreComando(com);
 WHILE (NOT (Equal(nomComando,"salir"))) DO
   cantParam := ObtenerCantParamComando(com);
   WriteString("Comando leido: ");
   WriteString(nomComando);
   WriteLn;
   IF (cantParam = 0) THEN
     WriteString("Sin parametros");
     WriteLn
   ELSE
     WriteString("Con los siguientes parametros: ");
     FOR i := 1 TO cantParam DO
       Parami := ObtenerParamComando(i,com);
       WriteString(Parami);
       IF (i <> cantParam) THEN
         WriteString(",")
       END
     END;
     WriteLn
   END;
   DestruirComando(com);
   com := LeerComando();
   nomComando := ObtenerNombreComando(com)
  END;
  WriteString("Fin!");
END Interprete.