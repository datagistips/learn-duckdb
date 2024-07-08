-- READ
load spatial;
create or replace table a as (from st_read('https://static.data.gouv.fr/resources/elections-legislatives-des-30-juin-et-7-juillet-2024-liste-des-candidats-du-2nd-tour/20240703-133918/legislatives-2024-candidatures-france-entiere-tour-2-2024-07-03-12h18.xlsx'));
from a limit 5;

-- TRIANGULAIRES & CO
-- Duels en opposition et triangulaires les plus fréquents
with b as (
select 
	"Code circonscription", 
	count(*) nb, 
	list("Code nuance").list_sort() liste 
from a 
group by "Code circonscription")
select 
	array_to_string(liste, ',') partis, 
	len(liste) as nb_partis, 
	count(*) nb_circos
from b
group by liste 
order by nb_circos desc;

-- NB ET PROPORTION DE CANDIDATES FEMMES PAR PARTIS TRIES PAR PROPORTION
with b as (
select 
	"Sexe du candidat", 
	"Code nuance", 
	count(*) as nb_f ,
	sum(nb_f) over (partition by "Code nuance") as nb_parti,
	round(nb_f / nb_parti * 100) as pc
from a 
group by ("Sexe du candidat", "Code nuance") 
order by ("Code nuance", "Sexe du candidat") desc)
select 
	*,
	mean(pc) OVER() as pc_moyen
from b
where "Sexe du candidat"='F' 
order by pc desc;

-- ÂGE
with b as (
select 
	2024 - date_part('year', strptime("Date de naissance du candidat", '%d/%m/%Y')) as age, 
	"Code nuance" as parti
	from a)
select 
	parti,  
	round(mean(age)) age_moyen
from b
group by parti
order by age_moyen asc;

-- PROFESSIONS DES CANDIDATS POUR RN, UG et ENS
with b as (
	select 
		"Profession", 
		"Code nuance" as parti, 
		count(*) nb 
	from a 
	where parti IN ('RN', 'UG', 'ENS') 
	group by ("Profession", parti) 
	order by parti, nb desc
),
c as (PIVOT b ON parti USING first(nb))
select 
	* replace (
		regexp_replace("Profession", '\([0-9]{2}\) - ', '') as "Profession", 
		ifnull(ENS, 0) as ENS, 
		ifnull(RN, 0) as RN, 
		ifnull(UG, 0) as UG
	) 
from c order by "Profession";