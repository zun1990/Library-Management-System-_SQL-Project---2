--  Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table)
SELECT * FROM books;
SELECT * FROM return_status;
SELECT * FROM issued_status;

-- Need to create store procedure 
DROP PROCEDURE IF EXISTS add_return_book;
DELIMITER //
CREATE PROCEDURE add_return_book(p_return_id VARCHAR(10),p_issued_id VARCHAR(10),p_book_quality VARCHAR(15))
BEGIN
DECLARE v_isbn VARCHAR(50);
SELECT 
issued_book_isbn INTO v_isbn
FROM issued_status
WHERE issued_id = p_issued_id;
-- Inserting into return table based on user input 
INSERT INTO return_status (return_id , issued_id , return_date,book_quality)
VALUES(p_return_id,p_issued_id,CURRENT_DATE,p_book_quality);
UPDATE books
SET status = 'Yes'
WHERE isbn = v_isbn;

END //
DELIMITER ;

CALL add_return_book('RS138','IS135','Good');
SELECT * FROM return_status;
SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM issued_status;
SELECT * FROM books_cnt;
SELECT * FROM employees;
USE sql_project_2;

/*  Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals. Save it as a view*/
CREATE VIEW branch_performance AS (
SELECT b.branch_id , COUNT(i.issued_id) AS num_book_issued ,
COUNT(r.return_id) AS num_book_return ,
SUM(bk.rental_price) AS total_revenue
FROM issued_status i
JOIN employees e
ON i.issued_emp_id = e.emp_id
JOIN branch b
ON e.branch_id = b.branch_id
LEFT JOIN return_status r
ON i.issued_id = r.issued_id
JOIN books bk
ON i.issued_book_isbn = bk.isbn
GROUP BY 1);

