//+------------------------------------------------------------------+
//|                                              MTK_TP_Language.mqh |
//|                       Copyright 2014, MTK Beijing Tech. Co., Ltd |
//|                                        https://www.mt4xitong.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MTK Beijing Tech. Co., Ltd"
#property link      "https://www.mt4xitong.com"
#property strict

enum language_item {
   lang_id = 0,
   S_PANEL_TITLE,
   S_SYMBOL,
   S_VOLUME,
   S_EXPIRATION,
   S_TRADETYPE,
   S_PRICE,
   S_PAYOFF,
   S_LOWVOLA,
   S_TYPE_UP_DOWN,
   S_TYPE_BIG_SMALL,
   S_TYPE_ODD_EVEN,
   S_TYPE_RANGE,
   S_BUTTON_CALL,
   S_BUTTON_PUT,
   S_BUTTON_BIG,
   S_BUTTON_SMALL,
   S_BUTTON_ODD,
   S_BUTTON_EVEN,
   S_BUTTON_RANGE_IN,
   S_BUTTON_RANGE_OUT
};

string DISPLAY_LANG[2][32] = {
   {
      "English",
      "MTK BinaryOption Trade Panel",
      "Symbol",
      "Volume",
      "Expiration",
      "Trade Type",
      "Price",
      "PayOff",
      "Low Volatility",
      "Up/Down",
      "Big/Small",
      "Odd/Even",
      "Range IN/OUT",
      "CALL",
      "PUT",
      "BIG",
      "SMALL",
      "ODD",
      "EVEN",
      "RANGE-IN",
      "RANGE_OUT", 
      "", "", "", "", "", "", "", "", "", "", ""
   },
   {
      "简体中文",
      "MTK 二元期权交易",
      "产品",
      "交易量",
      "到期",
      "期权类型",
      "价格",
      "结算",
      "低波动",
      "高/低",
      "大/小",
      "奇/偶",
      "范围内/外",
      "看涨",
      "看跌",
      "买大",
      "买小",
      "买奇",
      "买偶",
      "范围内",
      "范围外",
      "", "", "", "", "", "", "", "", "", "", ""
   }
};