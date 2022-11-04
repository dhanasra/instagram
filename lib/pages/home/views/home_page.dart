
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/bloc/image_bloc/image_bloc.dart';
import 'package:instagram/pages/posts/bloc/posts_bloc.dart';
import 'package:instagram/pages/posts/views/posts_page.dart';
import 'package:instagram/pages/profile/bloc/profile_bloc.dart';
import 'package:instagram/pages/profile/views/profile_page.dart';

import '../../../app/app.dart';
import '../cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final List<Widget> children = [
      MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_)=>PostsBloc()..add(GetPosts())),
            BlocProvider(
                create: (_)=>ImageBloc()),
          ],
          child: const PostsPage()
      ),
      BlocProvider(
        create: (_)=>ProfileBloc()..add(GetProfile()),
        child: const ProfilePage(),
      )
    ];

    return WillPopScope(
            onWillPop: () async {
              const App().closeApp();
              return true;
            },
            child: BlocBuilder<HomeCubit,int>(
              builder: (_,state){
                return Scaffold(
                    body: children[state],
                    bottomNavigationBar: BottomNavigationBar(
                      items: const [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.house, size: 22,),
                            label: 'Home'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.person_outline_outlined),
                            label: 'Profile'),
                      ],
                      showSelectedLabels: true,
                      showUnselectedLabels: true,
                      currentIndex: state,
                      onTap: (index){
                        if(index!=2) {
                          BlocProvider.of<HomeCubit>(context).currentPageIndex(index);
                        }
                      },
                    )
                );
              },
            )
    );
  }
}
