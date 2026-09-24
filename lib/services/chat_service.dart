import 'dart:async';
import '../models/chat_model.dart';
import '../models/property_model.dart';
import '../models/agent_model.dart';
import '../data/mock_data.dart';
import 'api_response.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal() {
    _conversations = List<ChatConversation>.from(MockData.initialConversations);
  }

  List<ChatConversation> _conversations = [];

  Future<ApiResponse<List<ChatConversation>>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResponse.success(List.unmodifiable(_conversations));
  }

  ChatConversation getOrCreateConversationForProperty(Property property) {
    final existingIndex = _conversations.indexWhere(
      (c) => c.agentId == property.agent.id,
    );

    if (existingIndex != -1) {
      return _conversations[existingIndex];
    }

    final newConv = ChatConversation(
      id: 'chat_${DateTime.now().millisecondsSinceEpoch}',
      agentId: property.agent.id,
      agentName: property.agent.name,
      agentAvatar: property.agent.avatarUrl,
      propertyTitle: property.title,
      propertyThumbnail: property.images.isNotEmpty ? property.images.first : '',
      unreadCount: 0,
      messages: [
        MessageItem(
          id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
          senderId: property.agent.id,
          text: 'Hi! I am ${property.agent.name}. How can I assist you with ${property.title}?',
          timestamp: DateTime.now(),
          isFromMe: false,
        ),
      ],
    );
    _conversations.insert(0, newConv);
    return newConv;
  }

  ChatConversation getOrCreateConversationForAgent(Agent agent) {
    final existingIndex = _conversations.indexWhere((c) => c.agentId == agent.id);
    if (existingIndex != -1) {
      return _conversations[existingIndex];
    }

    final newConv = ChatConversation(
      id: 'chat_${DateTime.now().millisecondsSinceEpoch}',
      agentId: agent.id,
      agentName: agent.name,
      agentAvatar: agent.avatarUrl,
      propertyTitle: 'Consultation with ${agent.name}',
      propertyThumbnail: agent.avatarUrl,
      unreadCount: 0,
      messages: [
        MessageItem(
          id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
          senderId: agent.id,
          text: 'Hello! I am ${agent.name}. How can I help you find your dream luxury home?',
          timestamp: DateTime.now(),
          isFromMe: false,
        ),
      ],
    );
    _conversations.insert(0, newConv);
    return newConv;
  }

  Future<ApiResponse<ChatConversation>> sendMessage(String conversationId, String text) async {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index == -1) {
      return ApiResponse.error('Conversation not found');
    }

    final conv = _conversations[index];
    final updatedMessages = List<MessageItem>.from(conv.messages)
      ..add(
        MessageItem(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          senderId: 'user',
          text: text,
          timestamp: DateTime.now(),
          isFromMe: true,
        ),
      );

    _conversations[index] = conv.copyWith(messages: updatedMessages);
    return ApiResponse.success(_conversations[index]);
  }

  void markAsRead(String conversationId) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1 && _conversations[index].unreadCount > 0) {
      _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
    }
  }

  List<ChatConversation> get currentConversations => List.unmodifiable(_conversations);
}
