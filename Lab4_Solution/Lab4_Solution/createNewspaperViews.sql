/* createNewsPaperViews.sql for Fall 2023 Lab4
 *
 *  We provide two solutions for Lab4.  One of them uses these views; the other does not.
 *  There can be other ways to create views for Lab4 besides the.
 */

CREATE OR REPLACE VIEW SubscriptionsWithEndDate AS
    SELECT subscriberPhone, subscriptionStartDate, 
             DATE(subscriptionStartDate + subscriptionInterval) AS subscriptionEndDate
    FROM Subscriptions;

CREATE OR REPLACE VIEW CoincidentSubscriptionsInOrder AS
    SELECT sn1.subscriberPhone AS commonSubscriberPhone, 
           sn1.subscriptionStartDate AS firstStartDate, 
           sn2.subscriptionStartDate AS secondStartDate
    FROM SubscriptionsWithEndDate sn1, SubscriptionsWithEndDate sn2
    WHERE sn1.subscriberPhone = sn2.subscriberPhone
      AND sn1.subscriptionStartDate < sn2.subscriptionStartDate 
      AND sn2.subscriptionStartDate <= sn1.subscriptionEndDate;

/* Two different subscriptions with the same subscriberPhone can't have the same startDate,
 * because (subscriberPhone, startDate) is the Primary key of subscriptions
 */

CREATE OR REPLACE VIEW DifferentCoincidentSubscriptionDates AS
    ( SELECT commonSubscriberPhone, firstStartDate
      FROM CoincidentSubscriptionsInOrder  )
        UNION
    ( SELECT commonSubscriberPhone, secondStartDate
      FROM CoincidentSubscriptionsInOrder );

/* The query which we'll use for countCoincidentSubscriptions will be the following, where
   theSubscriberPhone is the parameter of the countCoincidentSubscriptions C function.

  SELECT COUNT(*)
  FROM DifferentCoincidentSubscriptionDates
  WHERE CommonSubscriberPhone = theSubscriberPhone;

  Yes, we didn't need the DifferentCoincidentSubscriptionDates view.  We could have just put
  the query for DifferentCoincidentSubscriptionDates into the FROM clause of the above query.
  We would need a tuple variable for it, as we also do when there's a query in the FROM
  clause.
*/




