-- Table for artist applications
CREATE TABLE IF NOT EXISTS artist_applications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    surname TEXT NOT NULL,
    email TEXT NOT NULL,
    whatsapp TEXT NOT NULL,
    country_code TEXT NOT NULL,
    country TEXT NOT NULL,
    artist_name TEXT NOT NULL,
    image_urls TEXT[] NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending', -- pending, approved, denied
    denial_reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now()),
    user_id TEXT
);

-- Table for notifications to artists
CREATE TABLE IF NOT EXISTS artist_notifications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    artist_application_id uuid REFERENCES artist_applications(id) ON DELETE CASCADE,
    type TEXT NOT NULL, -- approval, denial, info
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now()),
    read BOOLEAN DEFAULT FALSE
);

-- Index for fast admin queries
CREATE INDEX IF NOT EXISTS idx_artist_applications_status ON artist_applications(status);

