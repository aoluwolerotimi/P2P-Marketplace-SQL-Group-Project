-- 1. Count of listing per category
/*
 Objective: This query provides insight into the popularity of each category based on the number of listings. 
 For instance, if the 'Electronics' category has the highest count, it suggests that electronics are the most listed items on the platform. 
 This information can guide strategic decisions such as marketing focus, category expansion, or user targeting.
 */
SELECT c.categoryName,
    COUNT(l.listingID) AS listingCount
FROM Listing l
    LEFT JOIN Category c ON c.categoryId = l.categoryId
GROUP BY c.categoryId
ORDER BY listingCount DESC;
-- BREAK
-- 2. Average number of messages exchanged per category
/*
 Objective: This query provides insight into the level of user engagement or potential buyer-seller negotiations within each category. 
 For example, a high average number of messages in the 'Cars' category might indicate that these listings require more discussion before a sale, possibly due to higher prices or complexity. 
 This could inform customer service resource allocation or the development of more detailed listing templates for certain categories.
 */
SELECT c.categoryName,
    AVG(m.messageCount) AS averageMessageCount
FROM Category c
    LEFT JOIN (
        SELECT l.categoryID,
            l.listingID,
            COUNT(m.messageID) AS messageCount
        FROM Listing l
            LEFT JOIN Message m ON m.listingID = l.listingID
        GROUP BY l.listingID
    ) m ON m.categoryID = c.categoryID
GROUP BY c.categoryID
ORDER BY averageMessageCount DESC;
-- BREAK
-- 3. Number of listings per month by category and growth rate
/*
 Objective: This query provides insights into the monthly growth and popularity trends of each category. 
 For instance, a steady increase in listings for the 'Home Decor' category might suggest a growing interest in home improvement items. 
 This data can inform marketing strategies, inventory management, and predictions for future demand.
 */
SELECT currentMonth.categoryID,
    currentMonth.categoryName,
    MONTHNAME(
        STR_TO_DATE(
            CONCAT('2023-', currentMonth.month, '-01'),
            '%Y-%m-%d'
        )
    ) as month,
    currentMonth.listingCount,
    IFNULL(
        (
            (
                currentMonth.listingCount - previousMonth.listingCount
            ) / previousMonth.listingCount
        ),
        0
    ) AS MoM_Growth_Rate
FROM (
        SELECT c.categoryID,
            c.categoryName,
            MONTH(l.datePosted) AS month,
            COUNT(l.listingID) AS listingCount
        FROM Listing l
            LEFT JOIN Category c ON c.categoryID = l.categoryID
        GROUP BY c.categoryID,
            c.categoryName,
            MONTH(l.datePosted)
    ) AS currentMonth
    LEFT JOIN (
        SELECT c.categoryID,
            c.categoryName,
            MONTH(l.datePosted) AS month,
            COUNT(l.listingID) AS listingCount
        FROM Listing l
            LEFT JOIN Category c ON c.categoryID = l.categoryID
        GROUP BY c.categoryID,
            c.categoryName,
            MONTH(l.datePosted)
    ) AS previousMonth ON currentMonth.categoryID = previousMonth.categoryID
    AND currentMonth.month = previousMonth.month + 1
ORDER BY currentMonth.categoryID ASC,
    currentMonth.month ASC,
    currentMonth.listingCount DESC;
-- BREAK
-- 4. Average price of active listings per category
/*
 Objective: This query provides insight into the average pricing structure across different categories. 
 For example, if the 'Antiques' category has a higher average price, it suggests that items in this category are generally more expensive. 
 This information can help users in pricing their listings competitively and can guide buyers in budgeting their purchases.
 */
SELECT c.categoryID,
    c.categoryName AS Category,
    ROUND(AVG(l.price), 2) AS Average_Listing_Price
FROM Listing l
    JOIN Category c ON l.categoryID = c.categoryID
WHERE l.status = 'A'
GROUP BY l.categoryID
ORDER BY l.categoryID DESC;
-- BREAK
-- 5. Show listing with minimum price in each category
/*
 Objective: This query provides insight into the lowest price point within each category.
 For example, if the minimum price in the 'Books' category is very low, it suggests that there are affordable options available for buyers interested in this category.
 This information can be useful for price-sensitive buyers and can help sellers understand the price range within their category.
 */
SELECT c.categoryID,
    c.categoryName,
    MIN(l.price) as minimumListingPrice
FROM Category c,
    Listing l
WHERE c.categoryID = l.categoryID
GROUP BY categoryID,
    categoryName
ORDER BY MIN(l.Price);
-- BREAK
-- 6. Underperforming categories
/*
 Objective: This query identifies categories where listings tend to stay unsold for longer periods, indicating they may be underperforming.
 For example, if the 'Collectibles' category has the most listings older than two months, it suggests that items in this category are not selling as quickly as those in other categories.
 This information can help sellers understand which categories may require more marketing efforts or price adjustments to increase sales.
 */
SELECT c.CategoryID,
    c.categoryName,
    COUNT(l.listingID) AS Items
FROM Listing l
    JOIN Category c ON c.CategoryID = l.CategoryID
