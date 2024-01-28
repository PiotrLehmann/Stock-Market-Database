SELECT i.first_name,
       i.surname,
       s.type,
       s.sid,
       i_s.quantity,
       s.price,
       c.name
FROM investor_stocks i_s, investors i, stocks s, companies c
WHERE i_s.iid = i.iid
    AND i_s.sid = s.sid
    AND s.cid = c.cid;