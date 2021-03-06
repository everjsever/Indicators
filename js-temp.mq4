
#property copyright "Copyright ? soyh.com"
#property link      "http://www.soyh.com"
#include <stdlib.mqh>
#include <stderror.mqh>
#include <MQH\Lib\SQLite3\SQLite3Base.mqh>

//---- indicator settings
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Red
#property indicator_color2 Red
#property indicator_color3 Red
#property indicator_color4 Yellow
#property indicator_color5 Yellow
#property indicator_color6 Yellow
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 1
#property indicator_width6 1
#property indicator_style1 STYLE_DOT
#property indicator_style3 STYLE_DOT
#property indicator_style4 STYLE_DOT
#property indicator_style6 STYLE_DOT


//---- indicator buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
string line_name="rotating_line";
string object_name1="my_text1";
string object_name2="my_text2";
string object_name3="my_text3";
string object_name4="my_text4";
string object_name5="my_text5";
string object_name6="my_text6";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   // Three more buffers to store long/short trading info and trend
   IndicatorBuffers(6);
   
   // Drawing settings
   SetIndexStyle(0,DRAW_ARROW); SetIndexArrow(0, 65);
   SetIndexStyle(1,DRAW_ARROW); SetIndexArrow(1, 178);
   SetIndexStyle(2,DRAW_ARROW); SetIndexArrow(2,34);
   SetIndexStyle(3,DRAW_ARROW); SetIndexArrow(3,34);
   SetIndexStyle(4,DRAW_ARROW); SetIndexArrow(4,169);
   SetIndexStyle(5,DRAW_ARROW); SetIndexArrow(5,65);//high
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
   
   // Name and labels
   IndicatorShortName("The Classic JS Trader");
   SetIndexLabel(0,"Buy Limit ");
   SetIndexLabel(1,"Buy breakout");
   SetIndexLabel(2,"Buy Stop ");
   SetIndexLabel(3,"Sell Limit ");
   SetIndexLabel(4,"Sell breakout ");
   SetIndexLabel(5,"Sell Stop ");
   
   // Buffers
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);    
   SetIndexBuffer(3,ExtMapBuffer4); 
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexBuffer(5,ExtMapBuffer6);

   SqlInit();
   Comment("Copyright ? http://www.xxxx.com");
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{

   double high1,high2,low1,low2,high3,high4,low3,low4,high5,high6,low5,low6,high0,low0;
     // More vars here too...
     int start = 0,i,error,index,fontsize=10;
     int limit;
     int counted_bars = IndicatorCounted();

     // check for possible errors
     if(counted_bars < 0) 
        return(-1);
        
     // Only check these
     limit = Bars - 1 - counted_bars;
      


      int TradePeriod =52;    
      high1=High[iHighest(NULL,0,MODE_HIGH,TradePeriod,22)];      
      low1=Low[iLowest(NULL,0,MODE_LOW,TradePeriod,22)];  

      if((high1-low1)>500*Point){//价格幅度              

     ////// judge trend /////
     // Check the signal foreach bar
        high6=High[iHighest(NULL,0,MODE_HIGH,3,1)];  
        low6=Low[iLowest(NULL,0,MODE_LOW,3,1)]; 
        high5=High[iHighest(NULL,0,MODE_HIGH,250,20)];  
        low5=Low[iLowest(NULL,0,MODE_LOW,250,20)];              
//     for( i = limit; i >= start; i--)

       for( i=0; i<limit; i++)
     {           
      
         // It might be recalculating bar zero
         ExtMapBuffer1[i] = EMPTY_VALUE;
         ExtMapBuffer2[i] = EMPTY_VALUE;
         ExtMapBuffer3[i] = EMPTY_VALUE;
         ExtMapBuffer4[i] = EMPTY_VALUE;
         ExtMapBuffer5[i] = EMPTY_VALUE;
         ExtMapBuffer6[i] = EMPTY_VALUE;         
         
         if(i==22+TradePeriod||i==22){
          //ExtMapBuffer1[i] =low5;
          ExtMapBuffer2[i] = low1;
          //ExtMapBuffer3[i] = low1-200*Point;
          //ExtMapBuffer4[i] = high1+150*Point;
          ExtMapBuffer5[i] = high1;
         // ExtMapBuffer6[i] = high5;
         }
         
         if(i==3){

           //ExtMapBuffer1[i] =high6;
           ExtMapBuffer2[i] = low6;
          // ExtMapBuffer3[i] = low6;

          //ExtMapBuffer4[i] = high1+150*Point;
           ExtMapBuffer5[i] = high6;
               // ExtMapBuffer6[i] = low1+40*Point;
         }
         
         if(i==0 ){

          ExtMapBuffer1[i] =high1-40*Point;
          ExtMapBuffer2[i] = low1;
          ExtMapBuffer3[i] = low1-200*Point;
          ExtMapBuffer4[i] = high6-30*Point +150*Point;
          ExtMapBuffer5[i] = high6-30*Point;//high1;
          ExtMapBuffer6[i] = low1+40*Point;
          
         index=3;
         ObjectCreate(object_name1, OBJ_TEXT, 0, Time[index],  (low6+high6)/2);
         ObjectSetText(object_name1,DoubleToStr(high6-low6, 4), fontsize, "Times New Roman", White  );  
         index=22;
         ObjectCreate(object_name2, OBJ_TEXT, 0, Time[index],  (low1+high1)/2);
         ObjectSetText(object_name2,DoubleToStr(high1-low1, 4)+"点", fontsize, "Times New Roman", White  );  

         ObjectCreate(object_name3, OBJ_TEXT, 0, Time[index],  (high5+high1)/2);
         ObjectSetText(object_name3,DoubleToStr(high5-high1, 4)+"点", fontsize, "Times New Roman", White  );   
         ObjectCreate(object_name4, OBJ_TEXT, 0, Time[index],  high5);
         ObjectSetText(object_name4,DoubleToStr(high5, 4), fontsize, "Times New Roman", White  );   
         ObjectCreate(object_name5, OBJ_TEXT, 0, Time[index],  low5);
         ObjectSetText(object_name5,DoubleToStr(low5, 4), fontsize, "Times New Roman", White  );   
         ObjectCreate(object_name6, OBJ_TEXT, 0, Time[index],  (low5+low1)/2);
         ObjectSetText(object_name6,DoubleToStr(MathAbs(low5-low1),4)+"点", fontsize, "Times New Roman", White  );                         
         //ObjectsRedraw();
         }
    }//for
           

  
}
    
   // Bye Bye
   return(0);
}


       
  
         
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deinit()
  {
  // ObjectDelete(line_name);
   ObjectDelete(object_name1);
   ObjectDelete(object_name2);   
   ObjectDelete(object_name3);    
   ObjectDelete(object_name4);
   ObjectDelete(object_name5);
   ObjectDelete(object_name6);                    
   ObjectsRedraw();
   Disconnect();   
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
   for(int r=0; r<rs; r++){
		   CSQLite3Row *row=tbl.Row(r);
		   cs=ArraySize(row.m_data);
		   for( c=0; c<cs; c++){
		          //RecordData[r][c]=row.m_data[c].GetString();
		           printf("db datais : %s  :  %d",row.m_data[c].GetString(),cs);
		           }      
      }
	
   
          
   return(INIT_SUCCEEDED);
  } 

 void  Disconnect(){

   sql3.Disconnect();
}