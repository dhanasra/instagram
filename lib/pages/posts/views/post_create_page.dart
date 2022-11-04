import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/app/app.dart';
import 'package:instagram/app/app_routes.dart';
import 'package:instagram/bloc/location_bloc/location_bloc.dart';
import 'package:instagram/pages/image_edit/image_edit_view_model.dart';
import 'package:instagram/pages/posts/bloc/posts_bloc.dart';
import 'package:instagram/pages/posts/post_view_model.dart';

class PostCreatePage extends StatefulWidget {
  const PostCreatePage({Key? key}) : super(key: key);

  @override
  State<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  late PostViewModel viewModel;

  @override
  void initState() {
    viewModel = PostViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Uint8List? imageBytes = ModalRoute.of(context)!.settings.arguments as Uint8List?;

    return BlocConsumer<PostsBloc, PostsState>(
        listener: (_, state){
          if(state is Uploaded){
            const App().setNavigation(context, AppRoutes.home);
          }
        },
        builder: (_,state){
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  elevation: 2,
                  actions: [
                    IconButton(
                        onPressed: (){
                          FocusScope.of(context).unfocus();
                          context.read<PostsBloc>().add(UploadPost(
                              imageData: imageBytes,
                              position: viewModel.position,
                              images: ImageEditViewModel.images,
                              text: viewModel.textController.text)
                          );
                        },
                        splashRadius: 26,
                        icon: const Icon(Icons.check)
                    )
                  ],
                ),
                body: Form(
                    key: viewModel.formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: PostFields(
                          imageBytes: imageBytes,
                          viewModel: viewModel),
                    )
                ),
              ),

              if(state is Uploading)
                Container(
                  color: Colors.black45,
                  child: const Center(
                    child: SizedBox(
                      width: 30, height: 30,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
            ],
          );
        });
  }
}

class PostFields extends StatelessWidget {
  final Uint8List? imageBytes;
  final PostViewModel viewModel;
  const PostFields({Key? key,required this.imageBytes, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          children: [
              if(imageBytes!=null)
              Container(
                width: 80,
                height: 54,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(imageBytes!),
                  ),
                ),
              ),
              if(imageBytes==null && ImageEditViewModel.images!.isNotEmpty)
                Container(
                  width: 80,
                  height: 54,
                  color: Colors.green,
                  alignment: Alignment.center,
                  child: Text("${ImageEditViewModel.images!.length}", style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),),
                ),

              const SizedBox(width: 8,),
              Expanded(
                  child: TextFormField(
                    autofocus: true,
                    onChanged: (val){
                      viewModel.formKey.currentState?.validate();
                    },
                    decoration: const InputDecoration(
                        hintText: "Add comment here...",
                        prefixIcon: Icon(Icons.comment),
                        focusedBorder: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder()
                    ),
                    controller: viewModel.textController,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),
                  )
              )
            ],
        ),

        BlocBuilder<LocationBloc, LocationState>(
            builder: (_, state){
              if(state is LocationFetched){
                viewModel.position = state.position;
                return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        const Divider(),
                        Row(
                          children: const [
                            Icon(Icons.location_on, size: 20,),
                            SizedBox(width: 8,),
                            Text("Current Location :", style: TextStyle(fontSize: 16),)
                          ],
                        ),
                        const SizedBox(height: 8,),
                        Text("( ${state.position.latitude}, ${state.position.longitude} )"),
                      ],
                    );
              }else{
                return TextButton(
                    onPressed: ()=>context.read<LocationBloc>().add(GetLocation()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text("Add Location"),
                        Icon(Icons.location_on_rounded, size: 16,)
                      ],
                    )
                );
              }
            })
      ],
    );
  }

}

