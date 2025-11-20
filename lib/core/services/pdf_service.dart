import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:asd/features/questionnaire/domain/entities/assessment_result.dart';

class PdfService {
  static Future<pw.Document> generateQuestionnaireReport(
    AssessmentResult result,
  ) async {
    final pdf = pw.Document();

    final regularFont = await PdfGoogleFonts.notoSansThaiRegular();
    final boldFont = await PdfGoogleFonts.notoSansThaiBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'ASD Screening Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  font: boldFont,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                'Assessment Date: ${_formatDate(result.completedAt)}',
                style: pw.TextStyle(font: regularFont, fontSize: 12),
              ),
              pw.Text(
                'Questionnaire: ${result.questionnaireTitle ?? 'Q-CHAT-10'}',
                style: pw.TextStyle(font: regularFont, fontSize: 12),
              ),
              pw.SizedBox(height: 24),
              _buildRiskAssessment(result, regularFont, boldFont),
              pw.SizedBox(height: 24),
              _buildScoreSummary(result, regularFont, boldFont),
              pw.SizedBox(height: 24),
              _buildRecommendations(result, regularFont, boldFont),
              pw.SizedBox(height: 24),
              _buildDisclaimer(regularFont),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildRiskAssessment(
    AssessmentResult result,
    pw.Font regular,
    pw.Font bold,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: _riskColor(result.riskLevel),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Risk Assessment',
            style: pw.TextStyle(
              color: PdfColors.white,
              font: bold,
              fontSize: 16,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            _riskLabel(result.riskLevel),
            style: pw.TextStyle(
              color: PdfColors.white,
              font: bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildScoreSummary(
    AssessmentResult result,
    pw.Font regular,
    pw.Font bold,
  ) {
    // Calculate max possible score (totalQuestions * 2 for Q-CHAT)
    final maxScore = result.totalQuestions * 2;
    final percentage = ((result.score / maxScore) * 100).round();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Score Summary', style: pw.TextStyle(font: bold, fontSize: 16)),
        pw.SizedBox(height: 8),
        pw.Text(
          'Total Score: ${result.score}/$maxScore ($percentage%)',
          style: pw.TextStyle(font: regular, fontSize: 12),
        ),
        pw.Text(
          'Risk thresholds: Low (0-6), Medium (7-13), High (14+)',
          style: pw.TextStyle(
            font: regular,
            fontSize: 10,
            color: PdfColors.grey700,
          ),
        ),
        if (result.flaggedBehaviors.isNotEmpty) ...[
          pw.SizedBox(height: 12),
          pw.Text(
            'Flagged Behaviors:',
            style: pw.TextStyle(font: bold, fontSize: 14),
          ),
          ...result.flaggedBehaviors.map(
            (behavior) => pw.Padding(
              padding: const pw.EdgeInsets.only(top: 4),
              child: pw.Text(
                '• $behavior',
                style: pw.TextStyle(font: regular, fontSize: 12),
              ),
            ),
          ),
        ],
      ],
    );
  }

  static pw.Widget _buildRecommendations(
    AssessmentResult result,
    pw.Font regular,
    pw.Font bold,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Recommendations',
          style: pw.TextStyle(font: bold, fontSize: 16),
        ),
        pw.SizedBox(height: 8),
        ...result.recommendations.entries.map(
          (entry) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  entry.key,
                  style: pw.TextStyle(font: bold, fontSize: 14),
                ),
                pw.SizedBox(height: 4),
                // Check if value is a list (nextSteps)
                if (entry.value is List)
                  ...((entry.value as List).map(
                    (item) => pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 8, top: 2),
                      child: pw.Text(
                        '• ${item.toString()}',
                        style: pw.TextStyle(font: regular, fontSize: 12),
                      ),
                    ),
                  ))
                else
                  pw.Text(
                    entry.value.toString(),
                    style: pw.TextStyle(font: regular, fontSize: 12),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildDisclaimer(pw.Font regular) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Disclaimer',
            style: pw.TextStyle(
              font: regular,
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'This screening tool is designed for preliminary assessment only and '
            'is not a substitute for professional medical diagnosis. '
            'Please consult with a qualified healthcare professional for a '
            'comprehensive evaluation and diagnosis.',
            style: pw.TextStyle(font: regular, fontSize: 10),
          ),
        ],
      ),
    );
  }

  static PdfColor _riskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return PdfColors.green;
      case RiskLevel.medium:
        return PdfColors.orange;
      case RiskLevel.high:
        return PdfColors.red;
    }
  }

  static String _riskLabel(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return 'Low Risk';
      case RiskLevel.medium:
        return 'Medium Risk';
      case RiskLevel.high:
        return 'High Risk';
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
