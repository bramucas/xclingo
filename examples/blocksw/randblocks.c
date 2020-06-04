#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

void printarray(char*s,int size,int *a) {
  int j;
  printf("%s [",s);
  for (j=0;j<size;j++) printf("%d ",a[j]);
  printf("]\n");
}

int *permutation(int n) {
  int *blocks, *pos;
  int i,j,k;

  blocks=malloc(n*sizeof(int));
  for (i=0;i<n;i++) blocks[i]=i+1;
  pos=malloc(n*sizeof(int));
  for (i=0;i<n;i++) {
    j=rand()%(n-i);
    pos[i]=blocks[j];
    // shift blocks
    for (k=j+1;k<n-i;k++)
      blocks[k-1]=blocks[k];
  }
  free(blocks);
  return pos;
}

void randstate(int n,int towers) {
  int *pos,t,i;

  pos=permutation(n);
  if (towers) t=rand()%n;
  for (i=0;i<n;i++,t--) {
    printf("%d ",pos[i]);
    if (towers && t==0 && i<n-1) {
      printf("\n");
      t=rand()%(n-i);
      towers--;
    }
  }
  printf("\n");
  free(pos);
}

int main(int argc, char *argv[]) {
  int n,towers,i;
  if (argc<3) {printf("randblocks <num_blocks> <towers> [-g]\n"); exit(0);}
  srand(time(NULL));
  n=atoi(argv[1]);
  towers=atoi(argv[2])-1;
  printf("%d\n",n);
  randstate(n,towers);
  printf("\n");
  if (argc>3 && strcmp(argv[3],"-g")==0) {
    for (i=0;i<n;i++) printf("%d ",i+1);
    printf("\n");
  }
  else
    randstate(n,towers);
}
