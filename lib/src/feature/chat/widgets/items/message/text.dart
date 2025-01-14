import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageText extends StatelessWidget {
  final MessageItem item;
  const MessageText({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final MessagesStore store = context.watch();

    final TextStyle style = textTheme.titleSmall!.copyWith(
      fontSize: 16,
      color: Colors.black,
    );

    return Observer(builder: (context) {
      if (store.isSearching) {
        return SubstringHighlight(
          text: item.text ?? '',
          textStyle: style,
          term: store.query ?? '',
          textStyleHighlight: textTheme.titleSmall!.copyWith(
            fontSize: 16,
            color: Colors.black,
            backgroundColor: AppColors.purpleBrighterBackgroundColor,
          ),
        );
      }

      return Linkify(
        text: item.text!,
        style: style,
        linkifiers: [
          HashtagLinkifier(),
          const UrlLinkifier(),
          const EmailLinkifier(),
          MentionLinkifier(),
        ],
        onOpen: (link) async {
          if (link.url.startsWith('hashtag:') ||
              link.url.startsWith('mention:')) {
            store.setQuery(link.url.substring(8));
            store.setIsSearching(true);
            logger.info('Hashtag or mention clicked: ${link.url}');
          } else {
            // Обработка обычных ссылок
            logger.info('Link clicked: ${link.url}');

            if (await canLaunchUrl(Uri.parse(link.url))) {
              await launchUrl(Uri.parse(link.url));
            }
          }
        },
        linkStyle: style.copyWith(
          color: AppColors.primaryColor,
        ),
      );
    });
  }
}

/// Custom Linkifier for hashtags

class HashtagLinkifier extends Linkifier {
  @override
  List<LinkifyElement> parse(
      List<LinkifyElement> elements, LinkifyOptions options) {
    final hashtagRegex = RegExp(r'\B#\w+');
    final parsedElements = <LinkifyElement>[];

    for (final element in elements) {
      if (element is TextElement) {
        final text = element.text;
        int lastMatchEnd = 0;

        for (final match in hashtagRegex.allMatches(text)) {
          // Добавляем текст до хэштега как обычный текст
          if (lastMatchEnd < match.start) {
            parsedElements
                .add(TextElement(text.substring(lastMatchEnd, match.start)));
          }

          // Добавляем хэштег как кликабельный элемент
          final hashtag = match.group(0)!;
          parsedElements.add(LinkableElement(hashtag, 'hashtag:$hashtag'));
          lastMatchEnd = match.end;
        }

        // Добавляем оставшийся текст
        if (lastMatchEnd < text.length) {
          parsedElements.add(TextElement(text.substring(lastMatchEnd)));
        }
      } else {
        // Если это уже LinkableElement, оставляем его без изменений
        parsedElements.add(element);
      }
    }

    return parsedElements;
  }
}

/// Custom Linkifier for mentions
class MentionLinkifier extends Linkifier {
  @override
  List<LinkifyElement> parse(
      List<LinkifyElement> elements, LinkifyOptions options) {
    final mentionRegex = RegExp(r'\B@\w+');
    final parsedElements = <LinkifyElement>[];

    for (final element in elements) {
      if (element is TextElement) {
        final text = element.text;
        int lastMatchEnd = 0;

        for (final match in mentionRegex.allMatches(text)) {
          // Добавляем текст до упоминания как обычный текст
          if (lastMatchEnd < match.start) {
            parsedElements
                .add(TextElement(text.substring(lastMatchEnd, match.start)));
          }

          // Добавляем упоминание как кликабельный элемент
          final mention = match.group(0)!;
          parsedElements.add(LinkableElement(mention, 'mention:$mention'));
          lastMatchEnd = match.end;
        }

        // Добавляем оставшийся текст
        if (lastMatchEnd < text.length) {
          parsedElements.add(TextElement(text.substring(lastMatchEnd)));
        }
      } else {
        // Если это уже LinkableElement, оставляем его без изменений
        parsedElements.add(element);
      }
    }

    return parsedElements;
  }
}
