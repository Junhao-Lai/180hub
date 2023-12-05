/**
 * runHighwayApplication skeleton, to be modified by students
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "libpq-fe.h"

/* These constants would normally be in a header file */
/* Maximum length of string used to submit a connection */
#define MAXCONNECTIONSTRINGSIZE 501
/* Maximum length of string used to submit a SQL statement */
#define MAXSQLSTATEMENTSTRINGSIZE 2001
/* Maximum length of string version of integer; you don't have to use a value this big */
#define  MAXNUMBERSTRINGSIZE        20


/* Exit with success after closing connection to the server
 *  and freeing memory that was used by the PGconn object.
 */
static void good_exit(PGconn *conn)
{
    PQfinish(conn);
    exit(EXIT_SUCCESS);
}

/* Exit with failure after closing connection to the server
 *  and freeing memory that was used by the PGconn object.
 */
static void bad_exit(PGconn *conn)
{
    PQfinish(conn);
    exit(EXIT_FAILURE);
}

/* The three C functions that for Lab4 should appear below.
 * Write those functions, as described in Lab4 Section 4 (and Section 5,
 * which describes the Stored Function used by the third C function).
 *
 * Write the tests of those function in main, as described in Section 6
 * of Lab4.
 *
 * You may use "helper" functions to avoid having to duplicate calls and
 * printing, if you'd like, but if Lab4 says do things in a function, do them
 * in that function, and if Lab4 says do things in main, do them in main,
 * possibly using a helper function, if you'd like.
 */
/* Function: countCoincidentSubscriptions:
 * -------------------------------------
 * Parameters:  connection, and theSubscriberPhone, which should be the ID of a subscriber.
 * Counts the number of coincident subscriptions for that subscriber, if there is a
 * subscriber corresponding to theSubscriberPhone.
 * Return 0 if normal execution, -1 if no such subscriber.
 * bad_exit if SQL statement execution fails.
 */


int countCoincidentSubscriptions(PGconn *conn, int theSubscriberPhone)
{
    char stringSubscriberPhone[MAXNUMBERSTRINGSIZE];
    sprintf(stringSubscriberPhone, "%d", theSubscriberPhone); //转成str

    //subscriberPhone exists?
    char exist[MAXSQLSTATEMENTSTRINGSIZE] = 
        "SELECT b.subscriberPhone "
        "FROM Subscribers b " 
        "WHERE b.subscriberPhone = '";
        strcat(exist, stringSubscriberPhone);
        strcat(exist, "'");

    PGresult *res_exist = PQexec(conn, exist);
    if (PQresultStatus(res_exist) != PGRES_TUPLES_OK)
    {
        fprintf(stderr, "SELECT for subscriberPhone failed: %s, %s", exist, PQerrorMessage(conn));
        PQclear(res_exist);
        bad_exit(conn);
        return(-1);
    }


    char coin[MAXSQLSTATEMENTSTRINGSIZE] = 
        "SELECT DISTINCT s1.subscriptionStartDate, s1.subscriptionInterval "
        "FROM Subscriptions s1 "
        "WHERE s1.subscriberPhone ='";
        strcat(coin, stringSubscriberPhone);
        strcat(coin, "'");
        strcat(coin,
        "AND EXISTS(SELECT *"
        "FROM Subscriptions s2 "
        "WHERE s1.subscriberPhone = s2.subscriberPhone "
        "AND s1.subscriptionStartDate <= s2.subscriptionStartDate AND "
        "s2.subscriptionStartDate <= DATE(s1.subscriptionStartDate + s1.subscriptionInterval))");

    PGresult *res_coin = PQexec(conn, coin);

    if (PQresultStatus(res_coin) != PGRES_TUPLES_OK)
    {
        fprintf(stderr, "SELECT for coincidence failed: %s, %s", coin, PQerrorMessage(conn));
        PQclear(res_coin);
        bad_exit(conn);
        return(-1);
    }

    int count = PQntuples(res_coin);

    if (count == 0){ 
        printf("No subsciber exists whose subscriberPhone is %d\n",theSubscriberPhone);
    }
    else if (count == 1){
        printf("Subscriber %d has 0 coincident subscriptions.\n", theSubscriberPhone);
    }
    else{
        printf("Subscriber %d has %d coincident subscriptions.\n", theSubscriberPhone, count);
    }



    return count;

}

