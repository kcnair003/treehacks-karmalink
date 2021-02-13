class ReactionModel {
  /// The post that the reaction is associated with.
  final String postID;
  /// 'love', 'support', 'hug', or 'laugh'.
  final String name;
  /// How many there are of this reaction.
  final int amount;
  /// The width of the reaction bar in the UI based on the ratio of this reaction.
  final double width;

  ReactionModel({
    this.postID,
    this.name,
    this.amount,
    this.width,
  });
}