# 🔧 URGENT FIX: Missing Database Columns

## Error Messages:
```
❌ Could not find the 'made_by' column of 'products'
❌ Could not find the 'selling_price_usd' column of 'products'
```

---

## The Problem

Your products table is missing several columns that the app needs to save products.

---

## ⚡ Quick Fix (Do This NOW):

### Step 1: Open Supabase SQL Editor
1. Go to your Supabase Dashboard
2. Click **SQL Editor** (left sidebar)
3. Click **New query**

### Step 2: Copy & Paste This SQL
Open the file: `fix_products_schema.sql`

Or copy this:
```sql
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS cost_price_zar NUMERIC(10,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS cost_price_usd NUMERIC(10,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS made_by TEXT,
ADD COLUMN IF NOT EXISTS materials TEXT[],
ADD COLUMN IF NOT EXISTS styling TEXT,
ADD COLUMN IF NOT EXISTS selling_price_usd NUMERIC(10,2),
ADD COLUMN IF NOT EXISTS base_price_usd NUMERIC(10,2),
ADD COLUMN IF NOT EXISTS member_price_usd NUMERIC(10,2),
ADD COLUMN IF NOT EXISTS promo_price_usd NUMERIC(10,2);
```

### Step 3: Run the SQL
Click **RUN** button (or press Ctrl+Enter)

### Step 4: Verify
You should see: **Success. No rows returned**

---

## What This Adds

The SQL adds these missing columns:

### Cost Prices:
- ✅ `cost_price_zar` - Total cost in ZAR
- ✅ `cost_price_usd` - Total cost in USD

### Product Info:
- ✅ `made_by` - Artist/manufacturer name
- ✅ `materials` - Array of materials used
- ✅ `styling` - Styling tips

### USD Prices:
- ✅ `selling_price_usd` - Selling price in USD
- ✅ `base_price_usd` - RRP in USD
- ✅ `member_price_usd` - Member price in USD
- ✅ `promo_price_usd` - Promo price in USD

---

## After Running SQL

1. **Go back to your app**
2. **Try saving the product again**
3. **Should work now!** ✅

---

## Complete Products Table Schema

After running the SQL, your products table will have:

```
products
├── id (UUID) - Primary key
├── name (TEXT) - Product name
├── category (TEXT) - Collection name
├── description (TEXT) - Product description
├── styling (TEXT) - Styling tips ✨ NEW
├── base_price_zar (NUMERIC) - RRP ZAR
├── base_price_usd (NUMERIC) - RRP USD ✨ NEW
├── selling_price_zar (NUMERIC) - Selling ZAR
├── selling_price_usd (NUMERIC) - Selling USD ✨ NEW
├── member_price_zar (NUMERIC) - Member ZAR
├── member_price_usd (NUMERIC) - Member USD ✨ NEW
├── promo_price_zar (NUMERIC) - Promo ZAR
├── promo_price_usd (NUMERIC) - Promo USD ✨ NEW
├── cost_price_zar (NUMERIC) - Cost ZAR ✨ NEW
├── cost_price_usd (NUMERIC) - Cost USD ✨ NEW
├── stock_quantity (INTEGER) - Stock count
├── images (TEXT[]) - Image URLs
├── is_featured (BOOLEAN)
├── is_new_arrival (BOOLEAN)
├── is_best_seller (BOOLEAN)
├── is_vault_item (BOOLEAN)
├── allow_gift_wrap (BOOLEAN)
├── allow_gift_message (BOOLEAN)
├── status (TEXT) - Product status
├── url_slug (TEXT) - URL friendly name
├── sku (TEXT) - Stock keeping unit
├── made_by (TEXT) - Artist name ✨ NEW
├── materials (TEXT[]) - Materials array ✨ NEW
├── created_at (TIMESTAMPTZ)
└── updated_at (TIMESTAMPTZ)
```

---

## 🎯 Summary

**File to run**: `fix_products_schema.sql`

**Where**: Supabase SQL Editor

**Result**: All missing columns added, product saving will work!

---

**Run this NOW and your product save will work!** 🚀

