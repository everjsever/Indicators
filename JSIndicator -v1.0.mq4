//+------------------------------------------------------------------+
//|                                                       ZigZag.mq4 |
//|                   Copyright 2006-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "2006-2014, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property strict
#include <stderror.mqh>
#include <MQH\Lib\SQLite3\SQLite3Base.mqh>
#property indicator_chart_window

//--- globals
int    ExtLevel=3; // recounting's depth of extremums
input int MagicNum = 0;

string object_line = "trendline";
string object_arrow = "buysign";

int OrderNum = 0;  
  
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {


   SqlInit();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
  {
 
   return(rates_total);
  }

//+------------------------------------------------------------------+

  CSQLite3Base sql3;
   CSQLite3Table tbl;  
int SqlInit()
  {
  //--- open database connection
    ResetLastError();
    string terminal_data_path=TerminalInfoString(TERMINAL_DATA_PATH);
    //printf(terminal_data_path);
    //char arr[256]={0};
    
    string filename=terminal_data_path+"\\MQL4\\Libraries\\"+"fx.db";
    uchar arrayChar[512]={0};
    StringToCharArray(filename,arrayChar,0,WHOLE_ARRAY,CP_UTF8);
    filename=CharArrayToString(arrayChar);
    ushort array[512]={0};
    StringToShortArray(filename,array);
    string dbpath=ShortArrayToString(array);
    
   if(sql3.Connect(filename)!=SQLITE_OK){
        printf("sql open fail");
      return INIT_FAILED;
  }
   printf("db sql open ok!");
   
   
    string chartSymbol = Symbol();
    StringToLower(chartSymbol);
    string sqlquery="select * from twoyear where ";
    sqlquery+="item ='" + chartSymbol + ".lmx'"; 
    printf(" %s ", sqlquery);
    if(sql3.Query(tbl,sqlquery)!=SQLITE_DONE)
     {
      Print(sql3.ErrorMsg());
      return false ;
     }     

   int cs,c;
   int rs=ArraySize(tbl.m_data);
   int recordcs=rs; 
   printf("Record count=%d",rs);
   for(int r=0; r<rs; r++){
		   CSQLite3Row *row=tbl.Row(r);
		   cs=ArraySize(row.m_data);
		  // for( c=0; c<cs; c++){
		   
         
                if(StringCompare(row.m_data[0].GetString() ,chartSymbol + ".lmx")!=0) continue;

                string type = row.m_data[8].GetString();
//                if((StringCompare(type ,"buy")!=0) && (StringCompare(type ,"sell")!=0)) 
                if(StringCompare(type ,"buy")!=0) {                
                      if(StringCompare(type ,"sell")==0){
                      
                      }
                      else{
                          printf("type= %s ",type);
                          continue;                         
                        }             
                }

                
                OrderNum ++;

                datetime t1 = StringToTime(row.m_data[1].GetString());//
                datetime t2 = StringToTime(row.m_data[2].GetString());
                double price1 = StringToDouble(row.m_data[4].GetString());
                double price2 = StringToDouble(row.m_data[5].GetString());

                ENUM_OBJECT arrow;                
                if(StringCompare(type ,"buy")==0) arrow = OBJ_ARROW_UP;
                else if(StringCompare(type ,"sell")==0) arrow = OBJ_ARROW_DOWN;
                
                string arrow_name = StringFormat("%s%d",object_arrow,OrderNum);
                if(!ObjectCreate(ChartID(),arrow_name,arrow,0,t1,price1)) printf("arrow(%d) creation error 1, error code:%d", OrderNum,GetLastError());
                else{
                 ObjectSetInteger(ChartID(),arrow_name,OBJPROP_COLOR,clrYellow);
                 ObjectSetInteger(ChartID(),arrow_name,OBJPROP_WIDTH,5);

                }
                color line_clr;
                if(StringCompare(type ,"buy")==0){
                 if(price2 > price1) line_clr = clrRed;
                 else line_clr = clrBlue;
                }
                else if(StringCompare(type ,"sell")==0){
                 if(price1 > price2) line_clr = clrRed;
                 else line_clr = clrBlue;
                }
                string line_name = StringFormat("%s%d",object_line,OrderNum);
                if(!ObjectCreate(ChartID(),line_name,OBJ_TREND,0,t1,price1,t2,price2)) printf("trendline(%d) creation error 2, error code:%d", OrderNum,GetLastError());
                else{
                 ObjectSetInteger(ChartID(),line_name,OBJPROP_COLOR,line_clr);
                 ObjectSetInteger(ChartID(),line_name,OBJPROP_WIDTH,2);
                 ObjectSetInteger(ChartID(),line_name,OBJPROP_RAY_RIGHT,false);

                }
	         
//		           }      
      }
	
   
          
   return(INIT_SUCCEEDED);
  } 

 void  Disconnect(){

   sql3.Disconnect();
}
void deinit()
  {
   Disconnect(); 
   RecordOff();     
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