#line 2 "GET_LCK_.c"
// ********************************************************
// ** GET_LCK_
// ** 1 ALOCKEDBY  in BINARY_INTEGER,
// ** 2 ALOCKID    in out BINARY_INTEGER,
// ** 3 ATHELOCK   in out VARCHAR2,
// ** 4 ADATE      in out DATE,
// ** 5 ARPAGES    in out VARCHAR2,
// ** 6 AWPAGES    in out VARCHAR2,
// ** 7 ATRLOCKID  in out VARCHAR2,
// ** 8 AFUNCNAME  in out VARCHAR2,
// ** 9 AARGCOUNT  in out BINARY_INTEGER,
// ** 10 AARG1      in out VARCHAR2,
// ** 11 AARG2      in out VARCHAR2,
// ** 12 AARG3      in out VARCHAR2,
// ** 13 AFIRSTREC  in BINARY_INTEGER,
// ** 14 ACURREC    in out BINARY_INTEGER
// ** 15 )return BINARY_INTEGER is
// ********************************************************
////_EXECE(pevm_MOVI(ctx, argv[1], argv[15]), _unhndl_excp);
_EXEC(pevm_MOVI (PEN_Perc, argv[1], argv[15]));

{
    pemtshd* alockedby = argv[1];
    pemtshd* alockID = argv[2];
    pemtshd* athelock = argv[3];
    pemtshd* adate = argv[4];
    pemtshd* arpages = argv[5];
    pemtshd* awpages = argv[6];
    pemtshd* aTRLockID = argv[7];
    pemtshd* afuncname = argv[8];
    pemtshd* aargcount = argv[9];
    pemtshd* aargc1 = argv[10];
    pemtshd* aargc2 = argv[11];
    pemtshd* aargc3 = argv[12];
    pemtshd* aFirstRec = argv[13];
    pemtshd* aCurRec = argv[14];
    pemtshd* aReturnValue = argv[15];

    char stmp[120],stmp2[120];
    char tmpstr[80];
    char tmpstr1[80];
    char tmpstr2[80];
    char tmpstr3[80];
    unsigned long l_argcount;

    long lby,rec,currec,firstrec,l,i;
    int flg=0;

    time_t ftime;
    struct tm *ptm;

    char *dt= ((char*)adate->peval->plsbfp);
    lby= *((ub4*)alockedby->peval->plsbfp);
    currec= *((ub4*)aCurRec->peval->plsbfp);
    firstrec= *((ub4*)aFirstRec->peval->plsbfp);

    flock ( dataFile, LOCK_SH);
// for test
sighandler_t prev;
prev=signal( SIGALRM, (sighandler_t)sigHandler );
sfunc=5;
alarm (20);
// ***
    
    if (!currec){
       rec=BYIDX(lby);
       while ((firstrec--)&&(rec))  rec=tFRecord(rec)->H2NextRecord;
    } else rec=tFRecord(currec)->H2NextRecord;

    if ( rec ){
    strncpy(athelock->peval->plsbfp,tFRecord(rec)->thelock, strlen(tFRecord(rec)->thelock));
    athelock->peval->plscvl = strlen(tFRecord(rec)->thelock);

    strncpy(aTRLockID->peval->plsbfp,tFRecord(rec)->trlockID, strlen(tFRecord(rec)->trlockID));
    aTRLockID->peval->plscvl = strlen(tFRecord(rec)->trlockID);

    if ( tFRecord(rec)->rpage == 0xFFFFFFFF ) strcpy(stmp2,"(All)");
      else{
        strcpy(stmp2,"");
        flg=0;
        for (i=1;i<33;i++){
           if ( tFRecord(rec)->rpage & (1<<(i-1)) ){
            sprintf (stmp,"%d",i);
            if (flg++) strcat(stmp2,",");
            strcat(stmp2,stmp);
           }
        }
      }

    strncpy(arpages->peval->plsbfp,stmp2, strlen(stmp2));
    arpages->peval->plscvl = strlen(stmp2);

    if ( tFRecord(rec)->wpage == 0xFFFFFFFF ) strcpy(stmp2,"(All)");
      else {
        strcpy(stmp2,"");
        flg=0;
        for (i=1;i<33;i++){
           if ( tFRecord(rec)->wpage & (1<<(i-1)) ){
            sprintf (stmp,"%d",i);
            if (flg++) strcat(stmp2,",");
            strcat(stmp2,stmp);
           }
        }
      }

    strncpy(awpages->peval->plsbfp,stmp2, strlen(stmp2));
    awpages->peval->plscvl = strlen(stmp2);

    *((ub4*)aCurRec->peval->plsbfp) = rec;
    *((ub4*)alockID->peval->plsbfp) = rec;

    ftime=tFRecord(rec)->theTime;
    ptm = localtime ( &ftime );
    dt[0]=ptm->tm_year-148;
    dt[1]=((ptm->tm_year+1900) > 2047) ? 8 : 7;
    dt[2]=(char)ptm->tm_mon+1;
    dt[3]=(char)ptm->tm_mday;
    dt[4]=(char)ptm->tm_hour;
    dt[5]=(char)ptm->tm_min;
    dt[6]=(char)ptm->tm_sec;

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

     *((ub4*)aReturnValue->peval->plsbfp) = 1;
    } else *((ub4*)aReturnValue->peval->plsbfp) = 0;

// for test
alarm (0);
signal( SIGALRM, prev );
// ***
    flock ( dataFile, LOCK_UN);
}
