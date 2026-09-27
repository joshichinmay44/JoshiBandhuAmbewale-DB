create or replace procedure dm.usp_add_booking(
p_customer_name VARCHAR(400),
p_sku_name VARCHAR(100),
p_quantity NUMERIC(19,4),
p_lead_generated_by VARCHAR(400),
p_created_by VARCHAR(200)
)
language plpgsql
as
$$
declare
	v_customer_id BIGINT;
	v_sku_id BIGINT;
	v_address_id BIGINT;
	v_salesperson_id BIGINT;
begin
	v_customer_id := (SELECT customer_id FROM dim.customer WHERE CONCAT(first_name,' ',last_name) = p_customer_name);
	v_sku_id := (SELECT sku_id FROM dim.sku WHERE sku_name = p_sku_name);
	v_address_id := (SELECT address_id FROM dim.customer_address WHERE customer_id = v_customer_id and is_active = TRUE);	
	v_salesperson_id := (SELECT salesperson_id FROM dim.salespeople WHERE username = p_lead_generated_by);
	v_quantity := (SELECT sku_units FROM dim.sku WHERE sku_id = v_sku_id) * p_quantity;

	INSERT INTO dm.booking (customer_id, sku_id, quantity, address_id, lead_generated_by, created_by, updated_by)
	VALUES(v_customer_id, v_sku_id, v_quantity, v_address_id, v_salesperson_id, p_created_by, p_created_by);
end;
$$;