import 'story_model.dart';

class StoryUserModel {

  final String username;

  final String profileImage;

  final List<StoryModel> stories;

  const StoryUserModel({
    required this.username,
    required this.profileImage,
    required this.stories,
  });
}