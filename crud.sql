--  CRUD Operations
-- 1.Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
SELECT * FROM books;
INSERT INTO books(isbn , book_title ,category , rental_price , status , author , publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Update an Existing Member's C103 Address into 125 Oak St 
SELECT * FROM members;
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';

-- Delete the record with issued_id = 'IS121' from the issued_status table.
SELECT * FROM issued_status;
DELETE FROM issued_status
WHERE issued_id = 'IS121';

-- Select all books issued by the employee with emp_id = 'E101'.
SELECT issued_emp_id ,issued_book_name 
FROM issued_status
WHERE issued_emp_id = 'E101';

-- List Members Who Have Issued More Than One Book
SELECT issued_member_id , COUNT(*) AS num_books_issued 
FROM issued_status
GROUP BY 1
HAVING COUNT(*) >1
ORDER BY 2;

-- Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
CREATE TABLE books_cnt (
SELECT b.isbn ,b.book_title, COUNT(i.issued_id) AS total_book_issued
 FROM books b
JOIN issued_status i
ON b.isbn = i.issued_book_isbn
GROUP BY 1,2);
SELECT * FROM books_cnt;






