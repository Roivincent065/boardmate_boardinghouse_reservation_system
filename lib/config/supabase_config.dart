const String supabaseUrl = 'https://wfertcjlyllocsqiwzir.supabase.co';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmZXJ0Y2pseWxsb2NzcWl3emlyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4NDYyODgsImV4cCI6MjA5NDQyMjI4OH0.NLCmfhj4VRwh4E2dgAbW5J95KtYKvtAafIFdXYlosSU';

/// Replace the values above with your Supabase project URL and anon key.
///
/// Backend schema recommendations:
/// - profiles: id (text, primary key), name, username, email, role, school, budget_min,
///   budget_max, preferred_location, move_in_date, study_habit, personality, smoker,
///   sleep_schedule, cleanliness
/// - rooms: id, landlord_id, title, price, deposit, address, location, capacity,
///   current_occupants, amenities, photos, availability, description, landlord_name,
///   landlord_phone
/// - messages: id, sender_id, receiver_id, text, timestamp
