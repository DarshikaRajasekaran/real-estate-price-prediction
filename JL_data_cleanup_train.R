library(dplyr)
library(stringr)
library(lubridate)

train=read.csv(file.choose(),stringsAsFactors = FALSE)
View(train)

glimpse(train)

#frequency analysis
library(FREQ)
my_table_neigh=table(train$TAX.CLASS.AT.TIME.OF.SALE)
my_table_neigh
prop.table(my_table_neigh)

#creating dummy variables
train$bcc=trimws(train$BUILDING.CLASS.CATEGORY)
train$BCAT=trimws(train$BUILDING.CLASS.AT.PRESENT)
train$BCST=trimws(train$BUILDING.CLASS.AT.TIME.OF.SALE)

# 
train_build_class_cat=train%>%
  mutate(bc_a_series=as.numeric(bcc %in% c('01 ONE FAMILY DWELLINGS','05 TAX CLASS 1 VACANT LAND','02 TWO FAMILY DWELLINGS','42 CONDO CULTURAL/MEDICAL/EDUCATIONAL/ETC')
                                & str_detect(BCAT,"A")&(BCAT!="RA")),
        bc_b_series=as.numeric(bcc %in% c('02 TWO FAMILY DWELLINGS','07 RENTALS  WALKUP APARTMENTS','05 TAX CLASS 1 VACANT LAND',
                                            '01 ONE FAMILY DWELLINGS','37 RELIGIOUS FACILITIES','03 THREE FAMILY DWELLINGS',
                                            '31 COMMERCIAL VACANT LAND') & str_detect(BCAT,"B") &(BCAT!="RB")),
        bc_c_series=as.numeric(bcc %in% c('07 RENTALS  WALKUP APARTMENTS',
                                          '03 THREE FAMILY DWELLINGS',
                                          '09 COOPS  WALKUP APARTMENTS',
                                          '02 TWO FAMILY DWELLINGS',
                                          '05 TAX CLASS 1 VACANT LAND',
                                          '31 COMMERCIAL VACANT LAND') & str_detect(BCAT,"C")),
        bc_d_series=as.numeric(bcc %in% c('10 COOPS  ELEVATOR APARTMENTS',
                                          '08 RENTALS  ELEVATOR APARTMENTS',
                                          '05 TAX CLASS 1 VACANT LAND') & str_detect(BCAT,"D")),
        bc_e_series=as.numeric(bcc %in% c('30 WAREHOUSES',
                                          '29 COMMERCIAL GARAGES') & str_detect(BCAT,"E")),
        bc_f_series=as.numeric(bcc %in% c('27 FACTORIES') & str_detect(BCAT,"F")),
        bc_g_series=as.numeric(bcc %in% c('29 COMMERCIAL GARAGES',
                                          '06 TAX CLASS 1  OTHER',
                                          '44 CONDO PARKING') & str_detect(BCAT,"G") &(BCAT!="RG")),
        bc_h_series=as.numeric(bcc %in% c('25 LUXURY HOTELS',
                                          '26 OTHER HOTELS',
                                          '38 ASYLUMS AND HOMES',
                                          '07 RENTALS  WALKUP APARTMENTS') & str_detect(BCAT,"H") &(BCAT!="RH")),
        bc_i_series=as.numeric(bcc %in% c('32 HOSPITAL AND HEALTH FACILITIES') & str_detect(BCAT,"I")),
        bc_j_series=as.numeric(bcc %in% c('34 THEATRES',
                                          '22 STORE BUILDINGS',
                                          '41 TAX CLASS 4  OTHER') & str_detect(BCAT,"J")),
        bc_k_series=as.numeric(bcc %in% c('46 CONDO STORE BUILDINGS') & str_detect(BCAT,"K")&(BCAT!="RK")),
        bc_l_series=as.numeric(bcc %in% c('23 LOFT BUILDINGS') & str_detect(BCAT,"L")),
        bc_m_series=as.numeric(bcc %in% c('37 RELIGIOUS FACILITIES',
                                          '21 OFFICE BUILDINGS') & str_detect(BCAT,"M")),
        bc_n_series=as.numeric(bcc %in% c('38 ASYLUMS AND HOMES') & str_detect(BCAT,"N")),
        bc_o_series=as.numeric(bcc %in% c('21 OFFICE BUILDINGS') & str_detect(BCAT,"O")),
        bc_p_series=as.numeric(bcc %in% c('35 INDOOR PUBLIC AND CULTURAL FACILITIES') & str_detect(BCAT,"P")&(BCAT!="RP")),
        bc_q_series=as.numeric(bcc %in% c('36 OUTDOOR RECREATIONAL FACILITIES') & str_detect(BCAT,"Q")),
        bc_r_series=as.numeric(bcc %in% c('04 TAX CLASS 1 CONDOS','13 CONDOS  ELEVATOR APARTMENTS','15 CONDOS  210 UNIT RESIDENTIAL',
                                          '12 CONDOS  WALKUP APARTMENTS','17 CONDO COOPS','45 CONDO HOTELS','16 CONDOS  210 UNIT WITH COMMERCIAL UNIT',
                                          '44 CONDO PARKING','11A CONDORENTALS','48 CONDO TERRACES/GARDENS/CABANAS',
                                          '43 CONDO OFFICE BUILDINGS','28 COMMERCIAL CONDOS','46 CONDO STORE BUILDINGS',
                                          '42 CONDO CULTURAL/MEDICAL/EDUCATIONAL/ETC')& str_detect(BCAT,"R")),
        bc_s_series=as.numeric(bcc %in% c('14 RENTALS  410 UNIT',
                                          '02 TWO FAMILY DWELLINGS',
                                          '01 ONE FAMILY DWELLINGS')& str_detect(BCAT,"S")),
        
        bc_t_series=as.numeric(bcc %in% c('39 TRANSPORTATION FACILITIES')& str_detect(BCAT,"T")),
        bc_v_series=as.numeric(bcc %in% c('31 COMMERCIAL VACANT LAND',
                                          '05 TAX CLASS 1 VACANT LAND',
                                          '03 THREE FAMILY DWELLINGS',
                                          '01 ONE FAMILY DWELLINGS',
                                          '29 COMMERCIAL GARAGES')& str_detect(BCAT,"V")),
        bc_w_series=as.numeric(bcc %in% c('33 EDUCATIONAL FACILITIES',
                                          '34 THEATRES')& str_detect(BCAT,"W")),
        bc_Y_series=as.numeric(bcc %in% c('40 SELECTED GOVERNMENTAL FACILITIES',
                                          '41 TAX CLASS 4  OTHER')& str_detect(BCAT,"Y")),
        bc_Z_series=as.numeric(bcc %in% c('06 TAX CLASS 1  OTHER')& str_detect(BCAT,"Z")),
        
        bc_a_sell_series=as.numeric(bcc %in% c('01 ONE FAMILY DWELLINGS','05 TAX CLASS 1 VACANT LAND','02 TWO FAMILY DWELLINGS','42 CONDO CULTURAL/MEDICAL/EDUCATIONAL/ETC')
                               & (str_detect(BCAT,"A")==str_detect(BCST,"A"))&(BCAT!="RA")),

        bc_b_sell_series=as.numeric(bcc %in% c('02 TWO FAMILY DWELLINGS','07 RENTALS  WALKUP APARTMENTS','05 TAX CLASS 1 VACANT LAND',
                                          '01 ONE FAMILY DWELLINGS','37 RELIGIOUS FACILITIES','03 THREE FAMILY DWELLINGS',
                                          '31 COMMERCIAL VACANT LAND') &(str_detect(BCAT,"B")==str_detect(BCST,"B")) &(BCAT!="RB")),
        bc_c_sell_series=as.numeric(bcc %in% c('07 RENTALS  WALKUP APARTMENTS',
                                          '03 THREE FAMILY DWELLINGS',
                                          '09 COOPS  WALKUP APARTMENTS',
                                          '02 TWO FAMILY DWELLINGS',
                                          '05 TAX CLASS 1 VACANT LAND',
                                          '31 COMMERCIAL VACANT LAND') & (str_detect(BCAT,"C")==str_detect(BCST,"C"))),
        bc_d_sell_series=as.numeric(bcc %in% c('10 COOPS  ELEVATOR APARTMENTS',
                                          '08 RENTALS  ELEVATOR APARTMENTS',
                                          '05 TAX CLASS 1 VACANT LAND') & (str_detect(BCAT,"D")==str_detect(BCST,"D")),
        bc_e_sell_series=as.numeric(bcc %in% c('30 WAREHOUSES',
                                          '29 COMMERCIAL GARAGES') & (str_detect(BCAT,"E")==str_detect(BCST,"E"))),
        bc_f_sell_series=as.numeric(bcc %in% c('27 FACTORIES') & (str_detect(BCAT,"F")==str_detect(BCST,"F"))),
        bc_g_sell_series=as.numeric(bcc %in% c('29 COMMERCIAL GARAGES',
                                          '06 TAX CLASS 1  OTHER',
                                          '44 CONDO PARKING') & (str_detect(BCAT,"G")==str_detect(BCST,"G")) &(BCAT!="RG")),
        bc_h_sell_series=as.numeric(bcc %in% c('25 LUXURY HOTELS',
                                          '26 OTHER HOTELS',
                                          '38 ASYLUMS AND HOMES',
                                          '07 RENTALS  WALKUP APARTMENTS') & (str_detect(BCAT,"H")==str_detect(BCST,"H")) &(BCAT!="RH"))),
        bc_i_sell_series=as.numeric(bcc %in% c('32 HOSPITAL AND HEALTH FACILITIES') & (str_detect(BCAT,"I")==str_detect(BCST,"I"))),        bc_j_sell_series=as.numeric(bcc %in% c('34 THEATRES',
                                          '22 STORE BUILDINGS',
                                          '41 TAX CLASS 4  OTHER') & (str_detect(BCAT,"J")==str_detect(BCST,"J"))),
        bc_k_sell_series=as.numeric(bcc %in% c('46 CONDO STORE BUILDINGS') & (str_detect(BCAT,"K")==str_detect(BCST,"K"))&(BCAT!="RK")),
        bc_l_sell_series=as.numeric(bcc %in% c('23 LOFT BUILDINGS') & (str_detect(BCAT,"L")==str_detect(BCST,"L"))),
        bc_m_sell_series=as.numeric(bcc %in% c('37 RELIGIOUS FACILITIES',
                                          '21 OFFICE BUILDINGS') & (str_detect(BCAT,"M")==str_detect(BCST,"M"))),
      
        bc_n_sell_series=as.numeric(bcc %in% c('38 ASYLUMS AND HOMES') & (str_detect(BCAT,"N")==str_detect(BCST,"N"))),
        bc_o_sell_series=as.numeric(bcc %in% c('21 OFFICE BUILDINGS') & (str_detect(BCAT,"O")==str_detect(BCST,"O"))),
        bc_p_sell_series=as.numeric(bcc %in% c('35 INDOOR PUBLIC AND CULTURAL FACILITIES') & (str_detect(BCAT,"P")==str_detect(BCST,"P"))&(BCAT!="RP")),
        bc_q_sell_series=as.numeric(bcc %in% c('36 OUTDOOR RECREATIONAL FACILITIES') & (str_detect(BCAT,"Q")==str_detect(BCST,"Q"))),
        bc_r_sell_series=as.numeric(bcc %in% c('04 TAX CLASS 1 CONDOS','13 CONDOS  ELEVATOR APARTMENTS','15 CONDOS  210 UNIT RESIDENTIAL',
                                          '12 CONDOS  WALKUP APARTMENTS','17 CONDO COOPS','45 CONDO HOTELS','16 CONDOS  210 UNIT WITH COMMERCIAL UNIT',
                                          '44 CONDO PARKING','11A CONDORENTALS','48 CONDO TERRACES/GARDENS/CABANAS',
                                          '43 CONDO OFFICE BUILDINGS','28 COMMERCIAL CONDOS','46 CONDO STORE BUILDINGS',
                                          '42 CONDO CULTURAL/MEDICAL/EDUCATIONAL/ETC')& (str_detect(BCAT,"R")==str_detect(BCST,"R"))),
        bc_s_sell_series=as.numeric(bcc %in% c('14 RENTALS  410 UNIT',
                                          '02 TWO FAMILY DWELLINGS',
                                          '01 ONE FAMILY DWELLINGS')& (str_detect(BCAT,"S")==str_detect(BCST,"S"))),
        
        bc_t_sell_series=as.numeric(bcc %in% c('39 TRANSPORTATION FACILITIES')& (str_detect(BCAT,"T")==str_detect(BCST,"T"))),
        bc_v_sell_series=as.numeric(bcc %in% c('31 COMMERCIAL VACANT LAND',
                                          '05 TAX CLASS 1 VACANT LAND',
                                          '03 THREE FAMILY DWELLINGS',
                                          '01 ONE FAMILY DWELLINGS',
                                          '29 COMMERCIAL GARAGES')& (str_detect(BCAT,"V")==str_detect(BCST,"V"))),
        bc_w_sell_series=as.numeric(bcc %in% c('33 EDUCATIONAL FACILITIES',
                                          '34 THEATRES')& (str_detect(BCAT,"W")==str_detect(BCST,"W"))),
        bc_Y_sell_series=as.numeric(bcc %in% c('40 SELECTED GOVERNMENTAL FACILITIES',
                                          '41 TAX CLASS 4  OTHER')& (str_detect(BCAT,"Y")==str_detect(BCST,"Y"))),
        bc_Z_sell_series=as.numeric(bcc %in% c('06 TAX CLASS 1  OTHER')& (str_detect(BCAT,"Z")==str_detect(BCST,"Z"))))%>%
  select(-bcc,-BCAT,-BCST,-BUILDING.CLASS.AT.PRESENT,-BUILDING.CLASS.CATEGORY,BUILDING.CLASS.AT.TIME.OF.SALE)
         
      
                 
