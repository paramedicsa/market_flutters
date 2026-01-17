# Artist Subscription System - Migration Setup Guide

## Problem Resolved
✅ **Fixed**: `ERROR: 42P01: relation "profiles" does not exist`

The error occurred because the `artist_subscription_packages` table references the `profiles` table, but `profiles` didn't exist. This has been resolved by creating a complete migration that includes all necessary tables in the correct order.

## Quick Start

### Option 1: Run Combined Migration (Easiest)

1. Open your Supabase project dashboard
2. Navigate to: **SQL Editor** (in the sidebar)
3. Copy the entire contents of `supabase/migrations/run_all_migrations.sql`
4. Paste into the SQL Editor
5. Click **Run** or press Ctrl+Enter
6. Wait for completion (you'll see success messages at the end)

### Option 2: Run Individual Migrations

If you prefer to run migrations one at a time:

1. Open Supabase SQL Editor
2. Run each file in order:
   - `00001_create_profiles.sql`
   - `00002_create_artist_subscription_packages.sql`
   - `00003_create_artist_subscriptions.sql`

## What Was Created

### 1. profiles Table
- Extends `auth.users` with additional user data
- Stores subscription status and package information
- Auto-created when users sign up
- Includes fields for PayPal and PayFast subscription IDs

### 2. artist_subscription_packages Table
- Contains 5 predefined subscription packages:
  
  | Package | USD | ZAR | Slots | PayPal Plan ID | Status |
  |---------|-----|-----|-------|----------------|--------|
  | Tester | $2 | R15 | 5 | To be added | Unlocked |
  | Hobbyist | $4 | R30 | 15 | To be added | Unlocked |
  | Creator | $10 | R75 | 30 | To be added | Unlocked |
  | Boutique | $25 | R189 | 50 | P-9SN47701RA820541PNFVN27I | Locked* |
  | Gallery | $32 | R399 | 150 | P-966999960M894463YNFVNYNQ | Locked** |

  *Requires 150+ products sold  
  **Invitation only

### 3. artist_subscriptions Table
- Tracks individual subscription records
- Links users to their chosen packages
- Stores payment provider details
- Auto-syncs subscription status back to profiles

## Verification

After running the migration, you can verify it worked by running this query in Supabase SQL Editor:

```sql
-- Check tables exist
SELECT tablename FROM pg_tables 
WHERE tablename IN ('profiles', 'artist_subscription_packages', 'artist_subscriptions');

-- Check packages were inserted
SELECT display_name, price_usd, price_zar, paypal_plan_id 
FROM artist_subscription_packages 
ORDER BY sort_order;
```

Expected output:
- 3 table names
- 5 subscription packages with details

## Security (RLS Policies)

All tables have Row Level Security (RLS) enabled:

- **profiles**: Public read, users can manage their own
- **artist_subscription_packages**: Public read, admin write
- **artist_subscriptions**: Users can view/manage their own, admins can view all

## Automatic Features

✅ **Auto-create profile** on user signup  
✅ **Auto-update timestamps** when records change  
✅ **Auto-sync subscription** status from subscriptions to profiles  

## Next Steps

### 1. Create PayPal Plans
You still need to create PayPal subscription plans for:
- Tester ($2/month)
- Hobbyist ($4/month)
- Creator ($10/month)

Once created, update the database:
```sql
UPDATE artist_subscription_packages 
SET paypal_plan_id = 'P-YOUR-PLAN-ID-HERE' 
WHERE package_name = 'tester';
```

### 2. Test the Integration
- Ensure your Flutter app can query the `artist_subscription_packages` table
- Test the PayPal button integration for Boutique and Gallery packages
- Verify the payment flow works end-to-end

### 3. Implement Webhooks
Set up PayPal webhooks to handle:
- Subscription activation
- Subscription renewal
- Subscription cancellation
- Payment failures

## Troubleshooting

### "relation 'auth.users' does not exist"
This shouldn't happen in Supabase as `auth.users` is built-in. If you see this error:
1. Ensure you're running the SQL in your Supabase project (not a local PostgreSQL)
2. Check that you're in the correct database schema

### "permission denied for schema auth"
The migration functions use `SECURITY DEFINER` which requires admin permissions. This is normal and should work in Supabase SQL Editor.

### Need to Reset?
To completely remove the tables and start over:
```sql
DROP TABLE IF EXISTS artist_subscriptions CASCADE;
DROP TABLE IF EXISTS artist_subscription_packages CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;
DROP FUNCTION IF EXISTS sync_profile_subscription CASCADE;
DROP FUNCTION IF EXISTS handle_updated_at CASCADE;
DROP FUNCTION IF EXISTS handle_new_user CASCADE;
```

Then re-run the migration.

## Files Reference

- `00001_create_profiles.sql` - Profiles table
- `00002_create_artist_subscription_packages.sql` - Package definitions
- `00003_create_artist_subscriptions.sql` - Subscription tracking
- `run_all_migrations.sql` - Combined migration (use this one!)
- `README.md` - Detailed documentation
- `validate_migrations.sh` - Validation script
- `SETUP_GUIDE.md` - This file

## Support

If you encounter issues:
1. Check the Supabase logs in the dashboard
2. Verify you're running the migration in the correct project
3. Review the error message carefully
4. Check that all prerequisites (auth.users) are available

## Migration Status

✅ Profiles table created  
✅ Subscription packages table created  
✅ Package data seeded with PayPal IDs for Boutique & Gallery  
✅ Subscriptions tracking table created  
✅ RLS policies configured  
✅ Triggers and functions set up  
⏳ PayPal plans needed for Tester, Hobbyist, Creator  
⏳ Webhook handlers to be implemented  

---

**Note**: This migration is idempotent - you can run it multiple times safely. Existing data will be preserved using `CREATE TABLE IF NOT EXISTS` and `ON CONFLICT` clauses.
