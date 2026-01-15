# 🚨 URGENT FIX REQUIRED - Product Save Error

## ⚠️ PROBLEM
Your products won't save because the database is missing UUID auto-generation!

Error: `null value in column "id" of relation "products" violates not-null constraint`

---

## ✅ SOLUTION (2 STEPS)

### STEP 1: Fix Database (REQUIRED - DO THIS NOW!)

1. **Open Supabase Dashboard** → https://supabase.com/dashboard
2. Go to **SQL Editor** (left sidebar)
3. Click **"New Query"**
4. **Copy ALL** the SQL from file: `FIX_PRODUCTS_TABLE.sql`
5. **Paste** into the SQL editor
6. Click **"RUN"** (bottom right)
7. ✅ You should see a result table showing your columns with defaults

**If you get an error, check:**
- Make sure you selected the correct project
- Make sure you're in the SQL Editor (not Table Editor)

---

### STEP 2: Restart Your Flutter App

After running the SQL:

```bash
# In your terminal where Flutter is running
r  # (Hot reload)
```

Or fully restart:
```bash
# Press Ctrl+C to stop
flutter run
```

---

## 🎯 WHAT WILL HAPPEN

After completing both steps:

1. Database now has UUID auto-generation ✅
2. Code properly sends clean data ✅
3. Products will save successfully ✅

---

## 🔍 HOW TO VERIFY IT WORKED

After running the SQL, look at the output. You should see:

```
column_name  | data_type | is_nullable | column_default
-------------|-----------|-------------|------------------
id           | uuid      | NO          | uuid_generate_v4()
product_type | text      | NO          | 'other'
created_at   | timestamp | YES         | now()
updated_at   | timestamp | YES         | now()
```

---

## ⏱️ TIME TO FIX: 2 minutes

**DO IT NOW!** This is blocking all product creation.

Once done, try saving a product - it will work! 🎉

