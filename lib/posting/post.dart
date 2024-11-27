import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testimn/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Post & Comment App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PostPage(),
    );
  }
}

// Main Post Page
class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _postController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _username = 'Anonymous';

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc['name'] != null) {
        setState(() {
          _username = doc['name'];
        });
      }
    }
  }

  Future<void> _submitPost() async {
    if (_postController.text.isNotEmpty) {
      await _firestore.collection('posts').add({
        'username': _username,
        'content': _postController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'likes': 0,
      });
      _postController.clear();
    }
  }

  Future<void> _toggleLike(DocumentSnapshot post) async {
    final user = _auth.currentUser;
    final postId = post.id;
    final likeCollection =
        _firestore.collection('posts').doc(postId).collection('likes');

    final userLike = await likeCollection.doc(user?.uid).get();
    if (userLike.exists) {
      await likeCollection.doc(user?.uid).delete();
      await post.reference.update({'likes': post['likes'] - 1});
    } else {
      await likeCollection.doc(user?.uid).set({'liked': true});
      await post.reference.update({'likes': post['likes'] + 1});
    }
  }

  Future<void> _confirmDeletePost(DocumentSnapshot post) async {
    final shouldDelete = await _showDeleteConfirmationDialog();
    if (shouldDelete == true) {
      await post.reference.delete();
    }
  }

  Future<bool?> _showDeleteConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts', style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            // Input field for creating a new post
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              color: const Color.fromARGB(255, 130, 151, 152),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _postController,
                        decoration: InputDecoration(
                          hintText: 'What\'s on your mind?',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 30),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _submitPost,
                      icon: Icon(Icons.send, color: Colors.green.shade700),
                      tooltip: 'Post',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display list of posts
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('posts')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final posts = snapshot.data?.docs ?? [];
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final postData = post.data() as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Username and avatar
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              Colors.green.shade700,
                                          child: Text(
                                            postData['username'][0]
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          postData['username'] ?? 'Anonymous',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: const Color.fromARGB(
                                              255, 180, 128, 124)),
                                      onPressed: () => _confirmDeletePost(post),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                // Post content
                                Text(
                                  postData['content'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    postData['timestamp'] != null
                                        ? (postData['timestamp'] as Timestamp)
                                            .toDate()
                                            .toString()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          const Color.fromARGB(255, 77, 28, 28),
                                    ),
                                  ),
                                ),
                                Divider(),
                                // Like and Comment button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.thumb_up,
                                            color: Colors.green,
                                          ),
                                          onPressed: () => _toggleLike(post),
                                        ),
                                        Text('${postData['likes']}'),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CommentPage(postId: post.id),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'View Comments',
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Comment Page to show comments for a specific post
class CommentPage extends StatelessWidget {
  final String postId;

  CommentPage({required this.postId});

  final TextEditingController _commentController = TextEditingController();

  Future<void> _addComment(String content) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'username': FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous',
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': 0,
    });
  }

  Future<void> _toggleCommentLike(DocumentSnapshot comment) async {
    final user = FirebaseAuth.instance.currentUser;
    final likeCollection = comment.reference.collection('likes');

    final userLike = await likeCollection.doc(user?.uid).get();
    if (userLike.exists) {
      await likeCollection.doc(user?.uid).delete();
      await comment.reference.update({'likes': comment['likes'] - 1});
    } else {
      await likeCollection.doc(user?.uid).set({'liked': true});
      await comment.reference.update({'likes': comment['likes'] + 1});
    }
  }

  Future<void> _deleteComment(DocumentSnapshot comment) async {
    final shouldDelete = await _showDeleteConfirmationDialog('sure?');
    if (shouldDelete == true) {
      await comment.reference.delete();
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(dynamic context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postId)
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final comments = snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final commentData = comment.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(commentData['username'] ?? 'Anonymous'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(commentData['content']),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.thumb_up,
                                  color: Colors.green,
                                ),
                                onPressed: () => _toggleCommentLike(comment),
                              ),
                              Text('${commentData['likes']}'),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteComment(comment),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      _addComment(_commentController.text);
                      _commentController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
