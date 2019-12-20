---
title: ElastiCache のノードタイプを変更する際の注意点
date: 2019-12-20T10:00:00+09:00
tags: ["aws"]
draft: false 
---

注意: この記事は `aws elasticache list-allowed-node-type-modifications` を知っていれば(ほぼ)読む必要はありません。  

### 背景
今見ているサービスで RI の購入タイミングになったので、m4.4xlarge のものを m5.4xlarge に変更しようという話になりました。  
しかし、実際にオペレーションをしたところ変更ができなかったのでスケール時に確認しておくべきことなどを自分用にメモとして残しておきます。  
(いやその変更は直接は無理でしょ！と一瞬で分かった方には不要な記事です)

### 原因・事前にやっておくべきこと
結論から述べると、[ドキュメント](https://docs.aws.amazon.com/ja_jp/AmazonElastiCache/latest/red-ug/Scaling.RedisReplGrps.ScaleUp.html)に記載してある通り、スケールアップ先として選択可能なノードとそうでないノードが存在します。  
AWS CLI であれば `aws elasticache list-allowed-node-type-modifications` を使うのが良いです。

```sh

$ aws elasticache list-allowed-node-type-modifications --replication-group-id xxxxx
{
    "ScaleUpModifications": [
        "cache.m4.10xlarge",
        "cache.m5.12xlarge",
        "cache.m5.24xlarge",
        "cache.r3.4xlarge",
        "cache.r3.8xlarge",
        "cache.r4.16xlarge",
        "cache.r4.4xlarge",
        "cache.r4.8xlarge",
        "cache.r5.12xlarge",
        "cache.r5.24xlarge",
        "cache.r5.4xlarge"
    ],
    "ScaleDownModifications": [
        "cache.m3.2xlarge",
        "cache.m3.large",
        "cache.m3.medium",
        "cache.m3.xlarge",
        "cache.m4.2xlarge",
        "cache.m4.large",
        "cache.m4.xlarge",
        "cache.r3.2xlarge",
        "cache.r3.large",
        "cache.r3.xlarge",
        "cache.r4.large",
        "cache.r4.xlarge",
        "cache.t2.medium",
        "cache.t2.micro",
        "cache.t2.small",
        "cache.t3.medium",
        "cache.t3.micro",
        "cache.t3.small"
    ]
}
```

### なぜ変更できないのか
ドキュメントには詳細な仕様は明記されていません。  
今回のケースでは「別のノードタイプに変更する場合は現在よりメモリの小さいものには変更できない」というルールが存在していてそれに引っかかったのだと思われます。  
また、これ以外にも変更に関するルールは存在するようなので、必ず事前に調べておく必要があります。

### どうしても変更したい
という場合もあるかと思います。その場合は、

1. 同ノードタイプの現在よりメモリの小さいものに一旦変更
  - 例: m4.4xlarge -> m4.2xlarge
2. 当初変更予定だったノードタイプに変更
  - 例: m4.2xlarge -> m5.4xlarge

という手順で理論的には変更可能です。(こちらはサポートケースでも案内されました)
