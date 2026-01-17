# Supabase Migrations for Artist Subscription System

This directory contains SQL migration files for setting up the artist subscription system in Supabase.

## Migration Files

The migrations should be run in the following order:

1. **00001_create_profiles.sql** - Creates the profiles table to extend auth.users
2. **00002_create_artist_subscription_packages.sql** - Creates subscription packages table with PayPal plan IDs
3. **00003_create_artist_subscriptions.sql** - Creates artist subscriptions tracking table

## How to Run Migrations

### Option 1: Run Each File Individually (Recommended)

1. Log into your Supabase project dashboard
2. Navigate to the SQL Editor
3. Copy and paste the contents of each migration file in order
4. Execute each file one at a time

### Option 2: Run Combined Migration

For convenience, you can use `run_all_migrations.sql` which combines all three migrations into a single file.

## Database Schema Overview

### profiles
- Extends `auth.users` with additional user profile data
- Stores subscription status and package information
- Auto-created when a new user signs up

### artist_subscription_packages
- Defines the 5 available subscription packages:
  - **Tester** ($2 USD / R15 ZAR) - 5 product slots
  - **Hobbyist** ($4 USD / R30 ZAR) - 15 product slots
  - **Creator** ($10 USD / R75 ZAR) - 30 product slots
  - **Boutique** ($25 USD / R189 ZAR) - 50 product slots (locked: 150+ products sold)
  - **Gallery** ($32 USD / R399 ZAR) - 150 product slots (invitation only)
- Contains PayPal plan IDs for Boutique and Gallery packages

### artist_subscriptions
- Tracks individual subscription records
- Links users (profiles) to their subscription packages
- Stores subscription status, payment provider info, and billing dates
- Automatically syncs subscription status back to profiles table

## PayPal Integration

The following PayPal plan IDs are configured:
- **Boutique**: `P-9SN47701RA820541PNFVN27I`
- **Gallery**: `P-966999960M894463YNFVNYNQ`

Tester, Hobbyist, and Creator packages still need PayPal plans created and their IDs added.

## Row Level Security (RLS)

All tables have RLS enabled with the following policies:

**profiles**:
- Public read access
- Users can insert/update their own profile

**artist_subscription_packages**:
- Public read access
- Authenticated users can manage packages (admin function)

**artist_subscriptions**:
- Users can view/create/update their own subscriptions
- Authenticated users have full access (admin function)

## Automatic Features

1. **Auto-create profile on signup**: When a new user is created in auth.users, a profile is automatically created
2. **Auto-update timestamps**: updated_at is automatically updated when records change
3. **Subscription sync**: When a subscription becomes active or cancelled, the profile is automatically updated

## Troubleshooting

### "relation 'profiles' does not exist"
- Ensure you run migration 00001 first, which creates the profiles table
- If you already have a profiles table, you may need to adjust the migration

### "function handle_updated_at() does not exist"
- This function is created in 00001_create_profiles.sql
- Make sure to run migrations in order

### Testing Migrations Locally
```bash
# If you have PostgreSQL installed locally, you can test syntax:
psql -U postgres -d your_test_db -f 00001_create_profiles.sql
psql -U postgres -d your_test_db -f 00002_create_artist_subscription_packages.sql
psql -U postgres -d your_test_db -f 00003_create_artist_subscriptions.sql
```

## Next Steps

After running these migrations:

1. Create PayPal subscription plans for Tester, Hobbyist, and Creator packages
2. Update `00002_create_artist_subscription_packages.sql` with the new plan IDs
3. Re-run the migration (will use ON CONFLICT to update existing records)
4. Implement PayPal webhook handlers for subscription events
5. Test the complete payment flow
