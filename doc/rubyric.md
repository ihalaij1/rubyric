# Rubyric
Rubyric is an online tool which is used in teaching to make giving written 
feedback on assignments easier and faster using predefined rubrics.
Rubyric allows teachers to create courses, course instances and assignments.
Teachers can create assessment rubrics to assignments to be used as a base to
review students' submissions. Rubrics contain predefined criteria, feedback
phrases and their corresponding grades and points. The reviewer can choose
phrases and add their own comments in between them to create consistent but
personalized feedback for students.

This version of Rubyric has parts that have been developed according to wishes
of some courses in Aalto University and other parts have been developed to 
connect Rubyric to other teaching services, mainly A+. However, Rubyric can be 
used as a standalone service.

This documentation aims to explain how Rubyric works from point of view of
developer as well as end user.

## Contents

1. Installation
  * Install environment
  * Install Rubyric
  * Connect local Rubyric to A+ course in docker (optional for testing)
2. Technical documentation
3. User Guide

## 1. Installation

### Install environment
Install ruby version 2.3.1 or higher , for example with rvm or rbenv. Then
install rails:

```sh
gem install rails -v 5.0.2
```
or
```sh
sudo gem install rails -v 5.0.2
```

Rubyric requires pdfinfo, ghostscript and libpq-dev to work

```sh
sudo apt-get install poppler-utils ghostscript libpq-dev
```

Rubyric uses postgresql as database. Install postgresql and create user.

```sh
sudo apt-get install postgresql
sudo -u postgres createuser --interactive
```

### Install Rubyric
Install gems
```sh
bundle install
```

Copy configuration files
```sh
cp config/initializers/secret_token.rb.base config/initializers/secret_token.rb
cp config/initializers/settings.rb.base config/initializers/settings.rb
cp config/database.yml.base config/database.yml
```

Create database, and put password and username to config/database.yml
```sh
sudo -u postgres createdb -O my_username rubyric
```

Initialize database
```sh
rails db:setup
```

Start server
```sh
bin/delayed_job start
rails server
```
Now you can access Rubyric at http://localhost:3000/.

### Connect local Rubyric to A+ course in docker (optional)

> NOTE: Unless you are developer and you need help in testing Rubyric with A+, 
> you can just ignore this section.

This section is optional and is only used if you want to test how Rubyric
works with your A+ course in development environment, e.g. when you are
implementing some new function to Rubyric. To test your local Rubyric version
with A+ course, you need to start A+ course at localhost. To do this follow 
instructions at https://apluslms.github.io/guides/quick/.

In order to get A+ and Rubyrci to communicate with each other we need to do 
some configuring to both services. At the time of writing this guide A+ needs 
ports 8000, 8080 and 3000. Thus we cannot use the default port 3000 with 
Rubyric. Choose some other port for Rubyric, e.g. 3030. You also 
need to find out your docker ip address, which can be for example something like 
172.17.0.1 or 172.18.0.1 as A+ should contact that address in order to reach
Rubyric. You also need to find out from which address A+ tries to contact 
Rubyric. 

To add Rubyric as a LTI service to A+ you need to

  1. Go to http://localhost:8000/admin and login as `root`:`root`
  2. Choose `Lti services` and `Add Lti service`
  3. Set settings as
    * Url: http://[docker ip]:[port]/session/lti
    * Destination region: hosted in the same organization
    * Access settings: allow API access
    * Consumer key: test
    * Consumer secret: secret
    
Key-secret pair test:secret are part of default configuration of Rubyric. You
can change these in `config/initializers/settings.rb`. In production version
you **should** change these into something safer.

In Rubyric add A+ (docker) ip address into APLUS_IP_WHITELIST at file
`config/initializers/settings.rb`
so that Rubyric will accept submissions from A+.

Start Rubyric server

```sh
rails server -p [port] -b [docker ip]
```

With this your local Rubyric should allow your A+ course to connect to it.

## 2. Technical documentation
### Users and Sessions

### Roles

### Courses

### CourseInstances

### Exercises

