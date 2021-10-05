SET check_function_bodies = false;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public.attributes (
    id integer NOT NULL,
    name text NOT NULL,
    store_id integer NOT NULL,
    type_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    order_no integer
);
CREATE SEQUENCE public.attributes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.attributes_id_seq OWNED BY public.attributes.id;
CREATE TABLE public.categories (
    id integer NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    order_no integer,
    store_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    parent_id integer
);
CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;
CREATE TABLE public.images (
    id integer NOT NULL,
    store_id integer NOT NULL,
    path text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    product_id integer NOT NULL
);
CREATE SEQUENCE public.images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;
CREATE TABLE public.order_products (
    id integer NOT NULL,
    order_id integer NOT NULL,
    store_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    unit_price double precision NOT NULL,
    sub_total double precision NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE SEQUENCE public.order_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.order_products_id_seq OWNED BY public.order_products.id;
CREATE TABLE public.order_status (
    value text NOT NULL,
    name text NOT NULL
);
CREATE TABLE public.orders (
    id integer NOT NULL,
    store_id integer NOT NULL,
    shipping_full_name text NOT NULL,
    shipping_phone_number text NOT NULL,
    shipping_address text NOT NULL,
    shipping_email text,
    note text,
    is_paid boolean DEFAULT false NOT NULL,
    status text DEFAULT 'true'::text NOT NULL,
    code text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    total_price double precision NOT NULL
);
CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;
CREATE TABLE public.product_attribute (
    id integer NOT NULL,
    product_id integer NOT NULL,
    attribute_id integer NOT NULL,
    value text NOT NULL,
    store_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE SEQUENCE public.product_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.product_attribute_id_seq OWNED BY public.product_attribute.id;
CREATE TABLE public.products (
    id integer NOT NULL,
    name text NOT NULL,
    store_id integer NOT NULL,
    options jsonb,
    sku text,
    description text,
    slug text NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    in_stock boolean DEFAULT false NOT NULL,
    category_id integer NOT NULL,
    price double precision NOT NULL,
    type_id integer NOT NULL,
    order_no integer,
    order_confirmed integer DEFAULT 0 NOT NULL
);
CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;
CREATE TABLE public.stores (
    id integer NOT NULL,
    domain text NOT NULL,
    screen_name text NOT NULL,
    name text NOT NULL,
    description text,
    color_scheme text,
    email text,
    phone_number text,
    address text,
    is_activated boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_blocked boolean DEFAULT false NOT NULL,
    user_id integer NOT NULL
);
CREATE SEQUENCE public.stores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.stores_id_seq OWNED BY public.stores.id;
CREATE TABLE public.types (
    id integer NOT NULL,
    store_id integer NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE SEQUENCE public.types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.types_id_seq OWNED BY public.types.id;
CREATE TABLE public.users (
    id integer NOT NULL,
    full_name text NOT NULL,
    gender integer,
    email text NOT NULL,
    password text NOT NULL,
    birthday date,
    phone_number text NOT NULL,
    address text,
    activated_code text NOT NULL,
    oauth_partner integer,
    oauth_uid text,
    ip_address integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_super boolean DEFAULT false NOT NULL,
    is_activated boolean DEFAULT false NOT NULL,
    is_blocked boolean DEFAULT false NOT NULL
);
CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
ALTER TABLE ONLY public.attributes ALTER COLUMN id SET DEFAULT nextval('public.attributes_id_seq'::regclass);
ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);
ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);
ALTER TABLE ONLY public.order_products ALTER COLUMN id SET DEFAULT nextval('public.order_products_id_seq'::regclass);
ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);
ALTER TABLE ONLY public.product_attribute ALTER COLUMN id SET DEFAULT nextval('public.product_attribute_id_seq'::regclass);
ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);
ALTER TABLE ONLY public.stores ALTER COLUMN id SET DEFAULT nextval('public.stores_id_seq'::regclass);
ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);
ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
ALTER TABLE ONLY public.attributes
    ADD CONSTRAINT attributes_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);
ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.order_products
    ADD CONSTRAINT order_products_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.order_status
    ADD CONSTRAINT order_status_pkey PRIMARY KEY (value);
ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_code_key UNIQUE (code);
ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.product_attribute
    ADD CONSTRAINT product_attribute_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_slug_key UNIQUE (slug);
ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_domain_key UNIQUE (domain);
ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_name_key UNIQUE (name);
ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_user_id_key UNIQUE (user_id);
ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
CREATE TRIGGER set_public_order_products_updated_at BEFORE UPDATE ON public.order_products FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_order_products_updated_at ON public.order_products IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_orders_updated_at BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_orders_updated_at ON public.orders IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_stores_updated_at BEFORE UPDATE ON public.stores FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_stores_updated_at ON public.stores IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_users_updated_at ON public.users IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.attributes
    ADD CONSTRAINT attributes_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.attributes
    ADD CONSTRAINT attributes_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.types(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.order_products
    ADD CONSTRAINT order_products_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.order_products
    ADD CONSTRAINT order_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.order_products
    ADD CONSTRAINT order_products_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.product_attribute
    ADD CONSTRAINT product_attribute_attribute_id_fkey FOREIGN KEY (attribute_id) REFERENCES public.attributes(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.product_attribute
    ADD CONSTRAINT product_attribute_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.product_attribute
    ADD CONSTRAINT product_attribute_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.types(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
