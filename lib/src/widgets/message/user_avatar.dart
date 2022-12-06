import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/bubble_rtl_alignment.dart';
import '../../util.dart';
import '../state/inherited_chat_theme.dart';

/// Renders user's avatar or initials next to a message.
class UserAvatar extends StatelessWidget {
  /// Creates user avatar.
  const UserAvatar({
    super.key,
    required this.author,
    this.bubbleRtlAlignment,
    this.imageHeaders,
    this.avatarInitialsBuilder,
    this.onAvatarTap,
  });

  /// Author to show image and name initials from.
  final types.User author;

  /// See [Message.bubbleRtlAlignment].
  final BubbleRtlAlignment? bubbleRtlAlignment;

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// Allow you to define the custom initials for avatars.
  final String Function(types.User user)? avatarInitialsBuilder;

  /// Called when user taps on an avatar.
  final void Function(types.User)? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final color = getUserAvatarNameColor(
      author,
      InheritedChatTheme.of(context).theme.userAvatarNameColors,
    );
    final hasImage = author.imageUrl != null;
    final initials = avatarInitialsBuilder != null ? avatarInitialsBuilder!(author) : getUserInitials(author);

    return Container(
      margin: bubbleRtlAlignment == BubbleRtlAlignment.left ? const EdgeInsetsDirectional.only(end: 8) : const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => onAvatarTap?.call(author),
        child: (author.imageUrl?.startsWith('assets/') ?? false)
            ? Image.asset(
                author.imageUrl!,
                width: 32,
                height: 32,
              )
            : CircleAvatar(
                backgroundColor: hasImage ? InheritedChatTheme.of(context).theme.userAvatarImageBackgroundColor : color,
                backgroundImage: hasImage ? CachedNetworkImageProvider(author.imageUrl!, headers: imageHeaders) : null,
                radius: 16,
                child: !hasImage
                    ? Text(
                        initials,
                        style: InheritedChatTheme.of(context).theme.userAvatarTextStyle,
                      )
                    : null,
              ),
      ),
    );
  }
}
