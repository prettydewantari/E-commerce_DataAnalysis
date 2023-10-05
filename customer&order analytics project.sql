select * from `final_project.order_detail`;

-- Question1: Selama transaksi yang terjadi selama 2021, pada bulan apa total nilai transaksi (after_discount) paling besar?

select 
  (extract(month from order_date)) as month,
  sum(after_discount) as total_transaction
from `final_project.order_detail`
where 
  is_valid = 1 and 
  (extract(year from order_date) = 2021)
group by 1
order by 2 desc;

--to extract order date as string format
select 
 CAST(order_date AS STRING FORMAT 'Month') as order_month_2021,
 sum(after_discount) as total_transaksi
from 
 `final_project.order_detail`
where
 is_valid = 1 and
 (extract(year from order_date) = 2021)
group by 1
order by 2 DESC;

--Quastion2: Selama transaksi pada tahun 2022, kategori apa yang menghasilkan nilai transaksi paling besar? Gunakan is_valid = 1 untuk memfilter data transaksi.
select
  sd.category,
  sum(od.after_discount) as total_transaction
from `final_project.order_detail` as od
left join `final_project.sku_detail` as sd
  on sd.id = od.sku_id 
where 
  od.is_valid = 1
  and (extract(year from od.order_date) = 2022)
group by 1
order by 2 desc;

-- Question 3: Bandingkan nilai transaksi dari masing-masing kategori pada tahun 2021 dengan 2022. Sebutkan kategori apa saja yang mengalami peningkatan dan kategori apa yang mengalami penurunan nilai transaksi dari tahun 2021 ke 2022. Gunakan is_valid = 1 untuk memfilter data transaksi.

with tran22_table as (
select
  sd.category,
  sum(
    case when (extract(year from od.order_date) = 2022) then od.after_discount end
    ) as total_transaction_2022,
  sum(
    case when (extract(year from od.order_date) = 2021) then od.after_discount end
    ) as total_transaction_2021
from `final_project.order_detail` as od
join `final_project.sku_detail` as sd
  on sd.id = od.sku_id 
where 
  od.is_valid = 1
group by 1
)
select 
  tran22_table.*, 
  round(tran22_table.total_transaction_2022 - tran22_table.total_transaction_2021,2) as growth_val
from tran22_table
order by growth_val desc;

--Question4: Tampilkan top 5 metode pembayaran yang paling populer digunakan selama 2022 (berdasarkan total unique order).

select
  pd.payment_method,
  count(distinct od.customer_id) as total_uniq_order
from `final_project.order_detail` as od
join `final_project.payment_detail`as pd
  on od.payment_id = pd.id
where 
  od.is_valid = 1 and
  extract(year from od.order_date) = 2022
group by 1
order by 2 desc
limit 5;

select
  pd.payment_method,
  count(distinct od.id) as total_uniq_order
from `final_project.order_detail` as od
join `final_project.payment_detail`as pd
  on od.payment_id = pd.id
where 
  od.is_valid = 1 and
  extract(year from od.order_date) = 2022
group by 1
order by 2 desc
limit 5;

--Question5: Urutkan dari ke-5 produk ini berdasarkan nilai transaksinya.1. Samsung 2. Apple 3. Sony 4. Huawei 5. Lenovo
with product as (
select
  case 
    when sd.sku_name like '%samsung%'then 'Samsung' 
    when sd.sku_name like '%apple%'then 'Apple'
    when sd.sku_name like '%sony%'then 'Sony'
    when sd.sku_name like '%huawei%'then 'Huawei'
    when sd.sku_name like '%lenovo%'then 'Lenovo'
    end as product_name,
  sum(od.after_discount) as total_transaction
from `final_project.order_detail` as od
join `final_project.sku_detail` as sd
  on sd.id = od.sku_id 
where 
  is_valid = 1
group by 1
)
select product.*
from product
where product.product_name is not NULL
ORDER by 2 desc;

select *
from `final_project.sku_detail`
where category = 'Mobiles & Tablets';

with product as (
select
  case 
    when lower (sd.sku_name) like '%samsung%' then 'Samsung' 
    when lower (sd.sku_name) like '%apple%' or lower (sd.sku_name) like '%iphone%' 
	  or lower (sd.sku_name) like '%ipad%' or lower (sd.sku_name) like '%macbook%'
	  then 'Apple'
    when lower (sd.sku_name) like '%sony%' then 'Sony'
    when lower (sd.sku_name) like '%huawei%' then 'Huawei'
    when lower (sd.sku_name) like '%lenovo%' then 'Lenovo'
    end as product_name,
sum(od.after_discount) as total_transaction
from `final_project.order_detail` as od
join `final_project.sku_detail` as sd
  on sd.id = od.sku_id 
where 
  is_valid = 1
group by 1
)
select product.*
from product
where product.product_name is not NULL
order by 2 desc;






