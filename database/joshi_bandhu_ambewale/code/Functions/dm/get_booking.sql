create or replace function dm.usp_get_bookings()
returns table
(
booking_id BIGINT,
customer_name VARCHAR(500),
sku_name VARCHAR(500),
sku_units NUMERIC(19,4),
booked_quantity_in_doz NUMERIC(19,4),
customer_mode VARCHAR(50),
customer_address TEXT,
customer_phone_number_calling VARCHAR(20),
customer_phone_number_whatsapp VARCHAR(20),
customer_type VARCHAR(50),
sale_booked_by VARCHAR(500),
booking_date TIMESTAMP
)
language plpgsql
as
$$
begin
	return query (
	SELECT 
	b.booking_id, 
	concat(c.first_name, ' ', c.last_name)::VARCHAR(500) as customer_name,
	s.sku_name,
	s.sku_units,
	b.quantity,
	c.customer_mode as delivery_mode,
	concat(a.street, ' ', a.city,'-', a.postal_code) as delivery_address,
	c.phone_number_calling as calling_number,
	c.phone_number_whatsapp as whatsapp_number,
	c.customer_type,
	concat(sl.first_name, ' ', sl.last_name)::VARCHAR(500) as sale_booked_by,
	b.booking_date
	FROM dm.booking b
	INNER JOIN dim.customer c on c.customer_id = b.customer_id 
	INNER JOIN dim.customer_address ca on c.customer_id = ca.customer_id
	INNER JOIN dim.address a on ca.address_id = a.address_id 
	INNER JOIN dim.sku s on s.sku_id = b.sku_id
	INNER JOIN dim.salespeople sl on sl.salesperson_id = b.lead_generated_by 
	WHERE ca.is_active = TRUE
	);
end;
$$;