import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedMessages() async {
  final firestore = FirebaseFirestore.instance;

  final messages = <Map<String, dynamic>>[
    {
      'id': 'msg_001',
      'textEn':
          'Sometimes we wish for a palace, while a small house is enough. Sometimes we wish for a certain person, while our family and friends are enough. Thank God in every situation.',
      'textAr':
          'أحيانًا نتمنى قصرًا، بينما يكفينا بيت صغير. وأحيانًا نتمنى شخصًا معينًا، بينما أهلنا وأصدقاؤنا يكفوننا. الحمد لله في كل حال.',
      'type': 'message',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_002',
      'textEn':
          'Disagreements are sometimes necessary to discover what others hide in their hearts.',
      'textAr':
          'أحيانًا تكون الخلافات ضرورية لنعرف ما يخفيه الآخرون في قلوبهم.',
      'type': 'quote',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_003',
      'textEn':
          'Do not improve your image for anyone. Be yourself, and let the right people appreciate you as you are.',
      'textAr':
          'لا تحسّن صورتك من أجل أحد. كن كما أنت، ودع الأشخاص المناسبين يقدّرونك كما أنت.',
      'type': 'message',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_004',
      'textEn':
          'Little do you give thanks. Be grateful for what you have, because many blessings are often overlooked.',
      'textAr':
          'قليلًا ما تشكرون. كن ممتنًا لما لديك، فكثير من النعم نغفل عنها.',
      'type': 'ayat',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_005',
      'textEn':
          'And whoever is mindful of Allah, He will make a way out for them and provide for them from where they do not expect.',
      'textAr':
          'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا ۝ وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ.',
      'type': 'ayat',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_006',
      'textEn':
          'God will not forget your step towards consoling someone, your kindness to someone, or your attempt to make someone happy.',
      'textAr':
          'لن ينسى الله خطوتك التي مشيتها لجبر خاطر أحد، ولا طيبتك مع أحد، ولا محاولتك لإسعاد شخص.',
      'type': 'message',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_007',
      'textEn':
          'O Allah, ward off from our homes sadness, worry, and harm, and fill them with peace, mercy, and blessings.',
      'textAr':
          'اللهم اصرف عن بيوتنا الحزن والهم والضرر، واملأها سكينة ورحمة وبركة.',
      'type': 'message',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_008',
      'textEn':
          'Honesty and frankness may sometimes hurt, but they are better than beautiful words that hide the truth.',
      'textAr':
          'الصراحة والصدق قد يؤلمان أحيانًا، لكنهما أفضل من كلمات جميلة تخفي الحقيقة.',
      'type': 'quote',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_009',
      'textEn':
          'What is meant for you will reach you, even if it takes time. Trust Allah’s plan.',
      'textAr': 'ما كُتب لك سيأتيك ولو طال الوقت، فثق بتدبير الله.',
      'type': 'quote',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_010',
      'textEn':
          'Do not justify your actions to those who have already decided to misunderstand you.',
      'textAr': 'لا تبرر أفعالك لمن قرر مسبقًا أن يسيء فهمك.',
      'type': 'quote',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_011',
      'textEn':
          'Whoever conceals his worries and remains patient, Allah knows what is hidden in his heart.',
      'textAr': 'من كتم همومه وصبر، فإن الله يعلم ما يخفيه قلبه.',
      'type': 'message',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_012',
      'textEn':
          'Be great in your own eyes. You do not need everyone’s approval to know your worth.',
      'textAr':
          'كن عظيمًا في عين نفسك، فأنت لا تحتاج إلى موافقة الجميع لتعرف قيمتك.',
      'type': 'message',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_013',
      'textEn':
          'Family, friends, food, and a roof over your head are blessings worth being grateful for.',
      'textAr':
          'العائلة والأصدقاء والطعام وسقف فوق رأسك، كلها نعم تستحق أن تحمد الله عليها.',
      'type': 'quote',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_014',
      'textEn':
          'Train yourself to work without waiting for encouragement, praise, or recognition from others.',
      'textAr':
          'درّب نفسك على العمل دون انتظار التشجيع أو المدح أو التقدير من الآخرين.',
      'type': 'message',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_015',
      'textEn':
          'Do good and let it fall where it may. Goodness never goes to waste.',
      'textAr': 'افعل الخير ودعه يقع حيث يقع، فالخير لا يضيع أبدًا.',
      'type': 'quote',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_016',
      'textEn':
          'The world is temporary, and its pleasures are short-lived. Do not let it distract you from what truly matters.',
      'textAr':
          'إن الدنيا فانية ومتاعها قصير، فلا تجعلها تشغلك عما هو أهم وأبقى.',
      'type': 'quote',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_017',
      'textEn':
          'Some people are granted acceptance even when they remain silent. Their presence alone brings comfort.',
      'textAr':
          'بعض الناس يمنحهم الله القبول حتى في صمتهم، فوجودهم وحده يبعث الراحة.',
      'type': 'message',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_018',
      'textEn':
          'The one who does a good deed does not fall. Goodness always leaves an أثر.',
      'textAr': 'من يفعل الخير لا يسقط، فالخير يترك أثرًا دائمًا.',
      'type': 'message',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },

    {
      'id': 'msg_019',
      'textEn':
          'Maryam, daughter of Imran, was chosen and honored by Allah. Her story reminds us that patience, faith, and trust in Allah can carry us through the most difficult moments.',
      'textAr':
          'مريم ابنة عمران اصطفاها الله وكرّمها، وقصتها تذكرنا بأن الصبر والإيمان والتوكل على الله يمكن أن يحملنا خلال أصعب اللحظات.',
      'type': 'message',
      'createdBy': 'system',
      'isPublic': true,
      'isApproved': true,
    },
  ];

  final batch = firestore.batch();

  for (final message in messages) {
    final messageId = message['id'] as String;

    final document = firestore.collection('messages').doc(messageId);

    batch.set(document, message);
  }

  await batch.commit();

  print('Successfully added/updated ${messages.length} messages.');
}
