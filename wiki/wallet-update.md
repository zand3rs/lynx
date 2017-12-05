## **Get Wallet**

### `PATCH` /v1/wallets/:id
#### Headers
|Attribute  | R/O  | Type  | Description |
|---------  | ---  | ----  | ----------- |
| **Content-Type**  | R  |`string` | application/json |
| **Accept**  | R  |`string` | application/json |
| **Authorizaton**  | R  |`string` | Basic base64(client_id:client_secret) |

#### Path & Query Parameters
|Attribute  | R/O  | Type  | Description |
|---------  | ---  | ----  | ----------- |
| **name**  | O  |`string` | Custom name for the wallet |
| **description**  | O  |`string` | Description / purpose of wallet |
| **label**  | O  |`string` | Custom wallet label |

#### Request
```javascript
PATCH /v1/wallets/1 HTTP/1.1
Host: server.example.com
Content-Type: application/json
Accept: application/json
Authorizaton: Basic a1JpYWxOQTkxTllUYzVqUURvaUNHUEpIU1Z1MTRSU3Y6UzJVT3FWckNzbUU3Mk9Scjh1UjFVV2NJck5UVmxzTnk=

  {
    "name": "Lynx Test Wallet"
  }
```

#### Response
```javascript
{
  "data": {
     "id": 1,
     "name": "Lynx Test Wallet",
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
