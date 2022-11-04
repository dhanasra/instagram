import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram/database/modal/post.dart';

import '../../../database/firebase.dart';
import '../../../utils/constants.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final VoidCallback onDelete;
  const PostItem({Key? key, required this.post, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: post.profilePic!=null
                ? CircleAvatar(backgroundImage: NetworkImage(post.profilePic!), radius: 18,)
                : const CircleAvatar(backgroundImage: AssetImage("${appAssets}man.png"), radius: 18,),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              if(post.position!=null)
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12,),
                    const SizedBox(width: 4,),
                    Text("( ${post.position!["latitude"]}, ${post.position!["longitude"]} )",
                      style: const TextStyle(fontSize: 10),
                    )
                  ],
                )
            ],
          ),
          const Spacer(),
          IconButton(
              onPressed: (){}, splashRadius: 22, icon: const Icon(Icons.more_vert)),
        ],),
        Stack(
            fit: StackFit.loose,
            children: [
              Container(
                color: Colors.black,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: post.image[0],
                  width: double.infinity,
                  placeholder: (_, url){
                    return const SizedBox(
                      height: 300,
                      child: Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(color: promptColor,),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if(post.image.length>1)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircleAvatar(
                      child: Text("${post.image.length}"),
                    ),
                  ),
                )
            ]
        ),
        Row(
          children: [
            IconButton(
                onPressed: (){}, splashRadius: 22, icon: const Icon(Icons.favorite_border)),
            IconButton(
                onPressed: (){}, splashRadius: 22, icon: const Icon(Icons.mode_comment_outlined)),
            IconButton(
                onPressed: (){}, splashRadius: 22, icon: const Icon(Icons.send_outlined)),

            if(Auth().firebaseAuth.currentUser!.uid==post.uid)
              IconButton(
                  onPressed: onDelete,
                  splashRadius: 22, icon: const Icon(Icons.delete_outline, color: Colors.redAccent,)),
            const Spacer(),
            IconButton(
                onPressed: (){}, splashRadius: 22, icon: const Icon(Icons.bookmark)),

          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: Text("Comment : ${post.text}"),
        ),
      ],
    );
  }
}
