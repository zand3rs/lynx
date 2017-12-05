## **Errors / Exceptions**

### Summary
|Module  |  Exception  | Error Message  |
|---------  | -----  | -----------  |
| Generic Error | UnknownError  | Unknown Error |

### Response Structure
```javascript
{
  "error": {
    "code": `Code`,
    "type": `Error/Exception Type`,
    "message": `Message`
  }
}
```

### Example Response
```javascript
{
  "error": {
    "type": "RecordNotFound",
    "message": "User not found"
  }
}
```
