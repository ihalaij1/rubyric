# User Guide

## Contents

1. [Getting started](#getting-started)
2. [Rubrics and reviews](#rubrics-and-reviews)
3. [A+ connected courses and exercises](#a-connected-courses-and-exercises)
4. [Results](#results)

## Getting started
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
the menu on the left. The page shows the deadline, group size and *submit 
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

## Rubrics and reviews
This chapter will first explain how to create rubrics. After that the chapter 
will introduce different types of reviews available at Rubyric and how reviewing 
submissions works.

Start creating or editing your rubric by choosing the exercise and clicking 
rubric under assignment name at the menu on the left. Rubrics on Rubyric have 
*pages*, *criteria* and *phrases*. The feedback is constructed out of phrases. 
Phrases are related to one specific criterion and criteria are located on pages. 
Pages can be used for separating criteria from each other, e.g. criteria related 
to style are located at one page and criteria related to content are on another. 

Rubric editor starts at "Settings" tab. There you can set *grading mode*, 
*feedback categories*, *languages*, *final comment* and, if your grading mode 
is set as "Mean", *grades*. 

*Grading mode* has four options: "No grade", "Mean", "Sum" and "Always pass". 
"No grade" mode does not give any grade or points to the submission but gives 
purely textual feedback. "Mean" mode allows instructor to define set of 
*grades* which can be associated with phrases. When reviewing submission, 
Rubyric calculates the mean of grades of chosen phrases for each page and 
suggests it to the reviewer. However the reviewer is also allowed choose some 
other value. Final grade of review is set in the same fashion except that the 
suggested value is calculated as a mean of grades of the pages. "Sum" mode 
allows instructor to set grades/points for each phrase and final grade is the 
sum of these grades. "Always pass" mode is available only for course instances 
with Submission policy "LTI integration". "Always pass" mode does not associate 
phrases with any points and, like "No grade", it gives purely textual feedback. 
When sending points to other services "Always pass" sends feedback as full 
points.

*Feedback categories* are associated with phrases and are used in reviews to 
collect selected phrases into groups. In final feedback text the phrases 
associated with same category will be collected together under the feedback 
category's name. Feedback categories could be for example: "Strengths", 
"Weaknesses" and "Other".

Rubyric allows instructor to create multilingual rubrics so that every page, 
criterion and phrase has versions in all languages the instructor has chosen for 
the rubric. *Languages* are added to the language list on the "Settings" tab. 
By default rubrics are not multilingual and have only one language with name 
"default" defined. Adding a new language is done by pressing "Add language" 
button after which the instructor is asked to name the language. Instructor 
should translate all phrases, criteria, pages etc. to available languages. 
Deleting a language deletes all texts associated with the language. When 
reviewing assignment with multilingual rubric, only the translations in the 
language of the review are shown to the reviewer. If rubric is multilingual, a 
new review's language defaults to the first language in the languages list. 
However the reviewer can change the language of the review.

*Final comment* is a text that is automatically added to the end of every 
review.

Each *page* is shown as its own tab. New pages are added by pressing "Create 
new page" button. New pages always have two criteria both if which have two 
default phrases as an example. Pages can be renamed by clicking their name and 
confirming the new name by pressing "OK" button. Instructor can set minimum and 
maximum points the students can acquire from pages and add grading instructions 
for the reviewers. Min and max point fields and button for adding grading 
instructions can be seen by hovering over the page name. Page can be deleted by 
pressing trash can icon next to page name.

*Criteria*, just like pages, can be renamed and can be associated with minimum 
and maximum points and grading instructions. New criterion is created to the 
page by pressing "Create new criterion" button. Criteria can be rearranged 
within the page by dragging them to a new position.

*Phrases* have text fields for their content, one text field for each available 
language. They can be edited by clicking the text in them and changes are 
confirmed by pressing "OK" button. The feedback categories (if there is any) 
are selected per phrase. If the grading mode of rubric is "Mean", the phrase is 
associated with a grade chosen from list of defined grades. If the grading mode 
is "Sum", the instructor can type the grade to the field left from phrase's 
content. New phrases are added to existing criterion by pressing "Create new 
phrase" button. Phrases can be moved within criterion and between criteria by 
dragging them to the desired position.

After you have finished editing rubric press "Save" button and click on the 
exercise name at top of the view to return to exercise page.

Rubyric has two types of reviews "Plain text" and "Annotation". The type of 
review is set in exercise settings. "Plain text" is, as the name suggests, 
review constructed of plain text. "Annotation" review opens the submission and 
allows reviewer to drag phrases on the submission to point at the exact point 
the phrase is referring at. 

To start reviewing a submission hover over it at exercise page and press "Create 
review" button. The review editor loads the rubric on the default language if 
the review is new or review's language is not set. Otherwise the rubric is 
loaded on the review's language. The editor shows pages as tabs and criteria 
and phrases associated with them in similar fashion as when editing rubrics. 
"Overview" tab shows basic information about the review. The reviewer can view 
information about when the review has been created and last updated and the 
group that has made the submission. Reviewer can also download the submission 
file and change the language of the review at "Overview" tab.

"Plain text" reviews are done by clicking suitable phrases. After clicking on a 
phrase, its contents appear on text field on the right side of the editor. If 
the rubric has feedback categories there are separate text fields for each 
category and phrases appear on the text field of its associated category. The 
phrases can be edited in the text fields and reviewer can add their own comments 
in between phrases. 

"Annotation" reviews are done by dragging phrases to the submission. Phrases can 
be deleted by clicking X-button at them. They can be edited by clicking on their 
content, changing the content and pressing "OK". The reviewer can add their own 
comments to the review by clicking the point where they want to add it to. It 
opens text field where reviewer can freely write what they want.

Reviews have a few different statuses:

  * "": The review has been created but is still empty
  * "started": The review has been started but not yet finished
  * "finished": The review has been finished and ready to be delivered to 
  students
  * "mailing": The review is about to be delivered to students
  * "mailed": The review has been delivered to students
  * "invalidated": The review cannot be edited nor sent to students
  
The review reaches "finished" status if reviewer has chosen a phrase from each 
criteria and moved to "Finalize" tab. "Plain text" reviews allow reviewer to 
view and edit the final feedback at "Finalize" tab. After moving to "Finalize" 
review can no longer be edited on other tabs. Finalization can be cancelled but 
doing so will destroy all changes reviewer has done at "Finalize".

## A+ connected courses and exercises
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

## Results
This chapter will explain how exercise view works, how to send reviews
to students and how the "Results" page works. 

As an instructor the user can view list of all submissions and reviews for each 
exercise (or assignment) by going to the exercise view. To do this click on the 
course instance name and after this click on the exercise name. The view shows 
deadline, allowed group size for submissions and submit url or sevice url 
(in LTI course instances). The view also has two tables: *Completed reviews* and 
*Submissions*. 

*Completed reviews* table lists all graders for the exercise. That is: users who 
are either instructors, reviewers or have at least one review at the exercise. 
For each grader the table shows how many reviews they have *Not started*, 
*Started*, *Completed* and *Mailed*. *Not started* refers to submissions of 
groups that have been assigned to the reviewer but which reviewer has not yet 
reviewed. *Started* refers to reviews with status "started" or "". *Completed* 
refers to reviews with status "finished", "mailing" and "mailed" and *Mailed* 
shows how many of Completed reviews have status "mailed". Reviews with status 
"invalidated" are not considered to be Started nor Completed. Thus "invalidated" 
reviews do not reduce Not started count.

**Completed reviews**

| Reviewer    | Not started | Started | Completed(Mailed) |
|:------------|:------------|:--------|:------------------|
| Teacher 1   | 0           | 1       | 2 ( 2 )           |
| Assistant 1 | 3           | 0       | 3 ( 1 )           |

From the example table above we can see that "Teacher 1" has one review they 
have started but not yet finished and two reviews they have finished and mailed 
to the students. "Assistant 1" has been assigned to review three submissions 
which they have yet to start reviewing. They have also finished three reviews 
out of which one has been mailed to the students.

Completed reviews table can be used to monitor assistants and to keep track on 
how many reviews each of them has completed. 

*Submissions* table lists all groups who have submitted to the exercise, their 
submissions and reviews done to them. The table has columns *Submission*, 
*Review*, *Status* and *Grade*. The submissions are grouped together by their 
submitter groups. Each group is shown as a row with grey background. The row 
shows group's name and, if the group has been assigned to a reviewer, the name 
of reviewer is also shown. Group's submissions are listed below the group name, 
each submissions as their own row (in case the group has more than one 
submission). 

*Submission* column contains the submission times and links to download the 
submissions. There is also a dropdown (tiny down pointing arrow next to 
submission download link) containing options: 

  * "Create new review": Creates new review for the submission
  * "New submission...": Create new submission for the group
  * "Move submissions...": Moves submissions to another exercise
  * "Delete submission...": Deletes the submission and its reviews
  
*Review* column has link to the review and a checkbox. The review link is shown 
as the name of the reviewer and hovering over the link shows the time it was 
last updated. While the review has not been mailed or invalidated, the link 
directs the instructor to edit the review. After the review has been mailed or 
invalidated, the link directs the instructor to view the review. The checkbox 
is used to choose the reviews the instructor wants to send to students. *Status* 
column states the status of the review. *Grade* column shows the grade of the 
review. In case the submission has several reviews (for example when using peer 
review), the row containing the submission is divided into several rows, one 
for each review, who all share the same Submission block. 

Once review has been finished, it can be sent to students. Instructor can sent 
multiple reviews at once by checking them at Submissions table and pressing 
"Deliver selected reviews" button. "Select all" button selects automatically 
all reviews, "Select finished" button selects only the reviews which have status 
"finished" and "Select none" cancels all selections. Regular submissions will 
be delivered to students' email. A+ submissions will be sent to A+. Note that 
A+ scales the points it receives from Rubyric to fit the maximum points of the 
exercise there. E.g. When Rubyric sends 2 points out of maximum 10 and A+ 
exercise has maximum points of 100, the points will scaled to 20 points.   

If sending reviews to A+ the instructor should pay attention to option "If 
sending several reviews for one submission set points equal to:". "Best grade" 
sets the points at A+ equal to the points of the best review of the submission. 
"Average grade" calculates average of the chosen reviews for the submissions 
and sets points at A+ equal to that value.

Another thing to note is that Rubyric cannot sent non-numerical grades 
(e.g. "Failed" or "Boomerang") to A+ and warns the instructor when trying to do 
so. Non-numerical grades won't be taken into account when calculating the 
points sent to A+ but the feedback text will still be included in the sent 
review. 

To see an summary of grades each student has gotten from an exercise, you need 
to go to "Results" page. To do this go to the exercise view and click on 
"Results" at the menu on the left. "Results" page lists grades for each student 
and allows instructor to download the list as CSV.

"Results" page has two options for listing grades: "All reviews" and "Combined 
grade". "All reviews" option lists students whose submissions has been reviewed 
(and review has been completed) with the grade of the review. If student's 
submission has several reviews, each one is listed separately. "Combined grade" 
options lists all students who have submitted to the exercise. The grade shown 
in "Combined grade" option is average grade of reviews. The tables can be sorted 
by their column values by clicking the arrow next to the column names. The 
tables can be downloaded from Rubyric by choosing the table and clicking 
"Download CSV spreadsheet" button. 

[<- Previous part](technical_documentation.md) |
