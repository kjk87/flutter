// Token Account Model
class TokenAccount {
  final String pubkey;
  final AccountData account;

  TokenAccount({
    required this.pubkey,
    required this.account,
  });

  factory TokenAccount.fromJson(Map<String, dynamic> json) {
    return TokenAccount(
      pubkey: json['pubkey'] ?? '',
      account: AccountData.fromJson(json['account'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pubkey': pubkey,
      'account': account.toJson(),
    };
  }
}

class AccountData {
  final AccountDataDetails data;
  final bool executable;
  final int lamports;
  final String owner;
  // final int rentEpoch;
  final int space;

  AccountData({
    required this.data,
    required this.executable,
    required this.lamports,
    required this.owner,
    // required this.rentEpoch,
    required this.space,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      data: AccountDataDetails.fromJson(json['data'] ?? {}),
      executable: json['executable'] ?? false,
      lamports: json['lamports'] ?? 0,
      owner: json['owner'] ?? '',
      // rentEpoch: json['rentEpoch'] ?? 0,
      space: json['space'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'executable': executable,
      'lamports': lamports,
      'owner': owner,
      // 'rentEpoch': rentEpoch,
      'space': space,
    };
  }
}

class AccountDataDetails {
  final ParsedData parsed;
  final String program;
  final int space;

  AccountDataDetails({
    required this.parsed,
    required this.program,
    required this.space,
  });

  factory AccountDataDetails.fromJson(Map<String, dynamic> json) {
    return AccountDataDetails(
      parsed: ParsedData.fromJson(json['parsed'] ?? {}),
      program: json['program'] ?? '',
      space: json['space'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parsed': parsed.toJson(),
      'program': program,
      'space': space,
    };
  }
}

class ParsedData {
  final String type;
  final TokenInfo info;

  ParsedData({
    required this.type,
    required this.info,
  });

  factory ParsedData.fromJson(Map<String, dynamic> json) {
    return ParsedData(
      type: json['type'] ?? '',
      info: TokenInfo.fromJson(json['info'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'info': info.toJson(),
    };
  }
}

class TokenInfo {
  final List<Extension> extensions;
  final bool isNative;
  final String mint;
  final String owner;
  final String state;
  final TokenAmount tokenAmount;

  TokenInfo({
    required this.extensions,
    required this.isNative,
    required this.mint,
    required this.owner,
    required this.state,
    required this.tokenAmount,
  });

  factory TokenInfo.fromJson(Map<String, dynamic> json) {
    return TokenInfo(
      extensions: (json['extensions'] as List?)
          ?.map((e) => Extension.fromJson(e))
          .toList() ?? [],
      isNative: json['isNative'] ?? false,
      mint: json['mint'] ?? '',
      owner: json['owner'] ?? '',
      state: json['state'] ?? '',
      tokenAmount: TokenAmount.fromJson(json['tokenAmount'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'extensions': extensions.map((e) => e.toJson()).toList(),
      'isNative': isNative,
      'mint': mint,
      'owner': owner,
      'state': state,
      'tokenAmount': tokenAmount.toJson(),
    };
  }
}

class Extension {
  final String extension;

  Extension({
    required this.extension,
  });

  factory Extension.fromJson(Map<String, dynamic> json) {
    return Extension(
      extension: json['extension'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'extension': extension,
    };
  }
}

class TokenAmount {
  final String amount;
  final int decimals;
  final double uiAmount;
  final String uiAmountString;

  TokenAmount({
    required this.amount,
    required this.decimals,
    required this.uiAmount,
    required this.uiAmountString,
  });

  factory TokenAmount.fromJson(Map<String, dynamic> json) {
    return TokenAmount(
      amount: json['amount'] ?? '0',
      decimals: json['decimals'] ?? 0,
      uiAmount: json['uiAmount']?.toDouble() ?? 0.0,
      uiAmountString: json['uiAmountString'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'decimals': decimals,
      'uiAmount': uiAmount,
      'uiAmountString': uiAmountString,
    };
  }
}