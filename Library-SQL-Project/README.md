# 📚 Library Management System — SQL Project

**Domain:** Library & Information Management  
**Level:** Beginner – Intermediate  
**Tools:** MySQL  
**Completed at:** Innomatics Research Labs (Sep 2026 – Present)

---

## Project Overview

This project involves designing and querying a relational database for a Library Management System. The database tracks books, authors, publishers, library branches, borrowers, and book loans across multiple branches.

---

## Database Schema

| Table | Description |
|---|---|
| `tbl_publisher` | Publisher details (name, address, phone) |
| `tbl_book` | Book catalog with publisher reference |
| `tbl_book_authors` | Author names linked to books |
| `tbl_library_branch` | 8 library branch locations |
| `tbl_book_copies` | Number of copies per book per branch |
| `tbl_borrower` | Borrower card details |
| `tbl_book_loans` | Loan records with due dates |

---

## Key SQL Queries Performed

1. How many copies of a specific book are owned by a particular branch?
2. How many copies of a book are owned by **each** library branch?
3. Names of all borrowers who currently have **no books** checked out
4. Books checked out from Sharpstown branch due on a specific date — with borrower names and addresses
5. Total number of books loaned out **per branch**
6. Borrowers who have checked out **more than 5 books**
7. Books authored by a specific author available at a specific branch

---

## Concepts Used

- `JOIN` (INNER, LEFT)
- `GROUP BY` and `HAVING`
- Subqueries
- Aggregate functions (`COUNT`)
- Foreign key relationships
- Multi-table relational design

---

## How to Run

1. Open MySQL Workbench or any MySQL client
2. Run `Sql_Library_project.sql` — it creates the database, all tables, inserts data, and runs all queries
3. Results will appear for each labelled query section

---

## Sample Output (Query 5 — Total Loans Per Branch)

| Branch Name | Total Loans |
|---|---|
| Sharpstown | 3 |
| Central Library | 0 |
| Westside Branch | 0 |
| ... | ... |

