import 'story_model.dart';

class StoryUserModel {

  bool viewed;

  final String username;

  final String profileImage;

  final List<StoryModel> stories;

  StoryUserModel({
    required this.username,
    required this.profileImage,
    required this.stories,
    this.viewed = false,
  });

}