### Rubrics
*RubricEditor* (`app/assets/javascripts/rubricEditor.js.coffee`) is `coffeescript` 
file which creates jsons depicting rubrics. *ReviewEditor* 
(`app/assets/javascripts/reviewEditor.js.coffee`) interprets rubric jsons and 
allows creation of plain text reviews. *AnnotationEditor* 
(`app/assets/javascripts/annotationEditor.js.coffee`) uses ReviewEditor's 
interpretation and allows creation of annotation reviews. Rubyric uses 
`knockout.js` to bind the models these files contain to the views.

At the moment Rubyric can interpret two versions of rubrics, 2 and 3. Version 
3 allows rubrics to be multilingual while version 2 does not support them. 
RubricEditor can open version 2 rubrics as version 3 rubrics that have only one
language. Thus it can open both version 2 and 3 but saves both as version 3. 
ReviewEditor can read both version 2 and 3 rubrics and turn them into single
language review bases. Let's have a look at what both versions look like in a
simple rubric, version 3 using two languages "en" and "fi":

~~~
{
  "version":"2",
  "pages": [
  {
    "id":1,
    "name":"Page 1",
    "instructions":"Some instructions for the grader.",
    "minSum":"0",
    "maxSum":"5",
    "criteria":[
    {
      "id":1,
      "name":"Criterion 1",
      "instructions":"Instructions",
      "minSum":"0",
      "maxSum":"2",
      "phrases":[
      {"id":1,"text":"Some positive feedback","category":1,"grade":2},
      {"id":2,"text":"Something to improve","category":2,"grade":1},
      {"id":5,"text":"General feedback","category":3}]
    },
    {
      "id":2,
      "name":"Criterion 2",
      "minSum":"0",
      "maxSum":"3",
      "phrases":[
      {"id":3,"text":"Failing grade","category":2,"grade":"Failed"},
      {"id":4,"text":"Well done!","category":1,"grade":3}]
    }]
  }],
  "feedbackCategories":[
  {"id":1, "name":"Strengths"},
  {"id":2, "name":"Weaknesses"},
  {"id":3,"name":"Other"}],
  "grades":["Failed",1,2,3,4,5],
  "gradingMode":"average",
  "finalComment":""
}
~~~
~~~
{
  "version":"3",
  "pages":[
  {
    "id":1,
    "name":{"en":"Page 1","fi":"Sivu 1"},
    "instructions":{"en":"Some instructions for the grader.", "fi":"Ohjeita arvostelijalle."},
    "minSum":"0",
    "maxSum":"5",
    "criteria":[
    {
      "id":1,
      "name":{"en":"Criterion 1","fi":"Kriteeri 1"},
      "instructions":{"en":"Instructions", "fi":"Ohjeita"},
      "minSum":"0",
      "maxSum":"2",
      "phrases":[
      {
        "id":1,
        "text":{"en":"Some positive feedback","fi":"Jotain positiivista"},
        "category":1,
        "grade":2
      },
      {
        "id":2,
        "text":{"en":"Something to improve","fi":"Jotain parannettavaa"},
        "category":2,
        "grade":1
      },
      {
        "id":5,
        "text":{"en":"General feedback","fi":"Yleistä palautetta"},
        "category":3
      }]
    },
    {
      "id":2,
      "name":{"en":"Criterion 2","fi":"Kriteeri 2"},
      "minSum":"0",
      "maxSum":"3",
      "phrases":[
      {
        "id":3,
        "text":{"en":"Failing grade","fi":"Hylätty arvosana"},
        "category":2,
        "grade":"Failed"
      },
      {
        "id":4,
        "text":{"en":"Well done!","fi":"Hyvin tehty!"},
        "category":1,
        "grade":3
      }]
    }]
  }],
  "feedbackCategories":[
    {"id":1,"name":{"en":"Strengths","fi":"Vahvuudet"}},
    {"id":2,"name":{"en":"Weaknesses","fi":"Heikkoudet"}},
    {"id":3,"name":{"en":"Other","fi":"Muuta"}}],
  "grades":["Failed",1,2,3,4,5],
  "gradingMode":"average",
  "finalComment":{"en":"","fi":""},
  "languages":["en","fi"]
}
~~~

RubricEditor defines classes: 
  * TextField
  * GradingInstructions
  * Page
  * Criterion
  * Phrase
  * Grade
  * FeedbackCategory
  * Language
  * RubricEditor
  
