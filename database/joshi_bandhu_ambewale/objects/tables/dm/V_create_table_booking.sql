-- DROP TABLE IF EXISTS dm.booking;

CREATE TABLE IF NOT EXISTS dm.booking (
    booking_id BIGINT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    customer_id BIGINT,
    sku_id BIGINT,
    quantity NUMERIC(19,4),
    address_id BIGINT,
    lead_generated_by BIGINT,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(200),
    updated_by VARCHAR(200),
    delivery_mode VARCHAR(50) CHECK (customer_mode IN ('Online', 'Offline')),
    FOREIGN KEY (customer_id) REFERENCES dim.customer(customer_id),
    FOREIGN KEY (sku_id) REFERENCES dim.sku(sku_id),
    FOREIGN KEY (address_id) REFERENCES dim.address(address_id),
    FOREIGN KEY (lead_generated_by) REFERENCES dim.salespeople(salesperson_id)
);