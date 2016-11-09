#line 2 "top.c"
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdarg.h>
#include <time.h>
#include <string.h>
#include <errno.h>
#include <ctype.h>
#include <stdio.h>
#include <limits.h>
#include <fcntl.h>
#include <stdint.h>
#include <sys/mman.h>
#include <errno.h>
#include <signal.h>

typedef unsigned long hashTableIndex;
typedef void (*sighandler_t)(int);

// DataBase File
#define Fimename "/media/storage/software/oracle/cone/sfile"
#define Errorfile "/media/storage/software/oracle/cone/err.fil"

#define MaxRecordsInTable   0xFFFFFF
#define MaxFileSize   300000000
#define IndexTablesize (sizeof(Hdr)+sizeof(Bylist)+(sizeof(Index)*MaxRecordsInTable*2))

int dataFile, offset;
char *Filedata;
struct stat sbuf;
char reterror[280];
FILE *Fil=NULL;

typedef struct Hdr_ {
    long lastzero; // position of last zero record in extended table 0=no empy records exist
} Hdr;

typedef struct Bylist_ { // list of by's for fast list access
    long Count;
    long bys[100000]; // max by's
} Bylist;
Bylist *listofbys;

typedef struct Index_ {
    long DataRecord; // position record with data
} Index;


typedef struct FileRecord_ {
    char thelock[35];           // index1
    char lockdesc[105];         // function argcount arg1 arg2 arg3
    time_t theTime;             // DateTime
    unsigned long lockedby;     // index2
    char trlockID[11];
    unsigned long rpage;        // pages for read
    unsigned long wpage;        // pages for writw
    unsigned long H1NextRecord; // Next record on index 1 0-not exist
    unsigned long H2NextRecord; // Next record on index 2

} FileRecord;

Hdr *header;

// point to data record
#define tFRecord(rec) ((FileRecord*)(Filedata+IndexTablesize+(sizeof(FileRecord)*(rec-1))))
// return record numer from index1
#define TLIDX(ihash) ((Index*)(Filedata+sizeof(Hdr)+sizeof(Bylist)+(sizeof(Index)*ihash)))->DataRecord
// return record numer from index2
#define BYIDX(rec) ((Index*)(Filedata+(sizeof(Index)*MaxRecordsInTable)+sizeof(Hdr)+sizeof(Bylist)+(sizeof(Index)*rec)))->DataRecord


int sfunc=0;
void sigHandler(int sig) {
 // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  FILE *fi;
  if (fi = fopen(Errorfile, "a")){
        fprintf(fi, "[%ld] %s\n",time(NULL), sfunc);
        fclose(fi);
    }
    exit(1);
}


// Hash function
hashTableIndex Hash (const char* v)
{
hashTableIndex r=0;
unsigned long a=231585, b=279220504, c=16334331;
while(*v){r += a;r ^= (b * (v[1] ^ v[0]));r += c * v[1];v++;}
return ( r% MaxRecordsInTable);
}

long findby(long lockedby)
{
  long l;
  for ( l=0 ; l < listofbys->Count ; l++)
  {
    if( listofbys->bys[l] == lockedby ) return l+1;
  }
   return 0L;
}

// main function for add lock
long addField(char *thelock,char *lockdesc,time_t theTime,char *trlockID,unsigned long lockedby, int mode, unsigned long page)
{
    hashTableIndex hash1;
    long currec;
    int alreadyexist=0;
    long newrec;
    long pagemask=0;

    size_t tllen;
    int t=0;
    tllen=strlen(thelock);

    if (!page) pagemask=0xFFFFFFFF;
    else pagemask=(1<<(page-1));

    // find hash
    hash1=Hash(thelock);
    currec=TLIDX(hash1);

    // searching conflict
    while( currec >0 )
    {
      if ( tFRecord(currec)->thelock[0] != '\0')
      {
       if ( strncmp(tFRecord(currec)->thelock,thelock,tllen) == 0 )
       {
        if ( tFRecord(currec)->lockedby != lockedby)
        {
          if ( tFRecord(currec)->wpage & pagemask )
             { sprintf(reterror,"W%ld",tFRecord(currec)->lockedby); return -1;}

          if ((mode)&&( tFRecord(currec)->rpage&pagemask ))
             { sprintf(reterror,"R%ld",tFRecord(currec)->lockedby); return -1;}
        } else { alreadyexist=1; newrec=currec; }
       }
      }
      currec=tFRecord(currec)->H1NextRecord;
    }

    // find place to write
    if (!alreadyexist) {
     if ( header->lastzero >0 ) { // if exist empty holes
       newrec=header->lastzero;
       header->lastzero=tFRecord(newrec)->H2NextRecord;
       tFRecord(newrec)->H2NextRecord=0;
     }
     else { // add to end of file
       fstat(dataFile, &sbuf);
       newrec= ((sbuf.st_size - IndexTablesize)/sizeof(FileRecord)); newrec++;
       if ( sbuf.st_size+sizeof(FileRecord) < MaxFileSize) {
          ftruncate(dataFile, sbuf.st_size+sizeof(FileRecord));
       } else { sprintf(reterror,"Max. lock file size reached"); return -1;}

//       ftruncate(dataFile, sbuf.st_size+sizeof(FileRecord));
     }
    }

    // Fill fields
    if (!alreadyexist){
      tFRecord(newrec)->rpage=0;
      tFRecord(newrec)->wpage=0;
      strncpy(tFRecord(newrec)->thelock,thelock,strlen(thelock)+1);
      tFRecord(newrec)->lockedby=lockedby;
      if ( TLIDX(hash1) == newrec ) tFRecord(newrec)->H1NextRecord=0;
         else tFRecord(newrec)->H1NextRecord=TLIDX(hash1);
      if ( BYIDX(lockedby) == newrec ) tFRecord(newrec)->H2NextRecord=0;
         else tFRecord(newrec)->H2NextRecord=BYIDX(lockedby);
      TLIDX(hash1)=newrec;
      BYIDX(lockedby)=newrec;
      if (!findby(lockedby))
      { listofbys->Count++; listofbys->bys[listofbys->Count-1]=lockedby; }
     }

      if (!mode) tFRecord(newrec)->rpage|=pagemask;
            else tFRecord(newrec)->wpage|=pagemask;

      strncpy(tFRecord(newrec)->lockdesc,lockdesc,strlen(lockdesc)+1);
      tFRecord(newrec)->theTime = theTime;
      strncpy(tFRecord(newrec)->trlockID,trlockID,strlen(trlockID)+1);

  if ( tFRecord(newrec)->H1NextRecord == newrec ) { tFRecord(newrec)->H1NextRecord=0; }
  if ( tFRecord(newrec)->H2NextRecord == newrec ) { tFRecord(newrec)->H2NextRecord=0; }

  return (newrec);
}

