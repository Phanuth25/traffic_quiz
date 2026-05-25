// lib/assignment2/data/emergency_data.dart

import 'package:project2/assignment2/model/emergency_model.dart';

class EmergencyQuizData {
  static final List<EmergencyQuestion> emergencyQuestions = [
    EmergencyQuestion(
      id: 1,
      question: "បើជនរងគ្រោះដាច់ដង្ហើម តើអ្នកអាចជួយជនរងគ្រោះនោះយ៉ាងដូចម្តេច?",
      answer1: "ក- ត្រូវអង្រន់ខ្លួន",
      answer2: "ខ- ត្រូវច្របាច់ដៃ ជើង",
      answer3: "គ- ត្រូវផ្លុំខ្យល់ចូលតាមមាត់ ជនរងគ្រោះ",
      correctAnswer: 2,
      category: "Emergency First Aid",
    ),
    EmergencyQuestion(
      id: 2,
      question: "តើរយៈពេលបាត់ដង្ហើមប៉ុន្មាននាទី ដែលអាចធ្វើអោយជនរងគ្រោះស្លាប់?",
      answer1: "ក- ចាប់ ៥ នាទី ឡើងទៅ",
      answer2: "ខ- ចាប់ពី ១០ នាទី ឡើងទៅ",
      answer3: "គ- ចាប់ពី ១៥ នាទី ឡើងទៅ",
      correctAnswer: 0,
      category: "Emergency First Aid",
    ),
    EmergencyQuestion(
      id: 3,
      question: "តើអ្នកអាចជួយជនរងគ្រោះបាត់ដង្ហើមក្នុងរយៈពេល ប៉ុន្មាននាទី?",
      answer1: "ក- ក្នុងរយៈពេល ២ ទៅ ៣ នាទី",
      answer2: "ខ- ក្នុងរយៈពេល ៥ ទៅ ១០ នាទី",
      answer3: "គ- ក្នុងរយៈពេល 10 ទៅ ១៥ នាទី",
      correctAnswer: 0,
      category: "Emergency First Aid",
    ),
    EmergencyQuestion(
      id: 4,
      question: "បើដឹងថាជនរងគ្រោះបាក់ដៃ តើអ្នកត្រូវធ្វើយ៉ាងដូចម្តេច?",
      answer1: "ក- ត្រូវទាញ ឬបង្វិលដៃដែលបាក់នោះ",
      answer2: "ខ- ត្រូវលើកជនរងគ្រោះដោយមិនបាច់ធ្វើអ្វីទាំងអស់",
      answer3: "គ- ត្រូវទុកដៃបាក់ឲ្យនៅស្ងៀម រួចប្រើបន្ទះដែក ឬឈើអបដៃរួចចងក្រណាត់ ឬក្រមាពាក់នឹងក ដើម្បីជួយទ្រដៃ",
      correctAnswer: 2,
      category: "Emergency First Aid",
    ),
    EmergencyQuestion(
      id: 5,
      question: "តើអ្នកដឹងថា ជីពចរជនរងគ្រោះ មិនដើរដោយសារអ្វី?",
      answer1: "ក- ដោយសារ ដៃស្ទាបពោះ",
      answer2: "ខ- ដោយសារប្រើអារម្មណ៍ម្រាមដៃ ចុចត្រង់ចំហៀងក",
      answer3: "គ- ដោយសារ ជនរងគ្រោះនិយាយមិនបាន",
      correctAnswer: 1,
      category: "Emergency First Aid",
    ),
  ];
}