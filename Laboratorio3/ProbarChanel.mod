MODULE ProbarChanel;

FROM TextIO IMPORT WriteString,WriteLn;
FROM IOChan IMPORT ChanId;
FROM ChanConsts IMPORT read,write,old,text,raw;
FROM StreamFile IMPORT Open,Close;
FROM RndFile    IMPORT OpenResults;
FROM StdChans   IMPORT OutChan,InChan;


VAR
	cid : ChanId;
	i   : CARDINAL;
	res : OpenResults;
	ch : ARRAY[0..5] OF CHAR;
BEGIN
		cid := OutChan();
	Open(cid,'CACA',write,res);
	WriteString(cid,'cacacacacaca');WriteString(cid,"  ");WriteString(cid,"pepeepepe");
	WriteLn(cid);WriteLn(cid);	
	Close(cid);
	cid := OutChan();
	Open(cid,'CACA',write,res);
	WriteString(cid,"....................222222222222222.................");
	WriteLn(cid);
	WriteString(cid,"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
END ProbarChanel.
	
	
	