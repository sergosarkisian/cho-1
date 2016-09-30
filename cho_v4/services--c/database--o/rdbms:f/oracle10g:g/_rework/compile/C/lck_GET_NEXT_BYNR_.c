#line 2 "NEXT_BYNR_.c"
// ********************************************************
// ** NEXT_BYNR_
// ** 1 ABYNR in BINARY_INTEGER)
// ** 2 )return BINARY_INTEGER is
// ********************************************************
////_EXECE(pevm_MOVI(ctx, argv[1], argv[2]), _unhndl_excp);
_EXEC(pevm_MOVI (PEN_Perc, argv[1], argv[2]));

{
    long fby;
    long ret;

    pemtshd* infby = argv[1];
    pemtshd* returnValue = argv[2];
    flock ( dataFile, LOCK_SH);
// for test
sighandler_t prev;
prev=signal( SIGALRM, (sighandler_t)sigHandler );
sfunc=4;
alarm (20);
// ***
    
    fby= *((ub4*)infby->peval->plsbfp);
    if ( fby <= listofbys->Count )
      ret=listofbys->bys[fby-1];
    else ret=0;

// for test
alarm (0);
signal( SIGALRM, prev );
// ***
    flock ( dataFile, LOCK_UN);

    *((ub4*)returnValue->peval->plsbfp) = ret;
}
