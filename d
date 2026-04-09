[09/04, 12:50 am] Ankit_IT: #include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>

struct sockaddr_in serv_addr;

int skfd, r, w;
unsigned short serv_port = 25050;
char serv_ip[] = "127.0.0.1";
char sbuff[128] = "time";
char rbuff[128];

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, &serv_addr.sin_addr);

    printf("\nTCP TIME CLIENT\n");

    if ((skfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        printf("\nCLIENT ERROR: cannot create socket\n");
        exit(1);
    }

    if ((connect(skfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr))) < 0)
    {
        printf("\nCLIENT ERROR: Cannot connect to the server\n");
        close(skfd);
        exit(1);
    }

    printf("\nCLIENT: Connected to the server\n");

    while (1)
    {
        printf("Enter time to get current time: ");
        fgets(sbuff, 128, stdin);

        w = write(skfd, sbuff, strlen(sbuff));

        if (w < 0)
        {
            printf("\nWrite failed\n");
            break;
        }

        if (strncmp(sbuff, "exit", 4) == 0)
        {
            printf("\nClosing connection\n");
            break;
        }

        r = read(skfd, rbuff, 128);

        if (r < 0)
        {
            printf("\nRead failed\n");
            break;
        }
        else if (r == 0)
        {
            printf("\nServer disconnected\n");
            break;
        }
        else
        {
            rbuff[r] = '\0';
            printf("SERVER: %s", rbuff);
        }
    }

    close(skfd);
    return 0;
}
[09/04, 12:50 am] Ankit_IT: #include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>

struct sockaddr_in serv_addr, cli_addr;

int listenfd, connfd, r, w, cli_addr_len;
unsigned short serv_port = 25050;
char serv_ip[] = "127.0.0.1";
char buff[120];

