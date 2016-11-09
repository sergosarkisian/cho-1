#line 2 "ADD.c"
// ********************************************************
// ** ADD
// ** 1 ATHELOCK   in VARCHAR2,
// ** 2 APAGE      in BINARY_INTEGER,
// ** 3 ALOCKMODE  in VARCHAR2,
// ** 4 ALOCKEDBY  in BINARY_INTEGER,
// ** 5 ATRLOCKID  in VARCHAR2,
// ** 6 AFUNCNAME  in VARCHAR2,
// ** 7 AARGCOUNT  in BINARY_INTEGER,
// ** 8 AARG1      in VARCHAR2,
// ** 9 AARG2      in VARCHAR2,
// ** 10 AARG3      in VARCHAR2,
// ** 11 AERRSTR    in out VARCHAR2
// ** 12 )return BINARY_INTEGER is
// ********************************************************

//_EXECE(pevm_MOVI(ctx, argv[4], argv[12]), _unhndl_excp);

 _EXEC(pevm_MOVI (PEN_Perc, argv[4], argv[12]));
//// _EXEC(pevm_MOVC (PEN_Perc, (hs + 624), argv[11])); 
{
    char add_thelock[36];
    char add_lockdesc[105];
    char add_trlockID[12];
    char tmpstr[80];
    char tmpstr1[80];
    char tmpstr2[80];
    char tmpstr3[80];


    long ret=0;

    pemtshd* thelock = argv[1];
    pemtshd* page = argv[2];
    pemtshd* lockmode = argv[3];
    pemtshd* lockedby = argv[4];
    pemtshd* trlockID = argv[5];
    pemtshd* funcname = argv[6];
    pemtshd* argcount = argv[7];
    pemtshd* aarg1 = argv[8];
    pemtshd* aarg2 = argv[9];
    pemtshd* aarg3 = argv[10];
    pemtshd* errstr = argv[11];
    pemtshd* returnValue = argv[12];

    unsigned long l_lockedby;
    unsigned long l_page;
    unsigned long l_argcount;

    time_t theTime;
    reterror[0]='\0';
    time(&theTime);

    l_lockedby= *((ub4*)lockedby->peval->plsbfp);
    l_page= *((ub4*)page->peval->plsbfp);
    l_argcount= *((ub4*)argcount->peval->plsbfp);
    
    if ( thelock->peval->plscvl > 35){
            sprintf(reterror,"The length of the lock more than 35");
            ret=-1;}

    strncpy(add_thelock,thelock->peval->plsbfp,thelock->peval->plscvl);
            add_thelock[thelock->peval->plscvl]='\0';
    strcpy(add_lockdesc,"!!!");

    strncpy(add_trlockID,trlockID->peval->plsbfp,trlockID->peval->plscvl);
            add_trlockID[trlockID->peval->plscvl]='\0';

    strncpy(tmpstr,funcname->peval->plsbfp,funcname->peval->plscvl);
    tmpstr[funcname->peval->plscvl]='\0';

    strncpy(tmpstr1,aarg1->peval->plsbfp,aarg1->peval->plscvl);
    tmpstr1[aarg1->peval->plscvl]='\0';

    strncpy(tmpstr2,aarg2->peval->plsbfp,aarg2->peval->plscvl);
    tmpstr2[aarg2->peval->plscvl]='\0';

    strncpy(tmpstr3,aarg3->peval->plsbfp,aarg3->peval->plscvl);
    tmpstr3[aarg3->peval->plscvl]='\0';

    sprintf (add_lockdesc,"%d %s %s %s %s", l_argcount, tmpstr, tmpstr1, tmpstr2, tmpstr3);

    flock ( dataFile, LOCK_EX);
// for test
sighandler_t prev;
prev=signal( SIGALRM, (sighandler_t)sigHandler );
sfunc=8;
alarm (20);
// ***
//    _EXECNC(pevm_TSTN(ctx, argv[4]), 4, _lbl66); 

    if (listofbys->Count > 99999 ) {
        sprintf(reterror,"Max LBY reached");
        ret=-1;
    } else {
        // zero lockedby Andry 30.05.2006
        if (! l_lockedby ){
            sprintf(reterror,"Can't lock by Zero lockedby");
            ret=-1;
        }
        else {
//            flock ( dataFile, LOCK_EX);
            if (ret!=-1)
            ret=addField(add_thelock,add_lockdesc, theTime, add_trlockID, l_lockedby,\
                (lockmode->peval->plsbfp[0]=='R')?0:1, l_page );
//            flock ( dataFile, LOCK_UN);
        }
    }
//goto _lbend;
//_lbl66:
//    sprintf(reterror,"ZERRRRO[%ld]",l_lockedby);
//    ret=-1;
//_lbend:
// for test
alarm (0);
signal( SIGALRM, prev );
// ***
    
    flock ( dataFile, LOCK_UN);
    
    strncpy(errstr->peval->plsbfp,reterror,strlen(reterror));
    errstr->peval->plscvl=strlen(reterror);
    errstr->peval->plsbfp[strlen(reterror)]='\0';

    *((ub4*)returnValue->peval->plsbfp) = ret;
}


