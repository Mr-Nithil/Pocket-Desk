enum IssueStatus {
  open,
  inProgress,
  resolved,
  closed;

  String get uiName {
    if (this == IssueStatus.inProgress) return 'In Progress';
    return name[0].toUpperCase() + name.substring(1);
  }
}
