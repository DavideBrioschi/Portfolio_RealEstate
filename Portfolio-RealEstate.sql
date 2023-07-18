-- Download OMI 2022-2 "Valori" and "Zone" and convert csv in xls with excel
-- Importing Data in SQL 

/*------------------------------------------------------------------------------------------------------------------------------
PS.
Judgment No. 3197 of February 9, 2018 states that OMI quotations can be taken into consideration to identify a presumed value, 
reiterating that they are only suitable for providing indications of approximate values."
"They are not considered valid for real estate valuation using international methods (such as RICS), 
and even the ABI (Italian Banking Association) no longer recognizes it as an official valuation."
--------------------------------------------------------------------------------------------------------------------------------

Simple Cleaning Data in SQL Queries

*/

-- Populate Missing Comune_Istat

select *
from [2022_Valori] 
where Comune_ISTAT = ''

-- Ordona on Google Istat number is 071063

Update [2022_Valori]
SET Comune_ISTAT = 071063
where Comune_descrizione = 'ORDONA'

select *
from [2022_Valori] 
where Comune_ISTAT = 071063

-- Identify and Remove Duplicate
-- > no Duplicate

Select *,
	ROW_NUMBER () OVER (
	Partition by LinkZona,
				Descr_Tipologia,
				Stato
				ORDER BY 
				linkzona
				) row_num
from [2022_Valori]

-- USE CTE

With RowNumCTE as(
Select *,
	ROW_NUMBER () OVER (
	Partition by LinkZona,
				Descr_Tipologia,
				Stato
				ORDER BY 
				linkzona
				) row_num
from [2022_Valori]
)
Select *
From RowNumCTE
where row_num > 1

-- Delete Unused Columns

ALTER TABLE [2022_valori] 
DROP COLUMN Comune_cat, Sez, Noname

-- Set 0 Rows Compr_min, Compr_max, Loc_min, Loc_max = ''

UPDATE [2022_valori]
SET Compr_min = COALESCE(Compr_min, 0),
    Compr_max = COALESCE(Compr_max, 0),
    Loc_min = COALESCE(Loc_min, 0),
    Loc_max = COALESCE(Loc_max, 0)
WHERE Compr_min IS NULL OR Compr_min = ''
   OR Compr_max IS NULL OR Compr_max = ''
   OR Loc_min IS NULL OR Loc_min = ''
   OR Loc_max IS NULL OR Loc_max = '';


-- View 2022_zone if equal
--> ok

SELECT [2022_Valori].Comune_descrizione
FROM [2022_Valori]
LEFT JOIN [2022_zone] ON [2022_Valori].Comune_descrizione = [2022_zone].Comune_descrizione
WHERE [2022_zone].Comune_descrizione IS NULL OR [2022_Valori].Comune_descrizione <> [2022_zone].Comune_descrizione;

