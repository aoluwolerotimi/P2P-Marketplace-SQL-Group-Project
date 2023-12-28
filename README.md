# SQL Relational Database for Peer-to-Peer Marketplace
 In this group project, our team of four defined a relational database to support a fictional P2P marketplace platform,  created example analytical queries for it, and loaded dummy data to verify functionality. 
 _Note: This repo includes the definition of the tables and their relationships (Communitrade-DDL.sql) and the example queries (Communitrade-DDL.sql) but does not include the data loads (Communitrade-DML.sql)_


## Context & Functionality
Our imagined platform - Communitrade - is a peer to peer buy-and-sell application that facilitates trade exchanges between users in the same location. CommuniTrade currently only operates in Canada.

The platform allows users to list items for sale, discover products, chat with other users to purchase products, leave reviews, and save posts for later viewing.

## Data Modeling and Schemas
#### ERD
Image URL will go here

#### Physical Model Representation
Image URL will go here

## Highlighted Analytical Queries - Platform Health Checks
#### Conversion Rate for Sellers
This indicates how well the platform is doing at turning posted listings into actual sales. When more listings are turning into successful sales, it means that CommuniTrade is facilitating exchanges which meet the needs of both sellers and buyers.​

#### Monthly Category Growth Rate
By assessing the month-over-month listing growth rate, the business gains insight into how the platform is evolving and overall platform viability. ​

Since each category within the platform represents distinct consumer markets, varying growth expectations are natural. By offering growth comparisons tailored to each category, the platform can be fine-tuned to measure against diverse business targets.​ With this information, the business can detect when categories are trending above the expected baseline and capitalize on that.
Similarly, the business can detect lackluster growth categories to target for intervention and then monitor results. ​

## Appendix - Relational Schema
User (UserID, Username, Email, PhoneNumber)
Primary Key: UserID

Listing (ListingID, Title, Description, Price, Status, DatePosted, DateSold CategoryID, LocationID, SellerID)
Primary Key: ListingID
Foreign Key: CategoryID References Category(CategoryID)
Foreign Key: LocationID References Location(LocationID)
Foreign Key: SellerID References User(UserID)
 
Category (CategoryID, Name, Description)
Primary Key: CategoryID

Messages (MessageID, Text, Timestamp, SenderID, ReceiverID, ListingID)
Primary Key: MessageID
Foreign Key: SenderID References User(UserID)
Foreign Key: ReceiverID References User(UserID)
Foreign Key: ListingID References Listing(ListingID)

Reviews (ReviewID, Rating, Content, Timestamp, reviewPosterID, reviewReceiverID)
Primary Key: ReviewID
Foreign Key: reviewPosterID References User(UserID)
Foreign Key: reviewReceiverID References User(UserID)

SavedListing (SavedListingID, Timestamp, UserID, ListingID)
Primary Key: SavedListingID
Foreign Key: UserID References User(UserID)
Foreign Key: ListingID References Listing(ListingID)
 
Location (LocationID, City, ZIPCode)
Primary Key: LocationID

Media (MediaID, URL, ListingID)
Primary Key: MediaID
Foreign Key: ListingID References Listing(ListingID)

Searches (SearchID, Query, Timestamp, UserID)
Primary Key: SearchID
Foreign Key: UserID References User(UserID)



