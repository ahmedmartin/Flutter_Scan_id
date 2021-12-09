class text_model {
  List<ParsedResults> ?parsedResults;
  int ?oCRExitCode;
  bool ?isErroredOnProcessing;
  String ?processingTimeInMilliseconds;
  String ?searchablePDFURL;

  text_model(
      {
        this.parsedResults,
        this.oCRExitCode,
        this.isErroredOnProcessing,
        this.processingTimeInMilliseconds,
        this.searchablePDFURL});

  text_model.fromJson(Map<String, dynamic> json) {
    if (json['ParsedResults'] != null) {
      parsedResults = [];
      json['ParsedResults'].forEach((v) {
        parsedResults!.add(new ParsedResults.fromJson(v));
      });
    }
    oCRExitCode = json['OCRExitCode'];
    isErroredOnProcessing = json['IsErroredOnProcessing'];
    processingTimeInMilliseconds = json['ProcessingTimeInMilliseconds'];
    searchablePDFURL = json['SearchablePDFURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OCRExitCode'] = this.oCRExitCode;
    data['IsErroredOnProcessing'] = this.isErroredOnProcessing;
    data['ProcessingTimeInMilliseconds'] = this.processingTimeInMilliseconds;
    data['SearchablePDFURL'] = this.searchablePDFURL;
    return data;
  }
}

class ParsedResults {

  String ?textOrientation;
  int ?fileParseExitCode;
  String ?parsedText;
  String ?errorMessage;
  String ?errorDetails;

  ParsedResults(
      {
        this.textOrientation,
        this.fileParseExitCode,
        this.parsedText,
        this.errorMessage,
        this.errorDetails});

  ParsedResults.fromJson(Map<String, dynamic> json) {

    textOrientation = json['TextOrientation'];
    fileParseExitCode = json['FileParseExitCode'];
    parsedText = json['ParsedText'];
    errorMessage = json['ErrorMessage'];
    errorDetails = json['ErrorDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['TextOrientation'] = this.textOrientation;
    data['FileParseExitCode'] = this.fileParseExitCode;
    data['ParsedText'] = this.parsedText;
    data['ErrorMessage'] = this.errorMessage;
    data['ErrorDetails'] = this.errorDetails;
    return data;
  }
}

class TextOverlay {
  List<String> lines;
  bool hasOverlay;
  String message;

  TextOverlay({required this.lines, required this.hasOverlay, required this.message});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HasOverlay'] = this.hasOverlay;
    data['Message'] = this.message;
    return data;
  }
}
