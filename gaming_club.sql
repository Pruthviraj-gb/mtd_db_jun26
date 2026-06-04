CREATE DATABASE gaming_club;

USE gaming_club;

-- ==========================================
-- MEMBERS
-- ==========================================

CREATE TABLE Members
(
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    age TINYINT,
    gender CHAR(1),
    phone_number BIGINT UNIQUE,
    wallet_balance FLOAT DEFAULT 500,

    CHECK (gender IN ('M','F','O')),
    CHECK (wallet_balance BETWEEN 500 AND 10000),
    CHECK (
        phone_number >= 6000000000
        AND phone_number <= 9999999999
    )
);

-- ==========================================
-- GAMES
-- ==========================================

CREATE TABLE Games
(
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    game_name VARCHAR(100) NOT NULL UNIQUE,
    amount_per_person INT NOT NULL,
    min_player_count TINYINT NOT NULL,
    max_player_count TINYINT NOT NULL,
    player_count_multiple TINYINT NOT NULL,

    CHECK(min_player_count > 0),
    CHECK(max_player_count >= min_player_count),
    CHECK(player_count_multiple > 0)
);

-- ==========================================
-- RECHARGES
-- ==========================================

CREATE TABLE Recharges
(
    recharge_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    recharge_amount FLOAT NOT NULL,
    recharge_date DATE DEFAULT (CURRENT_DATE),

    CHECK(recharge_amount >= 200),

    FOREIGN KEY(member_id)
    REFERENCES Members(member_id)
    ON DELETE CASCADE
);

-- ==========================================
-- TRANSACTIONS
-- ==========================================

CREATE TABLE Transactions
(
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    game_id INT NOT NULL,
    playing_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount FLOAT NOT NULL,

    FOREIGN KEY(member_id)
    REFERENCES Members(member_id)
    ON DELETE CASCADE,

    FOREIGN KEY(game_id)
    REFERENCES Games(game_id)
    ON DELETE CASCADE
);

-- ==========================================
-- COLLECTIONS
-- ==========================================

CREATE TABLE Collections
(
    collection_id INT AUTO_INCREMENT PRIMARY KEY,
    amount FLOAT NOT NULL,
    collection_date DATE DEFAULT (CURRENT_DATE),
    rating TINYINT,
    remarks VARCHAR(255),

    CHECK(rating BETWEEN 1 AND 5)
);

-- ==========================================
-- SAMPLE MEMBERS
-- ==========================================

INSERT INTO Members
(name,age,gender,phone_number,wallet_balance)
VALUES
('Jaideep',20,'M',9876543210,1000),
('Rahul',21,'M',8765432101,1500),
('Sneha',19,'F',7654321098,2500),
('Priya',22,'F',9123456789,3000),
('Arjun',18,'M',9988776655,500);

-- ==========================================
-- SAMPLE GAMES
-- ==========================================

INSERT INTO Games
(game_name,amount_per_person,min_player_count,max_player_count,player_count_multiple)
VALUES
('BGMI',100,4,100,4),
('Valorant',150,5,10,5),
('FIFA',200,2,4,2),
('Chess',50,2,2,2),
('Ludo',40,2,4,2);

-- ==========================================
-- SAMPLE RECHARGES
-- ==========================================

INSERT INTO Recharges
(member_id,recharge_amount)
VALUES
(1,500),
(2,1000),
(3,1500),
(4,500),
(5,300);

-- ==========================================
-- SAMPLE TRANSACTIONS
-- ==========================================

INSERT INTO Transactions
(member_id,game_id,amount)
VALUES
(1,1,100),
(1,2,150),
(2,2,150),
(3,3,200),
(4,1,100),
(5,5,40);

-- ==========================================
-- SAMPLE COLLECTIONS
-- ==========================================

INSERT INTO Collections
(amount,rating,remarks)
VALUES
(5000,5,'Excellent turnout'),
(3500,4,'Good response'),
(2000,3,'Average collection');

-- ==========================================
-- USEFUL QUERIES
-- ==========================================

-- View all members
SELECT * FROM Members;

-- View all games
SELECT * FROM Games;

-- Total recharge by each member
SELECT member_id,
       SUM(recharge_amount) AS total_recharge
FROM Recharges
GROUP BY member_id;

-- Average wallet balance
SELECT AVG(wallet_balance) AS average_wallet_balance
FROM Members;

-- Maximum recharge
SELECT MAX(recharge_amount) AS maximum_recharge
FROM Recharges;

-- Total revenue per game
SELECT g.game_name,
       SUM(t.amount) AS revenue
FROM Transactions t
JOIN Games g
ON t.game_id=g.game_id
GROUP BY g.game_name;

-- Most played game
SELECT g.game_name,
       COUNT(*) AS play_count
FROM Transactions t
JOIN Games g
ON t.game_id=g.game_id
GROUP BY g.game_name
ORDER BY play_count DESC;

-- Member and games played
SELECT m.name,
       g.game_name,
       t.amount
FROM Members m
JOIN Transactions t
ON m.member_id=t.member_id
JOIN Games g
ON t.game_id=g.game_id;

-- Highest collection
SELECT MAX(amount) AS highest_collection
FROM Collections;

-- Average collection
SELECT AVG(amount) AS average_collection
FROM Collections;

-- Members who recharged more than 1000
SELECT *
FROM Members
WHERE member_id IN
(
    SELECT member_id
    FROM Recharges
    WHERE recharge_amount > 1000
);