*TextField* represents an editable text field. It contains variables: text,
language, owner, editorActive and rubricEditor. Owner is the list the object 
belongs to. TextFields are used instead of strings to represent different
language versions of i.a. page and criterion names. Since it is not predefined
how many languages one rubric can have and editable strings associated with 
some language are needed in several cases it seemed appropriate to use separate 
class to represent text fields.

*GradingInstructions* represents the grading instructions the teacher can add
to pages and criteria. It contains variables: textFields, textFieldsByLanguageId
and rubricEditor. GradingInstructions object stores the TextField objects 
containing the different language versions of instructions it represents. 
GradingInstructions were made into their own class since they are used in both 
pages and criteria and they should function the same way in both cases.

*Page* has variables: rubricEditor, id, textFields, namesByLanguageId, 
criteria, minSum, maxSum, sumRangeHtml, instructions, tabUrl, tabId and 
tabLinkId. List textFields contains different language versions of page's name 
as TextField objects and namesByLanguageId is a hash used as a helper to sort 
textFields by their language. Variables minSum, maxSum and sumRangeHtml are used 
to crop points in the page to chosen range. Every page has at most one 
GradingInstructions object stored in variable instructions. Pages act as tabs 
in the editor views to allow teacher to divide grading criteria into larger 
groups. Page contains a list of criteria and new criteria are added to these 
lists. Adding a new criterion is handled by the page. If page is deleted, all 
of its criteria will be gone too.

*Criterion*, like Page, has variables: rubricEditor, id, textFields, 
namesByLanguageId, minSum, maxSum, sumRangeHtml and instructions. However 
Criterion has a list of phrases instead of criteria and Criterion object knows 
which page it belongs to. Criterion adds phrases to the rubrics. 

*Phrase* has variables: rubricEditor, id, criterion, category, grade, 
gradeValue, editorActive, textFields and namesByLanguageId. Phrases contain the 
feedback and they are used to construct the review.

*Grade* contains variables: value, container and editorActive. Container is the 
list grade belongs to.

*FeedbackCategory* has variables: rubricEditor, id, editorActive, text
and namesByLanguageId. Categories are used to sort and classify phrases in 
reviews.

*Language* has variables: rubricEditor, name, editorActive, id and textFields.
They are used to connect textFields of the same language with each other.

*RubricEditor* is the object which is used as a root and to whom knockout's 
ko.applyBindings() is called for. All other objects are accessed in the view
through the root. 


### Reviews

### Collaboration mode

### Peer review

