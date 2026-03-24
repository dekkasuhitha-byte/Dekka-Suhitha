-- Create Database
CREATE DATABASE Library;
USE Library;

-- Table: tbl_publisher
CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(15)
);
INSERT INTO tbl_publisher 
VALUES ('Pearson', 'Some Address', '1234567890'),
('HarperCollins', '195 Broadway, New York, NY', '2125551000'),
('Penguin Random House', '1745 Broadway, New York, NY', '2125552000'),
('Oxford Press', 'Great Clarendon St, Oxford, UK', '441865556600'),
('Vintage Books', '1745 Broadway, New York, NY', '2125553000');

-- Table: tbl_book
CREATE TABLE tbl_book (
    book_BookID INT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
);

INSERT INTO tbl_book 
VALUES (1, 'The Lost Tribe', 'Pearson'),
(2, 'The Silent River', 'HarperCollins'),
(3, 'Mystery of the Blue Train', 'Penguin Random House'),
(4, 'Winds of the Desert', 'Oxford Press'),
(5, 'Shadows of the Night', 'Vintage Books'),
(6, 'The Secret Garden', 'HarperCollins'),
(7, 'Journey to the Stars', 'Penguin Random House'),
(8, 'Deep Ocean Tales', 'Oxford Press'),
 (9, 'The Shining', 'Vintage Books');

-- Table: tbl_book_authors
CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
);
INSERT INTO tbl_book_authors (book_authors_BookID, book_authors_AuthorName)
VALUES
(1, 'David Martin'),
(2, 'Clara Weston'),
(3, 'Agatha Christie'),
(4, 'Rami Al-Farid'),
(5, 'Elena Brooks'),
(6, 'Frances Hodgson Burnett'),
(7, 'Neil Avery'),
(8, 'Marina Ortiz'),
(9, 'Stephen King');

-- Table: tbl_library_branch
CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);
INSERT INTO tbl_library_branch 
VALUES (1, 'Sharpstown', 'Houston, TX'),
(2, 'Central Library', 'Downtown, Houston, TX'),
(3, 'Westside Branch', 'Westheimer Rd, Houston, TX'),
(4, 'Northview Branch', 'Greenspoint, Houston, TX'),
(5, 'Eastwood Library', 'Eastwood St, Houston, TX'),
(6, 'Southridge Branch', 'Southridge Dr, Houston, TX'),
(7, 'Maple Leaf Library', 'Maple Ave, Houston, TX'),
(8, 'Riverstone Branch', 'Riverstone Blvd, Houston, TX');


-- Table: tbl_book_copies
CREATE TABLE tbl_book_copies (
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
);

INSERT INTO tbl_book_copies (book_copies_BookID, book_copies_BranchID, book_copies_No_Of_Copies)
VALUES (1, 1, 5),
(1, 2, 3), 
(2, 3, 2),
(3, 1, 6), 
(4, 7, 3), 
(5, 8, 6), 
(6, 5, 3), 
(7, 6, 2), 
(8, 1, 1),
(9, 2, 10);


-- Table: tbl_borrower
CREATE TABLE tbl_borrower (
    borrower_CardNo INT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress TEXT,
    borrower_BorrowerPhone VARCHAR(15)
);

INSERT INTO tbl_borrower
VALUES
(101, 'Sarah Johnson', 'Houston, TX', '8325551001'),
(102, 'Michael Lee', 'Sugar Land, TX', '8325551002'),
(103, 'Aisha Patel', 'Pearland, TX', '8325551003'),
(104, 'Daniel Gomez', 'Richmond, TX', '8325551004'),
(105, 'Emily Carter', 'Katy, TX', '8325551005');

-- Table: tbl_book_loans
CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID),
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
);

INSERT INTO tbl_book_loans 
(book_loans_BookID, book_loans_BranchID, book_loans_CardNo, book_loans_DateOut, book_loans_DueDate)
VALUES
(1, 1, 101, '2018-01-20', '2018-02-03'),   -- The Lost Tribe, Sharpstown
(3, 1, 102, '2018-01-25', '2018-02-03'),   -- Mystery of the Blue Train, Sharpstown
(6, 1, 103, '2018-01-28', '2018-02-03');   -- The Secret Garden, Sharpstown

-- 1 How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"? 
SELECT 
    tbl_book.book_Title,
    tbl_book_copies.book_copies_No_Of_Copies
FROM tbl_book_copies
JOIN tbl_book 
    ON tbl_book_copies.book_copies_BookID = tbl_book.book_BookID
JOIN tbl_library_branch
    ON tbl_book_copies.book_copies_BranchID = tbl_library_branch.library_branch_BranchID
WHERE tbl_book.book_Title = 'The Lost Tribe'
  AND tbl_library_branch.library_branch_BranchName = 'Sharpstown';

-- 2 How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT lb.library_branch_BranchName,
       bc.book_copies_No_Of_Copies
FROM tbl_book_copies bc
JOIN tbl_library_branch lb 
    ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE bc.book_copies_BookID = (
    SELECT book_BookID 
    FROM tbl_book 
    WHERE book_Title = 'The Lost Tribe'
);

-- 3 Names of all borrowers who do NOT have any books checked out
SELECT b.borrower_BorrowerName
FROM tbl_borrower b
LEFT JOIN tbl_book_loans bl
    ON b.borrower_CardNo = bl.book_loans_CardNo
WHERE bl.book_loans_CardNo IS NULL;

-- 4 From Sharpstown branch, DueDate = 2018-02-03 — retrieve Book Title + Borrower Name + Address
SELECT bk.book_Title,
       br.borrower_BorrowerName,
       br.borrower_BorrowerAddress
FROM tbl_book_loans bl
JOIN tbl_book bk
    ON bl.book_loans_BookID = bk.book_BookID
JOIN tbl_borrower br
    ON bl.book_loans_CardNo = br.borrower_CardNo
JOIN tbl_library_branch lb
    ON bl.book_loans_BranchID = lb.library_branch_BranchID
WHERE lb.library_branch_BranchName = 'Sharpstown'
  AND bl.book_loans_DueDate = '2018-02-03';
  
 -- 5 For each library branch, retrieve branch name + total number of books loaned out
 SELECT lb.library_branch_BranchName,
       COUNT(bl.book_loans_LoansID) AS TotalLoans
FROM tbl_library_branch lb
LEFT JOIN tbl_book_loans bl
    ON lb.library_branch_BranchID = bl.book_loans_BranchID
GROUP BY lb.library_branch_BranchID, lb.library_branch_BranchName;

-- 6 Borrowers who have more than 5 books checked out
SELECT br.borrower_BorrowerName,
       br.borrower_BorrowerAddress,
       COUNT(bl.book_loans_LoansID) AS BooksCheckedOut
FROM tbl_borrower br
JOIN tbl_book_loans bl
    ON br.borrower_CardNo = bl.book_loans_CardNo
GROUP BY br.borrower_CardNo, br.borrower_BorrowerName, br.borrower_BorrowerAddress
HAVING COUNT(bl.book_loans_LoansID) > 5;

-- 7 Books authored by “Stephen King” at the “Central” branch → title + #copies
SELECT bk.book_Title,
       bc.book_copies_No_Of_Copies
FROM tbl_book_authors ba
JOIN tbl_book bk
    ON ba.book_authors_BookID = bk.book_BookID
JOIN tbl_book_copies bc
    ON bk.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch lb
    ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE ba.book_authors_AuthorName = 'Stephen King'
  AND lb.library_branch_BranchName = 'Central Library';


