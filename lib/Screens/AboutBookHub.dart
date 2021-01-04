import 'package:bookhub/models/user.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AboutBookHub extends StatefulWidget {
  UserModel user;
  AboutBookHub({this.user});
  @override
  _AboutBookHubState createState() => _AboutBookHubState();
}

class _AboutBookHubState extends State<AboutBookHub> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              "Welcome "+widget.user.username+"!",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),
            ),
            SizedBox(height : 15),
            /*Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,0),
              child: Divider(height: 0.5,color: Colors.black,),
            ),
            SizedBox(height : 10),*/
            Text(
              "About BookHub",
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height : 10),
            RichText(
              text: TextSpan(
                text: "BookHub is a mobile application that runs on both Android and IOS developped as a university ( Sup'Com ) project by ",
                style: TextStyle(fontSize: 15,color: Colors.black),
                children: <TextSpan>[
                  TextSpan(text: 'Achraf Affes, Ameni Boukadida, Ahmed Kallel.', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                ],
              ),
            ),
            /*Text(
              """Achraf Affes,
Ameni Boukadida,
Ahmed Kallel.""",
              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
            ),*/
            SizedBox(height : 10),
            Text(
              "Introduction. ",
              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
            ),
            Text(
              """BookHub is an app that gives you the chance to exchange your old books with other people.
All you need to do is to create an account, edit your profile and post your book!
BookHub will then display it to the other users,
BookHub will also show you all the books available according to your preferences (location and catherogry).
You can also search for a specific book by its name.
Once you have found the book you are looking for, you will be given the possibility to chat with the owner of the book according to the termes and policies, and at this point, BookHub services reach its limit.
""",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height : 15),
            Text(
              "Learn about BookHub terms and policies",
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height : 10),
            Text("Information about You. ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            Text(
              "BookHub may need to provide your personal information, such as your name and email address, to other users for the purposes of communication.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height : 5),
            Text("Disabled Accounts. ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            Text(
              "If BookHub disables access to your account in accordance with the Terms (for example if you violate the Terms), you may be prevented from accessing BookHub, your account details or any files or other Content that is stored with your account.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height : 5),
            Text("Unauthorized Access to Accounts. ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            Text(
              "You must keep your account details secure and must not share them with anyone else. You must not collect or harvest any personal data of any user of BookHub, including account names.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height : 5),
            Text("Multiple Accounts. ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            Text(
              "BookHub allows the same machine to run multiple accounts, users that posts the same content with different accounts will get their accounts suspended. ",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height : 5),
            Text("Spam and fake posts. ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            Text(
              """Don't post fake books.
Don't post the same book multiple times.
Don't post the same book from multiple accounts.
Don't post books to mislead other users.
Don't misrepresent your identity, and don't use other people's identities.""",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height : 5),
            Text("Illegal content. ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            Text(
              """Your posts must comply with the law and any terms or legal agreements you have agreed to.
Don't post reviews that contain or link to illegal content.""",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height : 5),
            Text("Hate speech. ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            Text(
              """BookHub is intended for all people.
Don't promote violence, condone violence, or incite hatred toward an individual or group based on their race, nationality, ethnic origin, religion, gender, gender identity, sexual orientation, age, disability, veteran status, or any other characteristic that is associated with systemic discrimination or marginalization.""",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height : 15),
            Text(
              "Need help? Contact us",
              style: TextStyle(fontSize: 32),
            ),
            Text(
              "Tell us more, and we will help you get there",
              style: TextStyle(fontSize: 15),
            ),
            Row(
              children: [
                Icon( 
                  Icons.mail,
                  color : Colors.black
                ),
                SizedBox(width : 5),
                Text("BookHub@gmail.com",style: TextStyle(fontSize: 15),)
              ],
            )
          ],),
        )
      ],
    );
  }
}
