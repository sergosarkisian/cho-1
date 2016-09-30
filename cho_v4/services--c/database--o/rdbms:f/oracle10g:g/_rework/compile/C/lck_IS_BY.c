#line 2 "IS_BY.c"
// ********************************************************
// ** IS_BY
// ** 1 ABYNR in BINARY_INTEGER
// ** 2 )return BINARY_INTEGER
// ********************************************************
////_EXECE(pevm_MOVI(ctx, argv[1], argv[2]), _unhndl_excp);
_EXEC(pevm_MOVI (PEN_Perc, argv[1], argv[2]));

{
    long delby,l,ret;
    pemtshd* aby = argv[1];
    pemtshd* returnValue = argv[2];

    delby= *((ub4*)aby->peval->plsbfp);

    flock ( dataFile, LOCK_SH);
// for test
sighandler_t prev;
prev=signal( SIGALRM, (sighandler_t)sigHandler );
sfunc=2;
alarm (20);
// ***
    
    ret=l=0;
    if (listofbys->Count >0 ) {
    while (l <= listofbys->Count){
        if ( listofbys->bys[l++]==delby) {ret=1; break;}
    }}

// for test
alarm (0);
signal( SIGALRM, prev );
// ***
    flock ( dataFile, LOCK_UN);

    *((ub4*)returnValue->peval->plsbfp) = ret;

}

