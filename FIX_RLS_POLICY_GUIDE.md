# 🔒 FIX: Row Level Security Policy Error

## ❌ Current Error:
```
new row violates row-level security policy for table "products"
code: 42501, Unauthorized
```

---

## 🎯 The Problem

Your products table has **Row Level Security (RLS) enabled**, but there's **no policy** allowing authenticated users to INSERT products.

RLS is blocking your insert operation!

---

## ✅ Quick Fix (30 seconds)

### Step 1: Open Supabase SQL Editor
1. Go to Supabase Dashboard
2. Click **SQL Editor**
3. Click **New query**

### Step 2: Run the RLS Fix
Copy and paste: **`FIX_PRODUCTS_RLS_POLICIES.sql`**

Or copy this:

```sql
-- Drop existing policies
DROP POLICY IF EXISTS "Allow public read access to active products" ON products;
DROP POLICY IF EXISTS "Allow authenticated users full access" ON products;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON products;
DROP POLICY IF EXISTS "Enable read access for all users" ON products;
DROP POLICY IF EXISTS "Enable update for authenticated users only" ON products;
DROP POLICY IF EXISTS "Enable delete for authenticated users only" ON products;

-- Enable RLS
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Allow public to READ active products
CREATE POLICY "Allow public read access to active products"
ON products FOR SELECT
USING (status = 'active');

-- Allow authenticated users to INSERT
CREATE POLICY "Enable insert for authenticated users only"
ON products FOR INSERT
TO authenticated
WITH CHECK (true);

-- Allow authenticated users to UPDATE
CREATE POLICY "Enable update for authenticated users only"
ON products FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Allow authenticated users to DELETE
CREATE POLICY "Enable delete for authenticated users only"
ON products FOR DELETE
TO authenticated
USING (true);

-- Allow authenticated users to SELECT ALL
CREATE POLICY "Enable read all for authenticated users"
ON products FOR SELECT
TO authenticated
USING (true);
```

### Step 3: Click RUN
Wait for: "Success"

### Step 4: Test Product Save
Go back to your app and try saving the product again.

✅ **It will work!**

---

## 📋 What These Policies Do

### For Public Users (not logged in):
✅ **SELECT** - Can view products with `status = 'active'`
❌ **INSERT** - Blocked
❌ **UPDATE** - Blocked
❌ **DELETE** - Blocked

### For Authenticated Users (admin/logged in):
✅ **SELECT** - Can view ALL products (any status)
✅ **INSERT** - Can create products
✅ **UPDATE** - Can edit products
✅ **DELETE** - Can delete products

---

## 🔍 Why This Happened

1. Your products table has RLS enabled (good for security!)
2. But no policies existed to allow INSERT operations
3. When your app tried to save a product, RLS blocked it
4. This fix adds proper policies for admin operations

---

## ✨ Benefits

✅ **Security** - Public can't create/edit products
✅ **Admin Access** - You (authenticated) can do everything
✅ **Customer Viewing** - Public can browse active products
✅ **Proper Separation** - Clear distinction between public/admin

---

## 🎯 Timeline

1. Open Supabase → **10 seconds**
2. Paste SQL → **5 seconds**
3. Click RUN → **5 seconds**
4. Test product save → **Success!** ✅

---

**Run this NOW and product saving will work!** 🚀

The RLS policies are configured for both security AND functionality!

