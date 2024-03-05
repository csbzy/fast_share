import "package:logger/logger.dart";

final Logger logger = Logger(
  level: Level.debug,
  filter: null, // Use the default LogFilter (-> only log in debug mode)
  printer: PrettyPrinter(methodCount: 3), // Use the PrettyPrinter to format and print log
  output: null, // Use the default LogOutput (-> send everything to console)
);
