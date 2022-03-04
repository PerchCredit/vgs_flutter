# VGS Flutter

## Usage

```dart
final response = await VGSFlutter.send(
  data: VGSCollectData(
    vaultId: <vault-id>,
    sandbox: true,
    headers: {
      'Authorization': 'Bearer Token',
    },
    extraData: VGSExtraData(
      query: _query,
      variables: {
        'userID': 'USER ID',
        'ssn': '4111111111111111',
      },
    ),
  ),
);
```

