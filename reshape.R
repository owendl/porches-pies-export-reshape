library(tidyverse)

clean_up_export<-function(df){
  df[df=='']<-NA
  
  df_new= df %>% 
    select(Shipping.Last.Name, Shipping.First.Name, Shipping.Email,
           Order..,Status,Product.Id,Product.SKU,Product.Name,Product.Quantity,Product.Options, Order.Notes) %>% 
    fill(Shipping.Last.Name:Status) %>% 
    group_by(Order..) %>% 
    fill(Order.Notes) %>% 
    drop_na(Product.Id)
return(df_new)  
}