/* Function: changeAddresses:
 * ----------------------------
 * Parameters:  connection, and character strings oldAddress and newAddress
 
 * Updates all subscriberAddress values in Subscribers which had value oldAddress to newAddress,
 * and returns the number of addresses updates.
 * If no addresses are updated (because no subscribers have oldAddress as their subscriberAddress,
 * return 0; that's not an error.
 */

int changeAddresses(PGconn *conn, char *oldAddress, char *newAddress)
{
    // char address[MAXSQLSTATEMENTSTRINGSIZE] =
    //     "SELECT b.subscriberAddress " 
    //     "FROM Subscribers b "
    //     "WHERE subscriberAddress ='";
    //     strcat(address, oldAddress);
    //     strcat(address, "'");

    char address[MAXSQLSTATEMENTSTRINGSIZE];
    sprintf(address,"SELECT subscriberAddress FROM Subscribers WHERE subscriberAddress = '%s';", oldAddress);

    PGresult *res_address = PQexec(conn, address);
    if (PQresultStatus(res_address) != PGRES_TUPLES_OK)
    {
        fprintf(stderr, "SELECT for subscriberAddress failed: %s, %s", address, PQerrorMessage(conn));
        PQclear(res_address);
        bad_exit(conn);
        return(-1);
    }
    PQclear(res_address);

    // char update[MAXSQLSTATEMENTSTRINGSIZE] = 
    //     "UPDATE Subscribers SET subscriberAddress ='";
    //     strcat(update, newAddress);
    //     strcat(update, "'");
    //     "WHERE subscriberAddress ='";
    //     strcat(update, oldAddress);
    //     strcat(update, "'");

    char update[MAXSQLSTATEMENTSTRINGSIZE];
    sprintf(update,"UPDATE Subscribers SET subscriberAddress = '%s' WHERE subscriberAddress = '%s';",newAddress, oldAddress);

    PGresult *res_update = PQexec(conn, update);
    if (PQresultStatus(res_update) != PGRES_COMMAND_OK)
    {
        fprintf(stderr, "SELECT for subscriberAddress #2 failed: %s, %s", update, PQerrorMessage(conn));
        PQclear(res_update);
        bad_exit(conn);
        return(-1);
    }
    PQclear(res_update);
    int count = atoi(PQcmdTuples(res_update));

    if(count >= 0){
        printf("%d addresses which were %s were updated to %s \n",count, oldAddress, newAddress);
    }

    return count;
}


/* Function: increaseSomeRates:
 * -------------------------------
 * Parameters:  connection, and an integer maxTotalRateIncrease, the maximum total
 * rate increase that should be applied based on increasing rates for some subscription kinds
 * in SubscriptionKinds, aa described in Section 5 of the Lab4 pdf.
 *
 * Executes by invoking a Stored Function, increaseSomeRatesFunction, which does all of the work.
 *
 * Returns a negative value if there is an error, and otherwise returns the total rate increase
 * that's been applied to subscriptions that have certain subscription kinds.
 */

int increaseSomeRates(PGconn *conn, int maxTotalRateIncrease)
{    
    char stringFromNum[MAXNUMBERSTRINGSIZE];

    char store[MAXSQLSTATEMENTSTRINGSIZE] = "SELECT increaseSomeRatesFunction( ";
    sprintf(stringFromNum,"%d",maxTotalRateIncrease);
    strcat(store, stringFromNum);
    strcat(store, ")");

    
    PGresult *res_increase = PQexec(conn, store);
    if (PQresultStatus(res_increase) != PGRES_TUPLES_OK)
    {
        fprintf(stderr, "FUNCTION increaseSomeRates failed on %d: %s/n", maxTotalRateIncrease, PQerrorMessage(conn));
        PQclear(res_increase);
        bad_exit(conn);
    }
    
    int a = atoi(PQgetvalue(res_increase, 0, 0));

    PQclear(res_increase);
    return a;
}
   


