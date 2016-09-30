#line 2 "INT_GET_NFO.c"
// ********************************************************
// ** INT_GET_NFO
// ** 1 ALOCKEDBY  in BINARY_INTEGER,
// ** 2 ATHELOCK   in out VARCHAR2,
// ** 3 ADATE      in out DATE,
// ** 4 ARPAGES    in out VARCHAR2,
// ** 5 AWPAGES    in out VARCHAR2,
// ** 6 ATRLOCKID  in out VARCHAR2,
// ** 7 AFUNCNAME  in out VARCHAR2,
// ** 8 AARGCOUNT  in out BINARY_INTEGER,
// ** 9 AARG1      in out VARCHAR2,
// ** 10 AARG2      in out VARCHAR2,
// ** 11 AARG3      in out VARCHAR2,
// ** 12 ACURREC    in out BINARY_INTEGER,
// ** 13 ARMASK     in out BINARY_INTEGER,
// ** 14 AWMASK     in out BINARY_INTEGER
// ** 15 )return BINARY_INTEGER is
// ********************************************************
////_EXECE(pevm_MOVI(ctx, argv[1], argv[15]), _unhndl_excp);
_EXEC(pevm_MOVI (PEN_Perc, argv[1], argv[15]));

{
    long rec=0;
    long ret,newrec;
    char lthelock[50];
    char rstmp[120],rstmp2[120];
    char wstmp[120],wstmp2[120];
    char tmpstr[80];
    char tmpstr1[80];
    char tmpstr2[80];
    char tmpstr3[80];

    pemtshd* alockedby = argv[1];
    pemtshd* athelock = argv[2];
    pemtshd* adate = argv[3];
    pemtshd* arpages = argv[4];
    pemtshd* awpages = argv[5];
    pemtshd* aTRLockID = argv[6];
    pemtshd* afuncname = argv[7];
    pemtshd* aargcount = argv[8];
    pemtshd* aargc1 = argv[9];
    pemtshd* aargc2 = argv[10];
    pemtshd* aargc3 = argv[11];
    pemtshd* aCurRec = argv[12];
    pemtshd* aRMask = argv[13];
    pemtshd* aWMask = argv[14];
    pemtshd* aReturnValue = argv[15];

    char *dt= ((char*)adate->peval->plsbfp);
    long lby= *((ub4*)alockedby->peval->plsbfp);
    long currec= *((ub4*)aCurRec->peval->plsbfp);
    long lRMask= *((ub4*)aRMask->peval->plsbfp);
    long lWMask= *((ub4*)aWMask->peval->plsbfp);

    int rflg=0;
    int wflg=0;
    int i;
    int needadd=0;
    unsigned long l_argcount;
    time_t ftime;
    struct tm *ptm;

    strncpy(lthelock,athelock->peval->plsbfp,athelock->peval->plscvl);
    lthelock[athelock->peval->plscvl]='\0';

    ret=0;rec=0;
    strcpy(rstmp,"");strcpy(rstmp2,"");
    strcpy(wstmp,"");strcpy(wstmp2,"");

    if (((long)aRMask == 0xFFFFFFF)&&((long)aWMask == 0xFFFFFFF)) ret=0;
    else {
    flock ( dataFile, LOCK_SH);

// for test
sighandler_t prev;
prev=signal( SIGALRM, (sighandler_t)sigHandler );
sfunc=3;
alarm (20);
// ***
    
    if (!currec)newrec=TLIDX(Hash(lthelock));
           else newrec=tFRecord(currec)->H1NextRecord;
    while (newrec)
    {
      rec=newrec;
      if ( tFRecord(rec)->lockedby != lby )
      {
        needadd=0;
        for (i=1;i<33;i++)
        {
          if (strlen(rstmp2)<67) {
          if ( lRMask & (1<<(i-1)) );
          else {
           if ( tFRecord(rec)->rpage & (1<<(i-1)) )
           { sprintf (rstmp,"%d",i); needadd=1;
             if (rflg++) strcat(rstmp2,",");
               strcat(rstmp2,rstmp); }}}

          if (strlen(wstmp2)<67) {
          if ( lWMask & (1<<(i-1)) );
          else {
           if ( tFRecord(rec)->wpage & (1<<(i-1)) )
           { sprintf (wstmp,"%d",i); needadd=1;
             if (wflg++) strcat(wstmp2,",");
               strcat(wstmp2,wstmp); }}}
        }
          lRMask|=tFRecord(rec)->rpage;
          lWMask|=tFRecord(rec)->wpage;
       if ( needadd )
       {
        strncpy(aTRLockID->peval->plsbfp,tFRecord(rec)->trlockID, strlen(tFRecord(rec)->trlockID));
        aTRLockID->peval->plscvl = strlen(tFRecord(rec)->trlockID);

        memset(tmpstr,0,79);memset(tmpstr1,0,79);memset(tmpstr2,0,79);memset(tmpstr3,0,79);
        sscanf (tFRecord(rec)->lockdesc, "%d %s %s %s %s", &l_argcount, tmpstr, tmpstr1, tmpstr2, tmpstr3 );
        strncpy(afuncname->peval->plsbfp,tmpstr, strlen(tmpstr));
        afuncname->peval->plscvl = strlen(tmpstr);

        *((ub4*)aargcount->peval->plsbfp) = l_argcount;

        strncpy(aargc1->peval->plsbfp,tmpstr1, strlen(tmpstr1));
        aargc1->peval->plscvl = strlen(tmpstr1);
        aargc1->peval->plsbfp[strlen(tmpstr1)]='\0';
        aargc1->peval->plsmflg=1;

        strncpy(aargc2->peval->plsbfp,tmpstr2, strlen(tmpstr2));
        aargc2->peval->plscvl = strlen(tmpstr2);
        aargc2->peval->plsbfp[strlen(tmpstr2)]='\0';
        aargc2->peval->plsmflg=1;

        strncpy(aargc3->peval->plsbfp,tmpstr3, strlen(tmpstr3));
        aargc3->peval->plscvl = strlen(tmpstr3);
        aargc3->peval->plsbfp[strlen(tmpstr3)]='\0';
        aargc3->peval->plsmflg=1;

        ftime=tFRecord(rec)->theTime;
        ptm = localtime ( &ftime );
        dt[0]=ptm->tm_year-148;
        dt[1]=((ptm->tm_year+1900) > 2047) ? 8 : 7;
        dt[2]=(char)ptm->tm_mon+1;
        dt[3]=(char)ptm->tm_mday;
        dt[4]=(char)ptm->tm_hour;
        dt[5]=(char)ptm->tm_min;
        dt[6]=(char)ptm->tm_sec;

        *((ub4*)aRMask->peval->plsbfp)=lRMask;
        *((ub4*)aWMask->peval->plsbfp)=lWMask;

        strncpy(arpages->peval->plsbfp,rstmp2, strlen(rstmp2));
        arpages->peval->plscvl = strlen(rstmp2);

        strncpy(awpages->peval->plsbfp,wstmp2, strlen(wstmp2));
        awpages->peval->plscvl = strlen(wstmp2);

        *((ub4*)alockedby->peval->plsbfp)=tFRecord(rec)->lockedby;
        ret=rec;
        break;
       }
      }
      newrec=tFRecord(rec)->H1NextRecord;
    }

// for test
alarm (0);
signal( SIGALRM, prev );
// ***
    flock ( dataFile, LOCK_UN);
    }
    *((ub4*)aCurRec->peval->plsbfp) = rec;
    *((ub4*)aReturnValue->peval->plsbfp) = ret;
}
