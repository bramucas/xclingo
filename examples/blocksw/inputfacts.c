#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#define MAXLINE 4096


char printtower(char *pred, char *line) {
  char *p,*last="table";
  for (p=strtok(line," \n"); p!=NULL ; last=p,p=strtok(NULL," \n")) {
    printf("%s(on(%s),%s",pred,p,last);
    if (strcmp(pred,"h")==0) printf(",0");
    printf(").\n");
  }
  printf("\n");
  return last!="table";
}
int main (int argc,char *argv[]) {
  char *fileName;
  char line[MAXLINE];
  int i,j,n;
  char *pred="h";
  FILE *f;
  
  if (argc!=2) { printf("inputfacts <filename>\n"); exit(1); }
  fileName=argv[1];
  if ((f=fopen(fileName,"r"))==NULL)
  { printf("Error opening file %s\n",fileName); exit(1); }
  fscanf(f,"%d\n",&n);
  printf("nblocks(%d).\n",n);
  while (fgets(line,MAXLINE,f)!=NULL)
    if (!printtower(pred,line))
      pred="g";
  fclose(f);
  return 0;
}
