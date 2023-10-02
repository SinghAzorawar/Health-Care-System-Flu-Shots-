/*
 Objectives
 Come up with Flu Shots Dashboard for 2022 that does the following
 
 1) Total % of patients getting flu shots stratified by
    a) Age
	b) Race
	c) County (On a MAP)
	d) Overall

 2) Running Total of Flu Shots over the course of 2022
 3) Total number of flu shots given in 2022
 4) A list of patients that show wether or not they have received the flu shots
 
 Requirements: Patients must have been "Active at our hospital"
 
 */
 

-- Answer: 
 
 WITH flu_shots_2022 AS
(
 SELECT description, patient, min(date) as earliest_shots_2022
 FROM immunizations
 WHERE code='5302' AND date BETWEEN '2022-01-01 00:00' AND '2022-12-31 23:59'
 GROUP BY patient, description
),
 
 
 
 active_patients AS
 (
 SELECT DISTINCT patient
	 FROM encounters AS enc
	 INNER JOIN patients AS pat
	 ON enc.patient = pat.id
	 WHERE start BETWEEN '2020-01-01 00:00' AND '2022-12-31 23:59'
	 AND pat.deathdate IS NULL
	 AND EXTRACT (MONTH FROM age('2022-12-31', pat.birthdate)) >= 6 
 )
 
 
 SELECT patients.id,
 patients.first, 
 patients.last, 
 patients.birthdate,
 EXTRACT (YEAR FROM(age('2022-12-31',patients.birthdate))) AS AGE,
 patients.race,
 patients.county, 
 flu_shots_2022.earliest_shots_2022,
 flu_shots_2022.patient, 
 CASE WHEN flu_shots_2022 IS NULL THEN 0 ELSE 1
 END AS FluShotsIn2022
 FROM patients LEFT JOIN flu_shots_2022
 ON patients.id=flu_shots_2022.patient
 WHERE 1=1
 AND patients.id IN (SELECT patient FROM active_patients)