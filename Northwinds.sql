--1. undiscounted subtotal for each order
select o.OrderID, sum(od.UnitPrice * od.Quantity) as subtotal
from Orders o 
join [Order Details] od
on o.OrderID = od.OrderID
group by o.OrderID
order by subtotal desc

--2. discontinued products
select *
from Products
where Discontinued = 0

--3. cost after discount for each order
select o.OrderID, sum((od.UnitPrice * od.Quantity) * (1-od.Discount)) as subtotal
from Orders o 
join [Order Details] od
on o.OrderID = od.OrderID
group by o.OrderID
order by subtotal desc

--4. list of sales figures broken by category name
select c.CategoryName, round (sum((od.UnitPrice * od.Quantity) * (1-od.Discount)), 2) as SubTotal, sum(od.Quantity) as ItemsSold
from [Order Details] od
join Products p 
on p.ProductID = od.ProductID
join Categories c
on c.CategoryID = p.CategoryID
group by c.CategoryName
order by subtotal desc

--5. 10 most expensive products
select top 10 * 
from Products p
where p.Discontinued = 0
order by p.UnitPrice desc

--6. What quarter in 1997 was revenue highest
select datepart(quarter, o.OrderDate) as Quarter, sum((od.UnitPrice * od.Quantity) * (1-od.Discount)) as subtotal
from Orders o 
join [Order Details] od
on o.OrderID = od.OrderID
where year(o.orderDate) = 1997
group by datepart(quarter, o.OrderDate)
order by subtotal desc

--7. Which products have a price that's higher than average
--with discontinued
select * 
from Products p
where p.Discontinued = 0 and p.UnitPrice > (select sum(p.UnitPrice)/count(ProductName) as averagePrice from products p where p.Discontinued = 0)
order by p.UnitPrice desc

--without discontinued
select * 
from Products p
where p.UnitPrice > (select sum(p.UnitPrice)/count(ProductName) as averagePrice from products p)
order by p.UnitPrice desc
