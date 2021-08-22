// created by Umesh Prasad
//github : https://www.github.com/psumesh

#include <stdio.h>

void calculation(int upper_boundry, 
                 int lower_boundry,
                 int hsize,
                 int given_addr)
    {
        int i, temp;
        for(i = 0; i<20; i++) {
            if(given_addr <= upper_boundry) {
                temp = given_addr;
                given_addr = given_addr + hsize;
                printf("%d \n", temp);
            }
            
            else {
                temp       = (given_addr- upper_boundry);
                given_addr = lower_boundry + temp;
            }
        }
    }
    
int main()
{
    calculation(60, 10, 6, 16);
    return 0;
}