## 3. User Guide
### Getting started
This chapter contains basic information about Rubyric features such as creating 
courses and exercises and what different settings mean. For instructions on how 
to create A+ connected course check out the chapter 
[A+ connected courses and exercises](#a-connected-courses-and-exercises).

Rubyric has three different login methods: HAKA, LTI and regular. HAKA login is 
possible if Rubyric has required parameters defined for it and can then be 
accessed at front page. LTI login is done through some other trusted site where 
Rubyric has been added as a LTI service. The other site directs user to Rubyric.
LTI and HAKA login do not need separate registering but regular login requires 
it. To register go to /users/new and put in email and password for your Rubyric 
account. Regular login works through sign in form at front page.

Note that these login methods are connected to different accounts and thus you 
cannot access the same courses through different login methods.

To create a new course follow these steps:

  1. Login to Rubyric
  2. Click "Create new course" or go to /course_instances/new
  3. Fill in the form and click "Create"
  
Creating a new *course* also creates a new *course instance*. In the form you 
need to set *course name* and *course instance name*. A course can have several 
course instances, for example one for fall 2018 and another for spring 2019. 
*Interface language* affects on in which language some instructions are shown 
to course instructors and assistants. 

*Submission policy* defines who can submit to assignments: 

  * "Anybody can submit without authenticating" allows students to 
    submit without logging in by giving their email address. 
  * "Any authenticated user can submit" allows logged in students to submit.
  * "Only enrolled students can submit" requires instructor to provide list of
    students allowed to submit
  * "LTI integration" is used in LTI and A+ courses, if chosen you should fill 
    in *LTI consumer ID* and *LTI context ID* (shown only if "LTI integration"
    is chosen)
    
Front page lists courses (and instances) where you are either an instructor, 
a reviewer or a student. Choose a course where you are an instructor to inspect 
by clicking the name of the course. You can set *course code*, *time zone* and 
*course email* and change course name at course settings by clicking "Settings" 
under "Course" at the menu on the left.

*Instructors* belong to the course and all course instances the course has 
share instructors. Instructors have rights to i.a.:

  * Change course's settings
  * Create and update course instances
  * Create, update and delete assignments
  * Add and remove instructors and reviewers
  * Assign groups for reviewers so they can grade groups' submissions
  * Grade any student's submissions
  * Move and delete submissions 

Basically instructors can do anything to the course except delete it or its 
course instances. To add instructors click "Instructors", start to write
name of the user you want to add in search field and click "Search". If you 
find the user in the list click the button next to their name and click "OK"
button to confirm. If you cannot find the user in the list the user might not
have registered yet. Ask them to login once and try again or alternatively you 
can send an invitation to them by writing their whole email address to the 
search field. You can remove instructor by clicking the trash can icon next to 
their name and confirming it. The icon appears after you reload the page after 
adding the instructor.

If you want to create a new course instance for the course, inspect the course 
by clicking its name on the front page. Click "Create new instance" button and 
you will be directed to form for creating new course instance which is the same 
as the one used to create a new course except it does not ask for course name 
as the course already exists.

Inspect the course instance by clicking its name either on the front page or 
while inspecting the course. To update settings of the course click "Settings"
under the course instance at menu on the left. Clicking "Reviewers" you can add 
and remove *reviewers* in the same way you do instructors. Reviewers have rights 
to grade submissions of groups assigned to them. Otherwise they have similar 
rights as students. "Students" page lists the *students* of the instance. 
Students can make submissions and view reviews done to them. If the assignment 
uses peer review, students can assess other students' submissions. Reviewers and 
students belong to the course instance, not to the course. Thus each instance 
can have different students and reviewers.

By clicking "Groups" you can view student groups of the course instance. After 
choosing an exercise name from "Filter groups by" and clicking "Filter" the page 
shows only the groups that have submitted to the exercise. Assigning the groups 
to reviewers can be done in the "Groups" page. Assign group by:

  1. Hover over group
  2. Click "Add reviewer.." button
  3. Choose reviewer for the group
  4. Click "Save"
  
or assign several groups at once by:

  1. Check check-boxes of groups
  2. Choose whom to assign the groups to from "Assign selected groups to" 
     and click "Assign"
  3. Click "Save"
  
You can upload a student list to Rubyric by choosing "Batch upload" tab at 
"Group" page. Follow instructions at the page to provide student list and/or to 
use the page to assign groups to reviewers. If your course instance has 
submission policy "Only enrolled students can submit" you have to use "Batch 
upload" to provide the student list. Example input for batch upload:

~~~
00005, 00006, 00007 ; teacher1@example.com
00004
00008, 00009
~~~

Example input adds students with provided studentnumbers to the course as 
students and forms groups (00005, 00006, 00007), (00004) and (00008, 00009) out 
of them to groups list. Example input also assigns the first group to reviewer 
with given email address.

To create a new exercise follow these steps:

  1. Login to Rubyric
  2. Click the course instance you want to create the exercise to
  3. Click "Create new assignment"
  4. Fill in the form and click "Save"
  
The form is divided into three parts, first of which has general exercise 
settings, the second contains settings for using peer review and the last part 
defines anonymity of reviews and submissions. The general settings include 
*name*, *deadline*, *group size*, *submission type*, *review mode*, 
*submission instructions* and two toggle-able options *allow reviewers to send 
reviews immediately* and *allow reviewers to review all submissions*. Review 
mode has two options "Plain text" and "Annotation". Review mode affects what 
kinds of reviews are made for the exercise submissions. Toggling on allow 
reviewers to send reviews immediately adds to reviewers' an option to send their 
reviews to students themselves immediately after they have finished them. 
Normally the instructor sends the reviews onward. Allow reviewers to review all 
submissions allows reviewers to view and review all submissions done to this 
exercise, not only those made by groups assigned to them.

To activate peer review for the exercise you need to give some value to *peer 
review* which tells how many reviews each students should be doing. *Open peer 
review* defines when students are allowed to do reviews. *Collaborative mode* 
allows students to construct the feedback together, allowing students to review 
each other's submissions freely.

Anonymity settings are *anonymous reviewers* and *anonymous students*. Toggling 
anonymous reviewers on hides reviewer's name from students. Toggling anonymous 
students on hides students' names from reviewers. 

Once you have saved the new exercise you can view it by clicking its name at 
the menu on the left. The page shows the deadline, group size and *submissions 
url* that students can use when submitting. A new exercise does not yet have 
rubric to be used in reviews. You can create rubric by pressing "Edit rubric" 
button or clicking "Rubric" under assignment at the menu on the left. 
[Next chapter](#rubrics-and-reviews) will tell more about creating rubrics and 
reviewing the submissions. A new exercise does not have any submissions either. 
You can generate example submissions by pressing "Generate example submissions" 
button. Example submissions use fake students and you can use these submissions 
for trying out reviewing and testing your rubric.

On the exercise view there are also tables *Completed reviews* and 
*Submissions*. Completed reviews lists how many reviews each reviewer and 
instructor have started and completed. It can be used to monitor how much work 
each grader has done. Submissions table lists all submissions and reviews in the 
exercise. Instructor can send reviews onward to students by choosing them from 
table and pressing "Deliver selected reviews" button. More insight on how to use 
and read these tables and "Results" page can be found at chapter
[Results](#results).

### Rubrics and reviews
TODO: This chapter will introduce rubrics and different types of reviews you can
do at Rubyric.

### A+ connected courses and exercises
This chapter explains how to configure A+ connected courses and exercises.

To configure the course you have two choices. 

(Recommended) The first option:

  1. Add Rubyric to menu at A+
    * Open "Edit course"
    * Go to "Menu" tab
    * Click "Add new menu item"
    * Choose settings and submit the form
  2. Click the menu item you created
  3. Click "Continue to the service"
    * You should be directed to create course form at Rubyric.
  4. Fill in the course and course instance names
    * Form already has LTI consumer ID and LTI context ID filled in, do not
      touch them.
  5. Click "Create"
  
Alternatively you can:

  1. Login to Rubyric
  2. Click "Create new course" or go to /course_instances/new
  3. Fill in the course and course instance names and choose "LTI integration"
     as Submission policy
  4. Fill in the LTI consumer ID and LTI context ID
    * Add Rubyric to menu at A+
    * Click the menu item you created
    * Click show details and fill form at Rubyric with values from details:
      * LTI consumer ID: `oauth_consumer_key`
      * LTI context ID: `context_id`
  5. Click "Create"
  
The first option is recommended since getting LTI consumer ID and LTI context ID
right can be difficult in the latter. However the latter option can be used to 
create a new instance to existing course while it is not supported by the first 
option. New instance can be created by replacing step 2 with: Choose the course 
and click "Create new instance". And following the instructions after that.

To test whether or not the configuration was successful login to Rubyric with 
LTI by doing steps 2. and 3. from the first option. If it directs you to the 
course, configuration was successful. If you ended up in create course form, 
check that LTI consumer ID and LTI context ID are set correctly 
(remove all whitespace etc.).

After you have configured course you can configure A+ connected exercise. There 
is two choices for exercise configuration: automatic (recommended) and manual.

(Recommended) Automatic exercise configuration through A+:

  1. Create new A+ exercise using Rubyric as Lti service, use:
    * Service url: /aplus_exercise
    * Aplus get and post: True
    * Open in iframe: True
  2. Open the exercise at A+
    * Opening the exercise configures it at Rubyric if it has not yet been done
  3. (Optional) Login to Rubyric and change exercises setting to your liking
    * Do not touch LTI resource link ID

Manual exercise configuration:

  1. Login to Rubyric
  2. Choose the course instence and click "Create new assignment"
  3. Fill in the exercise form and click "Save"
    * Choose some unique `LTI resource link ID`: e.g. 
      [course_code]-[course_name]-[instance]-[exercise_name]
  4. Get `service url` from the exercise page
  5. Create new A+ exercise using Rubyric as Lti service, use:
    * Service url: `service url` from Rubyric exercise
    * Resource link id: `LTI resource link ID` from Rubyric exercise
    * Aplus get and post: True
    * Open in iframe: True
  6. (Optional) Test configuration by opening the exercise at A+, if you see
     submit button it should be done
     
TODO: Peer review configuration

### Results
TODO: This chapter should explain how exercise view works, how to send reviews
to students and how results page works. 
