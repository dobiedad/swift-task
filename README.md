Please read below steps and create a small app.

Make sure to read the document entirely before starting coding.

**Steps**

1. Create a new project into xCode.

Set its bundle identifier.

2. Create a firebase account at firebase.google.com

Create a new project and set it to match the bundle identifier of the new project created at step 1. This will be used to test notifications.

3. Create an app with the below specifications

4. Generate and upload an adhoc build to diawi.com. Send us the specific diawi link after for testing and the source code in a zip file. Send us the Firebase Cloud Messaging API Key linked to this project so we can test notifications.



**Specifications**

**[1]** Add Core Data to the app, create an entity called &quot;Message&quot; with the following attributes:

id (type Integer 32)

message (type String)

sendername (type String)



**[2]** The app must handle incoming notifications and detect json payloads attached to the notification.

The payloads will be in the json key &quot;jsondata&quot;. If json content is present in that key, expect it to be a dictionary of the following format:

[&quot;id&quot;: (integer 32), &quot;message&quot;: (string), &quot;sendername&quot;: (string)]



**[3]** Create a table view controller which displays the list of messages in the database. The data source of the table view controller must be the content of the Core Data database, and managed using an NSFetchedResultsController. Name this class MessagesViewController.

Only display the message string in the reusable cells.



**[4]** Create a view controller with one UILabel centered vertically and horizontally. Name this class ProfileViewController.



**[5]** When the user taps on a message in the MessagesViewController, push an instance of ProfileViewController and display the &quot;sendername&quot; string in the label.



**[6]** When the app is active and receives a notification, the content of the notification must be checked and if necessary the jsondata processed and added to Core Data. The MessagesViewController will then display the newly received message.



**[7]** Do not use storyboards.
