## 0.0.1
> Release date: 07/Oct/2021
- First version

## 0.0.2-beta1
> Release date: 08/Oct/2021
- Adds checkInternetError function
- Adds more HttpExceptions
- Updates docs

## 0.0.2-beta2
> Release date: 11/Oct/2021
- Updates `utf8Decode` default value to `false`

## 0.0.2
> Release date: 20/Oct/2021
- Adds `queries` argument

## 0.0.3-beta1
> Release date: 26/Oct/2021
- Adds ExpiredToken exception
- Adds validation for JWT
- Improves Auth class usage

## 0.0.3-beta2
> Release date: 28/Oct/2021
- Fixes format of authorization header value
- Adds Unauthorized exception
- Updates HttpCallExceptions implementations:
  - Adds ClientErrorException
  - Adds ServerErrorException
  - Adds ConnectionErrorException
- Refactor checkInternetConnection:
  - Renames to throwConnectionException
  - Updates to throw a ConnectionErrorException instead of returning HttpException type
