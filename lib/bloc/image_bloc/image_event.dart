part of 'image_bloc.dart';

@immutable
abstract class ImageEvent {}

class GetImageEvent extends ImageEvent{
  final bool isCamera;
  final bool isMultiImagePick;
  GetImageEvent({this.isCamera=false, this.isMultiImagePick=false});
}

class CancelImageEvent extends ImageEvent {}