//+------------------------------------------------------------------+
//|                                                       Robot1.mq4 |
//|                            Copyright 2021, Proyecto de Grado UTS |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Proyecto de Grado UTS"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs

extern int StartHour = 9;
extern int TakeProfit = 40; //TakeProfit
extern int StopLoss = 40; //StopLost
extern double Lots = 1;
extern int MA_Period = 100;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   static bool isFirstTick = true;
   static int ticket = 0;
   
   double ma = iMA(NULL, Period(), MA_Period, 0, 0, 0, 1);
   
   if(Hour() == StartHour){
      if(isFirstTick  == true){
         isFirstTick = false;
         
         bool resultado;
         resultado = OrderSelect(ticket, SELECT_BY_TICKET);
         if(resultado == true){
            if(OrderCloseTime() == 0){
               bool resultado2;
               resultado2 = OrderClose(ticket, Lots, OrderClosePrice(), 10);
               
               if(resultado2 == false){
                  Alert("Error cerrando orden #: ",ticket);
               }
            }
         }
         
         if(Open[0] < Open[StartHour]){
            if(Close[1] < ma){
               ticket = OrderSend(NULL, OP_BUY, Lots, Ask, 10, Ask-StopLoss*Point, Ask+TakeProfit*Point);
               if(ticket <0){
                  Alert("Error Enviando Orden!");
               }
            } 
         }
         else{
            if(Close[1] > ma){
               ticket = OrderSend(NULL, OP_SELL, Lots, Bid, 10, Bid-StopLoss*Point, Bid+TakeProfit*Point);
               if(ticket < 0){
                  Alert("Error Enviando Orden!");
               }
            }
         }   
      }
   }
   else{
      isFirstTick = true;
   }
   
  }
//+------------------------------------------------------------------+
