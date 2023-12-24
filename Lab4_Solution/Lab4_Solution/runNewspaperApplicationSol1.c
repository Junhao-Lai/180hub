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
    // Set up the Serializable transaction
    PGresult *res = PQexec(conn, "BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;");
    if (PQresultStatus(res) != PGRES_COMMAND_OK){
        fprintf(stderr, "BEGIN TRANSACTION failed for countCoincidentSubscriptions\n");
        PQclear(res);
        bad_exit(conn);
    }
    // Determine whether theSubscriberPhone corresponds to a subscriber
    char subscriber_query[MAXSQLSTATEMENTSTRINGSIZE];
    sprintf(subscriber_query, "SELECT * FROM Subscribers sr WHERE sr.subscriberPhone = %d;", theSubscriberPhone);
    // Okay to write this by converting theSubscriberPhone to a string using sprintf, and using strcat to concatenate that on to initial part of query.
    // Okeay to SELECT anything legal, since we're just checking for existence of subscriber.
    
    res = PQexec(conn, subscriber_query);
    // Checking the execution status of the query
    if (PQresultStatus(res) != PGRES_TUPLES_OK){
        fprintf(stderr, "SELECT for subscriber query failed\n");
        PQclear(res);
        bad_exit(conn);
    }

    if (PQntuples(res)==0){
        char *rollback_transaction = "ROLLBACK TRANSACTION";
        res = PQexec(conn, rollback_transaction);
        // Checking the execution status of the query
        if (PQresultStatus(res) != PGRES_COMMAND_OK){
            fprintf(stderr, "ROLLBACK TRANSACTION failed for countCoincidentSubscriptions\n");
            PQclear(res);
            bad_exit(conn);
        }
        return -1;
    }
    PQclear(res);

    char coincident_subscription_count_query[MAXSQLSTATEMENTSTRINGSIZE];
    
    // Use of backslash allows query to run across multiple lines, with formatting to make query a little clearer
    sprintf(coincident_subscription_count_query, \
           "SELECT COUNT(*) AS coincidentSubscriptionCount \
            FROM Subscriptions sn1 \
            WHERE sn1.subscriberPhone = %d \
              AND EXISTS ( \
                    SELECT * \
                    FROM Subscriptions sn2 \
                    WHERE sn1.subscriberPhone = sn2.subscriberPhone \
                      AND ( ( sn1.subscriptionStartDate < sn2.subscriptionStartDate \
                              AND sn2.subscriptionStartDate <= DATE(sn1.subscriptionStartDate + sn1.subscriptionInterval) ) \
                         OR ( sn2.subscriptionStartDate < sn1.subscriptionStartDate \
                              AND sn1.subscriptionStartDate <= DATE(sn2.subscriptionStartDate + sn2.subscriptionInterval) ) ) \
                          ); \
            ", theSubscriberPhone);
    // It's also okay to do this by converting theSubscriberPhone to a string using sprintf, and using strcat to concatenate that on to initial part of query
            
    res = PQexec(conn, coincident_subscription_count_query);
    
    if (PQresultStatus(res) != PGRES_TUPLES_OK){
        fprintf(stderr, "Coincident subscription count query for %d failed\n", theSubscriberPhone);
        PQclear(res);
        bad_exit(conn);
    }

    int num_coincident_subscriptions = atoi(PQgetvalue(res, 0, 0));
    PQclear(res);

    char *commit_transaction = "COMMIT TRANSACTION";
    res = PQexec(conn, commit_transaction);
    if (PQresultStatus(res) != PGRES_COMMAND_OK){
        fprintf(stderr, "COMMIT TRANSACTION failed for countCoincidentSubscriptions\n");
        PQclear(res);
        bad_exit(conn);
    }
    PQclear(res);
    return num_coincident_subscriptions;
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
    // Set up the Serializable transaction; that isn't required for this function.
    PGresult *res = PQexec(conn, "BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;");
    if (PQresultStatus(res) != PGRES_COMMAND_OK){
        fprintf(stderr, "BEGIN TRANSACTION failed for changeAddresses\n");
        PQclear(res);
        bad_exit(conn);
    }

    char update_query[MAXSQLSTATEMENTSTRINGSIZE];
    sprintf(update_query, "UPDATE Subscribers SET subscriberAddress = '%s' WHERE subscriberAddress = '%s';", newAddress, oldAddress);
    res = PQexec(conn, update_query);
    if (PQresultStatus(res) != ){
        fprintf(stderr, "Update command to change address from %s to %s failed", oldAddress, newAddress);
        PQclear(res);
        bad_exit(conn);
    }

    int numUpdated = atoi(PQcmdTuples(res));
    PQclear(res);

    // Okay not to have the BEGIN.  If you don't have the BEGIN, you shouldn't have COMMIT
    char *commit_query = "COMMIT TRANSACTION";
    res = PQexec(conn, commit_query);
    if (PQresultStatus(res) != PGRES_COMMAND_OK){
        fprintf(stderr, "COMMIT TRANSAPGRES_COMMAND_OKCTION failed for changeAddresses\n");
        PQclear(res);
        bad_exit(conn);
    }
    PQclear(res);
    
    return numUpdated;
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
    // Set up the Serializable transaction; this isn't necessary for this function
    PGresult *res = PQexec(conn, "BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;");
    if (PQresultStatus(res) != PGRES_COMMAND_OK){
        fprintf(stderr, "BEGIN TRANSACTION failed for increaseSomeRates\n");
        PQclear(res);
        bad_exit(conn);
    }
    
    // Stored function call
    char function_call_qry[MAXSQLSTATEMENTSTRINGSIZE];
    sprintf(function_call_qry, "SELECT increaseSomeRatesFunction(%d);", maxTotalRateIncrease);
    
    res = PQexec(conn, function_call_qry);
    
    if (PQresultStatus(res)!=PGRES_TUPLES_OK)
    {
        fprintf(stderr, "Call to Stored Function increaseSomeRatesFunction failed: %s/n", PQerrorMessage(conn));
        PQclear(res);
        bad_exit(conn);
    }
    int totalRateIncrease = atoi(PQgetvalue(res, 0, 0));
    PQclear(res);
    
    // Okay not to have the BEGIN.  If you don't have the BEGIN, you shouldn't have COMMIT
    char *commit_query = "COMMIT TRANSACTION";
    res = PQexec(conn, commit_query);
    if (PQresultStatus(res) != PGRES_COMMAND_OK){
        fprintf(stderr, "COMMIT TRANSACTION failed for increaseSomeRates\n");
        PQclear(res);
        bad_exit(conn);
    }
    PQclear(res);

    return totalRateIncrease;
}

