SELECT ID,
	   round(avg((CASE WHEN name = 'A' THEN val END))) AS "A",
	   round(avg((CASE WHEN name = 'B' THEN val END))) AS "B",
	   round(avg((CASE WHEN name = 'C' THEN val END))) AS "C"
FROM test
GROUP BY ID
ORDER BY ID

