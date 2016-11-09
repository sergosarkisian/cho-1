#line 2 "CLEAR.c"
// ********************************************************
// ** CLEAR
// ** 1 ALOCKEDBY  in BINARY_INTEGER
// ********************************************************

///  PEN_Enter_Args.frame = &PEN_Proc_AP;
///  PEN_Enter_Args.pevmea_stack.state_buf = (ub1 *)&PEN_State_Buf;
///  _EXEC(pevm_ENTER (PEN_Perc, 0, 560, &PEN_Enter_Args));
//  PEN_Registers = PEN_Enter_Args.preg_pevmea;
//  PEN_Line_Number = PEN_Enter_Args.pevmea_lnrppc.lnr_pevmea;
//  ds = ((ub1 **)(PEN_Registers[ 6]));
//  gf = ((ub1 **)(PEN_Registers[ 8]));
//  hs = ((ub1  *)(PEN_Registers[ 7]));  
//  (*PEN_Line_Number) = 42; 


{
    long delby,rdel,l;
    pemtshd* drecord = argv[1];
    int t=0;
    delby= *((ub4*)drecord->peval->plsbfp);

    flock ( dataFile, LOCK_EX);
// for test
sighandler_t prev;
prev=signal( SIGALRM, (sighandler_t)sigHandler );
sfunc=7;
alarm (20);
// ***
    
    if ( delby == 0 ) { // clear all
      ftruncate(dataFile, 0);
      ftruncate(dataFile, IndexTablesize);
    }
    else {
    rdel=BYIDX(delby);
    while (rdel){
        if ( delete_rec(rdel) == -1 ) break;
        rdel=BYIDX(delby);}

    l=findby(delby);
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

//PEN_Label_151:
//    pen_CHK_CTRL_BRK(PEN_Perc);
//   (*PEN_Line_Number) = 48; 
