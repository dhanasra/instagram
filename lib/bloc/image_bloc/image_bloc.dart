import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageInitial()) {
    on<GetImageEvent>(onGetImage);
    on<CancelImageEvent>(onImageCancel);
  }

  void onGetImage(GetImageEvent event, Emitter emit) async{
    final ImagePicker picker = ImagePicker();

    if(event.isMultiImagePick){
      List<XFile?> image = await picker.pickMultiImage();
      List<String> images = image.map((e) => e!.path).toList();
      emit(MultiImageFetched(images: images));
    }else {
      final XFile? image = await picker.pickImage(
          source: event.isCamera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 25);
      emit(ImageFetched(image: File(image!.path)));
    }

  }

  void onImageCancel(CancelImageEvent event, Emitter emit) async{
    emit(ImageCanceled());
  }
}
