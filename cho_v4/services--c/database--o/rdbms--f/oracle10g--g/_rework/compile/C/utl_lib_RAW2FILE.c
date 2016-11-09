#line 2 "RAW2FILE.c"
// ********************************************************
// ** RAW2FILE
// ** 1 ADATA     in RAW
// ** 2 AFILENAME in varchar2
// ** 3 AFLAGS    in BINARY_INTEGER
// ** 4  ) return BINARY_INTEGER is
// ********************************************************
_EXEC(pevm_MOVI (PEN_Perc, argv[1], argv[4]));
{
    pemtshd* data   = argv[1];
    pemtshd* file   = argv[2];
    pemtshd* flags  = argv[3];
    pemtshd* retval = argv[4];

    unsigned long flag, ret;
    char mode[10];
    char fname[512];
    struct stat fst;

    ret = 0;
    flag = *((ub4*)flags->peval->plsbfp);
    strcpy(mode, (flag & 1) ? "ab" : "wb");

    strncpy(fname, file->peval->plsbfp, file->peval->plscvl);
    fname[file->peval->plscvl]='\0';

    if (!(flag & 1) && (flag & 2) && (stat(fname, &fst) == 0)) {
        ret = 1;
    } else {
        FILE * pFile;
        mkrecdir(fname);
        if ((pFile = fopen(fname, mode)) != NULL) {
            fwrite (data->peval->plsbfp, 1, data->peval->plscvl, pFile);
            fclose (pFile);
        } else {
            ret = -1;
        }
    }
    *((ub4*)retval->peval->plsbfp) = ret;
}
