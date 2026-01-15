# 🔐 Supabase Credentials Configuration

## Your Project Details
Based on the context, here's what you need to add:

### Edit this file:
`lib/data/supabase/supabase_config.dart`

### Replace these lines:

**FROM:**
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

**TO:**
```dart
static const String supabaseUrl = 'https://hykorszulmehingfzqso.supabase.co';
static const String supabaseAnonKey = 'YOUR_ACTUAL_ANON_KEY_HERE';
```

## 📝 How to Get Your Anon Key:

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project: `hykorszulmehingfzqso`
3. Click **Settings** → **API**
4. Copy the **anon/public** key (starts with `eyJ...`)
5. Paste it in `supabase_config.dart`

## ✅ Quick Test:

After adding credentials, run:
```bash
flutter run -d windows
```

Navigate to **Admin → Products** and try creating a product!

## 🚨 Security Note:

For production apps, **NEVER** commit credentials to Git!
Use environment variables or secure storage instead.

For this Flutter app, consider using:
- `flutter_dotenv` package
- Or Flutter's `--dart-define` build flags

---

**Next Steps:**
1. Add your anon key to `supabase_config.dart`
2. Run the SQL schema in Supabase (see `supabase_setup.sql`)
3. Test the app!

