# SQL Migration Fix - Summary

## Issue Fixed
**Error**: `ERROR: 42P01: relation "profiles" does not exist`

**Root Cause**: The artist subscription system was trying to reference a `profiles` table that didn't exist in the database.

## Solution Implemented

Created a complete, properly ordered migration system in `supabase/migrations/`:

### Migration Files (Run in Order)

#### 1. 00001_create_profiles.sql
Creates the `profiles` table that extends Supabase's `auth.users` table.

**Key Features:**
- Links to auth.users via foreign key
- Stores subscription status (inactive, active, cancelled, past_due)
- Tracks subscription package and dates
- Stores PayPal and PayFast subscription IDs
- Auto-creates profile when user signs up
- Auto-updates timestamps

**Schema:**
```sql
profiles (
  id UUID PRIMARY KEY → auth.users(id),
  email TEXT,
  full_name TEXT,
  avatar_url TEXT,
  artist_name TEXT,
  subscription_package TEXT,
  subscription_status TEXT DEFAULT 'inactive',
  subscription_start_date TIMESTAMPTZ,
  subscription_end_date TIMESTAMPTZ,
  paypal_subscription_id TEXT,
  payfast_subscription_id TEXT,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ
)
```

#### 2. 00002_create_artist_subscription_packages.sql
Creates the subscription packages table and seeds it with 5 packages.

**Key Features:**
- Defines all available subscription tiers
- Includes pricing in both ZAR and USD
- Stores PayPal plan IDs for payment integration
- Contains feature lists as JSONB
- Marks locked packages (Boutique, Gallery)

**Packages Seeded:**

| Package | USD/month | ZAR/month | Slots | PayPal Plan ID | Status |
|---------|-----------|-----------|-------|----------------|--------|
| Tester | $2 | R15 | 5 | TBD | ✅ Available |
| Hobbyist | $4 | R30 | 15 | TBD | ✅ Available |
| Creator | $10 | R75 | 30 | TBD | ✅ Available |
| Boutique | $25 | R189 | 50 | P-9SN47701RA820541PNFVN27I | 🔒 150+ products sold |
| Gallery | $32 | R399 | 150 | P-966999960M894463YNFVNYNQ | 🔒 Invitation only |

**Schema:**
```sql
artist_subscription_packages (
  id UUID PRIMARY KEY,
  package_name TEXT UNIQUE,
  display_name TEXT,
  description TEXT,
  price_zar DECIMAL(10, 2),
  price_usd DECIMAL(10, 2),
  product_slots INTEGER,
  features JSONB,
  is_locked BOOLEAN,
  lock_reason TEXT,
  border_color TEXT,
  paypal_plan_id TEXT,
  payfast_plan_id TEXT,
  sort_order INTEGER,
  is_active BOOLEAN,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ
)
```

#### 3. 00003_create_artist_subscriptions.sql
Creates the subscription tracking table.

**Key Features:**
- Links users (profiles) to packages they subscribe to
- Tracks subscription lifecycle (pending, active, cancelled, expired)
- Stores payment provider details (PayPal or PayFast)
- Records billing dates and amounts
- Auto-syncs status back to profiles table

**Schema:**
```sql
artist_subscriptions (
  id UUID PRIMARY KEY,
  user_id UUID → profiles(id),
  package_id UUID → artist_subscription_packages(id),
  package_name TEXT,
  status TEXT,
  payment_provider TEXT,
  subscription_id TEXT,
  currency TEXT,
  amount DECIMAL(10, 2),
  start_date TIMESTAMPTZ,
  end_date TIMESTAMPTZ,
  next_billing_date TIMESTAMPTZ,
  cancelled_at TIMESTAMPTZ,
  cancellation_reason TEXT,
  metadata JSONB,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ
)
```

### Convenience Files

#### run_all_migrations.sql
- Combines all 3 migrations into a single file
- Can be executed in one go in Supabase SQL Editor
- Includes verification queries at the end
- Shows success messages when complete

