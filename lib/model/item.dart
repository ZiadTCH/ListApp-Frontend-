
class Item {
    int id;
    String name;
    String description;

    Item({
        required this.id,
        required this.name,
        required this.description,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        description: json["description"],
    );
    
}
