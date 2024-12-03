import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Icon(
          Icons.arrow_back,
          color: Color(0xFF0F2D5C),
        ),
        title: Text(
          "Home",
          style: TextStyle(color: Color(0xFF0F2D5C)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                'assets/images/profile.png',
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "New Project",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2262C6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: Size(130, 60)),
            ),
            SizedBox(height: 60),
            Expanded(
              child: ListView(
                children: [
                  ExamCard(
                    title: "Exam One",
                    questions: 20,
                    professors: ["DR. Osama", "DR. Amr"],
                    color: Color(0xFF507687),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         ExamDetailScreen(title: "Exam One"),
                      //   ),
                      // );
                    },
                  ),
                  ExamCard(
                    title: "Exam Two",
                    questions: 50,
                    professors: ["DR. Osama"],
                    color: Color(0xFFADB4C3),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         ExamDetailScreen(title: "Exam Two"),
                      //   ),
                      // );
                    },
                  ),
                  ExamCard(
                    title: "Exam Three",
                    questions: 100,
                    professors: ["DR. Osama", "DR. Sara"],
                    color: Color(0xFFB1CDFC),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         ExamDetailScreen(title: "Exam Three"),
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExamCard extends StatelessWidget {
  final String title;
  final int questions;
  final List<String> professors;
  final Color color;
  final VoidCallback onTap;

  const ExamCard({
    required this.title,
    required this.questions,
    required this.professors,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 2, bottom: 19, right: 30),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              "$questions questions",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: professors
                  .map((professor) => Text(
                        professor,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