View(train_build_class_cat)
train_build_class_cat$NEIGHBORHOOD_1=trimws(train_build_class_cat$NEIGHBORHOOD)

train_borough_neigh_data=train_build_class_cat%>%
  mutate(Manhattan_neigbourhood=as.numeric(NEIGHBORHOOD_1 %in% c('N112',
                                                                 'N232',
                                                                 'N111',
                                                                 'N45',
                                                                 'N44',
                                                                 'N230',
                                                                 'N110',
                                                                 'N107',
                                                                 'N142',
                                                                 'N229',
                                                                 'N40',
                                                                 'N152',
                                                                 'N233',
                                                                 'N151',
                                                                 'N41',
                                                                 'N113',
                                                                 'N79',
                                                                 'N106',
                                                                 'N160',
                                                                 'N238',
                                                                 'N237',
                                                                 'N210',
                                                                 'N133',
                                                                 'N150',
                                                                 'N122',
                                                                 'N72',
                                                                 'N139',
                                                                 'N99',
                                                                 'N84',
                                                                 'N128',
                                                                 'N2',
                                                                 'N77',
                                                                 'N234',
                                                                 'N228',
                                                                 'N135',
                                                                 'N215',
                                                                 'N198',
                                                                 'N231') & BOROUGH==1),
         Brooklyn_neighborhood=as.numeric(NEIGHBORHOOD_1%in% c('N90',
                                                               'N211',
                                                               'N196',
                                                               'N132',
                                                               'N182',
                                                               'N157',
                                                               'N205',
                                                               'N236',
                                                               'N71',
                                                               'N243',
                                                               'N147',
                                                               'N12',
                                                               'N114',
                                                               'N183',
                                                               'N29',
                                                               'N223',
                                                               'N38',
                                                               'N179',
                                                               'N131',
                                                               'N156',
                                                               'N251',
                                                               'N240',
                                                               'N42',
                                                               'N19',
                                                               'N56',
                                                               'N159',
                                                               'N57',
                                                               'N181',
                                                               'N10',
                                                               'N14',
                                                               'N78',
                                                               'N121',
                                                               'N158',
                                                               'N235',
                                                               'N43') & BOROUGH==2),
         Queens_Neighborhood=as.numeric(NEIGHBORHOOD_1 %in% c('N36',
                                                              'N81',
                                                              'N20',
                                                              'N15',
                                                              'N85',
                                                              'N206',
                                                              'N83',
                                                              'N23',
                                                              'N69',
                                                              'N177',
                                                              'N188',
                                                              'N105',
                                                              'N245',
                                                              'N153',
                                                              'N30',
                                                              'N64',
                                                              'N222',
                                                              'N102',
                                                              'N53',
                                                              'N173',
                                                              'N34',
                                                              'N92',
                                                              'N66',
                                                              'N80',
                                                              'N144',
                                                              'N172',
                                                              'N11',
                                                              'N207',
                                                              'N24',
                                                              'N244',
                                                              'N67',
                                                              'N37',
                                                              'N46',
                                                              'N247',
                                                              'N216',
                                                              'N59',
                                                              'N65',
                                                              'N129',
                                                              'N58',
                                                              'N21',
                                                              'N175',
                                                              'N246',
                                                              'N174',
                                                              'N82',
                                                              'N140',
                                                              'N9',
                                                              'N95',
                                                              'N190',
                                                              'N49',
                                                              'N98',
                                                              'N31',
                                                              'N178',
                                                              'N161',
                                                              'N249',
                                                              'N141',
                                                              'N26',
                                                              'N48',
                                                              'N154',
                                                              'N33',
                                                              'N254')&BOROUGH==3),
         

         The_Bronx_neigbourhood=as.numeric(NEIGHBORHOOD_1 %in% c('N13',
                                                                 'N91',
                                                                 'N88',
                                                                 'N119',
                                                                 'N195',
                                                                 'N138',
                                                                 'N200',
                                                                 'N89',
                                                                 'N55',
                                                                 'N217',
                                                                 'N97',
                                                                 'N209',
                                                                 'N146',
                                                                 'N7',
                                                                 'N162',
                                                                 'N192',
                                                                 'N218',
                                                                 'N134',
                                                                 'N191',
                                                                 'N214',
                                                                 'N148',
                                                                 'N136',
                                                                 'N189',
                                                                 'N50',
                                                                 'N8',
                                                                 'N116',
                                                                 'N73',
                                                                 'N86',
                                                                 'N250',
                                                                 'N176',
                                                                 'N35',
                                                                 'N242',
                                                                 'N118',
                                                                 'N1',
                                                                 'N123',
                                                                 'N213',
                                                                 'N76',
                                                                 'N197',
                                                                 'N16',
                                                                 'N18',
                                                                 'N130',
                                                                 'N126',
                                                                 'N124',
                                                                 'N253',
                                                                 'N68',
                                                                 'N221',
                                                                 'N115',
                                                                 'N17',
                                                                 'N94',
                                                                 'N117',
                                                                 'N127',
                                                                 'N63',
                                                                 'N27',
                                                                 'N109',
                                                                 'N96',
                                                                 'N169',
                                                                 'N25',
                                                                 'N125') & BOROUGH==4),
         Staten_Island_neigbourhood=as.numeric(NEIGHBORHOOD_1 %in% c('N103',
                                                                 'N170',
                                                                 'N241',
                                                                 'N165',
                                                                 'N5',
                                                                 'N3',
                                                                 'N108',
                                                                 'N32',
                                                                 'N74',
                                                                 'N4',
                                                                 'N199',
                                                                 'N145',
                                                                 'N219',
                                                                 'N239',
                                                                 'N149',
                                                                 'N226',
                                                                 'N39',
                                                                 'N248',
                                                                 'N51',
                                                                 'N167',
                                                                 'N187',
                                                                 'N168',
                                                                 'N184',
                                                                 'N185',
                                                                 'N166',
                                                                 'N227',
                                                                 'N225',
                                                                 'N212',
                                                                 'N186',
                                                                 'N137',
                                                                 'N163',
                                                                 'N220',
                                                                 'N120',
                                                                 'N171',
                                                                 'N194',
                                                                 'N143',
                                                                 'N101',
                                                                 'N104',
                                                                 'N52',
                                                                 'N193',
                                                                 'N208',
                                                                 'N201',
                                                                 'N202',
                                                                 'N47',
                                                                 'N204',
                                                                 'N100',
                                                                 'N61',
                                                                 'N221',
                                                                 'N252',
                                                                 'N60',
                                                                 'N75',
                                                                 'N224',
                                                                 'N6',
                                                                 'N62',
                                                                 'N203',
                                                                 'N164') & BOROUGH==5),
         sale_month=month(SALE.DATE),
         sale_year=year(SALE.DATE),
         sale_day=day(SALE.DATE)) %>%
  select(-BOROUGH,-NEIGHBORHOOD,-NEIGHBORHOOD_1,-BUILDING.CLASS.AT.TIME.OF.SALE,-SALE.DATE)
                                           
                           
  View(train_borough_neigh_data)


