# anchor
##Inspiration
We recognized a problem while talking to friends and realized that many people don’t show up to events simply because they don’t know anyone who's attending. We also noticed that socializing in classes becomes harder as you progress past freshman year. So, we created Anchor to help students find people to attend events with.

##What it does
Anchor is a web and cross-platform mobile application that helps students connect with others who are attending the same events. It creates a profile for each student based on their interests using speech-to-text and AI tag generation, making the process quick and easy. Additionally, AI pulls class title tags, allowing students to easily customize their profiles. Using their profile, the app suggests events on the events page, and students can filter based on their preferences. They can then select an event and click "Find a Buddy" to get matched with someone they can go with. This matching process uses AI to assess compatibility based on profile tags (without using any personal information).

##How we built it
For app development, we used:  
- Firebase Hosting  
- Flutter UI framework  
- VSCode  
- Gemini AI API  
- Dart  
- Speech-to-Text API  
- Google Generative AI package  
And others to build the app.

##Challenges we ran into
One of our main challenges was trying to use Eleven Labs for speech-to-text due to its excellent model, but Flutter didn’t have extensive documentation on how to integrate it with its existing audio web packages. This made implementation difficult, so we switched to an alternative package, Flutter's Speech-to-Text API. We also struggled with narrowing down our idea. Initially, it was very broad, but we eventually focused on matching students for on-campus events due to safety concerns. 

##Accomplishments we’re proud of
Despite having another event on the same day and a late start, we were able to put together a solid project that we are proud of. We also learned a lot about AI, app development, and how to address real-world problems.

##What’s next for Anchor
- Group matching  
- Expanding to nationwide campuses  
- Allowing users to create their own events  
- Providing a portal for organizations to list their events

##Built With  
- Firebase Hosting  
- Flutter UI Framework (For web/mobile app)
- Dart  
- Gemini AI API  
- Speech-to-Text API  
- Google Generative AI package  
- VSCode  
