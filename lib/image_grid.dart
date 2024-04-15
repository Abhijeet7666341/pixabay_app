import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pixabay_app/pixabay_services.dart';

class ImageGrid extends StatefulWidget {
  const ImageGrid({super.key});

  @override
  _ImageGridState createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  final PixabayAPI _api = PixabayAPI();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _api.fetchImages(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width ~/ 180,
              childAspectRatio: 1,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              var image = snapshot.data[index];
              return GridTile(
                footer: GridTileBar(
                  backgroundColor: Colors.black45,
                  title: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red),
                      const SizedBox(
                        width: 5,
                      ),
                      Text("${image['likes']}"),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(Icons.visibility, color: Colors.white),
                      const SizedBox(
                        width: 5,
                      ),
                      Text("${image['views']}"),
                    ],
                  ),
                  // subtitle: Text("${image['views']} Views"),
                ),
                child: GestureDetector(
                  onTap: () => _openImageFullScreen(
                      context, image['webformatURL'], image['largeImageURL']),
                  child: Hero(
                    tag: image['largeImageURL'],
                    child: CachedNetworkImage(
                      imageUrl: image['webformatURL'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void _openImageFullScreen(
      BuildContext context, String thumbnailUrl, String imageUrl) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: Hero(
              tag: imageUrl,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => CachedNetworkImage(
                  imageUrl: thumbnailUrl,
                  fit: BoxFit.contain,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
    }));
  }
}