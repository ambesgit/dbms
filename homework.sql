
--6.16
use Hotel
select price, [type]
from Room
where hotelNo =(select hotelNo from Hotel where hotelName='Grosvenor') 

--6.17
select *
from Guest
where guestNo In(select guestNo from Booking where hotelNo 
					In(select hotelNo from Hotel where hotelName='Grosvenor'))
					
--6.18
select R.roomNo,[type],price
from Room R inner join Booking B ON R.roomNo=B.roomNo AND R.hotelNo=B.hotelNo



select * from Hotel
select * from Room