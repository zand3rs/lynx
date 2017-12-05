## **Release Transaction**

### `POST` /v1/transactions/:id/release
#### Headers
|Attribute  | R/O  | Type  | Description |
|---------  | ---  | ----  | ----------- |
| **Content-Type**  | R  |`string` | application/json |
| **Accept**  | R  |`string` | application/json |
| **Authorizaton**  | R  |`string` | Basic base64(client_id:client_secret) |

#### Path & Query Parameters
|Attribute  | R/O  | Type  | Description |
|---------  | ---  | ----  | ----------- |
| **id**  | R  |`string` | transaction ID |
| **requestId**  | R  |`string` | Transaction reference in uuid v4 format |
| **amount**  | O  |`float` | Value to be committed (can be less than or equal to 'held' amount from debit or credit) |
| **remarks**  | O  |`string` | Additional notes/comments |

#### Request
```javascript
POST /v1/transactions/1/release HTTP/1.1
Host: server.example.com
Content-Type: application/json
Accept: application/json
Authorizaton: Basic a1JpYWxOQTkxTllUYzVqUURvaUNHUEpIU1Z1MTRSU3Y6UzJVT3FWckNzbUU3Mk9Scjh1UjFVV2NJck5UVmxzTnk=

  {
    "requestId": "0a7ec628-f3c6-4d73-a5f5-8367945f4edf",
    "remarks": "n/a"
  }
```

#### Response
1. CREDIT transaction; held amount: 5.00
##### FROM:
```javascript
{  
  "data": {
    "transactionId": "1",  
    "currentBalance": "15.00",
    "availableBalance": "10.00",
    "updatedAt": "2017-12-05T03:34:30.971Z"
  }  
}
```

##### TO
```javascript
{  
  "data": {
    "transactionId": "1",  
    "currentBalance": "10.00",
    "availableBalance": "10.00",
    "updatedAt": "2017-12-05T03:34:30.971Z"
  }  
}
```

2. DEBIT transaction; held amount: 5.00
##### FROM:
```javascript
{  
  "data": {
    "transactionId": "1",  
    "currentBalance": "5.00",
    "availableBalance": "10.00",
    "updatedAt": "2017-12-05T03:34:30.971Z"
  }  
}
```

##### TO:
```javascript
{  
  "data": {
    "transactionId": "1",  
    "currentBalance": "10.00",
    "availableBalance": "10.00",
    "updatedAt": "2017-12-05T03:34:30.971Z"
  }  
}
```

#### Errors

[Home](../README.md) | [API Docs](/wiki/index.md)
