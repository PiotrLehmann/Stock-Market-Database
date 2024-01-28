CREATE OR REPLACE FUNCTION public.withdraw_balance_script(
  in_first_name VARCHAR(50),
  in_surname VARCHAR(50),
  in_iid INT,
  in_amount DECIMAL(10, 2) DEFAULT 0.00 -- Default amount if not provided
)
RETURNS VOID AS $$
BEGIN
  -- Check if user exists based on provided criteria
  IF in_iid IS NULL AND (in_first_name IS NULL OR in_surname IS NULL) THEN
    RAISE EXCEPTION 'Invalid input. Provide either investor ID or both first name and surname.';
  END IF;

  -- Check if the balance is sufficient
  IF in_iid IS NOT NULL THEN
    IF (SELECT balance FROM Investors WHERE iid = in_iid) < in_amount  THEN
      RAISE EXCEPTION 'Insufficient funds for withdrawal';
    END IF;

    -- Update by investor ID
    UPDATE Investors
    SET balance = balance - in_amount
    WHERE iid = in_iid;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Investor with iid % not found', in_iid;
    END IF;

  ELSE
    -- Check if the balance is sufficient
    IF (SELECT balance FROM Investors WHERE first_name = in_first_name AND surname = in_surname) < in_amount  THEN
      RAISE EXCEPTION 'Insufficient funds for withdrawal';
    END IF;

    -- Update by first name and surname
    UPDATE Investors
    SET balance = balance - in_amount
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
$$ LANGUAGE plpgsql;
