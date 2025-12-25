-- 0. Tạo database Quản lý khách sạn
create database QuanLyKhachSan;

-- 1. Tạo bảng theo cấu trúc (schema public)
-- Tạo bảng Customer
create table Customer(
    customer_id varchar(50) primary key not null,
    customer_full_name varchar(100) not null,
    customer_email varchar(100) not null unique,
    customer_phone varchar(15) not null,
    customer_address varchar(255) not null
);

-- Tạo bảng Room
create table Room(
    room_id varchar(5) primary key not null,
    room_type varchar(50) not null,
    room_price decimal(10, 2) not null,
    room_status varchar(20) not null,
    room_area int not null
);

-- Tạo bảng Booking
create table booking(
    booking_id serial primary key not null,
    customer_id varchar(5) references customer(customer_id) not null,
    room_id varchar(5) references room(room_id) not null ,
    check_in_date date not null,
    check_out_date date not null,
    total_amount decimal(10, 2)
);

-- Tạo bảng Payment
create table payment(
    payment_id serial primary key not null,
    booking_id int references booking(booking_id) not null,
    payment_method varchar(50) not null,
    payment_date date not null ,
    payment_amount decimal(10, 2) not null
);

-- 2. Chèn dữ liệu mẫu
-- Chèn dữ liệu vào Customer
insert into customer values
('C001', 'Nguyen Anh Tu', 'tu.nguyen@example.com', '0912345678', 'Hanoi, Vietnam'),
('C002', 'Tran Thi Mai', 'mai.tran@example.com', '0923456789', 'Ho Chi Minh, Vietnam'),
('C003', 'Le Minh Hoang', 'hoang.le@example.com', '0934567890', 'Danang, Vietnam'),
('C004', 'Pham Hoang Nam', 'nam.pham@example.com', '0945678901', 'Hue, Vietnam'),
('C005', 'Vu Minh Thu', 'thu.vu@example.com', '0956789012', 'Hai Phong, Vietnam');

-- Chèn dữ liệu vào bảng Room
insert into room values
('R001', 'Single', 100.0,'Available', 25),
('R002', 'Double', 150.0, 'Booked', 40),
('R003', 'Suite', 250.0, 'Available', 60),
('R004', 'Single', 120.0, 'Booked', 30),
('R005', 'Double', 160.0, 'Available', 35);

-- Chèn dữ liệu vào bảng Booking
insert into booking values
(1, 'C001', 'R001', '2025-03-01', '2025-03-05', 400.0),
(2, 'C002', 'R002', '2025-03-02', '2025-03-06', 600.0),
(3, 'C003', 'R003', '2025-03-03', '2025-03-07', 1000.0),
(4, 'C004', 'R004', '2025-03-04', '2025-03-08', 480.0),
(5, 'C005', 'R005', '2025-03-05', '2025-03-09', 800.0);

-- Chèn dữ liệu vào bảng Payment
insert into payment values
(1, 1, 'Cash', '2025-03-05', 400.0),
(2, 2, 'Credit Card', '2025-03-06', 600.0),
(3, 3, 'Bank Transfer', '2025-03-07', 1000.0),
(4, 4, 'Cash', '2025-03-08', 480.0),
(5, 5, 'Credit Card', '2025-03-09', 800.0);

-- 3. Cập nhật total_amount trong bảng booking với những record có check_in_date trước 3/3/2025
update booking
set total_amount = total_amount * 0.9
where check_in_date < '2025-03-03';

-- 4. Xoá các thanh toán trong payment khi payment_method là "Cash" và payment_amount < 500
delete from payment
where payment_method = 'Cash' and payment_amount < 500;

-- 5. Lấy thông tin khách hàng gồm: mã khách hàng, họ tên, email, số điện thoại được sắp xếp theo họ tên khách hàng giảm dần.
select c.customer_id, c.customer_full_name, c.customer_email, c.customer_phone
from customer c
order by c.customer_full_name desc;

-- 6. Lấy thông tin các phòng khách sạn gồm: mã phòng, loại phòng, giá phòng và diện tích phòng, sắp xếp theo diện tích phòng tăng dần.
select r.room_id, r.room_type, r.room_price, r.room_area
from room r
order by room_area;

-- 7.  Lấy thông tin khách hàng và phòng khách sạn đã đặt gồm: họ tên khách hàng, mã phòng, ngày nhận phòng và ngày trả phòng.
select c.customer_full_name, r.room_id, b.check_in_date, b.check_out_date
from customer c
    join booking b on c.customer_id = b.customer_id
    join room r on r.room_id = b.room_id;

-- 8. Lấy danh sách khách hàng và tổng tiền đã thanh toán khi đặt phòng, gồm mã khách hàng, họ tên khách hàng, phương thức thanh toán và số tiền thanh toán, sắp xếp theo số tiền thanh toán tăng dần.
select c.customer_id, c.customer_full_name, p.payment_method, p.payment_amount
from customer c
    join booking b on c.customer_id = b.customer_id
    join payment p on b.booking_id = p.booking_id
order by p.payment_amount;

-- 9. Lấy tất cả thông tin khách hàng từ vị trí thứ 2 đến thứ 4 trong bảng Customer được sắp xếp theo tên khách hàng (Z-A).
select *
from customer c
order by c.customer_full_name desc
offset 1
limit 3;

-- 10. Lấy danh sách khách hàng đã đặt ít nhất 2 phòng gồm : mã khách hàng, họ tên khách hàng và số lượng phòng đã đặt.
select c.customer_id, c.customer_full_name, count(b.booking_id) as "Số lượng phòng đã đặt"
from customer c join booking b on c.customer_id = b.customer_id
group by c.customer_id
having count(b.booking_id) >= 2;

