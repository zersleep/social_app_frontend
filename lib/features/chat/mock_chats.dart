import 'chat_models.dart';

const List<ChatStory> mockStories = [
  ChatStory(
    name: 'Your Story',
    avatar: 'assets/images/story1.jpg',
    isYourStory: true,
  ),
  ChatStory(
    name: 'Danny',
    avatar: 'assets/images/story2.jpg',
  ),
  ChatStory(
    name: 'Kesha',
    avatar: 'assets/images/post4.jpg',
  ),
  ChatStory(
    name: 'Raihan',
    avatar: 'assets/images/post5.jpg',
  ),
  ChatStory(
    name: 'Sharuki',
    avatar: 'assets/images/post6.jpg',
  ),
  ChatStory(
    name: 'Maya',
    avatar: 'assets/images/post7.jpg',
  ),
  ChatStory(
    name: 'Leon',
    avatar: 'assets/images/post8.jpg',
  ),
];

const List<ChatMessage> mockMessages = [
  ChatMessage(
    name: 'Raffialdo Bayu',
    avatar: 'assets/images/story3.jpg',
    lastMessage: '10 minutes to campus, bro.',
    time: '13:46',
    unreadCount: 2,
    isOnline: true,
  ),
  ChatMessage(
    name: 'Debora Ellaria',
    avatar: 'assets/images/post4.jpg',
    lastMessage: 'Hi, Darel! How are you doing?',
    time: '11:30',
    unreadCount: 3,
    isOnline: true,
  ),
  ChatMessage(
    name: 'Barnaby Chris',
    avatar: 'assets/images/post5.jpg',
    lastMessage: 'Bro, when can we design together?',
    time: '10:18',
  ),
  ChatMessage(
    name: 'Janice Karyl',
    avatar: 'assets/images/post1.jpg',
    lastMessage: 'Darel, are you busy on holidays?',
    time: '09:37',
  ),
  ChatMessage(
    name: 'David Keith',
    avatar: 'assets/images/post2.jpg',
    lastMessage: "Bro what day college holidays? Let's...",
    time: '08:22',
  ),
  ChatMessage(
    name: 'Iko',
    avatar: 'assets/images/story2.jpg',
    lastMessage: 'Sent you the film photos',
    time: 'Yesterday',
  ),
  ChatMessage(
    name: 'Jules H.',
    avatar: 'assets/images/post3.jpg',
    lastMessage: 'Coffee tomorrow? :)',
    time: 'Yesterday',
  ),
];
