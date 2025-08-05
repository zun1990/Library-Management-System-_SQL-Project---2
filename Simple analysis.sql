-- Data Analysis & Findings
-- Retrieve All Books in a Specific Category:
SELECT *
FROM books
WHERE category = 'Children';

-- Find Total Rental Income by Category:

SELECT b.category , SUM(b.rental_price ) AS rental_income
FROM books b 
JOIN books_cnt bc 
ON b.isbn = bc.isbn
GROUP BY 1;

-- List Members Who Registered before ,in the Last 120 Days from the date 2022-01-05 
SELECT *
 FROM members
 WHERE reg_date <= '2022-01-05' - INTERVAL 120 day;
 
 -- List Employees with Their Branch Manager's Name and their branch details:
 SELECT * FROM branch;
 SELECT e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
 FROM employees e1
 JOIN branch b
 USING(branch_id)
 JOIN employees e2
 ON b.manager_id = e2.emp_id;
 
 -- Retrieve the List of Books Not Yet Returned
SELECT * FROM return_status;
SELECT * 
FROM issued_status i 
LEFT JOIN return_status r
 USING(issued_id)
 WHERE r.return_date IS NULL;
 
 