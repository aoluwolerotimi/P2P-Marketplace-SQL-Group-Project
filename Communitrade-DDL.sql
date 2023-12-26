-- @block create "users" table
CREATE TABLE IF NOT EXISTS `User` (
    userID INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phoneNumber VARCHAR(255) NOT NULL,
    PRIMARY KEY (userID)
);
-- @block create "searches" table
CREATE TABLE IF NOT EXISTS `Search` (
    searchID INT NOT NULL AUTO_INCREMENT,
    query VARCHAR(255) NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    userID INT NOT NULL,
    PRIMARY KEY (searchID),
    FOREIGN KEY (userID) REFERENCES User(userID)
);
-- @block create "reviews" table
CREATE TABLE IF NOT EXISTS `Review` (
    reviewID INT NOT NULL AUTO_INCREMENT,
    rating INT NOT NULL,
    comment VARCHAR(255) NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reviewPosterID INT NOT NULL,
    reviewReceiverID INT NOT NULL,
    PRIMARY KEY (reviewID),
    FOREIGN KEY (reviewPosterID) REFERENCES User(userID),
    FOREIGN KEY (reviewReceiverID) REFERENCES User(userID)
);
-- @block create "location" table
CREATE TABLE IF NOT EXISTS `Location` (
    locationID INT NOT NULL AUTO_INCREMENT,
    city VARCHAR(255) NOT NULL,
    ZIPCode VARCHAR(255) NOT NULL,
    PRIMARY KEY (locationID)
);
-- @block create "category" table
CREATE TABLE IF NOT EXISTS `Category` (
    categoryID INT NOT NULL AUTO_INCREMENT,
    categoryName VARCHAR(255) NOT NULL,
    categoryDescription VARCHAR(255) NOT NULL,
    PRIMARY KEY (categoryID)
);
-- @block create "listing" table
CREATE TABLE IF NOT EXISTS `Listing` (
    listingID INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(255) NOT NULL,
    datePosted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dateSold TIMESTAMP NULL DEFAULT NULL,
    categoryID INT NOT NULL,
    locationID INT NOT NULL,
    sellerID INT NOT NULL,
    PRIMARY KEY (listingID),
    FOREIGN KEY (categoryID) REFERENCES Category(categoryID),
    FOREIGN KEY (locationID) REFERENCES Location(locationID),
    FOREIGN KEY (sellerID) REFERENCES User(userID)
);
-- @block create "messages" table
CREATE TABLE IF NOT EXISTS `Message` (
    messageID INT NOT NULL AUTO_INCREMENT,
    messageText VARCHAR(255) NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    senderID INT NOT NULL,
    receiverID INT NOT NULL,
    listingID INT NOT NULL,
    PRIMARY KEY (messageID),
    FOREIGN KEY (senderID) REFERENCES User(userID),
    FOREIGN KEY (receiverID) REFERENCES User(userID),
    FOREIGN KEY (listingID) REFERENCES Listing(listingID)
);
-- @block create "media" table
CREATE TABLE IF NOT EXISTS `Media` (
    mediaID INT NOT NULL AUTO_INCREMENT,
    mediaURL VARCHAR(255) NOT NULL,
    listingID INT NOT NULL,
    PRIMARY KEY (mediaID),
    FOREIGN KEY (listingID) REFERENCES Listing(listingID)
);
-- @block create "saved listings" table
CREATE TABLE IF NOT EXISTS `SavedListing` (
    savedListingID INT NOT NULL AUTO_INCREMENT,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    userID INT NOT NULL,
    listingID INT NOT NULL,
    PRIMARY KEY (savedListingID),
    FOREIGN KEY (userID) REFERENCES User(userID),
    FOREIGN KEY (listingID) REFERENCES Listing(listingID)
);