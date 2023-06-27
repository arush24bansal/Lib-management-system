USE libraryMngSys;


/*=================== STORED PROCEDURES FOR ALL ANSWERS ================================= */ 
DELIMITER //  

DROP PROCEDURE IF EXISTS getDayWiseIssues//
CREATE PROCEDURE getDayWiseIssues()
BEGIN
	SELECT
		(CASE
			WHEN day = 0 THEN 'Monday'
			WHEN day = 1 THEN 'Tuesday'
			WHEN day = 2 THEN 'Wednesday'
			WHEN day = 3 THEN 'Thursday'
			WHEN day = 4 THEN 'Friday'
			WHEN day = 5 THEN 'Saturday'
			ELSE 'Sunday'
		END) AS "weekday",
		issue_count
	FROM (
		SELECT
			WEEKDAY(Issue_date) AS "day",
			COUNT(member_id) AS issue_count
		FROM Issues
		GROUP BY WEEKDAY(Issue_date)
	) a
	ORDER BY day;
END //


DROP PROCEDURE IF EXISTS getMarchInventory//
CREATE PROCEDURE getMarchInventory()
BEGIN
	WITH cte AS (
		SELECT Issue_date as dates, 1 AS issued, 0 AS returned
		FROM Issues
		WHERE Issue_Date < '2022-04-01' 

		UNION ALL

		SELECT Return_date, 0 AS issued, 1 AS returned
		FROM Issues
		WHERE Return_date < '2022-04-01'
	), cte2 AS (
		SELECT
			dates, SUM(issued) AS issued, SUM(returned) AS returned,
			SUM(issued) - SUM(returned) AS effect
		FROM cte
		GROUP BY dates
	), cte3 AS (
		SELECT dates, issued, returned,
		SUM(effect) OVER(ORDER BY dates ASC) AS books_in_issue
		FROM cte2
	)
	SELECT *
	FROM cte3
	WHERE MONTH(dates) = 3;
END //


DROP PROCEDURE IF EXISTS getOutstandingDues//
CREATE PROCEDURE getOutstandingDues()
BEGIN
	SELECT i.Member_id, m.First_name AS name, SUM(datediff(i.Return_date, i.Due_date) * 10) AS Amount_due 
	FROM issues i
	JOIN members m
	ON i.Member_id = m.ID
	WHERE i.Due_date < i.Return_date
	GROUP BY i.Member_id;
END // 


DROP PROCEDURE IF EXISTS getLongestDuration//
CREATE PROCEDURE getLongestDuration()
BEGIN
	WITH cte AS (
		SELECT member_id, issue_date,
		(CASE WHEN return_date IS NULL THEN '2022-05-09' ELSE return_date END) AS return_date
		FROM issues
	), cte2 AS (
		SELECT *,
			LAG(return_date) OVER w AS previous,
			datediff(return_date, issue_date) AS count,
			ROW_NUMBER() OVER w AS rn
		FROM cte
		WINDOW W AS (PARTITION BY member_id ORDER BY issue_date ASC) 
	), cte3 AS (
		SELECT *,
			rn - SUM(CASE WHEN issue_date = previous THEN 1 ELSE 0 END)
			OVER(PARTITION BY member_id ORDER BY issue_date) AS continuity
		FROM cte2
	)

	SELECT member_id, MIN(issue_date) AS start_date, MAX(return_date) AS end_date, SUM(count) AS count
	FROM cte3
	GROUP BY member_id, continuity
	ORDER BY count DESC
	LIMIT 3;
END //


DROP PROCEDURE IF EXISTS getIssuesPerBook//
CREATE PROCEDURE getIssuesPerBook()
BEGIN
	SELECT a.id, a.first_name,
		ROUND((COUNT(issue_date) * 1.0)/ COUNT(DISTINCT b.id), 2) AS issues_per_book
	FROM authors a
	LEFT JOIN books b
	ON a.id = b.author_id
	LEFT JOIN issues i
	ON  b.id = i.book_id
	GROUP BY a.id, a.first_name;
END //

DELIMITER ;

/*================================= CALLS TO PROCEDURES ================================= */

-- ANSWER 1 
-- CALL getDayWiseIssues();

-- ANSWER 2 
-- CALL getMarchInventory();

-- ANSWER 3
-- CALL getOutstandingDues();

-- ANSWER 4 
-- CALL getLongestDuration();

-- ANSWER 5 
-- CALL getIssuesPerBook();