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

split_export<-function(df){
  bakers = df[df$Product.Name == "Bake-Off Entry",]
  items = df[df$Product.Name != "Bake-Off Entry",]
  return(list(bakers,items))
}

extract_baker_category<-function(df){
  regex_string = '(: [[:alnum:]-\\s]+)'
  df_new = df %>% 
    extract(Product.Options,"baker_info", regex_string) %>% 
    separate(baker_info,c("proam", "savsweet"), sep = " - ") %>% 
    extract(proam, "proam", "([A-Za-z]+)")
  return(df_new)
}
