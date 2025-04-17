import 'package:flutter/material.dart';
import 'essay_screen.dart';
import 'mcq_screen.dart';
import 'multiChoice_screen.dart';



class ManualQuestionScreen extends StatefulWidget {
  final String url;
  final String title;

  const ManualQuestionScreen({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  State<ManualQuestionScreen> createState() => _ManualQuestionScreenState();
}

class _ManualQuestionScreenState extends State<ManualQuestionScreen> with TickerProviderStateMixin {
  bool showOptions = false;

  late final AnimationController _controller;
  late final Animation<Offset> _mcqOffset;
  late final Animation<Offset> _easyOffset;
  late final Animation<Offset> _multiOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _mcqOffset = Tween<Offset>(
      begin: Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.4, curve: Curves.easeOut)));

    _easyOffset = Tween<Offset>(
      begin: Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Interval(0.2, 0.6, curve: Curves.easeOut)));

    _multiOffset = Tween<Offset>(
      begin: Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Interval(0.4, 0.8, curve: Curves.easeOut)));
  }

  void toggleMenu() {
    setState(() {
      showOptions = !showOptions;
      if (showOptions) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Widget buildOption(String text, Animation<Offset> animation, VoidCallback onTap) {
    return SlideTransition(
      position: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40,
              color: Colors.indigo[900],
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF004aad),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Add Questions",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showOptions)
                    buildOption("MCQ", _mcqOffset, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MCQScreen()));
                    }),
                  if (showOptions)
                    buildOption("Essay", _easyOffset, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => EssayQuestionScreen()));
                    }),
                  if (showOptions)
                    buildOption("Multi Choice", _multiOffset, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MultiChoiceScreen()));
                    }),
                  SizedBox(height: 50),
                  if (showOptions)
                    Container(
                      width: 260,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFb2e8fa), Color(0xFF004aad)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => AllQuestionsScreen()));
                        },
                        child: Text(
                          "show all Questions",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.more_horiz, size: 38, color: Colors.black),
                onPressed: toggleMenu,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/////////////////////////////////
// Screens to navigate to:
/////////////////////////////////







class AllQuestionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Questions")),
      body: Center(child: Text("All questions go here!")),
    );
  }
}