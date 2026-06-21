import 'dart:convert';
import 'package:http/http.dart' as http;

class SanityBlock {
  final String key;
  final String type;
  final String? style;
  final List<SanitySpan> children;

  const SanityBlock({
    required this.key,
    required this.type,
    this.style,
    required this.children,
  });

  factory SanityBlock.fromJson(Map<String, dynamic> json) {
    return SanityBlock(
      key: json['_key'] as String,
      type: json['_type'] as String,
      style: json['style'] as String?,
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => SanitySpan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SanitySpan {
  final String key;
  final String type;
  final String? text;

  const SanitySpan({
    required this.key,
    required this.type,
    this.text,
  });

  factory SanitySpan.fromJson(Map<String, dynamic> json) {
    return SanitySpan(
      key: json['_key'] as String,
      type: json['_type'] as String,
      text: json['text'] as String?,
    );
  }
}

class SanityArticle {
  final String id;
  final String title;
  final String? slug;
  final String? date;
  final int? readingTime;
  final String? imageUrl;
  final String? authorName;
  final String? authorBio;
  final String? categoryName;
  final List<SanityBlock>? content;

  const SanityArticle({
    required this.id,
    required this.title,
    this.slug,
    this.date,
    this.readingTime,
    this.imageUrl,
    this.authorName,
    this.authorBio,
    this.categoryName,
    this.content,
  });

  factory SanityArticle.fromJson(Map<String, dynamic> json) {
    return SanityArticle(
      id: json['_id'] as String,
      title: json['article'] as String,
      slug: json['slug'] as String?,
      date: json['date'] as String?,
      readingTime: json['readingTime'] as int?,
      imageUrl: json['imageUrl'] as String?,
      authorName: json['authorName'] as String?,
      authorBio: json['authorBio'] as String?,
      categoryName: json['categoryName'] as String?,
      content: (json['content'] as List<dynamic>?)
          ?.map((e) => SanityBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String get excerpt {
    if (content == null || content!.isEmpty) return '';
    final texts = content!
        .expand((b) => b.children.map((c) => c.text ?? ''))
        .where((t) => t.isNotEmpty)
        .join(' ')
        .trim();
    if (texts.length > 120) return '${texts.substring(0, 117).trim()}...';
    return texts;
  }

  String get bodyAsText {
    if (content == null || content!.isEmpty) return '';
    return content!
        .map((b) =>
            b.children.map((c) => c.text ?? '').join(' ').trim())
        .where((p) => p.isNotEmpty)
        .join('\n\n');
  }
}

class SanityAuthor {
  final String id;
  final String name;
  final String? slug;
  final String? bio;
  final String? imageUrl;

  const SanityAuthor({
    required this.id,
    required this.name,
    this.slug,
    this.bio,
    this.imageUrl,
  });

  factory SanityAuthor.fromJson(Map<String, dynamic> json) {
    return SanityAuthor(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      bio: json['bio'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

class SanityService {
  SanityService._();

  static const _projectId = 'mxxqb8kk';
  static const _dataset = 'production';
  static const _apiVersion = '2025-06-04';

  static Future<T> _fetchSanity<T>(String query, T fallback) async {
    final url = Uri.parse(
      'https://$_projectId.api.sanity.io/v$_apiVersion/data/query/$_dataset'
      '?query=${Uri.encodeComponent(query)}',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final payload = jsonDecode(response.body) as Map<String, dynamic>;
        final result = payload['result'];
        if (result != null) return result as T;
      }
    } catch (_) {}
    return fallback;
  }

  static Future<List<SanityArticle>> getArticles({int limit = 6}) {
    final safeLimit = limit.clamp(1, 12);

    const query = r'''*[_type == "article"] | order(date desc)[0...$limit] {
      _id,
      article,
      "slug": slug.current,
      date,
      readingTime,
      "imageUrl": image.asset->url,
      "authorName": author->name,
      "authorBio": author->bio,
      "categoryName": category->category,
      content[]{
        _key,
        _type,
        style,
        children[]{
          _key,
          _type,
          text
        }
      }
    }''';

    final q = query.replaceFirst('\$limit', '$safeLimit');

    return _fetchSanity<List<dynamic>>(q, []).then(
      (list) => list.map((e) => SanityArticle.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  static Future<SanityArticle?> getArticleBySlug(String slug) {
    final safeSlug = slug.replaceAll('"', '\\"');

    const query = r'''*[_type == "article" && slug.current == "$slug"] | order(date desc)[0] {
      _id,
      article,
      "slug": slug.current,
      date,
      readingTime,
      "imageUrl": image.asset->url,
      "authorName": author->name,
      "authorBio": author->bio,
      "categoryName": category->category,
      content[]{
        _key,
        _type,
        style,
        children[]{
          _key,
          _type,
          text
        }
      }
    }''';

    final q = query.replaceFirst('\$slug', safeSlug);

    return _fetchSanity<Map<String, dynamic>?>(q, null).then(
      (json) => json != null ? SanityArticle.fromJson(json) : null,
    );
  }

  static Future<List<SanityAuthor>> getAuthors({int limit = 9}) {
    final safeLimit = limit.clamp(1, 24);

    const query = r'''*[_type == "author"] | order(name asc)[0...$limit] {
      _id,
      name,
      "slug": slug.current,
      bio,
      "imageUrl": image.asset->url
    }''';

    final q = query.replaceFirst('\$limit', '$safeLimit');

    return _fetchSanity<List<dynamic>>(q, []).then(
      (list) => list.map((e) => SanityAuthor.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  static String excerptFromArticle(SanityArticle article, String fallback) {
    final excerpt = article.excerpt;
    return excerpt.isNotEmpty ? excerpt : fallback;
  }

  static List<String> blocksToParagraphs(SanityArticle article) {
    if (article.content == null || article.content!.isEmpty) return [];
    return article.content!
        .map((b) =>
            b.children.map((c) => c.text ?? '').join(' ').trim())
        .where((p) => p.isNotEmpty)
        .toList();
  }
}
