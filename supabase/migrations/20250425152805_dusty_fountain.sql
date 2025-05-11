/*
  # Initial schema setup for Nebula Market

  1. New Tables
    - vendors
      - id (uuid, primary key)
      - username (text, unique)
      - email (text, unique)
      - store_name (text)
      - description (text)
      - rating (numeric)
      - sales_count (integer)
      - created_at (timestamp)
      - level (integer)
      - is_trusted (boolean)
      - is_featured (boolean)
    
    - products
      - id (uuid, primary key)
      - vendor_id (uuid, foreign key)
      - name (text)
      - description (text)
      - price (numeric)
      - category (text)
      - image_url (text)
      - rating (numeric)
      - sales_count (integer)
      - created_at (timestamp)
      - is_featured (boolean)
      - is_trusted (boolean)

  2. Security
    - Enable RLS on all tables
    - Add policies for vendors to manage their own products
    - Add policies for public product viewing
*/

-- Create vendors table
CREATE TABLE vendors (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  username text UNIQUE NOT NULL,
  email text UNIQUE NOT NULL,
  store_name text NOT NULL,
  description text,
  rating numeric DEFAULT 0,
  sales_count integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  level integer DEFAULT 1,
  is_trusted boolean DEFAULT false,
  is_featured boolean DEFAULT false
);

-- Create products table
CREATE TABLE products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  vendor_id uuid REFERENCES vendors(id) ON DELETE CASCADE NOT NULL,
  name text NOT NULL,
  description text,
  price numeric NOT NULL,
  category text NOT NULL,
  image_url text,
  rating numeric DEFAULT 0,
  sales_count integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  is_featured boolean DEFAULT false,
  is_trusted boolean DEFAULT false
);

-- Enable RLS
ALTER TABLE vendors ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Policies for vendors
CREATE POLICY "Vendors can view their own data"
  ON vendors
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Vendors can update their own data"
  ON vendors
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

-- Policies for products
CREATE POLICY "Anyone can view products"
  ON products
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Vendors can insert their own products"
  ON products
  FOR INSERT
  TO authenticated
  WITH CHECK (vendor_id = auth.uid());

CREATE POLICY "Vendors can update their own products"
  ON products
  FOR UPDATE
  TO authenticated
  USING (vendor_id = auth.uid());

CREATE POLICY "Vendors can delete their own products"
  ON products
  FOR DELETE
  TO authenticated
  USING (vendor_id = auth.uid());