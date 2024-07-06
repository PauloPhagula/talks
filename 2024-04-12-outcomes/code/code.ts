// v1
let email = "paulo.phagula@factorial.co"
let domain = domainFromEmailAddress(email);
let tld = tldFromDomain(domain);
let emailHasGoodTLD = isGoodTLD(tld);

// v2
try {
  let email = "paulo.phagula@gmail.com"
  let domain = domainFromEmailAddress(email);
  let tld = tldFromDomain(domain);
  let emailHasGoodTLD = isGoodTLD(tld);
} catch { }

// v3 - Promises
let emailHasGootTld = new Promise((resolve, reject) => {
  resolve('paulo.phagula@factorial.co')
})
  .then(domainFromEmailAddress)
  .then(tldFromDomain)
  .then(isGoodTld);

emailHasGoodTld.catch(/* ...*/)

// v3 - Maybe
Optional.from("email@example.com")
  .then(domainFromEmailAddress)
  .then(tldFromDomain)
  .map(isGoodTld);

const Nothing = Symbol('Nothing')

class Optional<T> {
  constructor(private value: T | typeof Nothing) { }

  static from<T>(value: T): Optional<T> {
    return new Optional<T>(value);
  }

  static nothing<T>(): Optional<T> { return new Optional<T>(Nothing) }

  map<U>(f: (value: T) => U): Optional<U> {
    if (this.value === Nothing)
      return Optional.nothing<U>()
    return Optional.from<U>(f(this.value))
  }

  bind<U>(f: (value: T) => Optional<U>): Optional<U> {
    if (this.value === Nothing) return Optional.nothing<U>()
    return f(this.value)
  }
}

// v4 - Result
// Optional<T> is either a value, or nothing. But we should also be able to
// specify an error.
const ValueSym = Symbol('ValueSym')
interface ValueType<T> { kind: typeof ValueSym; value: T }
const ErrorSym = Symbol('ErrorSym')
interface ErrorType<TErr> { kind: typeof ErrorSym; error: TErr }

class Result<T, TErr> {
  constructor(private value: ValueType<T> | ErrorType<TErr>) { }

  static from<T, TErr>(value: T): Result<T, TErr> {
    return new Result<T, TErr>({ kind: ValueSym, value: value })
  }

  static fromError<T, TErr>(error: TErr): Result<T, TErr> {
    return new Result<T, TErr>({ kind: ErrorSym, error: error })
  }

  map<U>(f: (value: T) => U): Result<U, TErr> {
    if (this.value.kind === ErrorSym) return Result.fromError<U, TErr>(this.value.error)
    return Result.from<U, TErr>(f(this.value.value))
  }

  bind<U>(f: (value: T) => Result<U, TErr>): Result<U, TErr> {
    if (this.value.kind === ErrorSym) return Result.fromError<U, TErr>(this.value.error)
    return f(this.value.value)
  }
}

Result.from<String, ErrorType>("email@example.com")
  .bind(domainFromEmailAddress)
  .bind(tldFromDomain)
  .map(isGoodTld);
