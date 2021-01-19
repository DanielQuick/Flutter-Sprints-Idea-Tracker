import 'package:flutter/material.dart';
import 'package:idea_tracker/model/idea.dart';
import 'package:idea_tracker/view/page/create_idea_page.dart';
import 'package:idea_tracker/view/page/idea_details_page.dart';

class IdeasMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text('Ideas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateIdeaPage('Create Idea')));
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: ideas.length,
          itemBuilder: (context, index) {
            return IdeaCard(
              idea: ideas[index],
            );
          }),
    );
  }
}

final List<Idea> ideas = [
  Idea(
    title: 'Visual population tracker',
    description:
        'Full screen animation website that displays how many babies are born a second and how many people die, maybe how many people graduate from college a second and other cool life events. Then we could make animations for each thing. and a number above the animation. It could be as simple as a 2d graphic in different quadrants, making a short animation as the counter goes up or as complex as this graphic but I don\'t think it should be as complex as the photo, its just a reference as an idea',
  ),
  Idea(
    title: 'Meditation app',
    description:
        'There would be a meditation timer and you make groups and set the meeting time. You can make groups with your friends or random people on the app. Then when the meeting time comes every day you all check in by hitting I am here button and meditate together. This could have a lot of bells and whistles but simple on this one is best I think',
  ),
  Idea(
    title: 'Fitness app',
    description:
        'A fitness application where we can give the some fitness task to user or if user can complete the task so he/she can receive some amount of rewarded so he can motivate using the reward they can buy some products which we can sell our in app store. We cam said if you cover 1000 steps so we can give 1 coin like each and every 1000 step user get a coin so we can motivate him to run',
  ),
  Idea(
    title: 'E-Commerce app',
    description:
        'An e-commerce applications which is pretty much similar like to Udemy which we building using rest api here the only difference is in Udemy user can sell course but in this user can sell digital goods ( I don\'t know it is legally or not ) but I want to build a applications something like this where we can build complete admin panel for admin, admin panel for user, integrated payment method and the many more thing',
  ),
  Idea(
    title: 'Netflix Stats',
    description:
        'I always had the idea of making an app for looking at your Stats of Netflix. The idea resparked when the Spotify Wrapped came out. I was browsing the www and there exists something like that (Statflix) but it has paywals, so you can\'t fully use the app.',
  ),
];

class IdeaCard extends StatelessWidget {
  final Idea idea;

  IdeaCard({this.idea});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(idea: idea),
          ),
        );
      },
      child: Container(
        height: 180.0,
        width: 400.0,
        margin: EdgeInsets.all(8.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 20.0, left: 10.0),
                child: Text(
                  idea.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 5.0),
                child: Text(
                  idea.description,
                  style: TextStyle(fontSize: 17.0),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
