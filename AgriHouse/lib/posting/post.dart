import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testimn/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp_post());
}

class MyApp_post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Q&A Posting App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: PostPage(),
    );
  }
}

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  final TextEditingController _editController = TextEditingController();

  Future<void> _createPost() async {
    final postText = _postController.text.trim();
    final username = _usernameController.text.trim();
    if (postText.isNotEmpty && username.isNotEmpty) {
      await FirebaseFirestore.instance.collection('posts').add({
        'content': postText,
        'username': username,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _postController.clear();
      _usernameController.clear();
    }
  }

  Future<void> _replyToPost(String postId) async {
    final replyText = _replyController.text.trim();
    if (replyText.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('replies')
          .add({
        'content': replyText,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _replyController.clear();
    }
  }

  Future<void> _editPost(String postId) async {
    final updatedText = _editController.text.trim();
    if (updatedText.isNotEmpty) {
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'content': updatedText,
      }).then((_) {
        setState(() {
          // Triggers a rebuild to reflect changes
        });
        // Navigator.of(context).pop(); // Close the dialog after updating
      });
    }
  }

  void _sharePost(String content) {
    Share.share(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Q&A Posts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPostInput(),
            SizedBox(height: 16),
            Expanded(child: _buildPostList()),
          ],
        ),
      ),
    );
  }

  Widget _buildPostInput() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: 'Enter your username',
              border: InputBorder.none,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage('https://i.pravatar.cc/150?img=1'),
                radius: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _postController,
                  decoration: InputDecoration(
                    hintText: 'What\'s your question or post?',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.blue),
                onPressed: _createPost,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No posts available.'));
        }
        final posts = snapshot.data!.docs;
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final postData = posts[index];
            final postId = postData.id;
            return _buildPostCard(postData, postId);
          },
        );
      },
    );
  }

  Widget _buildPostCard(QueryDocumentSnapshot postData, String postId) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              postData['username'] ?? 'Unknown User',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 5),
            Text(
              postData['content'] ?? 'No content available',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _editController.text = postData['content'];
                    _showEditDialog(postId);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.green),
                  onPressed: () {
                    _sharePost(postData['content']);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.reply, color: Colors.blue),
                  onPressed: () {
                    _showReplyInput(postId);
                  },
                ),
              ],
            ),
            _buildReplyList(postId),
          ],
        ),
      ),
    );
  }

  void _showReplyInput(String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reply to Post'),
          content: TextField(
            controller: _replyController,
            decoration: InputDecoration(
              hintText: 'Type your reply...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _replyToPost(postId);
                Navigator.of(context).pop();
              },
              child: Text('Send'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Post'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(
              hintText: 'Edit your post...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _editPost(postId);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReplyList(String postId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('replies')
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        final replies = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: replies.map((replyDoc) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.reply, color: Colors.black54),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      replyDoc['content'] ?? '',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
