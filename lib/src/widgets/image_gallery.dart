import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../conditional/conditional.dart';
import '../models/preview_image.dart';

class ImageGallery extends StatelessWidget {
  const ImageGallery({
    super.key,
    this.imageHeaders,
    required this.images,
    required this.onClosePressed,
    this.options = const ImageGalleryOptions(),
    required this.pageController,
  });

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// Images to show in the gallery.
  final List<PreviewImage> images;

  /// Triggered when the gallery is swiped down or closed via the icon.
  final VoidCallback onClosePressed;

  /// Customisation options for the gallery.
  final ImageGalleryOptions options;

  /// Page controller for the image pages.
  final PageController pageController;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          onClosePressed();
          return false;
        },
        child: Dismissible(
          key: const Key('photo_view_gallery'),
          direction: DismissDirection.down,
          onDismissed: (direction) => onClosePressed(),
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                builder: (BuildContext context, int index) =>
                    PhotoViewGalleryPageOptions(
                  imageProvider: Conditional().getProvider(
                    images[index].uri,
                    headers: imageHeaders,
                  ),
                  minScale: options.minScale,
                  maxScale: options.maxScale,
                ),
                itemCount: images.length,
                loadingBuilder: (context, event) =>
                    _imageGalleryLoadingBuilder(event),
                pageController: pageController,
                scrollPhysics: const ClampingScrollPhysics(),
              ),
              Positioned.directional(
                end: options.closeBtnEndPosition,
                textDirection: Directionality.of(context),
                top: options.closeBtnTopPosition,
                child: options.closeBtnIcon == null
                    ? CloseButton(
                        color: options.closeBtnColor,
                        onPressed: onClosePressed,
                      )
                    : IconButton(
                        icon: options.closeBtnIcon!,
                        onPressed: onClosePressed,
                      ),
              ),
            ],
          ),
        ),
      );

  Widget _imageGalleryLoadingBuilder(ImageChunkEvent? event) => Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            value: event == null || event.expectedTotalBytes == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      );
}

class ImageGalleryOptions {
  const ImageGalleryOptions({
    this.maxScale,
    this.minScale,
    this.closeBtnEndPosition = 16,
    this.closeBtnTopPosition = 56,
    this.closeBtnColor = Colors.white,
    this.closeBtnIcon,
  });

  /// See [PhotoViewGalleryPageOptions.maxScale].
  final dynamic maxScale;

  /// See [PhotoViewGalleryPageOptions.minScale].
  final dynamic minScale;

  /// End position for the close button in the image gallery view.
  /// See [ImageGallery]
  final double closeBtnEndPosition;

  /// Top position for the close button in the image gallery view.
  /// See [ImageGallery]
  final double closeBtnTopPosition;

  /// Color for the default close button.
  final Color closeBtnColor;

  /// Icon used for the close button.
  final Icon? closeBtnIcon;
}
