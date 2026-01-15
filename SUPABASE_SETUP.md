# 🚀 Supabase Integration Setup Guide

## 📋 Prerequisites
1. Supabase account (free tier works fine)
2. Flutter project with dependencies installed

## 🔧 Setup Steps

### Step 1: Create Supabase Project
1. Go to [Supabase.com](https://supabase.com)
2. Click "New Project"
3. Enter project name and database password
4. Wait for project to be ready (~2 minutes)

### Step 2: Get Your Credentials
1. In your Supabase project dashboard
2. Click on **Settings** (gear icon) → **API**
3. Copy these values:
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **anon/public key** (starts with `eyJ...`)

### Step 3: Configure Flutter App
Open `lib/data/supabase/supabase_config.dart` and replace:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

With your actual credentials:

```dart
static const String supabaseUrl = 'https://xxxxx.supabase.co';
static const String supabaseAnonKey = 'eyJhbGc...your-actual-key';
```

### Step 4: Run SQL Schema
1. In Supabase dashboard, go to **SQL Editor**
2. Click **New Query**
3. Copy the entire content from `supabase_setup.sql`
4. Paste and click **Run**
5. You should see "Success. No rows returned"

### Step 5: Verify Database
1. Go to **Table Editor** in Supabase
2. You should see the `products` table
3. Go to **Storage** → You should see `product-images` bucket

### Step 6: Install Flutter Dependencies
```bash
flutter pub get
```

### Step 7: Run the App
```bash
flutter run -d windows
```

## ✅ Testing the Integration

### Test Product Creation:
1. Open the app
2. Go to Admin → Products
3. Click "Add Product"
4. Fill in the form
5. Click Save
6. Check Supabase Table Editor to see the new product

### Test Product Listing:
1. In Supabase Table Editor, add a few products manually
2. Refresh the Products screen in the app
3. Products should appear in the grid

### Test Product Update:
1. Click Edit icon on any product
2. Change the name or price
3. Save
4. Verify changes in Supabase

### Test Product Delete:
1. Click Delete icon on any product
2. Confirm deletion
3. Product should be removed from both app and database

## 🔍 Troubleshooting

### Error: "Failed to fetch products"
- Check your internet connection
- Verify Supabase URL and key are correct
- Check Supabase project is running (not paused)

### Error: "Row Level Security policy violation"
- Make sure RLS policies are created (run the SQL schema again)
- For testing, you can temporarily disable RLS:
  ```sql
  ALTER TABLE products DISABLE ROW LEVEL SECURITY;
  ```

### No products showing:
- Add sample products in Supabase Table Editor
- Check console for error messages
- Verify the table name is exactly `products` (lowercase)

## 📊 What's Connected

✅ **Products CRUD Operations:**
- Create new products
- Read/list all products
- Update existing products
- Delete products
- Search products by name
- Filter by category

✅ **Database Features:**
- UUID primary keys
- Timestamps (created_at, updated_at)
- Image URL storage (array)
- Category indexing for fast queries
- Row Level Security enabled

✅ **Storage (Ready for images):**
- Product images bucket created
- Public read access
- Authenticated upload/delete

## 🚀 Next Steps

### To Add Image Upload:
The repository already has `uploadProductImage()` method ready.
You'll need to:
1. Add image picker package
2. Connect to upload button in form
3. Call repository method

### To Add More Features:
- Order management (create `orders` table)
- User management (use Supabase Auth)
- Categories (create `categories` table)
- Analytics (create views)

## 📝 File Structure

```
lib/
├── data/
│   ├── models/
│   │   └── product_model.dart         # Product data model
│   ├── repositories/
│   │   └── product_repository.dart    # Supabase operations
│   └── supabase/
│       └── supabase_config.dart       # Supabase client config
└── screens/
    └── admin/
        └── products_screen.dart        # UI connected to Supabase
```

## 🎉 You're All Set!

Your Product Management is now fully connected to Supabase. All CRUD operations are working with a real database backend.

---

**Need Help?**
- [Supabase Docs](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)