int main()
{
    time_t current_time;

    bzero(&serv_addr, sizeof(serv_addr));

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, &serv_addr.sin_addr);

    printf("\nTCP TIME SERVER\n");

    if ((listenfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        printf("\nSERVER ERROR: Cannot create socket\n");
        exit(1);
    }

    if (bind(listenfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
        printf("\nSERVER ERROR: Cannot bind\n");
        close(listenfd);
        exit(1);
    }

    if (listen(listenfd, 5) < 0)
    {
        printf("\nSERVER ERROR: Cannot listen\n");
        close(listenfd);
        exit(1);
    }

    cli_addr_len = sizeof(cli_addr);

    while (1)
    {
        printf("\nSERVER listening for clients... press CTRL+C to stop\n");

        if ((connfd = accept(listenfd, (struct sockaddr *)&cli_addr, (socklen_t *)&cli_addr_len)) < 0)
        {
            printf("\nSERVER ERROR: Cannot accept client connections\n");
            continue;
        }

        printf("Connected to client: %s\n", inet_ntoa(cli_addr.sin_addr));

        while (1)
        {
            r = read(connfd, buff, 128);

            if (r < 0)
            {
                printf("\nRead failed\n");
                break;
            }

            if (r == 0)
            {
                printf("\nClient disconnected\n");
                break;
            }

            buff[r] = '\0';
            printf("Client: %s", buff);

            if (strncmp(buff, "exit", 4) == 0)
            {
                printf("\nClient exited\n");
                break;
            }

            time(&current_time);
            strcpy(buff, ctime(&current_time));

            printf("SERVER TIME: %s", buff);

            if ((w = write(connfd, buff, strlen(buff))) < 0)
            {
                printf("\nSERVER ERROR: Write failed\n");
            }
            else
            {
                printf("SERVER sent time to client\n");
            }
        }

        close(connfd);
    }

    close(listenfd);
    return 0;
}


calculator day 4

[09/04, 12:48 am] Ankit_IT: *TCP CLIENT CALCULATOR*
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>

struct sockaddr_in serv_addr;

int skfd, r, w;
unsigned short serv_port = 25053;
char serv_ip[] = "127.0.0.1";
char sbuff[128];
char rbuff[128];

int main()
{
    bzero(&serv_addr, sizeof(serv_addr));

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, &serv_addr.sin_addr);

    printf("\nTCP CALCULATOR CLIENT\n");

    if ((skfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        printf("\nCLIENT ERROR: Cannot create socket\n");
        exit(1);
    }

    if (connect(skfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
        printf("\nCLIENT ERROR: Cannot connect to the server\n");
        close(skfd);
        exit(1);
    }

    printf("\nCLIENT: Connected to the server\n");

    while (1)
    {
        printf("Enter expression (example 10 + 5) or exit: ");
        fgets(sbuff, sizeof(sbuff), stdin);

        w = write(skfd, sbuff, strlen(sbuff));
        if (w < 0)
        {
            printf("\nCLIENT ERROR: Write failed\n");
            break;
        }

        if (strncmp(sbuff, "exit", 4) == 0)
        {
            printf("\nClosing connection\n");
            break;
        }

        r = read(skfd, rbuff, sizeof(rbuff) - 1);
        if (r < 0)
        {
            printf("\nCLIENT ERROR: Read failed\n");
            break;
        }
        else if (r == 0)
        {
            printf("\nServer disconnected\n");
            break;
        }

        rbuff[r] = '\0';
        printf("SERVER: %s", rbuff);
    }

    close(skfd);
    return 0;
}
[09/04, 12:48 am] Ankit_IT: #include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>

struct sockaddr_in serv_addr, cli_addr;

int listenfd, connfd, r, w, cli_addr_len;
unsigned short serv_port = 25054;
char serv_ip[] = "127.0.0.1";
char buff[128];
char result[128];

int main()
{
    double n1, n2, ans;
    char op;

    bzero(&serv_addr, sizeof(serv_addr));
    bzero(&cli_addr, sizeof(cli_addr));

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(serv_port);
    inet_aton(serv_ip, &serv_addr.sin_addr);

    printf("\nTCP CALCULATOR SERVER\n");

    if ((listenfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        printf("\nSERVER ERROR: Cannot create socket\n");
        exit(1);
    }

    if (bind(listenfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
        printf("\nSERVER ERROR: Cannot bind\n");
        close(listenfd);
        exit(1);
    }

    if (listen(listenfd, 5) < 0)
    {
        printf("\nSERVER ERROR: Cannot listen\n");
        close(listenfd);
        exit(1);
    }

    cli_addr_len = sizeof(cli_addr);

    while (1)
    {
        printf("\nSERVER listening for clients... press CTRL+C to stop\n");

        if ((connfd = accept(listenfd, (struct sockaddr *)&cli_addr, (socklen_t *)&cli_addr_len)) < 0)
        {
            printf("\nSERVER ERROR: Cannot accept client connection\n");
            continue;
        }

        printf("Connected to client: %s\n", inet_ntoa(cli_addr.sin_addr));

        while (1)
        {
            bzero(buff, sizeof(buff));
            bzero(result, sizeof(result));

            r = read(connfd, buff, sizeof(buff) - 1);

            if (r < 0)
            {
                printf("\nSERVER ERROR: Read failed\n");
                break;
            }

            if (r == 0)
            {
                printf("\nClient disconnected\n");
                break;
            }

            buff[r] = '\0';
            printf("Client: %s", buff);

            if (strncmp(buff, "exit", 4) == 0)
            {
                printf("\nClient exited\n");
                break;
            }

            if (sscanf(buff, "%lf %c %lf", &n1, &op, &n2) != 3)
            {
                strcpy(result, "Invalid expression\n");
            }
            else
            {
                switch (op)
                {
                    case '+':
                        ans = n1 + n2;
                        sprintf(result, "Result = %.2lf\n", ans);
                        break;

                    case '-':
                        ans = n1 - n2;
                        sprintf(result, "Result = %.2lf\n", ans);
                        break;

                    case '*':
                        ans = n1 * n2;
                        sprintf(result, "Result = %.2lf\n", ans);
                        break;

                    case '/':
                        if (n2 == 0)
                            strcpy(result, "Division by zero not possible\n");
                        else
                            sprintf(result, "Result = %.2lf\n", n1 / n2);
                        break;

                    default:
                        strcpy(result, "Invalid operator\n");
                }
            }

            printf("SERVER: %s", result);

            w = write(connfd, result, strlen(result));
            if (w < 0)
            {
                printf("\nSERVER ERROR: Write failed\n");
                break;
            }
        }

        close(connfd);
    }

    close(listenfd);
    return 0;
}
