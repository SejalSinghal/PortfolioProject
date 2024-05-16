--cleaning data in sql queries

select * from PortfolioProject..NashvilleHousing

--Standardize Date Format

select SaleDate,CONVERT(Date,SaleDate) from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted=CONVERT(Date,SaleDate)



--Populate Property, Address And Data

select * from PortfolioProject..NashvilleHousing
where PropertyAddress is null
order by ParcelID

select * from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

--we can see in column 44,45 that parcel id is matches with Property address i.e for same parcel id propert address is same

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL( a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null

 update a
  set PropertyAddress=ISNULL( a.PropertyAddress,b.PropertyAddress) 
  From PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null

 --Breaking out address into Individual column (Address,state, city)
  
  select PropertyAddress
  from PortfolioProject..NashvilleHousing

  select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
  SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
  from PortfolioProject..NashvilleHousing

  alter table NashvilleHousing
add PropertysplitAddress nvarchar(255);

update NashvilleHousing
set PropertysplitAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertysplitCity nvarchar(100);

update NashvilleHousing
set PropertysplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select * from PortfolioProject..NashvilleHousing


select OwnerAddress
from PortfolioProject..NashvilleHousing


select PARSENAME(replace(OwnerAddress,',','.'),1)
,PARSENAME(replace(OwnerAddress,',','.'),2)
,PARSENAME(replace(OwnerAddress,',','.'),3)
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add OwnersplitAddress nvarchar(100);

update NashvilleHousing
set OwnersplitAddress=PARSENAME(replace(OwnerAddress,',','.'),3)

alter table NashvilleHousing
add OwnersplitCity nvarchar(100);

update NashvilleHousing
set OwnersplitCity=PARSENAME(replace(OwnerAddress,',','.'),2)

alter table NashvilleHousing
add OwnersplitState nvarchar(100);

update NashvilleHousing
set OwnersplitState=PARSENAME(replace(OwnerAddress,',','.'),1)

select * from PortfolioProject..NashvilleHousing

--change y and n to yes and no in sold as vacant

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant

select SoldAsVacant,
case 
	when SoldAsVacant='Y' then 'Yes'
  when SoldAsVacant='N' then 'No'
  else SoldAsVacant
 end
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant=
case 
	when SoldAsVacant='Y' then 'Yes'
  when SoldAsVacant='N' then 'No'
  else SoldAsVacant
 end
from PortfolioProject..NashvilleHousing

--Remove Duplicates

select * from PortfolioProject..NashvilleHousing

select *,ROW_NUMBER() over (
	partition by ParcelID,
	             PropertyAddress,SaleDate,SalePrice,LegalReference
				 order by UniqueID) row_num
from PortfolioProject..NashvilleHousing
order by ParcelID


with RowNumCTE as(
select *,ROW_NUMBER() over (
	partition by ParcelID,
	             PropertyAddress,SaleDate,SalePrice,LegalReference
				 order by UniqueID) row_num
from PortfolioProject..NashvilleHousing
--order by ParcelID
)
select* from RowNumCTE
where row_num>1
order by PropertyAddress


with RowNumCTE as(
select *,ROW_NUMBER() over (
	partition by ParcelID,
	             PropertyAddress,SaleDate,SalePrice,LegalReference
				 order by UniqueID) row_num
from PortfolioProject..NashvilleHousing
--order by ParcelID
)
delete
from RowNumCTE
where row_num>1
--order by PropertyAddress

--Delete Unused Column

select * from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column OwnerAddress,PropertyAddress,TaxDistrict

alter table PortfolioProject..NashvilleHousing
drop column SaleDate
