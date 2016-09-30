#line 2 "DEL.c"
// ********************************************************
// ** DEL
// ** 1 AREC in BINARY_INTEGER
// ********************************************************
{
    long delrec;
    long rdel,l;
    pemtshd* drecord = argv[1];
    long tmp;
    delrec= *((ub4*)drecord->peval->plsbfp);
    flock ( dataFile, LOCK_EX);
// for test
sighandler_t prev;
prev=signal( SIGALRM, (sighandler_t)sigHandler );
sfunc=6;
alarm (20);
// ***
    
// add 24.04.2006 clear lockedby if no more locks
  long dby = tFRecord(delrec)->lockedby;
    delete_rec(delrec);
// add 24.04.2006 clear lockedby if no more locks
  long drec=BYIDX(dby);
  if (!drec){
    l=findby(dby);
    if(l) {
    while (l <= listofbys->Count) {listofbys->bys[l-1]=listofbys->bys[l++];}
    listofbys->Count--;
    }

  }
// for test
alarm (0);
signal( SIGALRM, prev );
// ***
    flock ( dataFile, LOCK_UN);
}
