# Technical documentation

This part aims to explain how Rubyric works from a developer's point of view. 
Unfortunately, because of time limitations, documentation does not go too deeply 
into details nor does it have API description.

## Contents

1. [Users and sessions](#users-and-sessions)
2. [Roles](#roles)
3. [Courses](#courses)
4. [CourseInstances](#courseinstances)
5. [Exercises](#exercises)
6. [Rubrics](#rubrics)
7. [Reviews](#reviews)

## Users and Sessions

## Roles

## Courses

## CourseInstances

## Exercises

## Rubrics
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

## Reviews

TODO: Document reviews in similar way as rubrics

[<- Previous part](rubyric.md) | [Next part ->](user_guide.md)
