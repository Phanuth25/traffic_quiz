// lib/assignment2/data/priority_data.dart

import 'package:project2/assignment2/model/priority_model.dart';

class PriorityQuizData {
  static const List<PriorityQuestion> priorityQuestions = [
    PriorityQuestion(
      id: "1",
      imagePath: "lib/assignment2/assets/1.png",
      answer0: "ក- រថយន្តលេខ១ និងលេខ៣ ចេញទៅព្រមគ្នា ទើបរថយន្តលេខ២ និងលេខ៤ ចេញទៅតាមក្រោយ",
      answer1: "ខ- រថយន្តលេខ២ និងលេខ៤ ចេញទៅព្រមគ្នា ទើបរថយន្តលេខ១ និងលេខ៣ ចេញទៅតាមក្រោយ",
      answer2: "គ- រថយន្តលេខ៣ ទៅមុន បន្ទាប់មករថយន្តលេខ២ រួចរថយន្តលេខ១ ហើយចុងក្រោយគឺរថយន្តលេខ៤",
      correctAnswer: 0,
      category: "Priority",
    ),
    PriorityQuestion(
      id: "2",
      imagePath: "lib/assignment2/assets/2.png",
      answer0: "ក- រថយន្តលេខ១ ចេញទៅមុន បន្ទាប់មករថយន្តលេខ២ រួចលេខ៣ ទៅតាមក្រោយ",
      answer1: "ខ- រថយន្តលេខ៣ ចេញទៅមុន បន្ទាប់មករថយន្តលេខ២ រួចរថយន្តលេខ១ បត់ឆ្វេង ទៅតាមក្រោយ",
      answer2: "គ- រថយន្តលេខ២ និងលេខ៣ ចេញទៅព្រមគ្នា រួចរថយន្តលេខ១ ទៅតាមក្រោយ",
      correctAnswer: 1,
      category: "Priority",
    ),
    PriorityQuestion(
      id: "3",
      imagePath: "lib/assignment2/assets/3.png",
      answer0: "ក- រថយន្តលេខ២ ត្រូវទៅមុន បន្ទាប់មករថយន្តលេខ៣ រួចរថយន្តលេខ១ បត់ឆ្វេង ទៅតាមក្រោយ",
      answer1: "ខ- រថយន្តលេខ២ ត្រូវទៅមុន បន្ទាប់មករថយន្តលេខ៣ និងរថយន្តលេខ១ ចេញទៅព្រមគ្នា",
      answer2: "គ- រថយន្តលេខ២ ត្រូវទៅមុន បន្ទាប់មករថយន្តលេខ១ បត់ឆ្វេង រួចរថយន្តលេខ៣ទៅតាមក្រោយ",
      correctAnswer: 2,
      category: "Priority",
    ),
    PriorityQuestion(
      id: "4",
      imagePath: "lib/assignment2/assets/4.png",
      answer0: "ក- រថយន្តលេខ៣ ចេញទៅមុខ បន្ទាប់មករថយន្តលេខ៤ រួចរថយន្តលេខ១ និងលេខ២ទៅតាមក្រោយ",
      answer1: "ខ- រថយន្តលេខ៣ ចេញទៅមុន រថយន្តលេខ១ បត់ឆ្វេងទៅបន្ទាប់ រួចរថយន្តលេខ៤ រួខលេខ២ ទៅតាមក្រោយ",
      answer2: "គ- រថយន្តលេខ៣ និងលេខ២ ចេញទៅដំណាលគ្នា រួចរថយន្តលេខ៤ រួចលេខ១ ទៅតាម ក្រោយ",
      correctAnswer: 1,
      category: "Priority",
    ),
    PriorityQuestion(
      id: "5",
      imagePath: "lib/assignment2/assets/5.png",
      answer0: "ក- រថយន្តលេខ១ ចេញទៅមុន បន្ទាប់មករថយន្តលេខ៤ រួចរថយន្តលេខ៣ ហើយរថយន្តលេខ២ ទៅតាមក្រោយ",
      answer1: "ខ- រថយន្តលេខ១ និងលេខ៣ ត្រូវចេញទៅព្រមគ្នា បន្ទាប់មករថយន្តលេខ៤ ហើយរថយន្តលេខ២ ទៅតាមក្រោយ",
      answer2: "គ- រថយន្តលេខ៤ ចេញទៅមុន រថយន្តលេខ២ បត់ឆ្វេងទៅបន្ទាប់ រួចរថយន្តលេខ១ និងលេខ៣ ទៅព្រមគ្នា",
      correctAnswer: 2,
      category: "Priority",
    ),
  ];
}