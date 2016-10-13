//+------------------------------------------------------------------+
//|                                                  TradeRecord.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
input int RefreshInterval = 300;
input int MagicNum = 0;

string object_line = "trendline";
string object_arrow = "buysign";

int OrderNum = 0;

int OnInit()
  {
//--- indicator buffers mapping
   RecordOn();
//---
   EventSetTimer(RefreshInterval);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   RecordOff();
}

void OnTimer(){
   RecordOff();
   RecordOn();
}

void RecordOn(){
   for(int i=0;i<OrdersHistoryTotal();i++){
    if(!OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) {printf("order select error, error code:%d", GetLastError());continue;}
    if(OrderSymbol() != Symbol()) continue;
    if((MagicNum != 0) && (OrderMagicNumber() != MagicNum)) continue;
    int type = OrderType();
    if((type != OP_BUY) && (type != OP_SELL)) continue;
    OrderNum ++;
    datetime t1 = OrderOpenTime();
    datetime t2 = OrderCloseTime();
    double price1 = OrderOpenPrice();
    double price2 = OrderClosePrice();
    
    ENUM_OBJECT arrow;
    if(type == OP_BUY) arrow = OBJ_ARROW_UP;
    else if(type == OP_SELL) arrow = OBJ_ARROW_DOWN;
    string arrow_name = StringFormat("%s%d",object_arrow,OrderNum);
    if(!ObjectCreate(ChartID(),arrow_name,arrow,0,t1,price1)) printf("arrow(%d) creation error, error code:%d", OrderNum,GetLastError());
    else{
     ObjectSetInteger(ChartID(),arrow_name,OBJPROP_COLOR,clrYellow);
     ObjectSetInteger(ChartID(),arrow_name,OBJPROP_WIDTH,5);
    }
    color line_clr;
    if(type == OP_BUY){
     if(price2 > price1) line_clr = clrRed;
     else line_clr = clrBlue;
    }
    else if(type == OP_SELL){
     if(price1 > price2) line_clr = clrRed;
     else line_clr = clrBlue;
    }
    string line_name = StringFormat("%s%d",object_line,OrderNum);
    if(!ObjectCreate(ChartID(),line_name,OBJ_TREND,0,t1,price1,t2,price2)) printf("trendline(%d) creation error, error code:%d", OrderNum,GetLastError());
    else{
     ObjectSetInteger(ChartID(),line_name,OBJPROP_COLOR,line_clr);
     ObjectSetInteger(ChartID(),line_name,OBJPROP_WIDTH,2);
     ObjectSetInteger(ChartID(),line_name,OBJPROP_RAY_RIGHT,false);
    }
   }
}

void RecordOff(){
   for(int i=1;i<=OrderNum;i++){
    string arrow_name = StringFormat("%s%d",object_arrow,i);
    string line_name = StringFormat("%s%d",object_line,i);
    if(!ObjectDelete(ChartID(),arrow_name)) printf("arrow(%d) deletion error, error code:%d", i, GetLastError());
    if(!ObjectDelete(ChartID(),line_name)) printf("trendline(%d) deletion error, error code:%d", i, GetLastError());
   }
   OrderNum = 0;
}