/// A sealed class representing the result of an operation in the Smile ID SDK.
/// This class is intended to be extended by specific result types
/// such as [SmileIDSdkResultSuccess] and [SmileIDSdkResultError].
sealed class SmileIDSdkResult<T extends Object> {
  const SmileIDSdkResult();
}

final class SmileIDSdkResultSuccess<T extends Object> extends SmileIDSdkResult<T> {
  final T data;

  const SmileIDSdkResultSuccess(this.data);
}

final class SmileIDSdkResultError<T extends Object> extends SmileIDSdkResult<T> {
  final String error;

  const SmileIDSdkResultError(this.error);
}
