find errors in the code

# 1 - in google auth

When click in button "Entrar"
Then get error "Error signing in with Google: UnimplementedError: authenticate is not supported on the web. Instead, use renderButton to create a sign-in widget.
"
Where `horta-platform/lib/app/core/auth/auth_service.dart` line 34

# 2 - Scroll in About page

When click in "Contribuir" or "Privicidade"
Then the About Screen not scroll
Where `horta-platform/lib/app/modules/about/presenter/about_page.dart`

# 3 - Survey Detail Screen

When click in a survey card
Then i had the answer from api
```
[ApiService] Error: This exception was thrown because the response has a status code of 404 and RequestOptions.validateStatus was configured to throw for this status code.
The status code of 404 has the following meaning: "Client error - the request contains bad syntax or cannot be fulfilled"
Read more about status codes at https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
In order to resolve this exception you typically have either to verify and fix your request code or you have to fix the server code.
```
Where `horta-platform/lib/app/core/network/api_service.dart` line 52

# 4 - Validate if other apis is created

When I click in other tabs inside the survey detail screen
Then the api is not called
Where `horta-platform/lib/app/core/network/api_service.dart` line 57-80

