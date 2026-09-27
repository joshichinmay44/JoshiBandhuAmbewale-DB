create or replace procedure dm.usp_update_bookings(
p_booking_id BIGINT,
p_customer_name VARCHAR(500),
p_customer_address TEXT,
p_customer_phone_number_calling VARCHAR(20),
p_customer_phone_number_whatsapp VARCHAR(20),
p_customer_mode VARCHAR(50),
p_customer_type VARCHAR(50),
p_sku_name VARCHAR(500),
p_sku_units NUMERIC(19,4),
p_booked_quantity_in_doz NUMERIC(19,4),
p_sale_booked_by VARCHAR(500),
p_booking_date TIMESTAMP,
p_username VARCHAR(200)
)
language plpgsql
as
$$
declare 
	v_customer_id BIGINT := (	SELECT customer_id FROM dim.customer where 
						concat(first_name, ' ', last_name) = p_customer_name and phone_number_whatsapp = p_phone_number_whatsapp 
					 	and phone_number_calling = p_phone_number_calling and customer_type = p_customer_type
					 	and customer_mode = p_customer_mode and customer_type = p_customer_type
						);
	v_sku_id  BIGINT := (SELECT sku_id FROM dim.sku where sku_name = p_sku_name and sku_units = p_sku_units);
	v_address_id BIGINT:= (SELECT address_id FROM dim.customer_address where customer_id = v_customer_id and is_active = TRUE);
	v_lead_generated_by BIGINT:= (SELECT salesperson_id FROM dim.salespeople where concat(first_name, ' ', last_name) = p_sale_booked_by);
begin
	UPDATE dm.booking 
	SET customer_id = v_customer_id, sku_id = v_sku_id, quantity = p_booked_quantity_in_doz, 
	address_id = v_address_id, lead_generated_by = v_lead_generated_by, updated_at = now(),
	updated_by = p_username
	WHERE booking_id = p_booking_id
	;
end;
$$;