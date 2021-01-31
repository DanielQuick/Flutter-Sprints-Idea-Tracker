import 'package:flutter/material.dart';
import 'package:idea_tracker/controller/page/ideas_main_page_controller.dart';
import 'package:idea_tracker/model/idea.dart';
import 'package:idea_tracker/view/page/create_idea_page.dart';
import 'package:idea_tracker/view/page/idea_details_page.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';
import 'package:provider/provider.dart';

class IdeasMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<IdeasMainPageController>(onControllerReady: (controller) {
      controller.initialize();
    }, builder: (context, controller, child) {
      return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          title: Text('Ideas Main Page'),
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
        body: controller.ideas.isEmpty ? NoIdeasPage() : IdeaCardsList(),
      );
    });
  }
}

class IdeaCardsList extends StatelessWidget {
  const IdeaCardsList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<IdeasMainPageController>(context);
    return ListView.builder(
      itemCount: controller.ideas.length,
      itemBuilder: (context, index) {
        return IdeaCard(
          idea: controller.ideas[index],
        );
      },
    );
  }
}

class NoIdeasPage extends StatelessWidget {
  const NoIdeasPage({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No ideas available now',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 20.0),
          Text(
            'Tap the button below to create a new one!',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}

class IdeaCard extends StatefulWidget {
  final Idea idea;

  IdeaCard({this.idea});

  @override
  _IdeaCardState createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard> {
  @override
  Widget build(BuildContext context) {
    final title = widget.idea.title ?? "";
    final description = widget.idea.description ?? "";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IdeaDetailsPage(idea: widget.idea),
          ),
        );
      },
      child: Container(
        height: 180.0,
        width: 420.0,
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
                padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    // Row(
                    //   children: [
                    //     Text('0 votes'),
                    //   ],
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 5.0),
                child: Text(
                  description,
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
