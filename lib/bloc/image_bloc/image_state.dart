part of 'image_bloc.dart';

@immutable
abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageFetched extends ImageState {
  final File image;
  ImageFetched({ required this.image });
}

class MultiImageFetched extends ImageState {
  final List<String> images;
  MultiImageFetched({ required this.images });
}

class ImageCanceled extends ImageState {

}