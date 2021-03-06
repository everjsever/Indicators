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
string object_stop = "stopsign";
string object_limit = "limitsign";

int OrderNum = 0;  
  
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {


//   SqlInit();
   FileInitCSV();
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

void FileInitCSV(string fileNM ="follow.csv"){

   int filehandle=FileOpen(fileNM,FILE_READ|FILE_CSV);
   int OrderNum=0;
   string chartSymbol = Symbol();    
   if(filehandle!=INVALID_HANDLE)

     {

//      FileWrite(filehandle,TimeCurrent(),Symbol(), EnumToString(ENUM_TIMEFRAMES(_Period)));
      int    str_size;

      string str;

      //--- read data from the file

      while(!FileIsEnding(filehandle))

        {

         //--- find out how many symbols are used for writing the time

         str_size=FileReadInteger(filehandle,INT_VALUE);

         //--- read the string

         str=FileReadString(filehandle,str_size);
         //PrintFormat(str);
         string sep=",";                // A separator as a character
      
         ushort u_sep;                  // The code of the separator character
      
         string result[],result1[];               // An array to get strings
      
         //--- Get the separator code
      
         u_sep=StringGetCharacter(sep,0);// XAU/USD,buy,0.02,2016/4/11 12:07,2016/4/11 12:38,"1,250.63",12.1,2.42     ,,,,,"1,251.84",,
      
         //--- Split the string to substrings
      
         int k=StringSplit(str,u_sep,result);
      
         //--- Show a comment 
      
        // PrintFormat("Strings obtained: %d. Used separator '%s' with the code %d",k,sep,u_sep);
         str_size=FileReadInteger(filehandle,INT_VALUE);
         str=FileReadString(filehandle,str_size);
         //PrintFormat(str);         
         //--- Get the separator code
         u_sep=StringGetCharacter(sep,0);// XAU/USD,buy,0.02,2016/4/11 12:07,2016/4/11 12:38,"1,250.63",12.1,2.42     ,,,,,"1,251.84",,
         k=StringSplit(str,u_sep,result1);
     
         //--- Now output all obtained strings
         /*result[0]=XAU/USD
         result[1]=buy
         result[2]=0.02
         result[3]=2016/4/11 12:07
         result[4]=2016/4/11 12:38            2012.11.01 14:17:03  StringReplace()
         result[5]="1
         result[6]=250.63"
         result[7]=12.1
         result[8]=2.42 */  
           
         if(k>0)     
               
           {
                StringReplace(result[0],"/","");
                string stmp=result[0]+"pro";


                
                if(StringCompare(stmp,chartSymbol )!=0){ //for forex.com       
                if(StringCompare(result[0],chartSymbol )!=0)
                continue;
                                 
                
                }
                PrintFormat(stmp);                 
       /*  for(int i=0;i<k;i++)

        {

         PrintFormat("result[%d]=%s",i,result[i]);

        }

         for(int i=0;i<k;i++)

        {

         PrintFormat("result11[%d]=%s",i,result1[i]);

        }   */  StringReplace(result[3],"/",".");  
                StringReplace(result[4],"/","."); 
                       
                datetime t1 = StringToTime(result[3]);//
                datetime t2 =  StringToTime(result[4]);
                double price1 = StringToDouble(result[5]);
                double price2 = StringToDouble(result1[5]);
                  
                double stop = 0;//StringToDouble(row.m_data[6].GetString());
                double limit = 0;//StringToDouble(row.m_data[7].GetString()); 
                double profit = StringToDouble(result[7]);               
                double vsize = StringToDouble(result[2]);
                string type=result[1];
                ENUM_OBJECT arrow;                
                if(StringCompare(type ,"buy")==0) arrow = OBJ_ARROW_UP;
                else if(StringCompare(type ,"sell")==0) arrow = OBJ_ARROW_DOWN;
                
                string arrow_name = StringFormat("%s%d",object_arrow,OrderNum);
                if(!ObjectCreate(ChartID(),arrow_name,arrow,0,t1,price1)) printf("arrow(%d) creation error 1, error code:%d", OrderNum,GetLastError());
                else{
                 ObjectSetInteger(ChartID(),arrow_name,OBJPROP_COLOR,clrYellow);
                 ObjectSetInteger(ChartID(),arrow_name,OBJPROP_WIDTH,5);

                }
                
                ENUM_OBJECT LSarrow;                
                if(stop!=0){
                   LSarrow = OBJ_ARROW_STOP;                   
                   
                   string arrow_name = StringFormat("%s%d",object_stop,OrderNum)+"S";
                   if(!ObjectCreate(ChartID(),arrow_name,LSarrow,0,t1,stop)) printf("arrow(%d) creation error S, error code:%d  chart = %s  ,%f", OrderNum,GetLastError(),chartSymbol,stop);
                   else{
                    ObjectSetInteger(ChartID(),arrow_name,OBJPROP_COLOR,clrRed);
                    ObjectSetInteger(ChartID(),arrow_name,OBJPROP_WIDTH,2);

                 }
                }
                
                ENUM_OBJECT Limitarrow;                
                if(limit!=0){
                   Limitarrow = OBJ_ARROW_CHECK;                   
                   
                   string arrow_name = StringFormat("%s%d",object_limit,OrderNum)+"L";
                   if(!ObjectCreate(ChartID(),arrow_name,Limitarrow,0,t1,limit)) printf("arrow(%d) creation error L, error code:%d  ,%f", OrderNum,GetLastError(),limit);
                   else{
                    ObjectSetInteger(ChartID(),arrow_name,OBJPROP_COLOR,clrRed);
                    ObjectSetInteger(ChartID(),arrow_name,OBJPROP_WIDTH,2);

                 }
                }               
                ENUM_OBJECT textTime;                
                textTime = OBJ_TEXT;                   
                string text_name = StringFormat("%s%d",textTime,OrderNum)+"T";
                if(!ObjectCreate(ChartID(),text_name,textTime,0,t1,price1)) printf("arrow(%d) creation error T, error code:%d  ", OrderNum,GetLastError());
                   else{
                    ObjectSetInteger(ChartID(),text_name,OBJPROP_COLOR,clrAntiqueWhite);
                    //ObjectSetInteger(ChartID(),text_name,OBJPROP_WIDTH,4);
                    if(profit<0){
                      
                    }
                    else{
                    
                    }
                    
                    ObjectSetString(ChartID(),text_name,OBJPROP_TEXT,StringFormat("%s","                                            "+DoubleToString(MathAbs(price2-price1)*10000,1)+"："+ DoubleToString(vsize,1)+":W"+TimeDayOfWeek(t1)+":"+TimeToString(t1,TIME_MINUTES ))); 
                      //--- set distance property 
                    //ObjectSet(text_name,OBJPROP_YDISTANCE,i); 

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
                
             OrderNum++;      
      
           }

         //--- print the string

        }

      FileClose(filehandle);

      Print("FileOpen OK");

     }

   else Print("Operation FileOpen failed, error ",GetLastError());


}

  CSQLite3Base sql3;
   CSQLite3Table tbl;  
int SqlInit()
  {
  //--- open database connection
    ResetLastError();
    string terminal_data_path=TerminalInfoString(TERMINAL_DATA_PATH);
    //printf(terminal_data_path);
    //char arr[256]={0};
    
    string filename=terminal_data_path+"\\MQL4\\Libraries\\"+"fx-ea.db";
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
    printf("chartSymbol =%s",chartSymbol);
    StringToLower(chartSymbol);
    string sqlquery="select * from twoyear where ";
    sqlquery+="item ='" + chartSymbol + ".lmx' or item ='"+chartSymbol + "'"; 
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
         
                if(StringCompare(row.m_data[4].GetString() ,chartSymbol + ".lmx")!=0){
                
                if(StringCompare(row.m_data[4].GetString() ,chartSymbol )!=0)                
                                 
                 continue;
                                 
                
                }
                

                string type = row.m_data[2].GetString();
                if(StringCompare(type ,"buy")!=0) {                
                      if(StringCompare(type ,"sell")==0){
                      
                      }
                      else{
                          printf("type= %s ",type);
                          continue;                         
                        }             
                }

                
                OrderNum ++;

	         
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