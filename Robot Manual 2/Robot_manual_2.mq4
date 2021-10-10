//+------------------------------------------------------------------+
//|                                               Robot_manual_2.mq4 |
//|                            Copyright 2021, Proyecto de Grado UTS |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Proyecto de Grado UTS"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Proyecto de Grado UTS"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

int Magic = 1;
double SL = 30.0;
double TP = 30.0;
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
   if(operacionesAbiertas() == false){//OKOK
      if(comprar()==true && filtroCompra()==true){
         OrderSend(NULL, OP_BUY, 1.0, Ask, 1, Close[1]-(iATR(NULL, 0, 23, 1)*SL), Close[1]+(iATR(NULL, 0, 23, 1)*TP), "COMPRA ROBOT-EJEMPLO", Magic);
      }
   }
      else{
         if(Hour() >= 12){
            cerrarTodo();
         }
      }
   
  }
//+------------------------------------------------------------------+

bool  comprar(){//OKOK
   if(High[1] >= iHigh(NULL, PERIOD_D1, 0)){
      return(true);//si se va a comprar
   }
   else{
      return(false);//Si no se va a comprar
   }
}

bool filtroCompra(){//OK
   if(Hour() == 8){
      return(true);
   }
   else{
      return(false);
   }
}


bool operacionesAbiertas(){//OK
   for(int i=0;i<OrdersTotal();i++){
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true){
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == Magic){
            return(true);
         }
      }
   }
   return(false);
}


void cerrarTodo(){//OKOK
    for(int i=0;i<OrdersTotal();i++){
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true){
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == Magic){
            if(OrderType() == OP_BUY){
               OrderClose(OrderTicket(), OrderLots(), Bid, 1);
            }
            else 
            if(OrderType() == OP_SELL){
               OrderClose(OrderTicket(), OrderLots(), Ask, 1);
            }
         }
      }
    }
}