class IPModel {
  String id;
  String name;  
  String race;
  String type;
  String desc;
  String imageSmall;
  String imageBig;

  IPModel({
    this.id,
    this.name,
    this.race,
    this.type,
    this.desc,
    this.imageSmall,
    this.imageBig
  });

  factory IPModel.fromJson(Map<String, dynamic> json) {
    return IPModel(
      id: json['id'],
      name: json['name'], 
      race: json['race'], 
      type: json['type'],
      desc: json['desc'],
      imageSmall: parseImageSmall(json['card_images'][0]),
      imageBig: parseImageBig(json['card_images'][0]),
    );
  }

  static String parseImageSmall(imageJson){
    var imageList = ImageSmallModel.fromJson(imageJson);
    return imageList.imageSmall;
  }

  static String parseImageBig(imageJson){
    var imageList = ImageBigModel.fromJson(imageJson);
    return imageList.imageBig;
  }

  Map<String, dynamic> toJson() {
    return <String,dynamic>{
      'id' : this.id,
      'name' : this.name,
      'race' : this.race,
      'type' : this.type
    };
  }
}

class ImageSmallModel{
  String imageSmall;

  ImageSmallModel({
    this.imageSmall
  });

  factory ImageSmallModel.fromJson(Map<String, dynamic> json) {
    return ImageSmallModel(
      imageSmall: json['image_url_small']
    );
  }
}

class ImageBigModel{
  String imageBig;

  ImageBigModel({
    this.imageBig
  });

  factory ImageBigModel.fromJson(Map<String, dynamic> json) {
    return ImageBigModel(
        imageBig: json['image_url']
    );
  }
}

class ImageBigList{
  List<ImageBigModel> list;

  ImageBigList(this.list);

  factory ImageBigList.fromJson(List<dynamic> json){
    return ImageBigList(
        json?.map((e) => e == null ? null : ImageBigModel.fromJson(e as Map<String, dynamic>))?.toList()
    );
  }
}

class ImageSmallList{
  List<ImageSmallModel> list;

  ImageSmallList(this.list);

  factory ImageSmallList.fromJson(List<dynamic> json){
    return ImageSmallList(
        json?.map((e) => e == null ? null : ImageSmallModel.fromJson(e as Map<String, dynamic>))?.toList()
    );
  }
}

class IPList{
  List<IPModel> list;

  IPList(this.list);

  factory IPList.fromJson(List<dynamic> json){
    return IPList(
        json?.map((e) => e == null ? null : IPModel.fromJson(e as Map<String, dynamic>))?.toList()
    );
  }
}