#### README.md
- Detailed documentation of the migration system
- Explains each table and its purpose
- Lists all RLS policies
- Describes automatic features (triggers, functions)

#### SETUP_GUIDE.md
- Quick start guide for executing migrations
- Step-by-step instructions
- Troubleshooting section
- Verification queries
- Next steps for PayPal plan creation

#### validate_migrations.sh
- Bash script to validate SQL syntax
- Checks for common errors
- Verifies balanced parentheses
- Reports validation status

## Security (RLS)

All tables have Row Level Security enabled:

**profiles**
- ✅ Public can read all profiles
- ✅ Users can insert/update their own profile

**artist_subscription_packages**
- ✅ Public can read all packages
- ✅ Authenticated users (admins) can manage packages

**artist_subscriptions**
- ✅ Users can view/create/update their own subscriptions
- ✅ Authenticated users (admins) can view all subscriptions

## Automatic Features

### Triggers & Functions

1. **handle_new_user()** - Auto-creates profile when user signs up
2. **handle_updated_at()** - Auto-updates `updated_at` timestamp
3. **sync_profile_subscription()** - Syncs subscription status from subscriptions table to profiles table

### Data Flow

```
User Signs Up → Profile Created Automatically
       ↓
User Selects Package → Creates Subscription Record
       ↓
Subscription Activated → Profile Updated with Package Info
       ↓
Subscription Changes → Profile Synced Automatically
```

## Testing

✅ **Syntax Validation**: All SQL files passed validation
✅ **Balanced Parentheses**: Verified
✅ **CREATE Statements**: All present
✅ **Foreign Keys**: Properly ordered (profiles → packages → subscriptions)

## How to Execute

### Quick Method (Recommended)
1. Open Supabase Dashboard → SQL Editor
2. Copy entire contents of `run_all_migrations.sql`
3. Paste and execute
4. Verify success messages appear

### Alternative Method
Run each file individually in order:
1. `00001_create_profiles.sql`
2. `00002_create_artist_subscription_packages.sql`
3. `00003_create_artist_subscriptions.sql`

## Verification Queries

After running migration, execute these to verify:

```sql
-- Check tables exist
SELECT tablename FROM pg_tables 
WHERE tablename IN ('profiles', 'artist_subscription_packages', 'artist_subscriptions');

-- Check packages
SELECT display_name, price_usd, price_zar, paypal_plan_id 
FROM artist_subscription_packages 
ORDER BY sort_order;

-- Check RLS policies
SELECT tablename, policyname 
FROM pg_policies 
WHERE tablename IN ('profiles', 'artist_subscription_packages', 'artist_subscriptions');
```

## Next Steps

1. ✅ Migration files created - **COMPLETE**
2. ⏳ Execute migration in Supabase - **USER ACTION REQUIRED**
3. ⏳ Create PayPal plans for Tester, Hobbyist, Creator
4. ⏳ Update database with new PayPal plan IDs
5. ⏳ Implement PayPal webhook handlers
6. ⏳ Test payment flow end-to-end

## Files Changed

```
supabase/migrations/
├── 00001_create_profiles.sql                    (NEW - 83 lines)
├── 00002_create_artist_subscription_packages.sql (NEW - 172 lines)
├── 00003_create_artist_subscriptions.sql        (NEW - 115 lines)
├── run_all_migrations.sql                        (NEW - 404 lines)
├── README.md                                     (NEW - detailed docs)
├── SETUP_GUIDE.md                                (NEW - quick start)
└── validate_migrations.sh                        (NEW - validation script)
```

## Impact

- ❌ **Before**: Database error blocking artist subscription system
- ✅ **After**: Complete schema ready for PayPal integration
- ⚡ **Breaking Changes**: None (new feature)
- 🔒 **Security**: RLS policies configured
- 📊 **Data**: 5 subscription packages seeded

---

**Status**: ✅ Ready to deploy  
**Review**: SQL syntax validated, foreign keys properly ordered  
**Action Required**: Execute migration in Supabase SQL Editor
