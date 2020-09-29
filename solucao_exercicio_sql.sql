SELECT c.contest_id, c.hacker_id, c.name,
   IFNULL (SUM(s.total_submissions), 0) as total_submissions,
   IFNULL (SUM(s.total_accepted_submissions), 0) as total_accepted_submissions,
   IFNULL (SUM(v.total_views), 0) as total_views,
   IFNULL (SUM(v.total_unique_views), 0) as total_unique_views
FROM concursos c
JOIN faculdades f ON f.contest_id = c.contest_id
JOIN desafios d ON d.college_id = f.college_id
LEFT JOIN (
   SELECT 
      challenge_id, 
      SUM(total_views) as total_views,
      SUM(total_unique_views) as total_unique_views
   FROM view_stats
   GROUP BY challenge_id
) v ON v.challenge_id = d.challenge_id
LEFT JOIN (
   SELECT 
      challenge_id,
      SUM(total_submissions) as total_submissions,
      SUM(total_accepted_submissions) as total_accepted_submissions
   FROM submission_stats
   GROUP BY challenge_id
) s ON s.challenge_id = d.challenge_id
GROUP BY c.contest_id
HAVING
   IFNULL(SUM(s.total_submissions), 0) <> 0
   OR IFNULL(SUM(s.total_accepted_submissions), 0) <> 0
   OR IFNULL(SUM(v.total_views), 0) <> 0
   OR IFNULL(SUM(v.total_unique_views), 0) <> 0;