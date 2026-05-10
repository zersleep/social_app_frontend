enum StoryType {
  image,
  video,
}

class StoryModel {

  final StoryType type;

  final String media;

  final String time;

  const StoryModel({
    required this.type,
    required this.media,
    required this.time,
  });
}