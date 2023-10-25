import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagraam/resources/dark_mode.dart';
import 'package:instagraam/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUser = false;
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkMode>(context).isDark;

    return Scaffold(
      backgroundColor: isDark ? Colors.white :const Color.fromARGB(255, 60, 60, 60),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isDark ? Colors.white :const Color.fromARGB(255, 49, 49, 49),
        title: TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor:
                isDark ? Colors.white :const Color.fromARGB(255, 101, 101, 101),
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: isDark ? const Color.fromARGB(255, 59, 58, 58) : Colors.white,
              size: 26,
            ),
            hintText: 'Search friends',
            hintStyle: TextStyle(
              color: isDark
                  ?const Color.fromARGB(255, 0, 0, 0)
                  :const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          controller: _searchController,
          onChanged: (val) {
            if (val.isNotEmpty) {
              setState(() {
                isShowUser = true;
              });
            } else {
              setState(() {
                isShowUser = false;
              });
            }
          },
        ),
        actions: [
          IconButton(
              onPressed: _searchController.text.isNotEmpty
                  ? () {
                      setState(() {
                        _searchController.text = '';
                        isShowUser = false;
                      });
                    }
                  : null,
              icon: Icon(
                Icons.clear,
                color: isDark
                    ? (_searchController.text.isEmpty
                        ? Colors.grey
                        : Colors.black)
                    : (_searchController.text.isEmpty
                        ? const Color.fromARGB(255, 202, 202, 202)
                        : const Color.fromARGB(255, 255, 255, 255)),
                size: 30,
              ))
        ],
      ),
      body: isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.pink,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(5),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var snap = snapshot.data!.docs[index];
                    return ListTile(
                      onTap: () {
                        Get.to(() => ProfileScreen(uid: snap['uid']));
                      },
                      contentPadding: const EdgeInsets.all(3),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(snap['photoUrl']),
                        radius: 30,
                      ),
                      title: Text(
                        snap['username'],
                        style: TextStyle(
                          color: isDark
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length - 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    return Image.network(
                      snapshot.data!.docs[index]['postUrl'],
                    );
                  },
                );
              },
            ),
    );
  }
}
