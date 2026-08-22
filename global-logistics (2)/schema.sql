-- Global Logistics Supabase Schema
-- Run this in your Supabase SQL Editor

-- ============================================
-- PROFILES TABLE
-- ============================================
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT NOT NULL,
  role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS on profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Profiles are viewable by authenticated users" 
  ON public.profiles FOR SELECT 
  USING (auth.role() = 'authenticated');

CREATE POLICY "Users can view own profile" 
  ON public.profiles FOR SELECT 
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" 
  ON public.profiles FOR UPDATE 
  USING (auth.uid() = id);

CREATE POLICY "Admins can update any profile" 
  ON public.profiles FOR UPDATE 
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "Admins can view all profiles" 
  ON public.profiles FOR SELECT 
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- ============================================
-- TRACKING TABLE
-- ============================================
CREATE TABLE public.tracking (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  tracking_id TEXT UNIQUE NOT NULL,
  origin TEXT NOT NULL,
  destination TEXT NOT NULL,
  status TEXT DEFAULT 'Pending' CHECK (status IN ('Pending', 'In Transit', 'Delivered', 'Exception')),
  estimated_delivery DATE,
  customer_email TEXT,
  origin_lat FLOAT,
  origin_lng FLOAT,
  dest_lat FLOAT,
  dest_lng FLOAT,
  duration_hours INTEGER DEFAULT 24,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS on tracking
ALTER TABLE public.tracking ENABLE ROW LEVEL SECURITY;

-- Tracking policies
CREATE POLICY "Tracking codes are viewable by all authenticated users" 
  ON public.tracking FOR SELECT 
  USING (auth.role() = 'authenticated');

CREATE POLICY "Only admins can insert tracking codes" 
  ON public.tracking FOR INSERT 
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "Only admins can update tracking codes" 
  ON public.tracking FOR UPDATE 
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "Only admins can delete tracking codes" 
  ON public.tracking FOR DELETE 
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- ============================================
-- AUTO-CREATE PROFILE TRIGGER
-- ============================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, role)
  VALUES (
    NEW.id,
    NEW.email,
    CASE 
      WHEN NEW.email = 'frankroony474@gmail.com' THEN 'admin'
      ELSE 'user'
    END
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- EXAMPLE DATA (Optional - uncomment to use)
-- ============================================
-- INSERT INTO public.tracking (tracking_id, origin, destination, status, origin_lat, origin_lng, dest_lat, dest_lng, duration_hours, estimated_delivery, customer_email)
-- VALUES 
--   ('GL-ABC123', 'New York, USA', 'Los Angeles, USA', 'In Transit', 40.7128, -74.0060, 34.0522, -118.2437, 48, '2024-12-25', 'customer@example.com'),
--   ('GL-DEF456', 'London, UK', 'Paris, France', 'Pending', 51.5074, -0.1278, 48.8566, 2.3522, 12, '2024-12-20', 'client@example.com');
