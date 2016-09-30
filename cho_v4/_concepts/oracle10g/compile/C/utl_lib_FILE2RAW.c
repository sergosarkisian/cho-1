#line 2 "FILE2RAW.c"
// ********************************************************
// ** FILE2RAW
// ** 1 ADATA     in RAW
// ** 2 AFILENAME in varchar2
// ** 3 AOFFSET   in BINARY_INTEGER
// ** 4  ) return BINARY_INTEGER is
// ********************************************************
_EXEC(pevm_MOVI (PEN_Perc, argv[1], argv[4]));
{
    pemtshd* data   = argv[1];
    pemtshd* file   = argv[2];
    pemtshd* offset  = argv[3];
    pemtshd* retval = argv[4];

    unsigned long ret,pos, filesize;
    char fname[512];
    size_t result;

    char buf[32000];

    result = ret = 0;
    FILE *fi;

    strncpy(fname, file->peval->plsbfp, file->peval->plscvl);
    fname[file->peval->plscvl]='\0';
    pos = *((ub4*)offset->peval->plsbfp);

    if (fi = fopen(fname, "rb")){
	fseek (fi , 0 , SEEK_END);
	filesize = ftell (fi);
        if (filesize > pos) {
    	    fseek ( fi , pos , SEEK_SET );
	    result = fread(buf, 1, sizeof(buf), fi);
        } 
        fclose(fi);
        strncpy(data->peval->plsbfp, buf, result);
        ret = result;
    } else ret = -1;

//      sprintf(buf,"[%ld, %ld, %ld, %ld]", ret, filesize, pos, result);
//      strncpy(data->peval->plsbfp, buf, strlen(buf) );
//      data->peval->plscvl = strlen(buf);

    *((ub4*)retval->peval->plsbfp) = ret;
}