// find prev record in index "hashno"
long getPrevRecord ( long rec, int hashno, hashTableIndex hash )
{
    long currec,nextrec,trec;
    FileRecord Frecord;
    if (!hashno) trec=TLIDX(hash);
      else  trec=BYIDX(hash);

    if ( trec > 0 )   {
          if (!hashno) nextrec= tFRecord(trec)->H1NextRecord;
            else nextrec= tFRecord(trec)->H2NextRecord;
    } else return 0;

    currec=trec;
    while ( (nextrec>0) && (rec!=nextrec) ) {
          currec=nextrec;
          if (!hashno) nextrec=tFRecord(currec)->H1NextRecord;
                  else nextrec=tFRecord(currec)->H2NextRecord;
    }
return currec;
}

// delete record
int delete_rec(long delrec)
{
    hashTableIndex hash1,hash2;
    long currec,deletepos;
    long maxrecs,tl1,tl2;

    fstat(dataFile, &sbuf);
    maxrecs=((sbuf.st_size - IndexTablesize)/sizeof(FileRecord));

    if ( delrec > maxrecs) return -1;
    if ( tFRecord(delrec)->thelock[0]=='\0') return -1;

    hash1=Hash(tFRecord(delrec)->thelock);
    hash2=tFRecord(delrec)->lockedby;

    if ( TLIDX(hash1) == delrec )
        TLIDX(hash1) = tFRecord(delrec)->H1NextRecord;
    else {
    tl1=getPrevRecord ( delrec, 0, hash1 );
    if (tl1 == 0) TLIDX(hash1)=0;
    else tFRecord(tl1)->H1NextRecord=tFRecord(delrec)->H1NextRecord;
    }

    if ( BYIDX(hash2) == delrec )
         BYIDX(hash2) = tFRecord(delrec)->H2NextRecord;
    else{
    tl2=getPrevRecord ( delrec, 1, hash2 );
    if (tl2 == 0) BYIDX(hash2)=tFRecord(delrec)->H2NextRecord;
    else tFRecord(tl2)->H2NextRecord=tFRecord(delrec)->H2NextRecord;
    }

    tFRecord(delrec)->H2NextRecord=header->lastzero;
    header->lastzero=delrec;
    tFRecord(delrec)->thelock[0]=0;
    tFRecord(delrec)->lockdesc[0]=0;
    tFRecord(delrec)->theTime=0;
    tFRecord(delrec)->trlockID[0]=0;
    tFRecord(delrec)->rpage=0;
    tFRecord(delrec)->wpage=0;
    tFRecord(delrec)->lockedby=0;
    tFRecord(delrec)->H1NextRecord=0;
return 0;
}

// when .so loading
void _init()
{
    dataFile = open(Fimename, O_RDWR|O_CREAT, 0666);
    stat(Fimename, &sbuf);
    if ( sbuf.st_size < IndexTablesize ) {
      ftruncate(dataFile, IndexTablesize);
    }
    Filedata = mmap((caddr_t)0, MaxFileSize, PROT_READ|PROT_WRITE, MAP_SHARED, dataFile, 0);
    header=(Hdr *)(Filedata);
    listofbys= (Bylist *)(Filedata+sizeof(Hdr));
}

// when .so unloading
void _fini()
{
    munmap (Filedata, MaxFileSize);
    close(dataFile);
}