int main(int argc, char **argv)
{
    PGconn *conn;
    int theResult;

    if (argc != 3)
    {
        fprintf(stderr, "Usage: ./runHighwayApplication <username> <password>\n");
        exit(EXIT_FAILURE);
    }

    char *userID = argv[1];
    char *pwd = argv[2];

    char conninfo[MAXCONNECTIONSTRINGSIZE] = "host=cse180-db.lt.ucsc.edu user=";
    strcat(conninfo, userID);
    strcat(conninfo, " password=");
    strcat(conninfo, pwd);

    /* Make a connection to the database */
    conn = PQconnectdb(conninfo);

    /* Check to see if the database connection was successfully made. */
    if (PQstatus(conn) != CONNECTION_OK)
    {
        fprintf(stderr, "Connection to database failed: %s\n",
                PQerrorMessage(conn));
        bad_exit(conn);
    }
    
    /* Perform the calls to countCoincidentSubscriptions listed in Section 6 of Lab4,
     * and print messages as described.
     */

    int phone;
    int result; 

    // #1
    phone = 8315512;
    result = countCoincidentSubscriptions(conn, phone);
    if ( result == -1)
    {
        printf("No subscriber exists whose subscriberPhone is %d\n",phone);
    }

    //#2
    phone = 8313293;
    result = countCoincidentSubscriptions(conn, phone);
    if ( result == -1)
    {
        printf("No subscriber exists whose subscriberPhone is %d\n",phone);
    }

    //#3
    phone = 1234567;
    result = countCoincidentSubscriptions(conn, phone);
    if ( result == -1)
    {
        printf("No subscriber exists whose subscriberPhone is %d\n",phone);
    }

    //#4
    phone = 6502123;
    result = countCoincidentSubscriptions(conn, phone);
    if ( result == -1)
    {
        printf("No subscriber exists whose subscriberPhone is %d\n",phone);
    }
    
    /* Extra newline for readability */
    printf("\n");

    
    /* Perform the calls to changeAddresses listed in Section 6 of Lab4,
     * and print messages as described.
     */
    char *newAddress;
    char *oldAddress;

    // #1
    oldAddress = "100 Asgard St, Asgard, AG, 00001";
    newAddress = "PQRS";
    result = changeAddresses(conn, oldAddress, newAddress);
    if ( result == -1)
    {
        printf("Illegal value for newAddress\n",newAddress);
    }

    //#2
    oldAddress = "3428A Lombard St, Tahoe City, CA, 96142";
    newAddress = "ABCD";
    result = changeAddresses(conn, oldAddress, newAddress);
    if ( result == -1)
    {
        printf("Illegal value for newAddress\n",newAddress);
    }

    //#3s
    oldAddress = "IJL";
    newAddress = "MNOP";
    result = changeAddresses(conn, oldAddress, newAddress);
    if ( result == -1)
    {
        printf("Illegal value for newAddress\n",newAddress);
    }


 /* 
    else
    {
        printf("%d addresses which were %s were updated to %s\n", update_count, oldAddress, newAddress);
    }
*/

    /* Extra newline for readability */
    printf("\n");

    
    /* Perform the calls to increaseSomeRates listed in Section
     * 6 of Lab4, and print messages as described.
     * You may use helper functions to do this, if you want.
     */
    int maxTotalIncrease;
    
    maxTotalIncrease = 100;
    result = increaseSomeRates(conn, maxTotalIncrease);
    if ( result >= 0)
    {
        printf("Total increase for maxTotalIncrease %d is %d\n", maxTotalIncrease, result);
    }
    else
    {
        printf("Error: Value returned by increaseSomeRates for maxTotalIncrease %d is %d", maxTotalIncrease, result);
    }
        

    good_exit(conn);
    return 0;
}
