import 'package:aws_quiz_app/models/tag.dart';
import 'package:aws_quiz_app/models/term.dart';

class Scoring {
  final String examId;
  final String date;
  double avg_scoring;
  double avg_retention;
  double avg_mastery;
  List<DailyScoring> dailyScorings;
  List<ScoringCount> scoringCounts;
  List<RetentionCount> retentionCounts;
  List<RetentionCount> masteryCounts;
  DueForecast dueForecast;
  Quadrants quadrants;

  Scoring(this.examId, this.date, this.avg_scoring, this.dailyScorings);
  Scoring.fromMap(Map<String, dynamic> data)
      : examId = data["exam_id"],
        date = data["date"],
        avg_scoring = data["avg_scoring"],
        avg_retention = data["avg_retention"],
        avg_mastery =
            data["avg_mastery"] != null ? data["avg_mastery"].toDouble() : 0.0,
        // dailyScorings = DailyScoring.fromData(data["daily_scorings"]),
        scoringCounts = ScoringCount.fromData(data["scoring_counts"]),
        retentionCounts = RetentionCount.fromData(data["retention_counts"]),
        masteryCounts = data["mastery_counts"] != null
            ? RetentionCount.fromData(data["mastery_counts"])
            : null,
        dueForecast = data["due_forecast"] != null
            ? DueForecast.fromMap(data["due_forecast"])
            : null,
        quadrants =
            data["quadrants"] != null ? Quadrants.fromMap(data["quadrants"]) : null;
}

/// 復習負荷予測（今後N日で halving_date が到来する問題数）。
class DueForecast {
  final int overdue;
  final List<DueForecastDay> days;
  DueForecast(this.overdue, this.days);
  DueForecast.fromMap(Map<String, dynamic> data)
      : overdue = data["overdue"],
        days = data["days"]
            .map<DueForecastDay>(
                (item) => DueForecastDay(item["date"], item["count"]))
            .toList();
}

class DueForecastDay {
  final String date;
  final int count;
  DueForecastDay(this.date, this.count);
}

/// difficulty × retrievability の4象限（復習優先度）。
class Quadrants {
  final int danger; // 難しい×忘れかけ → 最優先
  final int effort; // 易しい×忘れかけ → 軽く復習
  final int fragile; // 難しい×維持中 → 油断注意
  final int stable; // 易しい×維持中 → 放置可
  final int unlearned; // 未学習
  Quadrants(this.danger, this.effort, this.fragile, this.stable, this.unlearned);
  Quadrants.fromMap(Map<String, dynamic> data)
      : danger = data["danger"],
        effort = data["effort"],
        fragile = data["fragile"],
        stable = data["stable"],
        unlearned = data["unlearned"];
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
