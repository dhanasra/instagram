import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/database/modal/post.dart';
import 'package:instagram/pages/image_edit/image_edit_view_model.dart';
import 'package:instagram/pages/posts/bloc/posts_bloc.dart';
import 'package:instagram/pages/posts/widgets/loading_shimmer.dart';
import 'package:instagram/pages/posts/widgets/post_item.dart';
import 'package:instagram/utils/constants.dart';

import '../../../app/app.dart';
import '../../../app/app_routes.dart';
import '../../../bloc/image_bloc/image_bloc.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageBloc, ImageState>(
      listener: (_,state) async{
        if(state is MultiImageFetched){
          if(state.images.length==1) {
            ImageEditViewModel.imagePath = state.images[0];
            const App().setNavigation(
                context, AppRoutes.imageEdit);
          }else{
            ImageEditViewModel.images = state.images;
            const App().setNavigation(
                context, AppRoutes.createPost);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: ShaderMask(
              shaderCallback: (bounds) =>
                  splashGradient.createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: const Text("Instagram",
                  style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 24))),
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Image.asset("${appAssets}app_logo.png", width: 70,),
          ),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: ()=>context.read<ImageBloc>().add(GetImageEvent(isMultiImagePick: true)),
                splashRadius: 22,
                icon: const Icon(Icons.add_box_outlined)),
            IconButton(
                onPressed: ()=>context.read<ImageBloc>().add(GetImageEvent(isCamera: true)),
                splashRadius: 22,
                icon: const Icon(Icons.camera_alt)),
          ],
        ),
        body: BlocBuilder<PostsBloc, PostsState>(
          builder: (_,state){
            if(state is PostsLoading){
              return const PostsBuilder(posts: [], isLoading: true);
            }else if(state is PostsFetched){
              return PostsBuilder(posts: state.posts, isLoading: false);
            }else{
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

class PostsBuilder extends StatelessWidget {
  final List<Post> posts;
  final bool isLoading;
  const PostsBuilder({Key? key, required this.posts, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: isLoading ? 3 : posts.length,
        itemBuilder: (_,index){
          if(isLoading){
            return const LoadingShimmer();
          }else {
            return PostItem(
                post: posts[index],
                onDelete: () {
                  context.read<PostsBloc>().add(
                      DeletePost(docId: posts[index].postId));
                }
            );
          }
        },
        separatorBuilder: (_, index){
          return const Divider();
        },
    );
  }
}

