class Room {
  final String id;
  final String landlordId;
  final String title;
  final int price;
  final int deposit;
  final String address;
  final String location;
  final int capacity;
  final int currentOccupants;
  final List<String> amenities;
  final List<String> photos;
  final String availability; // 'available' or 'full'
  final String description;
  final String landlordName;
  final String landlordPhone;

  const Room({
    required this.id,
    required this.landlordId,
    required this.title,
    required this.price,
    required this.deposit,
    required this.address,
    required this.location,
    required this.capacity,
    required this.currentOccupants,
    required this.amenities,
    this.photos = const [],
    required this.availability,
    required this.description,
    required this.landlordName,
    required this.landlordPhone,
  });

  int get spotsLeft => capacity - currentOccupants;
}
