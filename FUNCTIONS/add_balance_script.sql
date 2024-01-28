CREATE OR REPLACE FUNCTION public.add_balance_script(
  in_first_name VARCHAR(50),
  in_surname VARCHAR(50),
  in_iid INT,
  in_amount DECIMAL(10, 2) DEFAULT 0.00 -- Default amount if not provided
)
RETURNS VOID AS $$
BEGIN
  BEGIN
    IF in_iid IS NOT NULL THEN
      -- Update by investor ID
      UPDATE Investors
      SET balance = balance + in_amount
      WHERE iid = in_iid;

      IF NOT FOUND THEN
            RAISE EXCEPTION 'Investor with iid % not found', in_iid;
      END IF;

    ELSE
        -- Update by first name and surname
        UPDATE Investors
        SET balance = balance + in_amount
        WHERE first_name = in_first_name AND surname = in_surname;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Investor with name % % not found', in_first_name, in_surname;
        END IF;

    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- Handle other exceptions
      RAISE NOTICE 'Error: %', SQLERRM;
  END;

END;
$$ LANGUAGE plpgsql;