import 'package:aws_quiz_app/models/tag.dart';
import 'package:aws_quiz_app/models/term.dart';

class Scoring {
  final String examId;
  final String date;
  double avg_scoring;
  double avg_retention;
  List<DailyScoring> dailyScorings;
  List<ScoringCount> scoringCounts;
  List<RetentionCount> retentionCounts;

  Scoring(this.examId, this.date, this.avg_scoring, this.dailyScorings);
  Scoring.fromMap(Map<String, dynamic> data)
      : examId = data["exam_id"],
        date = data["date"],
        avg_scoring = data["avg_scoring"],
        avg_retention = data["avg_retention"],
        // dailyScorings = DailyScoring.fromData(data["daily_scorings"]),
        scoringCounts = ScoringCount.fromData(data["scoring_counts"]),
        retentionCounts = RetentionCount.fromData(data["retention_counts"]);
}

class DailyScoring {
  final String answerDate;
  final double average;
  DailyScoring(this.answerDate, this.average);
  static List<DailyScoring> fromData(List<dynamic> data) {
    return data
        .map((item) =>
            DailyScoring(item["answer_date"], item["avg_scoring"].toDouble()))
        .toList();
  }
}

class ScoringCount {
  final int scoring;
  int count;
  ScoringCount(this.scoring, this.count);
  static List<ScoringCount> fromData(List<dynamic> data) {
    return data
        .map((item) => ScoringCount(item["scoring"], item["count"]))
        .toList();
  }
}

class RetentionCount {
  final String label;
  int count;
  RetentionCount(this.label, this.count);
  static List<RetentionCount> fromData(List<dynamic> data) {
    return data
        .map((item) => RetentionCount(item["label"], item["count"]))
        .toList();
  }
}

class ScoringTableItem {
  final String label;
  double indent = 0.0;
  int sort;
  final int questionCount;
  double correctAnswerRate;
  double completionRate;
  double avgRetention;
  Tag tag;
  Term term;

  ScoringTableItem.fromReport(Map<String, dynamic> data)
      : tag = Tag.fromMap(data),
        label = data['tag_name'],
        sort = data['sort'],
        questionCount = data['question_count'],
        correctAnswerRate = data['execute_count'] == 0
            ? 0.0
            : (data['correct_count'] > data['execute_count'])
                ? 1.0
                : data['correct_count'] / data['execute_count'],
        completionRate = (data['complete_count'] > data['total_count'])
            ? 1.0
            : data['complete_count'] / data['total_count'],
        avgRetention = data['tag_avg_retention'].toDouble();

  ScoringTableItem.fromTagReport(Map<String, dynamic> data)
      : label = data['word'],
        indent = 5.0 * (data['level'] - 1),
        sort = data['sort'],
        questionCount = data['question_count'],
        correctAnswerRate = data['correct_answer_rate'].toDouble(),
        avgRetention = data['avg_retention'].toDouble(),
        term = Term.fromMap(data);

  ScoringTableItem.fromData(Map<String, dynamic> data)
      : label = data['tag_name'],
        sort = data['sort'],
        questionCount = data['question_count'],
        correctAnswerRate = data['correct_answer_rate'].toDouble(),
        avgRetention = data['avg_retention'].toDouble(),
        tag = Tag.fromMap(data);

  static List<ScoringTableItem> fromDataList(List<Map<String, dynamic>> data) {
    return data.map((item) => ScoringTableItem.fromData(item)).toList();
  }

  String toRatePercentage(double rate) {
    int percatege = (rate * 100.0).round();
    return percatege.toString() + "%";
  }
}
