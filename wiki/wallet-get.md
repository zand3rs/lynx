## **GET Wallet Details**

### `GET` /v1/wallets/:id
#### Headers
|Attribute  | R/O  | Type  | Description |
|---------  | ---  | ----  | ----------- |
| **Content-Type**  | R  |`string` | application/json |
| **Accept**  | R  |`string` | application/json |
| **Authorizaton**  | R  |`string` | Basic base64(client_id:client_secret) |

#### Path Parameters
|Attribute  | R/O  | Type  | Description |
|---------  | ---  | ----  | ----------- |
| **id**  | R  |`string` | wallet ID |

#### Request
```javascript
GET /v1/wallets/:id HTTP/1.1
Host: server.example.com
Content-Type: application/json
Accept: application/json
Authorizaton: Basic a1JpYWxOQTkxTllUYzVqUURvaUNHUEpIU1Z1MTRSU3Y6UzJVT3FWckNzbUU3Mk9Scjh1UjFVV2NJck5UVmxzTnk=
```

#### Response
```javascript
{
  "data": {
     "id": 1,
     "name": "Test Wallet",
     "description": "This wallet is for testing",
     "label": "PHP",
     "currentBalance": "0.00",
     "availableBalance": "0.00",
     "createdAt": "2017-12-05T04:16:36.331Z",
     "updatedAt": "2017-12-05T04:16:36.331Z",
   }
}
```

#### Errors

[Home](../README.md) | [API Docs](/wiki/index.md)
