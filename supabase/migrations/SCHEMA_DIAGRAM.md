# Database Schema Diagram

## Artist Subscription System - Entity Relationships

```
┌─────────────────────────────────────────────────────────────────────┐
│                          auth.users                                  │
│                   (Supabase Built-in)                               │
│  ┌───────────────────────────────────────────────────────┐         │
│  │ - id (UUID)                                           │         │
│  │ - email                                               │         │
│  │ - created_at                                          │         │
│  └───────────────────────────────────────────────────────┘         │
└─────────────────────────────┬───────────────────────────────────────┘
                              │
                              │ REFERENCES (ON DELETE CASCADE)
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                           profiles                                   │
│                   (Migration 00001)                                 │
│  ┌───────────────────────────────────────────────────────┐         │
│  │ - id (UUID) PRIMARY KEY → auth.users(id)             │         │
│  │ - email                                               │         │
│  │ - full_name                                           │         │
│  │ - avatar_url                                          │         │
│  │ - artist_name                                         │         │
│  │ - subscription_package                                │         │
│  │ - subscription_status (inactive/active/cancelled)     │         │
│  │ - subscription_start_date                             │         │
│  │ - subscription_end_date                               │         │
│  │ - paypal_subscription_id                              │         │
│  │ - payfast_subscription_id                             │         │
│  │ - created_at                                          │         │
│  │ - updated_at                                          │         │
│  └───────────────────────────────────────────────────────┘         │
└─────────────────────────────┬───────────────────────────────────────┘
                              │
                              │ REFERENCED BY
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   artist_subscriptions                              │
│                   (Migration 00003)                                 │
│  ┌───────────────────────────────────────────────────────┐         │
│  │ - id (UUID) PRIMARY KEY                               │         │
│  │ - user_id (UUID) → profiles(id)                       │◄────────┼──┐
│  │ - package_id (UUID) → artist_subscription_packages(id)│         │  │
│  │ - package_name                                        │         │  │
│  │ - status (pending/active/cancelled/past_due/expired)  │         │  │
│  │ - payment_provider (paypal/payfast)                   │         │  │
│  │ - subscription_id (external)                          │         │  │
│  │ - currency (USD/ZAR)                                  │         │  │
│  │ - amount                                              │         │  │
│  │ - start_date                                          │         │  │
│  │ - end_date                                            │         │  │
│  │ - next_billing_date                                   │         │  │
│  │ - cancelled_at                                        │         │  │
│  │ - cancellation_reason                                 │         │  │
│  │ - metadata (JSONB)                                    │         │  │
│  │ - created_at                                          │         │  │
│  │ - updated_at                                          │         │  │
│  └───────────────────────────────────────────────────────┘         │  │
└─────────────────────────────┬───────────────────────────────────────┘  │
                              │                                           │
                              │ REFERENCES                                │
                              │                                           │
                              ▼                                           │
┌─────────────────────────────────────────────────────────────────────┐  │
│              artist_subscription_packages                           │  │
│                   (Migration 00002)                                 │  │
│  ┌───────────────────────────────────────────────────────┐         │  │
│  │ - id (UUID) PRIMARY KEY                               │         │  │
│  │ - package_name (UNIQUE)                               │         │  │
│  │ - display_name                                        │         │  │
│  │ - description                                         │         │  │
│  │ - price_zar                                           │         │  │
│  │ - price_usd                                           │         │  │
│  │ - product_slots                                       │         │  │
│  │ - features (JSONB array)                              │         │  │
│  │ - is_locked                                           │         │  │
│  │ - lock_reason                                         │         │  │
│  │ - border_color                                        │         │  │
│  │ - paypal_plan_id                                      │         │  │
│  │ - payfast_plan_id                                     │         │  │
│  │ - sort_order                                          │         │  │
│  │ - is_active                                           │         │  │
│  │ - created_at                                          │         │  │
│  │ - updated_at                                          │         │  │
│  └───────────────────────────────────────────────────────┘         │  │
│                                                                     │  │
│  Seeded with 5 packages:                                           │  │
│  1. Tester    ($2/R15)   - 5 slots                                 │  │
│  2. Hobbyist  ($4/R30)   - 15 slots                                │  │
│  3. Creator   ($10/R75)  - 30 slots                                │  │
│  4. Boutique  ($25/R189) - 50 slots  [LOCKED: 150+ products sold]  │  │
│  5. Gallery   ($32/R399) - 150 slots [LOCKED: Invitation only]     │  │
│                                                                     │  │
│  PayPal Plan IDs configured for:                                   │  │
│  - Boutique: P-9SN47701RA820541PNFVN27I                           │  │
│  - Gallery:  P-966999960M894463YNFVNYNQ                           │  │
└─────────────────────────────────────────────────────────────────────┘  │
                                                                          │
                                                                          │
┌─────────────────────────────────────────────────────────────────────┐  │
│                        AUTOMATIC FEATURES                            │  │
│                                                                     │  │
│  Triggers & Functions:                                              │  │
│  1. handle_new_user()                                               │  │
│     → Auto-creates profile when user signs up in auth.users         │  │
│                                                                     │  │
│  2. handle_updated_at()                                             │  │
│     → Auto-updates updated_at timestamps on all tables              │  │
│                                                                     │  │
│  3. sync_profile_subscription()  ───────────────────────────────────┼──┘
│     → Syncs subscription status from artist_subscriptions           │
│       back to profiles table when status changes                    │
│                                                                     │
│  Data Flow:                                                         │
│  User Signs Up → Profile Created → User Selects Package →           │
│  Subscription Created → Status Changes → Profile Updated            │
└─────────────────────────────────────────────────────────────────────┘
```

