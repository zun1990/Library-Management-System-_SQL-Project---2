-- Adding data for advance analysis
INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 24 day,  '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 13 day,  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL 7 day,  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL 32 day,  '978-0-375-50167-0', 'E101');

-- Adding new column in the return_status
ALTER TABLE return_status
ADD COLUMN book_quality VARCHAR(15) DEFAULT 'Good';
SELECT * FROM return_status;
UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id IN ('IS112','IS117','IS118');
SELECT * FROM return_status;

-- Advanced SQL Operations
/*  Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.*/
SELECT * FROM return_status;
WITH overdue_books AS
(
SELECT * 
FROM issued_status i 
LEFT JOIN return_status r
 USING(issued_id)
 LEFT JOIN members m
ON i.issued_member_id = m.member_id
)
SELECT member_id , member_name , issued_book_name , issued_date , 
DATEDIFF(CURRENT_DATE ,issued_date) AS over_due
FROM overdue_books
WHERE return_date IS NULL 
AND DATEDIFF(CURRENT_DATE ,issued_date) >30;

--  Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table)
SELECT * FROM books;
SELECT * FROM return_status;
SELECT * FROM issued_status;

-- Need to create store procedure 
DELIMITER //
CREATE PROCEDURE add_return_book(p_return_id VARCHAR(10),p_issued_id VARCHAR(10),p_book_quality VARCHAR(15))
BEGIN
DECLARE v_isbn VARCHAR(50);
SELECT 
issued_book_isbn INTO v_isbn
FROM issued_status
WHERE issued_id = issued_id;
-- Inserting into return table based on user input 
INSERT INTO return_status (return_id , issued_id , return_date,book_quality)
VALUES(p_return_id,p_issued_id,CURRENT_DATE,p_book_quality);
UPDATE books
SET status = 'YES'
WHERE isbn = v_isbn;

END //
DELIMITER ;

-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issued_status
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
                    )
;


SELECT * FROM active_members;
