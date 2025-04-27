import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/themes/app_themes.dart';
import '../../../../view/widgets/progress_indicator_widget.dart';
import '../../../ApiManager/ApiManager.dart';
import '../../../Domain/Model/PostModel.dart';
import 'RecordingScreen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  static const String routeName = "PostScreenPage";

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<List<Post>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = ApiService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/scaffold.png'))
      ),
      child: Scaffold(
        appBar: AppBar(title:  Text('Posts',style: AppThemes.lightTheme.textTheme.labelLarge,),backgroundColor: Colors.transparent,),
        body: FutureBuilder<List<Post>>(
          future: _posts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(child:ProgressIndicatorClass.constructProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
      
            final posts = snapshot.data!;
      
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  color: AppThemes.blueAppColor,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(post.postTitle,style: GoogleFonts.anton(
                        fontSize: 20,
                        color: AppThemes.yellowAppColor
                    ),),
                    subtitle: Text(post.postContent,overflow:TextOverflow.ellipsis,maxLines: 6,style: GoogleFonts.anton(
                      fontSize: 15,
                      color: Colors.white,
                    ),),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppThemes.yellowAppColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          minimumSize: Size(5.w,60.h)
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(ScreensRoutes.recordScreenRoute,arguments: post);
                        },
                      child:  Text('Pronunciation',style: AppThemes.lightTheme.textTheme.titleMedium,),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
