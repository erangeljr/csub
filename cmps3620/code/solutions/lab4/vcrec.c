/* This code is derived from the CMPS 376 networking code by Marc Thomas
 *
 * The purpose of this code is to create a very simple Internet server which
 * binds to a port, does a simple handshake with the client and then echos 
 * everything the client sends to the screen.
 *
 * Command line usage:
 *   $ vcrec [packet_size] &
 *
 *   if packet_size is specified, it must be a positive integer and only that
 *   many bytes will be read from the client.
 *
 * TCP/IP socket functions used by this program:
 * 
 *   socket()        Create a byte stream for client connection requests
 *   bind()          Bind the socket to IP address and request TCP port number
 *   getsockname()   Query what port number the system assigned to the process
 *   listen()        Wait for a client to issue a connection request
 *   accept()        Accept the connection request from a client
 *   send()          Send data to the client
 *   recv()          Receive data from the client
 *   close()         Close the sockets
 *
 * Passive Socket Connection Process:
 * Server
 *
 * vcsend                      vcrec
 * -------------------------   ------------------------- 
 *  
 * socket() (client socket)    socket() (listen socket)
 *                             bind()
 *                             getsockname()
 *                             listen()
 * connect() --------------->  accept() (creates 2nd data socket)
 *
 * (data exchange phase can be response-driven but if more
 *  than one descriptor must be managed use of select() is
 *  strongly recommended)
 * 
 * send() --------------------> recv()
 * recv() <-------------------- send()
 * 
 * close() (client socket)     close() (both data and listen socket)
*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <unistd.h>      /* for gethostname() */
#include <arpa/inet.h>   /* for IP address structures and functions */
#include <errno.h>
#include <signal.h>
#include <sys/select.h>

#define SELECT_TIMEOUT   30
#define ULIMIT          255



const int BUF_SIZE = 2048;
const int LINE_SIZE = 80;

