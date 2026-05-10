import 'models/story_model.dart';
import 'models/story_user_model.dart';

final List<StoryUserModel> storyUsers = [

  StoryUserModel(

    username: 'iko',

    profileImage:
    'assets/images/story2.jpg',

    stories: [

      StoryModel(
        type: StoryType.image,

        media:
        'assets/images/post1.jpg',

        time: '2h',
      ),

      StoryModel(
        type: StoryType.image,

        media:
        'assets/images/post2.jpg',

        time: '1h',
      ),

      StoryModel(
        type: StoryType.video,

        media:
        'assets/videos/reel1.mp4',

        time: '45m',
      ),
    ],
  ),

  StoryUserModel(

    username: 'jules.h',

    profileImage:
    'assets/images/story3.jpg',

    stories: [

      StoryModel(
        type: StoryType.image,

        media:
        'assets/images/post4.jpg',

        time: '3h',
      ),

      StoryModel(
        type: StoryType.video,

        media:
        'assets/videos/reel2.mp4',

        time: '2h',
      ),
    ],
  ),

  StoryUserModel(

    username: 'mara.s',

    profileImage:
    'assets/images/post2.jpg',

    stories: [

      StoryModel(
        type: StoryType.image,

        media:
        'assets/images/post6.jpg',

        time: '1h',
      ),

      StoryModel(
        type: StoryType.image,

        media:
        'assets/images/post7.jpg',

        time: '45m',
      ),
    ],
  ),

  StoryUserModel(

    username: 'ona',

    profileImage:
    'assets/images/story1.jpg',

    stories: [

      StoryModel(
        type: StoryType.video,

        media:
        'assets/videos/reel1.mp4',

        time: '30m',
      ),

      StoryModel(
        type: StoryType.image,

        media:
        'assets/images/post8.jpg',

        time: '10m',
      ),
    ],
  ),
];