WHERE l.status = 'A'
    AND l.datePosted <= DATE_SUB(NOW(), INTERVAL 2 MONTH)
GROUP BY c.CategoryID,
    c.categoryName
ORDER BY Items DESC;
-- BREAK
-- 7. Count of saved listings per user
/*
 Objective: This query provides insight into user engagement and interest levels on the platform.
 For example, a user with a high count of saved listings is likely very active and interested in multiple items, indicating high potential for future transactions.
 This information can help in tailoring personalized recommendations and marketing strategies for each user based on their saved listings.
 */
SELECT u.userName,
    COUNT(s.listingID) AS savedListingCount
FROM SavedListing s
    LEFT JOIN User u ON u.userID = s.userID
GROUP BY u.userID
ORDER BY savedListingCount DESC;
-- BREAK
-- 8. Conversion rate for sellers
/*
 Objective: This query provides insight into the effectiveness of each seller in converting listings into sales.
 For example, a high conversion rate indicates that a seller is successful in selling their listed items, possibly due to competitive pricing, high-quality items, or effective communication.
 This information can help sellers understand their performance and identify areas for improvement to increase their sales.
 */
SELECT temp2.sellerID,
    temp2.total_listings AS totalListings,
    temp.sold_listings / temp2.total_listings AS conversion
FROM (
        SELECT sellerID,
            COUNT(status) as total_listings
        FROM Listing
        GROUP BY sellerID
    ) as temp2,
    (
        SELECT sellerID,
            COUNT(status) AS sold_listings
        FROM Listing
        WHERE status = 'S'
        GROUP BY sellerID
    ) as temp
WHERE temp.sellerID = temp2.sellerID
ORDER BY conversion;
-- BREAK
-- 9. Highest review contributors
/*
 Objective: This query identifies the users who contribute the most reviews.
 For example, if user 'JohnDoe' has the highest number of reviews, it suggests that he is highly active in providing feedback on the platform.
 This information can be used to recognize and reward active users, encouraging more user engagement and community building.
 */
SELECT u.userID,
    u.username,
    COUNT(r.reviewID) AS reviewsCount
FROM User u
    JOIN Review r ON u.userID = r.reviewPosterID
GROUP BY u.userID,
    u.username
ORDER BY reviewsCount DESC;
-- BREAK
-- 10. Impact of media on sales conversion by category
/*
 Objective: This query provides insight into the effectiveness of media (like photos or videos) in driving sales conversions across different categories.
 For example, if the 'Furniture' category has a high sales-to-media ratio, it suggests that media plays a significant role in influencing purchases in this category.
 This information can guide sellers on the importance of including high-quality media in their listings to potentially increase sales.
 */
SELECT sales_total.categoryName AS Category,
    total_sold AS totalSales,
    sold_w_media AS mediaSales,
    (sold_w_media / total_sold) AS mediaConversionRate
FROM -- Sold products which have media per category
    (
        SELECT c.categoryName,
            c.categoryID,
            COUNT(l.listingID) AS sold_w_media
        FROM Listing l
            JOIN Category c ON l.categoryID = c.categoryID
        WHERE l.status = 'S'
            AND l.listingID IN (
                SELECT DISTINCT m.listingID
                FROM Media m
            )
        GROUP BY c.categoryName,
            c.categoryID
    ) AS sales_media
    JOIN -- All sold products by category
    (
        SELECT c.categoryName,
            c.categoryID,
            COUNT(l.listingID) AS total_sold
        FROM Listing l
            JOIN Category c ON l.categoryID = c.categoryID
        WHERE l.status = 'S'
        GROUP BY c.categoryName,
            c.categoryID
    ) AS sales_total ON sales_media.categoryID = sales_total.categoryID;
-- BREAK
-- 11. Count of active listings per seller
/*
 Objective: This query provides insight into the activity level of each seller on the platform.
 For example, if a seller has a high count of active listings, it indicates that they are highly active and potentially a significant contributor to the platform's inventory.
 This information can help in identifying top sellers for potential partnerships, rewards, or for targeted marketing campaigns.
 */
SELECT u.userName,
    COUNT(l.listingID) AS activeListingCount
FROM Listing l
    INNER JOIN User u ON u.userID = l.sellerID
WHERE l.status = 'A'
GROUP BY l.sellerID
ORDER BY activeListingCount DESC;
-- BREAK
-- 12. Total revenue per seller
/*
 Objective: This query provides insight into the total earnings of each seller on the platform.
 For example, if Seller A has a higher total revenue than Seller B, it indicates that Seller A's listings are more profitable or more frequently sold.
 This information can be used to identify top-performing sellers, understand successful selling strategies, and provide targeted support or incentives to improve seller performance.
 */
SELECT sellerID,
    COUNT(listingID) AS numListingsSold,
    SUM(price) AS totalRevenue
FROM Listing
WHERE status = 'S'
GROUP BY sellerID
ORDER BY totalRevenue DESC;
-- BREAK
-- 13. Rank sellers by the total number of their listings in each location
/*
 Objective: This query provides insight into the activity level of sellers in different locations.
 For example, if a seller in 'New York' has the highest number of listings, it suggests that this seller is particularly active or has a large inventory.
 This information can help in identifying top sellers in each location, which can be useful for localized marketing strategies or for understanding regional market dynamics.
 */
