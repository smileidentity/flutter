/// A sealed class representing the result of an operation in the Smile ID SDK.
/// This class is intended to be extended by specific result types
/// such as [SmileIdSdkResultSuccess] and [SmileIdSdkResultError].
sealed class SmileIDSdkResult<T extends Object> {
  const SmileIDSdkResult();
}

final class SmileIdSdkResultSuccess<T extends Object> extends SmileIDSdkResult<T> {
  final T data;

  const SmileIdSdkResultSuccess(this.data);
}

final class SmileIdSdkResultError<T extends Object> extends SmileIDSdkResult<T> {
  final String error;

  const SmileIdSdkResultError(this.error);
}