int main(int argc, char **argv)
{
    PGconn *conn;

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

    int theResult;
    
    /* Perform the calls to countCoincidentSubscriptions listed in Section 6 of Lab4,
     * printing error message if there's an error.
     */
 
    int num_tests = 4;
    int subscribers_test_arr[] = {8315512, 8313293, 1234567, 6502123};
    for (int k=0; k < num_tests; k++){
        theResult = countCoincidentSubscriptions(conn, subscribers_test_arr[k]);
        if (theResult == -1)
            printf("No subscriber exists whose subscriberPhone is %d\n", subscribers_test_arr[k]);
        else
            printf("Subscriber %d has %d coincident subscriptions.\n", subscribers_test_arr[k], theResult);
    }
    
    /* Extra newline for readability */
    printf("\n");

    /* Perform the calls to changeAddresses listed in Section 6 of Lab4,
     * and print messages as described.
     */
    #define  NUMADDRESSTESTS          3
    #define  MAXADDRESSLENGTH        60

    char old_address_test_arr[NUMADDRESSTESTS] [MAXADDRESSLENGTH] = {"100 Asgard St, Asgard, AG, 00001", "3428A Lombard St, Tahoe City, CA, 96142", "IJL"};
    char new_address_test_arr[NUMADDRESSTESTS] [MAXADDRESSLENGTH] = {"PQRS", "ABCD", "MNOP"};
    for (int k=0; k < NUMADDRESSTESTS; k++){
        theResult = changeAddresses(conn, old_address_test_arr[k], new_address_test_arr[k]);
        printf("%d addresses which were %s were updated to %s\n", theResult, old_address_test_arr[k], new_address_test_arr[k]);
    }

    /* Extra newline for readability */
    printf("\n");

    /* Perform the calls to increaseSomeRates listed in Section
     * 6 of Lab4, and print messages as described.
     * You may use helper functions to do this, if you want.
     */

    num_tests = 5;
    int maxTotalRateIncrease_arr[] = {100, 45, 29, 2, 0};
    for (int k=0; k < num_tests; k++){
        theResult = increaseSomeRates(conn, maxTotalRateIncrease_arr[k]);
        if (theResult >= 0)
            printf("Total rate increase for maxTotalRateIncrease %d is %d\n", maxTotalRateIncrease_arr[k], theResult);
        else {
            printf("FAIL: increaseSomeRates for maxTotalRateIncrease %d returned %d\n",  maxTotalRateIncrease_arr[k], theResult);
            bad_exit(conn);
        }
    }

    
    good_exit(conn);
    return 0;
}
