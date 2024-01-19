import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagramclone/colors/colors.dart';
import 'package:instagramclone/screens/home_screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(labelText: 'Search for a user'),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUser = true;
            });
            // print(searchController.text);
          },
        ),
      ),
      body: isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uid: (snapshot.data! as dynamic).docs[index]
                                    ['uid'],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1530349311076-ab305120ccfc?q=80&w=989&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
                                // (snapshot.data! as dynamic).docs[index]
                                //     ['profilePic'],
                                ),
                          ),
                          title: Text((snapshot.data! as dynamic).docs[index]
                              ['username']),
                        ),
                      );
                    });
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return StaggeredGrid.count(
                  crossAxisCount: 3, crossAxisSpacing: 3, mainAxisSpacing: 8,
                  axisDirection: AxisDirection.right,
                  // itemCount: (snapshot.data! as dynamic).docs.length,
                  // itemBuilder: (context, index) {
                  //   return Image.network(
                  //       (snapshot.data! as dynamic).docs[index]['postUrl']);
                  // },
                  // staggeredTileBuilder: (index) => StaggeredTile.count(
                  //   (index % 7 == 0) ? 2 : 1,
                  //   (index % 7 == 0) ? 2 : 1,
                  // ),
                );
              },
            ),
    );
  }
}
