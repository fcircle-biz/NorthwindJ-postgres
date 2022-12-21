-- ========================================================
-- DBの作成
-- ========================================================
CREATE DATABASE "NorthwindJ" OWNER postgres;

-- ========================================================
-- データベースを切り替え
-- ========================================================
\c "NorthwindJ"

-- ========================================================
-- テーブルの作成
-- ========================================================

CREATE TABLE 運送会社 (
	  運送コード INTEGER NOT NULL
	, 運送会社 VARCHAR(40) NOT NULL
	, 電話番号 VARCHAR(24) NULL
	, PRIMARY KEY (運送コード)
);

CREATE TABLE 仕入先 (
	  仕入先コード INTEGER NOT NULL
	, フリガナ VARCHAR(80) NULL
	, 仕入先名 VARCHAR(40) NOT NULL
	, 担当者名 VARCHAR(30) NULL
	, 部署 VARCHAR(30) NULL
	, 郵便番号 VARCHAR(10) NULL
	, トドウフケン VARCHAR(30) NULL
	, 都道府県 VARCHAR(15) NULL
	, 住所1 VARCHAR(60) NULL
	, 住所2 VARCHAR(60) NULL
	, 電話番号 VARCHAR(24) NULL
	, ファクシミリ VARCHAR(24) NULL
	, ホームページ VARCHAR(3000) NULL
	, PRIMARY KEY (仕入先コード)
);

CREATE TABLE 社員 (
	  社員コード INTEGER NOT NULL
	, フリガナ VARCHAR(80) NULL
	, 氏名 VARCHAR(40) NOT NULL
	, 在籍支社 VARCHAR(20) NULL
	, 部署名 VARCHAR(30) NULL
	, 誕生日 TIMESTAMP NULL
	, 入社日 TIMESTAMP NULL
	, 自宅郵便番号 VARCHAR(10) NULL
	, 自宅都道府県 VARCHAR(40) NULL
	, 自宅住所1 VARCHAR(60) NULL
	, 自宅住所2 VARCHAR(60) NULL
	, 自宅電話番号 VARCHAR(24) NULL
	, 内線 VARCHAR(4) NULL
	, 写真 VARCHAR(255) NULL
	, プロフィール VARCHAR(3000) NULL
	, PRIMARY KEY (社員コード)
);

CREATE TABLE 受注 (
	  受注コード INTEGER NOT NULL
	, 得意先コード INTEGER NULL
	, 社員コード INTEGER NULL
	, 出荷先名 VARCHAR(40) NULL
	, 出荷先郵便番号 VARCHAR(10) NULL
	, 出荷先都道府県 VARCHAR(20) NULL
	, 出荷先住所1 VARCHAR(60) NULL
	, 出荷先住所2 VARCHAR(60) NULL
	, 運送区分 INTEGER NULL
	, 受注日 TIMESTAMP NULL
	, 締切日 TIMESTAMP NULL
	, 出荷日 TIMESTAMP NULL
	, 運送料 MONEY NULL
	, PRIMARY KEY (受注コード)
);

CREATE TABLE 受注明細 (
	  受注コード INTEGER NOT NULL
	, 商品コード INTEGER NOT NULL
	, 単価 MONEY NOT NULL
	, 数量 INTEGER NOT NULL
	, 割引 REAL NOT NULL
	, PRIMARY KEY (受注コード, 商品コード)
);

CREATE TABLE 商品 (
	  商品コード INTEGER NOT NULL
	, フリガナ VARCHAR(80) NULL
	, 商品名 VARCHAR(40) NOT NULL
	, 仕入先コード INTEGER NULL
	, 区分コード INTEGER NULL
	, 梱包単位 VARCHAR(20) NULL
	, 単価 MONEY NULL
	, 在庫 INTEGER NULL
	, 発注済 INTEGER NULL
	, 発注点 INTEGER NULL
	, 生産中止 BOOLEAN NOT NULL
	, PRIMARY KEY (商品コード)
);

CREATE TABLE 商品区分 (
	  区分コード INTEGER NOT NULL
	, 区分名 VARCHAR(30) NOT NULL
	, 説明 VARCHAR(3000) NULL
	, 図 BYTEA NULL
	, PRIMARY KEY (区分コード )
);

CREATE TABLE 都道府県 (
	  トドウフケン VARCHAR(30) NULL
	, 都道府県 VARCHAR(15) NULL
	, ローマ字 VARCHAR(100) NULL
	, 地域名ローマ字 VARCHAR(100) NULL
	, 地域 VARCHAR(10) NULL
);

CREATE TABLE 得意先 (
	  得意先コード INTEGER NOT NULL
	, フリガナ VARCHAR(40) NULL
	, 得意先名 VARCHAR(40) NOT NULL
	, 担当者名 VARCHAR(30) NULL
	, 部署 VARCHAR(30) NULL
	, 郵便番号 VARCHAR(10) NULL
	, トドウフケン VARCHAR(30) NULL
	, 都道府県 VARCHAR(15) NULL
	, 住所1 VARCHAR(60) NULL
	, 住所2 VARCHAR(60) NULL
	, 電話番号 VARCHAR(24) NULL
	, ファクシミリ VARCHAR(24) NULL
	, PRIMARY KEY (得意先コード)
);

-- ========================================================
-- シーケンス
-- ========================================================

-- ========================================================
-- インデックス
-- ========================================================

-- ========================================================
-- データ登録
-- ========================================================

COPY 運送会社
FROM '/docker-entrypoint-initdb.d/public.運送会社.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);

COPY 仕入先
FROM '/docker-entrypoint-initdb.d/public.仕入先.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);

COPY 社員
FROM '/docker-entrypoint-initdb.d/public.社員.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);

COPY 受注
FROM '/docker-entrypoint-initdb.d/public.受注.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);

COPY 受注明細
FROM '/docker-entrypoint-initdb.d/public.受注明細.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);

COPY 商品
FROM '/docker-entrypoint-initdb.d/public.商品.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);

COPY 商品区分
FROM '/docker-entrypoint-initdb.d/public.商品区分.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);

COPY 都道府県
FROM '/docker-entrypoint-initdb.d/public.都道府県.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);

COPY 得意先
FROM '/docker-entrypoint-initdb.d/public.得意先.csv'
WITH (
  FORMAT CSV,
  HEADER true,
  NULL ''
);

-- ========================================================
-- 外部キーの設定
-- ========================================================

ALTER TABLE 受注 ADD CONSTRAINT FK_受注_運送会社 FOREIGN KEY(運送区分)
REFERENCES 運送会社 (運送コード);

ALTER TABLE 受注 ADD CONSTRAINT FK_受注_社員 FOREIGN KEY(社員コード)
REFERENCES 社員 (社員コード);

ALTER TABLE 受注 ADD CONSTRAINT FK_受注_得意先 FOREIGN KEY(得意先コード)
REFERENCES 得意先 (得意先コード);

ALTER TABLE 受注明細 ADD  CONSTRAINT FK_受注明細_受注 FOREIGN KEY(受注コード)
REFERENCES 受注 (受注コード);

ALTER TABLE 受注明細 ADD CONSTRAINT FK_受注明細_商品 FOREIGN KEY(商品コード)
REFERENCES 商品 (商品コード);

ALTER TABLE 商品 ADD CONSTRAINT FK_商品_仕入先 FOREIGN KEY(仕入先コード)
REFERENCES 仕入先 (仕入先コード);

ALTER TABLE 商品 ADD CONSTRAINT FK_商品_商品区分1 FOREIGN KEY(区分コード)
REFERENCES 商品区分 (区分コード);

