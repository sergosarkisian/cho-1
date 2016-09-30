#line 2 "WANT_EDIT.c"
// ********************************************************
// ** WANT_EDIT
// ** 1  ALBY       in BINARY_INTEGER,
// ** 2  APAGE      in BINARY_INTEGER,
// ** 3  ATHELOCK   in VARCHAR2,
// ** 4  )return BINARY_INTEGER is
// ********************************************************
////_EXECE(pevm_MOVI(ctx, argv[1], argv[4]), _unhndl_excp);
_EXEC(pevm_MOVI (PEN_Perc, argv[1], argv[4]));

{
    char add_thelock[36];
    char add_lockdesc[105];
    unsigned long l_lockedby,rec,currec;
    unsigned long l_page,ret;
    long pagemask=0;

    pemtshd* lockedby = argv[1];
    pemtshd* page = argv[2];
    pemtshd* thelock = argv[3];
    pemtshd* returnValue = argv[4];
    ret=0;

    l_lockedby= *((ub4*)lockedby->peval->plsbfp);
    l_page= *((ub4*)page->peval->plsbfp);

    strncpy(add_thelock,thelock->peval->plsbfp,thelock->peval->plscvl);
    add_thelock[thelock->peval->plscvl]='\0';

    if (!l_page) pagemask=0xFFFFFFFF;
    else pagemask=(1<<(l_page-1));
    flock ( dataFile, LOCK_EX);

// for test
sighandler_t prev;
prev=signal( SIGALRM, (sighandler_t)sigHandler );
sfunc=1;
alarm (20);
// ***

    currec=BYIDX(l_lockedby);
    if ( currec ){
      do{
        rec=currec;
          if ( strncmp ( tFRecord(rec)->thelock, add_thelock, strlen(add_thelock)) == 0 )
          {
             if ( tFRecord(rec)->wpage & pagemask )
                 { ret=rec; break;
                 }
          }
          if ( tFRecord(rec)->H2NextRecord ) currec=tFRecord(rec)->H2NextRecord;
      } while  (tFRecord(rec)->H2NextRecord > 0);
    } else ret = 0;

// for test
alarm (0);
signal( SIGALRM, prev );
// ***

    flock ( dataFile, LOCK_UN);
    *((ub4*)returnValue->peval->plsbfp) = ret;
}
