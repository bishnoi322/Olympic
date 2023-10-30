USE olympic;
SELECT * FROM athlete_events;
SELECT * FROM noc_regions;

# How many olympic games have been held?
SELECT COUNT(DISTINCT Games) AS Total_games
FROM athlete_events;

# List down all the olympic games held so far?
 SELECT DISTINCT Games, Year
 FROM athlete_events
 ORDER BY Year;
 
 # Mention the total no of nations who participated in each olympics game?
 SELECT COUNT(DISTINCT Team) AS Cou_participated
 FROM athlete_events;

 # Which year saw the highest and lowest no of countries participating in olympics?
(SELECT Year, COUNT(DISTINCT Team) AS NumberOfTeams 
FROM athlete_events 
GROUP BY Year 
ORDER BY NumberOfTeams DESC 
LIMIT 1 )
UNION ALL 
(SELECT Year, COUNT(DISTINCT Team) AS NumberOfTeams 
FROM athlete_events 
GROUP BY Year 
ORDER BY NumberOfTeams ASC 
LIMIT 1);

#Which nation has participated in all of the olympic games? 
SELECT Team
FROM athlete_events
GROUP BY Team
HAVING COUNT(DISTINCT Games) = (SELECT COUNT(DISTINCT Games) FROM athlete_events);
 
 # Identify the sport which was played in all summer olympics.
 SELECT Sport
FROM athlete_events
WHERE Season = 'Summer'
GROUP BY Sport
HAVING COUNT(DISTINCT Year) = (SELECT COUNT(DISTINCT Year) FROM athlete_events WHERE Season = 'Summer');

# Which Sports were just played only once in the olympics? 
SELECT Sport, Games
FROM athlete_events
GROUP BY Sport
HAVING COUNT(DISTINCT Games) = 1;

#Fetch the total no of sports played in each olympic games.
SELECT COUNT(DISTINCT Sport) AS Total_sports, Games
FROM athlete_events
GROUP BY Games; 

# Fetch details of the oldest athletes to win a gold medal.
SELECT * FROM athlete_events
WHERE Medal = 'Gold'
ORDER BY Age DESC LIMIT 1;


#Find the Ratio of male and female athletes participated in all olympic games.
SELECT Sex, (COUNT(*) / (SELECT COUNT(*) FROM athlete_events)) * 100 AS ratio
FROM athlete_events
GROUP BY Sex;

#Fetch the top 5 athletes who have won the most gold medals.
SELECT a.Name, COUNT(*) as Gold_Medal_Count 
FROM athlete_events a 
WHERE a.Medal = 'Gold' 
GROUP BY a.Name 
ORDER BY Gold_Medal_Count DESC 
LIMIT 5;

#Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
SELECT a.Name, COUNT(*) as Total_Medal_Count 
FROM athlete_events a 
WHERE a.Medal = 'Gold' OR a.Medal = 'Silver' OR a.Medal = 'Bronze'
GROUP BY a.Name 
ORDER BY Total_Medal_Count DESC 
LIMIT 5;
#Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won. 
SELECT a.Team, COUNT(*) as Total_Medal_Count 
FROM athlete_events a 
WHERE a.Medal = 'Gold' OR a.Medal = 'Silver' OR a.Medal = 'Bronze'
GROUP BY a.Team 
ORDER BY Total_Medal_Count DESC 
LIMIT 5;
#List down total gold, silver and broze medals won by each country. 
SELECT Team AS Country,
COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS Gold_Medals,
COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS Silver_Medals,
COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS Bronze_Medals
FROM Athlete_events
WHERE Medal IS NOT NULL
GROUP BY Team ORDER BY Team;

#List down total gold, silver and broze medals won by each country corresponding to each olympic games.
SELECT Team AS Country, Games, 
COUNT(CASE WHEN Medal='Gold' THEN 1 ELSE NULL END) AS 'Total Gold', 
COUNT(CASE WHEN Medal='Silver' THEN 1 ELSE NULL END) AS 'Total Silver', 
COUNT(CASE WHEN Medal='Bronze' THEN 1 ELSE NULL END) AS 'Total Bronze'
FROM athlete_events 
WHERE Medal IS NOT NULL
GROUP BY Team, Games ORDER BY Team;
#Identify which country won the most gold, most silver and most bronze medals in each olympic games.
SELECT Games, 
  (SELECT Team FROM athlete_events WHERE Medal = 'Gold' GROUP BY Team ORDER BY COUNT(*) DESC LIMIT 1) AS MostGoldMedalTeam,
  (SELECT Team FROM  athlete_events WHERE Medal = 'Silver' GROUP BY Team ORDER BY COUNT(*) DESC LIMIT 1) AS MostSilverMedalTeam,
  (SELECT Team FROM  athlete_events WHERE Medal = 'Bronze' GROUP BY Team ORDER BY COUNT(*) DESC LIMIT 1) AS MostBronzeMedalTeam
FROM athlete_events
GROUP BY Games ORDER BY Games;

#Which countries have never won gold medal but have won silver/bronze medals? 
SELECT DISTINCT a.Team
FROM athlete_events AS a
LEFT JOIN noc_regions AS r ON a.NOC = r.NOC
WHERE a.Medal IN ('Silver', 'Bronze')
AND a.Team NOT IN (SELECT DISTINCT Team FROM athlete_events WHERE Medal = 'Gold') 
ORDER BY Team;
#In which Sport/event, India has won highest medals. 
SELECT Sport, COUNT(Medal) AS Medal_Count
FROM athlete_events 
WHERE Team = 'India' AND Medal IS NOT NULL 
GROUP BY Sport 
ORDER BY Medal_Count DESC 
LIMIT 1;

#Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.
SELECT a.Games, 
COUNT(a.Medal) AS Number_of_Medals
FROM athlete_events a 
INNER JOIN noc_regions r ON a.NOC = r.NOC
WHERE a.Team = 'India' AND a.Sport = 'Hockey' AND a.Medal IS NOT NULL
GROUP BY a.Games ORDER BY Games;
