erDiagram
    hier_clnd {
        string fscldt_id PK
        string fscldt_label
        string fsclwk_id
        string fsclwk_label
        string fsclmth_id
        string fsclmth_label
        string fsclqrtr_id
        string fsclqrtr_label
        string fsclyr_id
        string fsclyr_label
        string ssn_id
        string ssn_label
        string ly_fscldt_id
        string lly_fscldt_id
        string fscldow
        string fscldom
        string fscldoq
        string fscldoy
        string fsclwoy
        string fsclmoy
        string fsclqoy
        date date
    }
    hier_invloc {
        string loc PK
        string loc_label
        string loctype
        string loctype_label
    }
    hier_hldy {
        string hldy_id PK
        string hldy_label
    }
    hier_possite {
        string site_id PK
        string site_label
        string subchnl_id
        string subchnl_label
        string chnl_id
        string chnl_label
    }
    hier_pricestate {
        string substate_id PK
        string substate_label
        string state_id
        string state_label
    }
    hier_invstatus {
        string code_id PK
        string code_label
        string bckt_id
        string bckt_label
        string ownrshp_id
        string ownrshp_label
    }
    fact_averagecosts {
        string fscldt_id FK
        string sku_id FK
        float average_unit_standardcost
        float average_unit_landedcost
    }
    hier_rtlloc {
        string str PK
        string str_label
        string dstr
        string dstr_label
        string rgn
        string rgn_label
    }
    hier_prod {
        string sku_id PK
        string sku_label
        string stylclr_id
        string stylclr_label
        string styl_id
        string styl_label
        string subcat_id
        string subcat_label
        string cat_id
        string cat_label
        string dept_id
        string dept_label
        boolean issvc
        boolean isasmbly
        boolean isnfs
    }
    fact_transactions {
        string order_id PK
        string line_id PK
        string type
        date dt
        string pos_site_id FK
        string sku_id FK
        string fscldt_id FK
        string price_substate_id FK
        integer sales_units
        float sales_dollars
        float discount_dollars
        string original_order_id
        string original_line_id
    }
    fact_averagecosts }|--|| hier_clnd : fscldt_id
    fact_averagecosts }|--|| hier_prod : sku_id
    fact_transactions }|--|| hier_clnd : fscldt_id
    fact_transactions }|--|| hier_prod : sku_id
    fact_transactions }|--|| hier_possite : pos_site_id
    fact_transactions }|--|| hier_pricestate : price_substate_id
