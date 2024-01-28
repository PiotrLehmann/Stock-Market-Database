CREATE OR REPLACE FUNCTION public.finalise_sell_order_script(_oid INT, _iid INT) RETURNS VOID AS
    $$
DECLARE
    order_row RECORD;
    investor_balance DECIMAL(15, 2);
BEGIN
    -- Locking the row in the orders table for the specified order
    SELECT * INTO order_row FROM orders WHERE orders.oid = _oid AND order_type = 'Sell' FOR UPDATE;

    -- Retrieving the investor's balance
    SELECT balance INTO investor_balance FROM investors WHERE investors.iid = _iid;

    -- Checking if the investor has sufficient funds
    IF investor_balance >= order_row.price THEN
        -- Subtracting from the investor's balance
        UPDATE investors SET balance = balance - order_row.price WHERE investors.iid = _iid;
        -- Updating sellers balance
        UPDATE investors SET balance = balance + order_row.price WHERE investors.iid = (SELECT iid FROM orders WHERE oid = _oid);


        -- Adding a row to the investor_stocks table
        INSERT INTO investor_stocks (iid, sid, quantity)
        VALUES (_iid, order_row.sid, order_row.quantity);

        -- Checking if the investor already owns this stock from the same seller
        IF EXISTS (SELECT 1 FROM investor_stocks WHERE iid = _iid AND sid = order_row.sid) THEN
            -- Updating the quantity of the stock in the investor_stocks table
            UPDATE investor_stocks SET quantity = quantity + order_row.quantity WHERE iid = _iid AND sid = order_row.sid;
        ELSE
            -- Adding a row to the investor_stocks table
            INSERT INTO investor_stocks (iid, sid, quantity)
            VALUES (_iid, order_row.sid, order_row.quantity);
        END IF;

        -- Changing the status of the order to 'Completed'
        UPDATE orders SET status = 'Completed' WHERE orders.oid = _oid;
    ELSE
        RAISE EXCEPTION 'Insufficient funds in the investor''s account.';
    END IF;
END;
$$ LANGUAGE plpgsql;

