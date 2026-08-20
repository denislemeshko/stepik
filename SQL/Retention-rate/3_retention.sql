WITH 
retention AS (
	WITH
	month_day AS (
		WITH 
		login AS (SELECT user_id,
				   EXTRACT(MONTH FROM created_at) AS log_month,
				   EXTRACT(DAY FROM created_at) AS log_day
				   FROM client_session
				   WHERE EXTRACT(YEAR FROM created_at) >= 2022
				   GROUP BY 1, 2, 3),

		installs AS (SELECT user_id,
					 EXTRACT(MONTH FROM installed_at) AS inst_month
					 FROM user
					 WHERE EXTRACT(YEAR FROM installed_at) >= 2022)
		SELECT login.user_id,
			   installs.inst_month,
			   login.log_month,
			   login.log_day
		FROM installs
		FULL OUTER JOIN login ON installs.user_id = login.user_id
		WHERE login.log_month - installs.inst_month = 1)

	SELECT md.inst_month,
		   SUM(CASE WHEN md.log_day = 1 THEN 1 ELSE 0 END) AS day_1,
		   SUM(CASE WHEN md.log_day = 3 THEN 1 ELSE 0 END) AS day_3,
		   SUM(CASE WHEN md.log_day = 7 THEN 1 ELSE 0 END) AS day_7
	FROM month_day AS md
	GROUP BY md.inst_month)
	
SELECT rt.inst_month,
	   uc.count,
	   CAST(rt.day_1 as float) / uc.count AS day_1_retention,
	   CAST(rt.day_3 as float) / uc.count AS day_3_retention,
	   CAST(rt.day_7 as float) / uc.count AS day_7_retention
FROM retention AS rt
LEFT OUTER JOIN (
	SELECT EXTRACT(MONTH FROM installed_at) AS inst_month,
		   COUNT(DISTINCT user_id)
	FROM user
	WHERE EXTRACT(YEAR FROM installed_at) >= 2022
	GROUP BY inst_month) AS uc ON uc.inst_month = rt.inst_month
ORDER BY 1