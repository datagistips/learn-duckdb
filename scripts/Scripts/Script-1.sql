create table a as (from st_read('https://static.data.gouv.fr/resources/elections-legislatives-des-30-juin-et-7-juillet-2024-liste-des-candidats-du-2nd-tour/20240703-133918/legislatives-2024-candidatures-france-entiere-tour-2-2024-07-03-12h18.xlsx'));

from a where ;

-- Triangulaires & co
with b as (select "Code circonscription", count(*) nb, list("Code nuance").list_sort() liste from a group by "Code circonscription")
select count(*) nb, liste from b group by liste order by nb desc;

-- Sexe des candidats
with b as (select "Sexe du candidat", "Code nuance", count(*) as nb ,
sum(nb) over (partition by "Code nuance") nb_tot_nuance,
round(nb / nb_tot_nuance * 100) as pc
from a 
group by ("Sexe du candidat", "Code nuance") order by ("Code nuance", "Sexe du candidat") desc)
from b where "Sexe du candidat"='F' order by pc desc;

-- Âge
with b as (select 2024 - date_part('year', strptime("Date de naissance du candidat", '%d/%m/%Y')) as age, "Code nuance" from a)
select "Code nuance",  round(mean(age)) age_moyen from b group by "Code nuance" order by age_moyen desc;

-- Profession
-- REPLACE
with b as (
select "Profession", "Code nuance", count(*) nb from a where "Code nuance" IN ('RN', 'UG', 'ENS') group by ("Profession", "Code nuance") order by "Code nuance", nb desc),
c as (PIVOT b ON "Code nuance" USING first(nb)),
d as (select * replace (
regexp_replace("Profession", '\([0-9]{2}\) - ', '') as "Profession", 
ifnull(ENS, 0) as ENS, ifnull(RN, 0) as RN, ifnull(UG, 0) as UG) from c order by "Profession")
from d;



from b;