final_data=train_borough_neigh_data %>%
  mutate(tax_class_at_present_1=as.numeric(trimws(TAX.CLASS.AT.PRESENT)=="1"),
         tax_class_at_present_1A=as.numeric(trimws(TAX.CLASS.AT.PRESENT)=="1A"),
          tax_class_at_present_1B=as.numeric(trimws(TAX.CLASS.AT.PRESENT)=="1B"),
          tax_class_at_present_1C=as.numeric(trimws(TAX.CLASS.AT.PRESENT)=="1C"),
          tax_class_at_present_2=as.numeric(trimws(TAX.CLASS.AT.PRESENT)=="2"),
          tax_class_at_present_2A=as.numeric(trimws(TAX.CLASS.AT.PRESENT)=="2A"),
          tax_class_at_present_2B=as.numeric(trimws(TAX.CLASS.AT.PRESENT)=="2B"),
         tax_class_at_present_2C=as.numeric(trimws(TAX.CLASS.AT.PRESENT)=="2C"),
         tax_class_at_present_4=as.numeric(trimws(TAX.CLASS.AT.PRESENT)=="4"),
         tax_class_sale_time_1=as.numeric(TAX.CLASS.AT.TIME.OF.SALE==1),
         tax_class_sale_time_2=as.numeric(TAX.CLASS.AT.TIME.OF.SALE==2),
         tax_class_sale_time_4=as.numeric(TAX.CLASS.AT.TIME.OF.SALE==4))%>%
   select(-TAX.CLASS.AT.PRESENT,-TAX.CLASS.AT.TIME.OF.SALE)

