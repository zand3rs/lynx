CREATE OR REPLACE FUNCTION private.create_wallet (
  _account_id  uuid,
  _uid         text,
  _name        text,
  _description text,
  _label       text,
  _type        public.t_wallet_type
)
RETURNS public.wallets AS $$
  DECLARE
    owner  public.owners;
    wallet public.wallets;
  BEGIN
    -- try to create an owner record
    INSERT INTO public.owners (
      account_id, uid
    ) VALUES (
      _account_id, _uid
    )
    ON CONFLICT (account_id, uid) DO UPDATE
      SET updated_at = CURRENT_TIMESTAMP
    RETURNING * INTO owner;

    -- create a wallet record
    INSERT INTO public.wallets (
      owner_id, name, description, label, type
    ) VALUES (
      owner.id, _name, _description, _label, COALESCE(_type, 'default')
    )
    RETURNING * INTO wallet;

    RETURN wallet;
  END;
$$ LANGUAGE plpgsql;
