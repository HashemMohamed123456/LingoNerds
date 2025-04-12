import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../model/question/question_model.dart';

part 'level_test_state.dart';

class LevelTestCubit extends Cubit<LevelTestState> {
  LevelTestCubit() : super(LevelTestInitial());
  static LevelTestCubit get(context)=>BlocProvider.of<LevelTestCubit>(context);
  List<Question>questions=[
    Question(id: '1', title:'Choose The Correct Answer', options:{
      "She don't like pizza":false,
      "She doesn't like pizza":true,
      "She didn't like pizza":false,
      "She isn't like pizza":false
    }),
    Question(id: '2', title:'Which Word is The Synonym of Happy?', options:{
      'Sad':false,
      'Angry':false,
      'Joyful':true,
      'Nervous':false
    }),
    Question(id: '3', title:'Complete The Sentence: If I___a car I would drive to work', options:{
      'have':true,
      'has':false,
      'will have':false,
      'will had':false
    }),
    Question(id: '4', title:'___you like coffee?', options:{
      'Do':true,
      'Does':false,
      'Is':false,
      'Are':false
    }),
    Question(id: '5', title:"What is the plural form of 'child'?", options:{
      'Childs':false,
      'Children':true,
      'Childern':false,
      'Childes':false
    }),
    Question(id: '6', title:"Which sentence is in the passive voice?", options:{
      'They built a house':false,
      'A house was built':true,
      'They are building a house':false,
      'They have built a house':false
    }),
    Question(id: '7', title:"What is the past tense of 'Go'?", options:{
      'Goes':false,
      'Going':false,
      'Went':true,
      'Gone':false
    }),
    Question(id: '8', title:"Choose the correct preposition: 'I am waiting___the bus.'",
        options:{
          'at':false,
          'on':false,
          'to':false,
          'for':true
        }),
    Question(id: '9', title:"Which sentence uses the correct article?",
        options:{
          'I bought a apple':false,
          'I bought an apple':true,
          'I bought apple':false,
          'I bought the apple':false
        }),
    Question(id: '10', title:"What does 'break a leg' mean in English?",
        options:{
          'To break your leg':false,
          'To wish someone good luck':true,
          'To fall down':false,
          'To hurt yourself':false
        }),
    Question(id: '11', title:"Which of the following sentences is in future continuous tense?",
        options:{
          'I will be studying at 8 PM':true,
          'I study at 8 PM':false,
          'I am studying at 8 PM':false,
          'I will study at 8 PM':false
        }),
    Question(id: '12', title:"Which is the correct word order for a question?",
        options:{
          'You are coming to the party ?':false,
          'Are you coming to the party ?':true,
          'Coming are you to the party ?':false,
          'To the party you are coming ?':false
        }),
    Question(id: '13', title:"Choose the correct phrase: 'She’s very ___. She can play the piano, paint, and speak 3 languages'",
        options:{
          'lazy':false,
          'talented':true,
          'tired':false,
          'boring':false
        }),
    Question(id: '14', title:"What is the opposite of 'easy'?",
        options:{
          'Hard':false,
          'Difficult':false,
          'Tough':false,
          'both a and b':true
        }),
    Question(id: '15', title:"Choose the correct word: 'I have been working here ___ 2010.'",
        options:{
          'since':true,
          'for':false,
          'during':false,
          'by':false
        }),
    Question(id: '16', title:"Which of the following sentences uses 'much' correctly?",
        options:{
          "I don't have much time":true,
          "I don’t have many time":false,
          "I don’t have much times":false,
          "I don’t have a much time":false
        }),
    Question(id: '17', title:"Fill in the blank: '___ you ever been to Paris?'",
        options:{
          "Has":false,
          "Have":true,
          "Did":false,
          "Do":false
        }),
    Question(id: '18', title:"Which sentence is grammatically correct?",
        options:{
          "She is more taller than her sister":false,
          "She is tallest than her sister":false,
          "She is taller than her sister":true,
          "She is more taller as her sister":false
        }),
    Question(id: '19', title:"What is the correct way to ask for permission",
        options:{
          "Can I go to the bathroom ?":false,
          "May I go to the bathroom ?":true,
          "I can go the bathroom ?":false,
          "I go to the bathroom ?":false
        }),Question(id: '20', title:"Choose the correct option: 'The book is ___ the table.'",
        options:{
          "in":false,
          "on":true,
          "under":false,
          "at":false
        }),
  ];

}
