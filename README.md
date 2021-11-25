## iris-api-security-mediator
This is a ObjectScript Application to enforce authorization rules using XDATA into API methods.
Can be developed with Docker and VSCode,
can be deployed as ZPM module.

## Installation for development

Clone/git pull the repo into any local directory e.g. like it is shown below (here I show all the examples related to this repository, but I assume you have your own derived from the template):

```
$ git clone git@github.com:yurimarx/iris-api-security-mediator.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d --build
```

## Installation with ZPM

zpm:USER>install iris-api-security-mediator

## How it Works

1. Clone the project 
```
$ git clone git@github.com:yurimarx/iris-api-security-mediator.git
```

2. Build and up the project source code
```
$ docker-compose up -d --build
```

3. Open the class src\dc\Sample\PersonREST and go to GetAllPersons ClassMethod (line 41). You will see this:
```
/// Retreive all the records of dc.Sample.Person
/// @security.and: roles: { PersonAdmin }  
ClassMethod GetAllPersons() As %Status
{
 
    #dim tSC As %Status = $$$OK
    ....
}
```

4. Above the ClassMethod you see: 
```
@security.and: roles: { PersonAdmin }
```

5. When you set @security.and, you enforce the API calls to this method to authenticate to any user
6. When you set roles: { YOURROLENAME }, you enforce the API calls to this method to the user have the role between {}
7. So, in this example, the user needs the role PersonAdmin
8. First all, test without the role, call http://localhost:52773/crud/persons/all (use _SYSTEM user or another user to authenticate)
9. You will get the following message error:
```
{
    "verb": "GET",
    "url": "/persons/all",
    "application": "/crud/",
    "method": "GetAllPersons",
    "error": "_SYSTEM is not authorized for this request. User Roles Allowed is not in User Roles"
}
```
10. Now Go to Management Portal -> System Administration -> Security -> Roles
11. Press button Create New Role. In the Name set PersonAdmin and press Save button
12. Go to Members tab and select _SYSTEM (or the user that you want to login) and Assign to the PersonAdmin
13. Now call http://localhost:52773/crud/persons/all again
14. Now you be able to call with success! You get []
15. If you want to test with data, populate the database using http://localhost:52773/crud/persons/populate
16. Call http://localhost:52773/crud/persons/all again and you get JSON results!
17. Enjoy!


# Future features

1. Rule to enforce to header request values
2. Rule to enforce to request param and attributes values
3. Rule to enforce to date/time values
4. Rule to enforce to IP values
5. Rule to enforce to regex expressions
6. Rule to enforce to custom method evalution

# Thanks to:

1. Robert Cemper: beta tester
2. Evgeny Shvarov: iris-rest-api-template was the base to this app