int main(int argc, char *argv[], char *envp[])
{
	int	sock, msgsock;  /* Sockets are integer file descriptors on Linux */
	struct	sockaddr_in	name, caller;
	char	buf[BUF_SIZE];
	char	chrline[LINE_SIZE];
	int	size, length, ret, k;
	int bytesread;

  /* Process the command line for the buffer size, if given */
	if (argc > 1)
	{
		size = atoi(argv[1]);
    	/* Validate that the given argument is between 1 and sizeof(buf) - 1 
     	* Set to the default size if argument is invalid */
		if (size < 1  ||  size > sizeof(buf) - 1) 
			size = sizeof(buf) - 1;
	}
	else
	{
		size = sizeof(buf) - 1;  /* Default size */
	}

	/* The following variables are for the select() function */
  	fd_set readmask, writemask, exceptmask;
  	struct timeval timeout;  /* contains tv_sec and tv_usec member variables */


  /* Create the listen socket. This is a TCP socket, so use SOCK_STREAM 
   * Exit if the socket cannot be created */
	sock = socket(AF_INET, SOCK_STREAM, 0);
	if (sock < 0) 
	{
		perror("receiver: socket() failed. ");
		exit(EXIT_FAILURE);
	}

  /* Bind the socket to an IP address and port. We will use the IP address
   * INADDR_ANY, which tells the system to assign the IP address, and the
   * port number 0, which tells the system to assign a random port number.
   *
   * First we have to set the fields in the sockaddr_in object "name" and then
   * we can call bind(). Again, exit if bind() fails. */
	name.sin_family = AF_INET;         /* TCP/IP family */
	name.sin_addr.s_addr = INADDR_ANY; /* INADDR_ANY = assigned by system */
	name.sin_port = htons(0);	         /* 0 = assigned by system */
	ret = bind(sock,(struct sockaddr *)&name,sizeof name);
	if (ret < 0)
	{
		perror("receiver: bind() failed. ");
		exit(EXIT_FAILURE);
	}

  /* In order to use vcsend to send data to this program, we need to know
   * what port number the system just assigned this program. So this segment
   * calls getsockname() to update the sockaddr_in object "name" with the
   * system assigned values and then print that info to the screen. */
	length = sizeof name;
	ret = getsockname(sock, (struct sockaddr *)&name, (socklen_t *)&length);
	if (ret < 0)
	{
		perror("receiver: getsockname() failed. ");
		exit(EXIT_FAILURE);
	}

	sleep(1);	/* pause for clean screen display */
	printf("\nreceiver: process id: %d ", (int)getpid());
	printf("\nreceiver: IP address: %d.%d.%d.%d",
        (ntohl(name.sin_addr.s_addr) & 0xff000000) >> 24,
        (ntohl(name.sin_addr.s_addr) & 0x00ff0000) >> 16,
        (ntohl(name.sin_addr.s_addr) & 0x0000ff00) >>  8,
        (ntohl(name.sin_addr.s_addr) & 0x000000ff));
	printf("\nreceiver: port number: %hu", ntohs(name.sin_port));
	printf("\n");
	fflush(stdout);

	/* Now we will call listen() and wait for a client to connect. The
   * accept() function will block until there is a client or an error. */
	listen(sock,5);		/* up to 5 clients can connect. only 1st is accepted */
	k = sizeof caller;
	msgsock = accept(sock, (struct sockaddr *)&caller, (socklen_t *)&k);

	/* The first step to using select is to zero out all the file descriptors
     * in each mask */
    FD_ZERO(&readmask);
    FD_ZERO(&writemask);
    FD_ZERO(&exceptmask);

	/* The second step is to set all the file descriptors you wish to watch
     * for each mask. Recall that the file descriptor for stdin is 0 and the
     * file descriptor for stdout is 1. For a socket, the file descriptor is
     * the integer returned by the socket() function */
    FD_SET(STDIN_FILENO, &readmask);    /* activiate stdin read */
    FD_SET(STDIN_FILENO, &exceptmask);  /* activiate stdin exception */
	FD_SET(sock, &readmask);			/* activiate socket read */
	FD_SET(msgsock, &writemask);			/* activiate socket read */

	/* The third step is to set the timeout values. This is how long select()
     * will wait for activity before giving up and returning */
    timeout.tv_sec = SELECT_TIMEOUT;    /* seconds */
    timeout.tv_usec = 0;                /* microseconds */

	/* Now we are ready to call select(). We will wait here until something
     * happens or the function times out */
    ret = select(ULIMIT, &readmask, &writemask, &exceptmask, &timeout);

	

  /* We only reach this point when there is an error or a client. We can 
   * check the value of msgsock (the data socket) to see which has happened */
	if (msgsock == -1)
	{
		perror("receiver: accept() failed. ");
	}
	else
	{
		printf("\nreceiver: Valid connection received.\n");
		printf("receiver: Sending handshake.\n");
		fflush(stdout);

		 /* Now process the return value from timeout to see what happened */
		if(ret == 0)  /* timeout */
		{
		printf(" timeout!\n");
		}
		else if(ret < 0)  /* error or signal interupt */
		{
			if(errno == EINTR)
			{
				printf("Signal interupted select!\n");
			}
			else
			{
				printf("Exception on select(), exiting loop...\n");
				exit(EXIT_FAILURE);
			}
		}
		/* Check if there was an exception on stdin */
		else if(FD_ISSET(0, &exceptmask))
		{
			printf("Exception on select(), exiting loop...\n");
			exit(EXIT_FAILURE);
		}
		/* Check if there's data on stdin waiting to be read */
		else if(FD_ISSET(0, &readmask))
		{
			bytesread = read(0, buf, sizeof(buf));

			/* Check for the period to end the connection and also convert any
			* newlines into null characters */
			int i;
			for(i = 0 ; i < (sizeof(buf) - 1) ; i++)
			{
				if( (buf[i] == '\n') || (buf[i] == '\0') )
				break;
			}
			if(buf[i] == '\n')
				buf[i] = '\0';  /* get rid of newline */


			if(buf[0] == '.')    /* end of stream */
			{
				printf("Exiting select() loop at user's request...\n");
				return;				
			}
			else 
			{
				printf("You typed: %s\n", buf);
			}
		}

		/* let vcsend know we are ready by sending a single character */
		buf[0]= '0';		
		send(msgsock, buf, 1, 0);

		printf("receiver: Waiting for client....\n");
				
		do
		{
			bzero(buf,sizeof buf);	/* zero buffer to remove old data */

			/* recv() will block until the client sends information, the client
			* closes the connection or an error occurs on the data socket. */
			ret = recv(msgsock, buf, size, 0);
			if (ret < 0)
			{
				perror("receiver: recv() failed. ");
			}
			if (ret == 0)
			{
				printf("        received-->sender has ended connection \n");
			}
			else
			{
				printf("        received-->%s \n",buf);
			}
			
			printf("enter line> ");

			/* Read input from user */
			fgets(chrline, sizeof(chrline) - 1, stdin);
			/* Check for the period to end the connection and also convert any
			* newlines into null characters */
			int i;
			for (i = 0 ; i < (sizeof(chrline) - 1) ; i++)
			{
				if ( (chrline[i] == '\n') || (chrline[i] == '\0') )
					break;
			}
			if (chrline[i] == '\n')
				chrline[i] = '\0'; 	/* get rid of newline */
			
			if (chrline[0] == '.')		/* end of stream */
			{
				printf("receiver: termination requested \n");
				ret = 0;
				break; /* Exit nested loop */
			}
			else
			{
				length = strlen(chrline);
				ret = send(msgsock, chrline, length + 1, 0);

				if (ret < 0)
				{
					perror("receiver: write() failed. ");
					break;  /* Exit out of loop */
				}
			}
			printf("receiver: Waiting for client....\n");

		} while (ret != 0); /* Exit loop only when client ends connection */
	}

  /* When we exit the recv() loop, the client has ended the connection, so
   * all that remains is closing the sockets. */

	printf("receiver: ending session and exiting. \n");
	close(msgsock);		/* close data socket */
	close(sock);      /* close listen socket */

	exit(EXIT_SUCCESS);
}  /* end of main */