SELECT loc.city,
    u.userName,
    COUNT(l.listingID) AS listingCount
FROM Listing l
    INNER JOIN User u ON u.userID = l.sellerID
    INNER JOIN Location loc ON loc.locationID = l.locationID
GROUP BY u.userID,
    l.locationID
ORDER BY listingCount DESC,
    city ASC;
-- BREAK
-- 14. Average rating per seller
/*
 Objective: This query provides insight into the quality of service provided by each seller.
 For example, a high average rating indicates a seller who consistently provides good service, while a low average rating may indicate a seller who needs to improve their service.
 This information can help buyers in choosing reliable sellers and can guide platform administrators in identifying and assisting underperforming sellers.
 */
SELECT u.userID,
    u.username,
    COUNT(r.rating) AS numRatings,
    AVG(r.rating) AS avgRating
FROM User u
    JOIN Review r ON u.userID = r.reviewReceiverID
GROUP BY u.userID,
    u.username
ORDER BY numRatings DESC,
    avgRating DESC;
-- BREAK
-- 15. Number of unique buyers per seller
/*
 Objective: This query provides insight into the customer base size for each seller.
 For example, a seller with a high number of unique buyers could indicate a popular seller with a diverse range of products appealing to a wide audience.
 This information can help sellers understand their reach and influence, and can guide strategies for customer retention and expansion.
 */
SELECT u.userID,
    l.listingID,
    u.userName,
    COUNT(DISTINCT m.receiverID) AS uniqueBuyerCount
FROM Listing l
    INNER JOIN User u ON u.userID = l.sellerID
    INNER JOIN Message m ON m.listingID = l.listingID
GROUP BY u.userID,
    l.listingID
ORDER BY u.userID ASC,
    l.listingID ASC,
    uniqueBuyerCount DESC;
-- BREAK
-- 16. Popular posts saved by users
/*
 Objective: This query identifies the most popular listings that users have saved for later reference.
 For example, if a particular 'Vintage Furniture' listing is saved by a large number of users, it indicates a high interest in that item.
 This information can help sellers understand what items are currently trending, allowing them to adjust their offerings to meet demand.
 */
SELECT l.listingID,
    l.title,
    COUNT(sl.userID) as savedBy
FROM Listing l
    LEFT JOIN SavedListing sl ON l.listingID = sl.listingID
GROUP BY l.listingID
ORDER BY savedBy DESC;
-- BREAK
-- 17. Total number of listings per location
/*
 Objective: This query provides insight into the geographical distribution of listings.
 For example, if a particular city or ZIP code has a high number of listings, it suggests that users in that area are particularly active on the platform.
 This information can help in tailoring location-specific marketing strategies and understanding regional user engagement.
 */
SELECT l1.locationID,
    l2.city,
    COUNT(l1.listingID) AS TotalListings
FROM Listing l1
    LEFT JOIN Location l2 ON l2.locationID = l1.locationID
GROUP BY l1.locationID
ORDER BY TotalListings DESC;
-- BREAK
-- 18. Underperforming listings
/*
 Objective: This query identifies listings that are not performing well, possibly indicated by factors such as low views, low saves, or extended time on the platform without being sold.
 For example, if a particular 'Vintage Lamp' listing has been active for several months but has few views or saves, it would be considered underperforming.
 This information can help sellers to revise their listing strategies, such as improving their product descriptions, photos, or pricing, to attract more potential buyers.
 */
SELECT listingID,
    title,
    datePosted
FROM Listing
WHERE status = 'A'
ORDER BY `Listing`.`datePosted` ASC
LIMIT 10;
-- BREAK
-- 19. Query product listings by title and location
/*
 Objective: This query provides a way to search for specific product listings based on their title and location.
 For example, if a user is looking for a 'Vintage Lamp' in 'New York', this query will return all listings that match these criteria.
 This feature enhances the user experience by making it easier to find specific items in a preferred location, potentially increasing the likelihood of transactions.
 */
SELECT l.listingID,
    title,
    description,
    price,
    status,
    datePosted,
    c.categoryName,
    lo.city,
    u.userName
FROM Listing l
    INNER JOIN Location lo ON lo.locationID = l.locationID
    INNER JOIN Category c ON c.categoryID = l.categoryID
    INNER JOIN User u ON u.userID = l.sellerID
WHERE title LIKE '%{title}%'
    AND lo.city LIKE '%{location}%';
-- BREAK
-- 20. Number of searches by keyword
/*
 Objective: This query provides insight into the most searched keywords on the platform.
 For example, if the keyword 'vintage furniture' has a high search count, it suggests that there is a high demand or interest in vintage furniture among users.
 This information can guide sellers in listing relevant items and can help the platform optimize its search engine to better cater to user interests.
 */
SELECT query,
    COUNT(searchID) AS searchCount
FROM Search
WHERE query LIKE '%{keyword}%'
GROUP BY query
ORDER BY searchCount DESC;