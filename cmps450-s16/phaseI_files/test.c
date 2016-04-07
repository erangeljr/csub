/* sample cflat code */
int main() 
{
int n = 5;
loop:
if (n == 0)
goto out;
n--;
goto loop;
out:
write(1,"done\n",5);
return 0; 
} 