write.csv(final_data,"rf_input.csv")

glimpse(final_data)

# 
# set.seed(3)
# s=sample(1:nrow(final_data),0.8*nrow(final_data))
# final_data_1=final_data[s,]
# final_data_2=final_data[-s,]
# 
# 
# 
# fit=lm(SALE.PRICE~.-tax_class_at_present_4 -tax_class_at_present_2C -tax_class_at_present_2 
#        -tax_class_at_present_1C -tax_class_at_present_1B -tax_class_at_present_1 -tax_class_at_present_1A
#        -Staten_Island_neigbourhood -Queens_Neighborhood -The_Bronx_neigbourhood -sale_month -sale_year -sale_day         
#        -bc_w_sell_series-bc_t_sell_series-bc_r_sell_series-bc_q_sell_series -bc_p_sell_series
#        -bc_o_sell_series-bc_n_sell_series-bc_l_sell_series-bc_k_sell_series -bc_j_sell_series-bc_i_sell_series
#        -bc_Y_sell_series-bc_Z_sell_series-bc_s_sell_series-bc_m_sell_series -bc_d_sell_series
#        -bc_Z_series -bc_t_series -bc_p_series -bc_k_series -bc_g_series -bc_n_series-bc_o_series
#        -bc_r_series -bc_d_series -YEAR.BUILT -bc_j_series -bc_Y_series - ZIP.CODE -LOT -BLOCK -tax_class_sale_time_4,data=final_data_1)
# summary(fit)
# 
# #multicollinerity checks
# library(car)
# sort(vif(fit),decreasing = T)
# 
# fit=lm(SALE.PRICE~.-tax_class_at_present_4 -tax_class_at_present_2C -tax_class_at_present_2 
#        -tax_class_at_present_1C -tax_class_at_present_1B -tax_class_at_present_1 -tax_class_at_present_1A
#        -Staten_Island_neigbourhood -Queens_Neighborhood -The_Bronx_neigbourhood -sale_month -sale_year -sale_day         
#        -bc_w_sell_series-bc_t_sell_series-bc_r_sell_series-bc_q_sell_series -bc_p_sell_series
#        -bc_o_sell_series-bc_n_sell_series-bc_l_sell_series-bc_k_sell_series -bc_j_sell_series-bc_i_sell_series
#        -bc_Y_sell_series-bc_Z_sell_series-bc_s_sell_series-bc_m_sell_series -bc_d_sell_series
#        -bc_Z_series -bc_t_series -bc_p_series -bc_k_series -bc_g_series -bc_n_series-bc_o_series
#        -bc_r_series -bc_d_series -YEAR.BUILT -bc_j_series -bc_Y_series - ZIP.CODE -LOT -BLOCK -RESIDENTIAL.UNITS
#        -TOTAL.UNITS -COMMERCIAL.UNITS -bc_a_series -bc_c_sell_series -bc_b_series -bc_c_series -bc_b_sell_series -bc_v_sell_series
#        -bc_w_series -bc_v_series -bc_s_series -tax_class_at_present_2B -tax_class_at_present_2A -bc_m_series -bc_f_series -tax_class_sale_time_4
#        -bc_a_sell_series,data=final_data_1)
# summary(fit)
#   
# 
# par(mfrow=c(2,2)) 
# 
# plot(fit)
# 
# 
# val.pred=predict(fit,newdata=final_data_2)
# errors=final_data_2$SALE.PRICE-val.pred
# sqrt(mean(errors**2))