-- 11. Lấy danh sách các phòng từng có ít nhất 3 khách hàng đặt, gồm mã phòng, loại phòng, giá phòng và số lần đã đặt.
select r.room_id, r.room_type, r.room_price, count(b.booking_id) as "số lần đã đặt"
from room r join booking b on r.room_id = b.room_id
group by r.room_id
having count(b.booking_id) >= 3;

-- 12. Lấy danh sách các khách hàng có tổng số tiền đã thanh toán lớn hơn 1000, gồm mã khách hàng, họ tên khách hàng, mã phòng, tổng số tiền đã thanh toán.
select c.customer_id, c.customer_full_name, r.room_id, p.payment_amount
from customer c
    join booking b on c.customer_id = b.customer_id
    join room r on r.room_id = b.room_id
    join payment p on b.booking_id = p.booking_id
where b.customer_id in (
    select c.customer_id
    from customer c
             join booking b on c.customer_id = b.customer_id
             join payment p on b.booking_id = p.booking_id
    group by c.customer_id
    having sum(p.payment_amount) > 1000);

-- 13. Lấy danh sách các khách hàng gồm: mã KH, Họ tên, email, sđt có họ tên chứa chữ "Minh" hoặc địa chỉ ở "Hanoi". Sắp xếp kết quả theo họ tên tăng dần.
select c.customer_id, c.customer_full_name, c.customer_email, c.customer_phone, c.customer_address
from customer c
where c.customer_full_name ilike '%Minh%' or c.customer_address ilike '%Hanoi%'
order by c.customer_full_name;

-- 14. Lấy danh sách thông tin các phòng gồm : mã phòng, loại phòng, giá , sắp xếp theo giá phòng giảm dần.Chỉ lấy 5 phòng và bỏ qua 5 phòng đầu tiên (tức là lấy kết quả của trang thứ 2, biết mỗi trang có 5 phòng).
select r.room_id, r.room_type, r.room_price
from room r
order by r.room_price desc
offset 5
limit 5;

-- 15. Hãy tạo một view để lấy thông tin các phòng và khách hàng đã đặt, với điều kiện ngày nhận phòng nhỏ hơn ngày 2025-03-04. Cần hiển thị các thông tin sau: Mã phòng, Loại phòng, Mã khách hàng, họ tên khách hàng
create or replace view customer_room
as
    select r.room_id, r.room_type, c.customer_id, c.customer_full_name
    from customer c
        join booking b on c.customer_id = b.customer_id
        join room r on r.room_id = b.room_id
        where check_in_date < '2025-03-04';

-- 16. Hãy tạo một view để lấy thông tin khách hàng và phòng đã đặt, với điều kiện diện tích phòng lớn hơn 30 m². Cần hiển thị các thông tin sau: Mã khách hàng, Họ tên khách hàng, Mã phòng, Diện tích phòng, Ngày nhận phòng
create or replace view customer_booking_room_larger_than_30_meter_square
as
    select c.customer_id, c.customer_full_name, r.room_id, r.room_area, b.check_in_date
    from customer c
        join booking b on c.customer_id = b.customer_id
        join room r on r.room_id = b.room_id
    where r.room_area > 30;

-- 17. Hãy tạo một trigger check_insert_booking để kiểm tra dữ liệu mối khi chèn vào bảng Booking. Kiểm tra nếu ngày đặt phòng mà sau ngày trả phòng thì thông báo lỗi với nội dung “Ngày đặt phòng không thể sau ngày trả phòng được !” và hủy thao tác chèn dữ liệu vào bảng.
create or replace function check_booking_insert()
returns trigger
as $$
begin
    if new.check_in_date > new.check_out_date then
        raise exception 'Ngày đặt phòng không thể sau ngày trả phòng được!';
    end if;

    return new;
end;
$$ language plpgsql;

create or replace trigger check_insert_booking
before insert on booking
for each row
execute function check_booking_insert();

-- 18. Hãy tạo một trigger có tên là update_room_status_on_booking để tự động cập nhật trạng thái phòng thành "Booked" khi một phòng được đặt (khi có bản ghi được INSERT vào bảng Booking).
create or replace function check_update_room_insert()
returns trigger
as $$
begin
    update room
    set room_status = 'Booked'
    where room_id = new.room_id;
    return new;
end;
$$ language plpgsql;

create or replace trigger update_room_status_on_booking
after insert on booking
for each row
execute function check_update_room_insert();

-- 19. Viết store procedure có tên add_customer để thêm mới một khách hàng với đầy đủ các thông tin cần thiết.
create or replace procedure add_customer(
    in p_customer_id varchar(5),
    in p_full_name varchar(100),
    in p_email varchar(100),
    in p_phone varchar(15),
    in p_address varchar(255)
)
language plpgsql
as $$
begin
    insert into customer values
        (p_customer_id, p_full_name, p_email, p_phone, p_address);
end;
$$;

-- 20. Hãy tạo một Stored Procedure  có tên là add_payment để thực hiện việc thêm một thanh toán mới cho một lần đặt phòng.
create or replace procedure add_payment(
    in p_booking_id int,
    in p_payment_method varchar(50),
    in p_payment_amount decimal(10, 2),
    in p_payment_date date
)
as $$
begin
    insert into payment(booking_id, payment_method, payment_date, payment_amount) values
    (p_booking_id, p_payment_method, p_payment_date, p_payment_amount);
end;
$$ language plpgsql;
