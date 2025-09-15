import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Types for Food Consulting Admin Dashboard
export interface AdminUser {
  id: string;
  email: string;
  role: 'admin';
  full_name?: string;
  created_at: string;
  updated_at?: string;
}

export interface AppUser {
  id: string;
  email: string;
  full_name?: string;
  phone?: string;
  company?: string;
  role?: string;
  avatar_url?: string;
  document_number?: string;
  passport_number?: string;
  preferences?: Record<string, any>;
  created_at: string;
  updated_at?: string;
}

export interface Mission {
  id: string;
  name: string;
  description?: string;
  country: string;
  city: string;
  cover_image_url?: string;
  start_date: string;
  end_date: string;
  currency?: string;
  exchange_rate?: number;
  timezone?: string;
  language?: string;
  average_temperature?: number;
  emergency_contact?: string;
  emergency_phone?: string;
  status: 'draft' | 'active' | 'completed' | 'cancelled';
  created_at: string;
  updated_at?: string;
}

export interface UserMission {
  id: string;
  user_id: string;
  mission_id: string;
  assigned_at: string;
}

// Card Types for different mission sections
export interface MissionCard {
  id: string;
  mission_id: string;
  section_type: 'anuga' | 'destination' | 'accommodation' | 'transport' | 'activity' | 'culture';
  card_type: 'shared' | 'user_specific';
  title: string;
  description?: string;
  image_url?: string;
  link_url?: string;
  display_order: number;
  is_active: boolean;
  created_at: string;
  updated_at?: string;
}

export interface UserSpecificCard {
  id: string;
  card_id: string;
  user_id: string;
  booking_reference?: string;
  check_in_code?: string;
  seat_number?: string;
  additional_info?: Record<string, any>;
  created_at: string;
  updated_at?: string;
}

// Auth helper functions
export async function signInAdmin(email: string, password: string) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });
  return { data, error };
}

export async function signOutAdmin() {
  const { error } = await supabase.auth.signOut();
  return { error };
}

export async function getCurrentUser() {
  const { data: { user } } = await supabase.auth.getUser();
  return user;
}