## Row Level Security (RLS) Policies

### profiles
```
✓ Public: Can SELECT (read all profiles)
✓ Users:  Can INSERT (create own profile)
✓ Users:  Can UPDATE (update own profile)
```

### artist_subscription_packages
```
✓ Public:        Can SELECT (read all packages)
✓ Authenticated: Can ALL (manage packages - admin function)
```

### artist_subscriptions
```
✓ Users:         Can SELECT (view own subscriptions)
✓ Users:         Can INSERT (create own subscriptions)
✓ Users:         Can UPDATE (update own subscriptions)
✓ Authenticated: Can SELECT (view all - admin)
✓ Authenticated: Can ALL (manage all - admin)
```

## Indexes for Performance

### profiles
- `idx_profiles_email`
- `idx_profiles_subscription_status`
- `idx_profiles_subscription_package`

### artist_subscription_packages
- `idx_artist_subscription_packages_package_name`
- `idx_artist_subscription_packages_sort_order`
- `idx_artist_subscription_packages_is_active`

### artist_subscriptions
- `idx_artist_subscriptions_user_id`
- `idx_artist_subscriptions_package_id`
- `idx_artist_subscriptions_status`
- `idx_artist_subscriptions_subscription_id`
- `idx_artist_subscriptions_next_billing_date`

## Migration Execution Order

```
1. 00001_create_profiles.sql
   ↓ (creates profiles table)
   
2. 00002_create_artist_subscription_packages.sql
   ↓ (creates packages table and seeds data)
   
3. 00003_create_artist_subscriptions.sql
   ↓ (creates subscriptions table with foreign keys to both)
   
✓ All dependencies resolved
✓ Foreign keys properly ordered
✓ Ready to execute
```

## External Integrations

### PayPal
- **Boutique Plan**: P-9SN47701RA820541PNFVN27I
- **Gallery Plan**: P-966999960M894463YNFVNYNQ
- **Pending**: Tester, Hobbyist, Creator plans

### PayFast
- Plans to be configured for ZAR currency

## Status Legend

- ✓ = Configured and ready
- ⏳ = Pending/To be configured
- 🔒 = Locked (requires criteria)

## Notes

1. All tables use UUIDs for primary keys
2. All tables have created_at and updated_at timestamps
3. All tables have RLS enabled
4. Timestamps are in UTC (TIMESTAMPTZ)
5. Currency amounts use DECIMAL(10, 2) for precision
6. Features stored as JSONB for flexibility
7. ON CONFLICT DO UPDATE for idempotent inserts
