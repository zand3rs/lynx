## **GET Balance**

### `GET` /v1/wallets/:id/balance
#### Headers
|Attribute  | R/O  | Type  | Description |
|---------  | ---  | ----  | ----------- |
| **Content-Type**  | R  |`string` | application/json |
| **Accept**  | R  |`string` | application/json |
| **Authorizaton**  | R  |`string` | Basic base64(client_id:client_secret) |

#### Parameters
|Attribute  | R/O  | Type  | Description |
|---------  | ---  | ----  | ----------- |
| **id**  | R  |`string` | wallet ID |

#### Request
```javascript
GET /v1/wallets/1/balance HTTP/1.1
Host: server.example.com
Content-Type: application/json
Accept: application/json
Authorizaton: Basic a1JpYWxOQTkxTllUYzVqUURvaUNHUEpIU1Z1MTRSU3Y6UzJVT3FWckNzbUU3Mk9Scjh1UjFVV2NJck5UVmxzTnk=
```

#### Response
```javascript
{
  "data": {
     "currentBalance": "10",
     "availableBalance": "10",
     "updatedAt": "2017-01-31T04:16:36.331Z",
   }
}
```

#### Errors
