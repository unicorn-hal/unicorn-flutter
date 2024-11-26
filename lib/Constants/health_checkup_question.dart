import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup_answer.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup_question.dart';

class HealthCheckupQuestionData {
  static List<HealthCheckupQuestion> questions = [
    HealthCheckupQuestion(
        number: 1,
        question: '現在、体に違和感がありますか？',
        isMainQuestion: true,
        diseaseType: [
          HealthCheckupDiseaseEnum.goodHealth,
          HealthCheckupDiseaseEnum.highFever,
          HealthCheckupDiseaseEnum.badFeel,
          HealthCheckupDiseaseEnum.painfulChest,
          HealthCheckupDiseaseEnum.painfulStomach,
          HealthCheckupDiseaseEnum.painfulHead,
        ]),
    HealthCheckupQuestion(
      number: 2,
      question: '最近の健康状態について、どのように感じていますか？',
      isMainQuestion: false,
      answers: [
        HealthCheckupAnswer(
          answer: '非常に良い',
          healthPoint: -3,
        ),
        HealthCheckupAnswer(
          answer: '良い',
          healthPoint: -1,
        ),
        HealthCheckupAnswer(
          answer: '普通',
          healthPoint: 0,
        ),
        HealthCheckupAnswer(
          answer: '悪い',
          healthPoint: 1,
        ),
        HealthCheckupAnswer(
          answer: '非常に悪い',
          healthPoint: 3,
        ),
      ],
    ),
    HealthCheckupQuestion(
      number: 3,
      question: '過去24時間で、新たに気になる症状がありましたか？',
      isMainQuestion: false,
      answers: [
        HealthCheckupAnswer(
          answer: 'はい',
          healthPoint: 2,
        ),
        HealthCheckupAnswer(
          answer: 'いいえ',
          healthPoint: 0,
        ),
      ],
    ),
    HealthCheckupQuestion(
        number: 4,
        question: '最近、急激な痛みや息苦しさを感じましたか？',
        isMainQuestion: false,
        answers: [
          HealthCheckupAnswer(
            answer: 'はい',
            healthPoint: 4,
          ),
          HealthCheckupAnswer(
            answer: 'いいえ',
            healthPoint: 0,
          ),
        ]),
    HealthCheckupQuestion(
      number: 5,
      question: '最近の体重の変化はありますか？',
      isMainQuestion: false,
      answers: [
        HealthCheckupAnswer(
          answer: '急増',
          healthPoint: 4,
        ),
        HealthCheckupAnswer(
          answer: '増加',
          healthPoint: 1,
        ),
        HealthCheckupAnswer(
          answer: '変化なし',
          healthPoint: 0,
        ),
        HealthCheckupAnswer(
          answer: '減少',
          healthPoint: 1,
        ),
        HealthCheckupAnswer(
          answer: '激減',
          healthPoint: 4,
        ),
      ],
    ),
    HealthCheckupQuestion(
        number: 6,
        question: '定期的な運動をしていますか？',
        isMainQuestion: false,
        answers: [
          HealthCheckupAnswer(
            answer: '毎日',
            healthPoint: -2,
          ),
          HealthCheckupAnswer(
            answer: '週に数回',
            healthPoint: 0,
          ),
          HealthCheckupAnswer(
            answer: 'たまに',
            healthPoint: 1,
          ),
          HealthCheckupAnswer(
            answer: '運動していない',
            healthPoint: 2,
          ),
        ]),
    HealthCheckupQuestion(
        number: 7,
        question: 'どのような食事を普段しますか？',
        isMainQuestion: false,
        answers: [
          HealthCheckupAnswer(
            answer: '野菜中心の食事',
            healthPoint: -3,
          ),
          HealthCheckupAnswer(
            answer: '魚中心の食事',
            healthPoint: -2,
          ),
          HealthCheckupAnswer(
            answer: '肉中心の食事',
            healthPoint: 0,
          ),
          HealthCheckupAnswer(
            answer: '炭水化物中心の食事',
            healthPoint: 2,
          ),
          HealthCheckupAnswer(
            answer: 'ジャンクフード中心の食事',
            healthPoint: 3,
          ),
        ]),
    HealthCheckupQuestion(
      number: 8,
      question: '最近、ストレスや不安を感じることがありますか？',
      isMainQuestion: false,
      answers: [
        HealthCheckupAnswer(
          answer: '非常に感じる',
          healthPoint: 2,
        ),
        HealthCheckupAnswer(
          answer: '少し感じる',
          healthPoint: 1,
        ),
        HealthCheckupAnswer(
          answer: 'あまり感じない',
          healthPoint: 0,
        ),
        HealthCheckupAnswer(
          answer: '全く感じない',
          healthPoint: -2,
        ),
      ],
    ),
    HealthCheckupQuestion(
        number: 9,
        question: '睡眠の質について、どのように感じていますか？',
        isMainQuestion: false,
        answers: [
          HealthCheckupAnswer(
            answer: '非常に良い',
            healthPoint: -3,
          ),
          HealthCheckupAnswer(
            answer: '良い',
            healthPoint: -1,
          ),
          HealthCheckupAnswer(
            answer: '普通',
            healthPoint: 0,
          ),
          HealthCheckupAnswer(
            answer: 'あまりよくない',
            healthPoint: 1,
          ),
          HealthCheckupAnswer(
            answer: '非常に悪い',
            healthPoint: 3,
          ),
        ]),
    HealthCheckupQuestion(
        number: 10,
        question: '最近、体調に影響を与えるような生活の変化はありましたか？',
        isMainQuestion: false,
        answers: [
          HealthCheckupAnswer(
            answer: 'はい',
            healthPoint: 2,
          ),
          HealthCheckupAnswer(
            answer: 'いいえ',
            healthPoint: 0,
          ),
        ]),
    HealthCheckupQuestion(
        number: 11,
        question: '最近、急激に症状が悪化したと感じたことがありますか？',
        isMainQuestion: false,
        answers: [
          HealthCheckupAnswer(
            answer: 'はい',
            healthPoint: 7,
          ),
          HealthCheckupAnswer(
            answer: 'いいえ',
            healthPoint: 0,
          ),
        ])
  ];
}
