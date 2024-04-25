-- 코드를 작성해주세요

SELECT COUNT(*) AS fish_count, b.fish_name AS fish_name
FROM fish_info a
INNER JOIN fish_name_info b ON a.fish_type = b.fish_type
GROUP BY b.fish_name
ORDER BY COUNT(*) desc; -- 여기서 별칭 못 쓴다. 