## **Credit Transaction**

### `POST` /v1/wallets/:id/credit
#### Headers
|Attribute  | R/O  | Type  | Description |
|---------  | ---  | ----  | ----------- |
| **Content-Type**  | R  |`string` | application/json |
| **Accept**  | R  |`string` | application/json |
| **Authorizaton**  | R  |`string` | Basic base64(client_id:client_secret) |

#### Path & Query Parameters
|Attribute  | R/O  | Type  | Description |
|---------  | ---  | ----  | ----------- |
| **id**  | R  |`string` | wallet ID |
| **requestId**  | R  |`string` | Transaction reference in uuid v4 format |
| **amount**  | R  |`float` | Value to be credited |
| **hold**  | O  |`string` | Boolean (true or false), defaults to false |
| **remarks**  | O  |`string` | Additional notes/comments |

#### Request
```javascript
POST /v1/wallets/1/credit HTTP/1.1
Host: server.example.com
Content-Type: application/json
Accept: application/json
Authorizaton: Basic a1JpYWxOQTkxTllUYzVqUURvaUNHUEpIU1Z1MTRSU3Y6UzJVT3FWckNzbUU3Mk9Scjh1UjFVV2NJck5UVmxzTnk=

  {
    "requestId": "0a7ec628-f3c6-4d73-a5f5-8367945f4edf"
    "amount": 10,
    "hold": false,
    "remarks": "n/a"
  }
```

#### Response
1. hold = FALSE, initial balance = 0.00

```javascript
{  
  "data": {  
    "requestId": "0a7ec628-f3c6-4d73-a5f5-8367945f4edf", (given requestId)
    "transactionId": "1",  
    "currentBalance": "10.00",
    "availableBalance": "10.00",
    "updatedAt": "2017-12-05T03:34:30.971Z"
  }  
}
```

2. hold = TRUE, initial balance = 0.00
```javascript
{  
  "data": {  
    "requestId": "0a7ec628-f3c6-4d73-a5f5-8367945f4edf", (given requestId)
    "transactionId": "1",  
    "currentBalance": "10.00",
    "availableBalance": "0.00",
    "updatedAt": "2017-12-05T03:34:30.971Z"
  }  
}
```

#### Errors
 - [AuthorizationError](wiki/errors.md)
 - [RecordNotFound](wiki/errors.md)
 - [SystemError](wiki/errors.md)
 - [UnknownError](wiki/errors.md)
 - [ServerError](wiki/errors.md)
