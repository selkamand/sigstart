# parse_vcf_to_sigminer_maf works correctly

    Code
      df_maf
    Output
         Chromosome Position_1based     ID Reference_Allele Tumor_Seq_Allele2  QUAL
             <char>           <num> <char>           <char>            <char> <num>
      1:          1               1   <NA>                C                 A    NA
      2:          1               2   <NA>                G                 T    NA
         FILTER Tumor_Sample_Barcode  gt_AD gt_GT_alleles Ref_Length Alt_Length
         <char>               <char> <char>        <char>      <num>      <num>
      1:   PASS               sample  47,15           C/A          1          1
      2:   PASS               sample   84,5           G/T          1          1
         Start_Position End_Position Inframe Variant_Type
                  <num>        <num>  <lgcl>       <char>
      1:              1            1    TRUE          SNP
      2:              2            2    TRUE          SNP

# parse_vcf_to_sigminer_maf works correctly with tumor_normal samples

    Code
      df_maf
    Output
            Chromosome Position_1based     ID Reference_Allele Tumor_Seq_Allele2
                <char>           <num> <char>           <char>            <char>
         1:       chr1          183180   <NA>                G                 A
         2:       chr1         1177244   <NA>                C                 T
         3:       chr1         1987479   <NA>                C                 T
         4:       chr1         2902418   <NA>                C                 T
         5:       chr1         3772058   <NA>                C                 T
        ---                                                                     
      2823:       chrX       153526435   <NA>               CC                TT
      2824:       chrX       154702258   <NA>                G                 A
      2825:       chrX       155962790   <NA>                G                 T
      2826:       chrY        11115481   <NA>              ATC               GTT
      2827:       chrY        56847672   <NA>                C                 T
             QUAL FILTER BIALLELIC DEDUP_INDEL_OLD GND_FREQ HOTSPOT IMPACT     KT
            <num> <char>    <lgcl>          <lgcl>    <num>  <lgcl> <char> <char>
         1:   256   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
         2:   861   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
         3:   842   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
         4:  1291   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
         5:  2162   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
        ---                                                                      
      2823:  1999   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
      2824:  2015   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
      2825:   401   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
      2826:   293   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
      2827:   901   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
               LPS LPS_RC MAPPABILITY   MED     MH   MSG NEAR_HOTSPOT PAVE_TI
            <char> <char>       <num> <int> <char> <int>       <lgcl>  <char>
         1:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
         2:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
         3:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
         4:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
         5:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
        ---                                                                  
      2823:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
      2824:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
      2825:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
      2826:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
      2827:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
            PON_COUNT PON_MAX PURPLE_AF PURPLE_CN PURPLE_GERMLINE PURPLE_MACN
                <int>   <int>     <num>     <num>          <char>       <num>
         1:        NA      NA        NA        NA            <NA>          NA
         2:        NA      NA        NA        NA            <NA>          NA
         3:        NA      NA        NA        NA            <NA>          NA
         4:        NA      NA        NA        NA            <NA>          NA
         5:        NA      NA        NA        NA            <NA>          NA
        ---                                                                  
      2823:        NA      NA        NA        NA            <NA>          NA
      2824:        NA      NA        NA        NA            <NA>          NA
      2825:        NA      NA        NA        NA            <NA>          NA
      2826:        NA      NA        NA        NA            <NA>          NA
      2827:        NA      NA        NA        NA            <NA>          NA
            PURPLE_VCN     RC RC_IDX  RC_LF  RC_MH RC_NM RC_REPC RC_REPS  RC_RF
                 <num> <char>  <int> <char> <char> <int>   <int>  <char> <char>
         1:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
         2:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
         3:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
         4:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
         5:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
        ---                                                                    
      2823:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
      2824:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
      2825:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
      2826:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
      2827:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
            REPORTABLE_TRANSCRIPTS REPORTED REP_C  REP_S SUBCL   TIER    TNC
                            <char>   <lgcl> <int> <char> <num> <char> <char>
         1:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
         2:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
         3:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
         4:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
         5:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
        ---                                                                 
      2823:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
      2824:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
      2825:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
      2826:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
      2827:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
            Tumor_Sample_Barcode gt_ABQ  gt_AD gt_AF gt_AMQ     gt_ANM gt_DP  gt_GT
                          <char>  <int> <char> <num> <char>     <char> <int> <char>
         1:         tumor_sample     35 171,34 0.166  31,30 0.800,2.00   205    0/1
         2:         tumor_sample     35  56,34 0.378  60,60 0.600,1.20    90    0/1
         3:         tumor_sample     35  86,34 0.283  60,60  1.10,2.10   120    0/1
         4:         tumor_sample     32  31,57 0.648  58,57  1.90,2.20    88    0/1
         5:         tumor_sample     35  35,83 0.703  60,60  1.70,2.00   118    0/1
        ---                                                                        
      2823:         tumor_sample     36   0,69 1.000  60,60  2.10,2.10    69    1/1
      2824:         tumor_sample     36   0,70 1.000  60,60  1.10,1.10    70    1/1
      2825:         tumor_sample     36  64,15 0.190  60,60 0.500,1.00    79    0/1
      2826:         tumor_sample     36 504,34 0.063  51,52  5.10,6.60   538    1/1
      2827:         tumor_sample     36 592,64 0.098  48,47  2.70,3.70   656    1/1
               gt_RABQ gt_RAD           gt_RC_CNT gt_RC_IPC gt_RC_JIT
                <char> <char>              <char>     <int>    <char>
         1:  6574,1231 178,35  31,3,0,0,0,171,205         0     0,0,0
         2:  2098,1222  58,34    32,2,0,0,0,56,90         0     0,0,0
         3:  3280,1196  90,34   27,7,0,0,0,86,120         0     0,0,0
         4:  1053,1905  33,59    50,4,1,0,2,31,88         0     0,0,0
         5:  1320,3011  36,85  71,12,0,0,0,35,118         0     0,0,0
        ---                                                          
      2823:     0,2428   0,68     61,8,0,0,0,0,69         0     0,0,0
      2824:     0,2788   0,76     61,8,0,0,1,0,70         2     0,0,0
      2825:   2329,543  65,15    12,3,0,0,0,64,79         0     0,0,0
      2826: 18568,1135 514,31  29,5,0,0,0,504,538         0     0,0,0
      2827: 22205,2357 611,65 49,13,0,0,2,592,656         0     0,0,0
                          gt_RC_QUAL gt_RDP      gt_RSB       gt_SB gt_UMI_CNT
                              <char>  <int>      <char>      <char>     <char>
         1:    247,9,0,0,0,1627,1883    213 0.532,0.778 0.415,0.588       <NA>
         2:   846,15,0,0,0,1380,2241     92 0.429,0.618 0.571,0.647       <NA>
         3:   785,57,0,0,0,2440,3282    124 0.563,0.353 0.535,0.471       <NA>
         4:   1220,71,0,0,0,719,2010     92 0.313,0.355 0.387,0.439       <NA>
         5:  2027,135,0,0,0,966,3128    121 0.343,0.643 0.457,0.639       <NA>
        ---                                                                   
      2823:    1895,104,0,0,0,0,1999     68 0.500,0.429 0.500,0.391       <NA>
      2824:    1931,84,0,0,32,0,2047     76 0.500,0.479 0.500,0.420       <NA>
      2825:   372,29,0,0,0,1789,2190     80 0.438,0.600 0.484,0.467       <NA>
      2826:   272,21,0,0,0,5052,5345    547 0.436,0.412 0.461,0.412       <NA>
      2827: 818,83,0,0,0,11543,12444    676 0.508,0.446 0.505,0.469       <NA>
            gt_GT_alleles Ref_Length Alt_Length Start_Position End_Position Inframe
                   <char>      <num>      <num>          <num>        <num>  <lgcl>
         1:           G/A          1          1         183180       183180    TRUE
         2:           C/T          1          1        1177244      1177244    TRUE
         3:           C/T          1          1        1987479      1987479    TRUE
         4:           C/T          1          1        2902418      2902418    TRUE
         5:           C/T          1          1        3772058      3772058    TRUE
        ---                                                                        
      2823:         TT/TT          2          2      153526435    153526436    TRUE
      2824:           A/A          1          1      154702258    154702258    TRUE
      2825:           G/T          1          1      155962790    155962790    TRUE
      2826:       GTT/GTT          3          3       11115481     11115483    TRUE
      2827:           T/T          1          1       56847672     56847672    TRUE
            Variant_Type
                  <char>
         1:          SNP
         2:          SNP
         3:          SNP
         4:          SNP
         5:          SNP
        ---             
      2823:          DNP
      2824:          SNP
      2825:          SNP
      2826:          TNP
      2827:          SNP

# parse_vcf_to_sigminer_maf works correctly with tumor_normal_rna samples

    Code
      df_maf
    Output
            Chromosome Position_1based     ID Reference_Allele Tumor_Seq_Allele2
                <char>           <num> <char>           <char>            <char>
         1:       chr1          183180   <NA>                G                 A
         2:       chr1         1177244   <NA>                C                 T
         3:       chr1         1987479   <NA>                C                 T
         4:       chr1         2902418   <NA>                C                 T
         5:       chr1         3772058   <NA>                C                 T
        ---                                                                     
      2823:       chrX       153526435   <NA>               CC                TT
      2824:       chrX       154702258   <NA>                G                 A
      2825:       chrX       155962790   <NA>                G                 T
      2826:       chrY        11115481   <NA>              ATC               GTT
      2827:       chrY        56847672   <NA>                C                 T
             QUAL FILTER BIALLELIC DEDUP_INDEL_OLD GND_FREQ HOTSPOT IMPACT     KT
            <num> <char>    <lgcl>          <lgcl>    <num>  <lgcl> <char> <char>
         1:   256   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
         2:   861   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
         3:   842   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
         4:  1291   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
         5:  2162   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
        ---                                                                      
      2823:  1999   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
      2824:  2015   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
      2825:   401   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
      2826:   293   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
      2827:   901   PASS     FALSE           FALSE       NA   FALSE   <NA>   <NA>
               LPS LPS_RC MAPPABILITY   MED     MH   MSG NEAR_HOTSPOT PAVE_TI
            <char> <char>       <num> <int> <char> <int>       <lgcl>  <char>
         1:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
         2:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
         3:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
         4:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
         5:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
        ---                                                                  
      2823:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
      2824:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
      2825:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
      2826:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
      2827:   <NA>   <NA>          NA    NA   <NA>    NA        FALSE    <NA>
            PON_COUNT PON_MAX PURPLE_AF PURPLE_CN PURPLE_GERMLINE PURPLE_MACN
                <int>   <int>     <num>     <num>          <char>       <num>
         1:        NA      NA        NA        NA            <NA>          NA
         2:        NA      NA        NA        NA            <NA>          NA
         3:        NA      NA        NA        NA            <NA>          NA
         4:        NA      NA        NA        NA            <NA>          NA
         5:        NA      NA        NA        NA            <NA>          NA
        ---                                                                  
      2823:        NA      NA        NA        NA            <NA>          NA
      2824:        NA      NA        NA        NA            <NA>          NA
      2825:        NA      NA        NA        NA            <NA>          NA
      2826:        NA      NA        NA        NA            <NA>          NA
      2827:        NA      NA        NA        NA            <NA>          NA
            PURPLE_VCN     RC RC_IDX  RC_LF  RC_MH RC_NM RC_REPC RC_REPS  RC_RF
                 <num> <char>  <int> <char> <char> <int>   <int>  <char> <char>
         1:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
         2:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
         3:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
         4:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
         5:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
        ---                                                                    
      2823:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
      2824:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
      2825:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
      2826:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
      2827:         NA   <NA>     NA   <NA>   <NA>    NA      NA    <NA>   <NA>
            REPORTABLE_TRANSCRIPTS REPORTED REP_C  REP_S SUBCL   TIER    TNC
                            <char>   <lgcl> <int> <char> <num> <char> <char>
         1:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
         2:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
         3:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
         4:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
         5:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
        ---                                                                 
      2823:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
      2824:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
      2825:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
      2826:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
      2827:                   <NA>    FALSE    NA   <NA>    NA   <NA>   <NA>
            F_MISSING    AN     AC    NS AC_Hom AC_Het AC_Hemi     AF   MAF      HWE
               <char> <int> <char> <int> <char> <char>  <char> <char> <num>   <char>
         1:  0.333333     4      1     2      0      1       0   0.25  0.25        1
         2:  0.333333     4      1     2      0      1       0   0.25  0.25        1
         3:  0.333333     4      1     2      0      1       0   0.25  0.25        1
         4:  0.333333     4      1     2      0      1       0   0.25  0.25        1
         5:  0.333333     4      1     2      0      1       0   0.25  0.25        1
        ---                                                                         
      2823:  0.333333     4      2     2      2      0       0    0.5  0.50 0.333333
      2824:  0.333333     4      2     2      2      0       0    0.5  0.50 0.333333
      2825:  0.333333     4      1     2      0      1       0   0.25  0.25        1
      2826:  0.333333     4      2     2      2      0       0    0.5  0.50 0.333333
      2827:  0.333333     4      2     2      2      0       0    0.5  0.50 0.333333
            ExcHet Tumor_Sample_Barcode gt_ABQ  gt_AD gt_AF gt_AMQ  gt_ANM gt_DP
            <char>               <char>  <int> <char> <num> <char>  <char> <int>
         1:      1         tumor_sample     35 171,34 0.166  31,30   0.8,2   205
         2:      1         tumor_sample     35  56,34 0.378  60,60 0.6,1.2    90
         3:      1         tumor_sample     35  86,34 0.283  60,60 1.1,2.1   120
         4:      1         tumor_sample     32  31,57 0.648  58,57 1.9,2.2    88
         5:      1         tumor_sample     35  35,83 0.703  60,60   1.7,2   118
        ---                                                                     
      2823:      1         tumor_sample     36   0,69 1.000  60,60 2.1,2.1    69
      2824:      1         tumor_sample     36   0,70 1.000  60,60 1.1,1.1    70
      2825:      1         tumor_sample     36  64,15 0.190  60,60   0.5,1    79
      2826:      1         tumor_sample     36 504,34 0.063  51,52 5.1,6.6   538
      2827:      1         tumor_sample     36 592,64 0.098  48,47 2.7,3.7   656
             gt_GT    gt_RABQ gt_RAD           gt_RC_CNT gt_RC_IPC gt_RC_JIT
            <char>     <char> <char>              <char>     <int>    <char>
         1:    0/1  6574,1231 178,35  31,3,0,0,0,171,205         0     0,0,0
         2:    0/1  2098,1222  58,34    32,2,0,0,0,56,90         0     0,0,0
         3:    0/1  3280,1196  90,34   27,7,0,0,0,86,120         0     0,0,0
         4:    0/1  1053,1905  33,59    50,4,1,0,2,31,88         0     0,0,0
         5:    0/1  1320,3011  36,85  71,12,0,0,0,35,118         0     0,0,0
        ---                                                                 
      2823:    1/1     0,2428   0,68     61,8,0,0,0,0,69         0     0,0,0
      2824:    1/1     0,2788   0,76     61,8,0,0,1,0,70         2     0,0,0
      2825:    0/1   2329,543  65,15    12,3,0,0,0,64,79         0     0,0,0
      2826:    1/1 18568,1135 514,31  29,5,0,0,0,504,538         0     0,0,0
      2827:    1/1 22205,2357 611,65 49,13,0,0,2,592,656         0     0,0,0
                          gt_RC_QUAL gt_RDP      gt_RSB       gt_SB gt_UMI_CNT
                              <char>  <int>      <char>      <char>     <char>
         1:    247,9,0,0,0,1627,1883    213 0.532,0.778 0.415,0.588       <NA>
         2:   846,15,0,0,0,1380,2241     92 0.429,0.618 0.571,0.647       <NA>
         3:   785,57,0,0,0,2440,3282    124 0.563,0.353 0.535,0.471       <NA>
         4:   1220,71,0,0,0,719,2010     92 0.313,0.355 0.387,0.439       <NA>
         5:  2027,135,0,0,0,966,3128    121 0.343,0.643 0.457,0.639       <NA>
        ---                                                                   
      2823:    1895,104,0,0,0,0,1999     68   0.5,0.429   0.5,0.391       <NA>
      2824:    1931,84,0,0,32,0,2047     76   0.5,0.479    0.5,0.42       <NA>
      2825:   372,29,0,0,0,1789,2190     80   0.438,0.6 0.484,0.467       <NA>
      2826:   272,21,0,0,0,5052,5345    547 0.436,0.412 0.461,0.412       <NA>
      2827: 818,83,0,0,0,11543,12444    676 0.508,0.446 0.505,0.469       <NA>
              gt_VAF  gt_VAF1 gt_GT_alleles Ref_Length Alt_Length Start_Position
              <char>    <num>        <char>      <num>      <num>          <num>
         1: 0.165854 0.165854           G/A          1          1         183180
         2: 0.377778 0.377778           C/T          1          1        1177244
         3: 0.283333 0.283333           C/T          1          1        1987479
         4: 0.647727 0.647727           C/T          1          1        2902418
         5:  0.70339 0.703390           C/T          1          1        3772058
        ---                                                                     
      2823:        1 1.000000         TT/TT          2          2      153526435
      2824:        1 1.000000           A/A          1          1      154702258
      2825: 0.189873 0.189873           G/T          1          1      155962790
      2826: 0.063197 0.063197       GTT/GTT          3          3       11115481
      2827: 0.097561 0.097561           T/T          1          1       56847672
            End_Position Inframe Variant_Type
                   <num>  <lgcl>       <char>
         1:       183180    TRUE          SNP
         2:      1177244    TRUE          SNP
         3:      1987479    TRUE          SNP
         4:      2902418    TRUE          SNP
         5:      3772058    TRUE          SNP
        ---                                  
      2823:    153526436    TRUE          DNP
      2824:    154702258    TRUE          SNP
      2825:    155962790    TRUE          SNP
      2826:     11115483    TRUE          TNP
      2827:     56847672    TRUE          SNP

# parse_purple_sv_vcf_to_bedpe works correctly

    Code
      bedpe
    Output
          chrom1    start1      end1 chrom2    start2      end2              name
      1        1  87337010  87337011     10  36119126  36119127   gridss34ff_107o
      2        1 118516185 118516186      1 118516221 118516222    gridss47fb_59o
      4        1 199952581 199952582     19  28300902  28300903   gridss79ff_102o
      5        1 207981228 207981233      1 208014817 208014822    gridss83fb_92o
      7        1 224646602 224646603      1 224800119 224800120   gridss89bf_129o
      8        1 224782794 224782795      1 224786033 224786034   gridss89fb_300o
      11       3  24565105  24565109      3  24566178  24566182    gridss207bb_2o
      15       3  26431916  26431919      6  26194038  26194041  gridss207bb_163o
      16       3  26663920  26663922      3  26664497  26664499  gridss207ff_208o
      18       3  60132753  60132754      3  60204542  60204543   gridss221fb_91o
      20       3  60204584  60204585      3  60204585  60204586  gridss221fb_100o
      22       3  60872122  60872125      3  61013212  61013215  gridss221fb_163o
      24       3 186442173 186442176      3 186513631 186513634  gridss271fb_326o
      26       4  66211954  66211959      4  66212036  66212041   gridss302bf_99o
      28       4 187996320 187996322      4 187996380 187996382  gridss351bf_106o
      30       5  28787995  28787996      5  28963095  28963096   gridss364fb_65o
      32       5 178973286 178973289      5 178973320 178973323  gridss424fb_156o
      35       6  26194116  26194117      6  26194405  26194406  gridss435ff_118o
      39       7  52440352  52440354      7  52440386  52440388  gridss514fb_182o
      41       7  57471575  57471578      7  57496108  57496111  gridss516fb_427o
      43       7  77981838  77981839      7  78082248  78082249   gridss525fb_57o
      45       7  78190204  78190207      7  78257684  78257687   gridss525fb_75o
      47       7  85844667  85844668      7  85853699  85853700   gridss528bf_22o
      49       7 104485066 104485069      7 104612299 104612302   gridss535bf_81o
      51       7 110393331 110393332      7 110394460 110394461   gridss538fb_15o
      53       7 125746122 125746123      7 126166900 126166901   gridss544fb_65o
      54       7 126098487 126098491      7 126167440 126167444   gridss544bb_33o
      58       8  78515532  78515536      8  78517775  78517779   gridss589fb_39o
      59       8  78517419  78517420      8 112063211 112063212   gridss589bb_10o
      61       8  78517775  78517779      8  78518233  78518237    gridss589ff_8o
      63       8  78518239  78518240      8 112063329 112063330    gridss589bf_8o
      64       8 112062418 112062420      8 112063581 112063583   gridss602fb_47o
      68       8 131248114 131248117      8 131274644 131274647   gridss610bf_40o
      70       9  28031834  28031835      9  28059139  28059140   gridss627ff_34o
      71       9  28031862  28031863      9  28034466  28034467   gridss627bb_34o
      72       9  28034297  28034299      9  28157691  28157693   gridss627fb_81o
      76      10   7059510   7059512     19  17396809  17396811   gridss675bf_67o
      77      10   7132871   7132876     19  17397639  17397644  gridss675fb_329o
      78      10   7634372   7634373     18   9868616   9868617    gridss676bb_3o
      79      10  33386452  33386453     10  36119060  36119061   gridss686fb_82o
      80      10  36118407  36119259     10  86057424  86058119   gridss687ff_31o
      83      10  55476343  55476349     10  55476895  55476901   gridss695fb_15o
      85      10  60477223  60477224      3  25401058  25401059  gridss207fb_184h
      86      10  60477421  60477422     12  72667073  72667074   gridss697ff_11o
      87      10  83641805  83641806     10  83827665  83827666   gridss706fb_36o
      90      10  89700298  89700299     10  89712340  89712341  gridss708fb_131o
      92      11  37459923  37459927     11  40859856  40859860   gridss742bb_11o
      93      11  37460102  37460103     11  40859238  40859239   gridss742ff_12o
      96      11  80785597  80785602     11  81093779  81093784   gridss759fb_46o
      98      12  72666891  72666892      3  25400601  25400602  gridss207fb_181h
      100     12  92161145  92161147     12  92161181  92161183   gridss818fb_27o
      102     14  41217951  41217955     14  41244104  41244108   gridss897bf_24o
      104     14  73014648  73014650     14  73014745  73014747   gridss910bf_15o
      106     15  23685606  23685608     20  37274466  37274468   gridss933bb_40o
      107     15  23686071  23686072     20  37274466  37274467   gridss933bb_41o
      108     15  23706878  23706879     20  37274666  37274667   gridss933bf_69o
      109     15  23712616  23712619      6 138774179 138774182   gridss480ff_64h
      110     15  23717165  23717166      6 138774058 138774059   gridss480bb_60h
      111     15  23831657  23831661     15  23992699  23992703   gridss933ff_36o
      113     15  41621291  41621296     15  41628505  41628510   gridss940bf_39o
      115     15  84810724  84810725      7 150746656 150746657  gridss554fb_106h
      116     16  58624544  58624545     16  58663330  58663331  gridss988fb_159o
      118     16  78928632  78928639     16  79095000  79095007  gridss996fb_109o
      121     18  66379459  66379462     18  66382825  66382828 gridss1060fb_111o
      126     20  13160726  13160730     20  13164099  13164103  gridss1094fb_59o
      128     20  14962954  14962958     20  15013947  15013951  gridss1095fb_34o
      129     20  14988823  14988825     20  15108817  15108819  gridss1095fb_35o
      130     20  15000621  15000624     20  15013841  15013844  gridss1095fb_36o
      137     21  42818738  42818744     21  42820831  42820837 gridss1131fb_156o
      139     22  33759248  33759249     22  33838398  33838399  gridss1147fb_97o
      141      X  31196942  31196943      X  31216210  31216211 gridss1166fb_177o
      143      X  31301202  31301203      X  32038749  32038750   gridss1167fb_2o
      145      X  32077854  32077855      X  32293096  32293097  gridss1167fb_11o
      146      X  32098530  32098533      X  32201250  32201253  gridss1167fb_14o
      149      X  34059777  34059778      X  34062704  34062705   gridss1168fb_4o
             score strand1 strand2
      1    2454.77       +       +
      2    3447.02       +       -
      4     511.82       +       +
      5    1777.14       +       -
      7    4860.77       -       +
      8    6276.25       +       -
      11  13695.02       -       -
      15   6345.71       -       -
      16  12983.54       +       +
      18   3113.75       +       -
      20    803.06       +       -
      22   3644.29       +       -
      24    789.60       +       -
      26   2107.45       -       +
      28   2623.52       -       +
      30   3345.95       +       -
      32   7031.15       +       -
      35   3880.05       +       +
      39   7840.24       +       -
      41   7540.40       +       -
      43   3590.63       +       -
      45   3148.99       +       -
      47   4129.85       -       +
      49   7525.08       -       +
      51   3522.52       +       -
      53   6728.99       +       -
      54   6826.11       -       -
      58    474.28       +       -
      59    437.18       -       -
      61    222.31       +       +
      63    441.86       -       +
      64    710.32       +       -
      68   1825.75       -       +
      70   3552.45       +       +
      71   3247.45       -       -
      72   2316.28       +       -
      76   3264.52       -       +
      77   2795.68       +       -
      78   2002.54       -       -
      79   2301.50       +       -
      80    164.56       +       +
      83    525.95       +       -
      85   4556.81       -       +
      86   6154.84       +       +
      87    884.39       +       -
      90   6614.50       +       -
      92    428.49       -       -
      93    388.72       +       +
      96   4342.11       +       -
      98   5254.92       -       +
      100  2742.22       +       -
      102   875.20       -       +
      104  4368.84       -       +
      106  1369.60       -       -
      107   514.56       -       -
      108  2504.24       -       +
      109  3342.51       +       +
      110  2744.39       -       -
      111  5066.51       +       +
      113  3955.88       -       +
      115  4525.53       -       +
      116  6023.65       +       -
      118  3422.61       +       -
      121  2414.34       +       -
      126  6231.55       +       -
      128  3325.98       +       -
      129  1636.74       +       -
      130  3354.89       +       -
      137  1114.21       +       -
      139  3228.90       +       -
      141  3468.47       +       -
      143  3559.36       +       -
      145  4144.53       +       -
      146  2926.90       +       -
      149  4983.57       +       -

# parse_purple_sv_vcf_to_sigminer works correctly

    Code
      sigminer
    Output
          Sample chr1    start1      end1 chr2    start2      end2              name
      1   Sample    1  87337010  87337011   10  36119126  36119127   gridss34ff_107o
      2   Sample    1 118516185 118516186    1 118516221 118516222    gridss47fb_59o
      4   Sample    1 199952581 199952582   19  28300902  28300903   gridss79ff_102o
      5   Sample    1 207981228 207981233    1 208014817 208014822    gridss83fb_92o
      7   Sample    1 224646602 224646603    1 224800119 224800120   gridss89bf_129o
      8   Sample    1 224782794 224782795    1 224786033 224786034   gridss89fb_300o
      11  Sample    3  24565105  24565109    3  24566178  24566182    gridss207bb_2o
      15  Sample    3  26431916  26431919    6  26194038  26194041  gridss207bb_163o
      16  Sample    3  26663920  26663922    3  26664497  26664499  gridss207ff_208o
      18  Sample    3  60132753  60132754    3  60204542  60204543   gridss221fb_91o
      20  Sample    3  60204584  60204585    3  60204585  60204586  gridss221fb_100o
      22  Sample    3  60872122  60872125    3  61013212  61013215  gridss221fb_163o
      24  Sample    3 186442173 186442176    3 186513631 186513634  gridss271fb_326o
      26  Sample    4  66211954  66211959    4  66212036  66212041   gridss302bf_99o
      28  Sample    4 187996320 187996322    4 187996380 187996382  gridss351bf_106o
      30  Sample    5  28787995  28787996    5  28963095  28963096   gridss364fb_65o
      32  Sample    5 178973286 178973289    5 178973320 178973323  gridss424fb_156o
      35  Sample    6  26194116  26194117    6  26194405  26194406  gridss435ff_118o
      39  Sample    7  52440352  52440354    7  52440386  52440388  gridss514fb_182o
      41  Sample    7  57471575  57471578    7  57496108  57496111  gridss516fb_427o
      43  Sample    7  77981838  77981839    7  78082248  78082249   gridss525fb_57o
      45  Sample    7  78190204  78190207    7  78257684  78257687   gridss525fb_75o
      47  Sample    7  85844667  85844668    7  85853699  85853700   gridss528bf_22o
      49  Sample    7 104485066 104485069    7 104612299 104612302   gridss535bf_81o
      51  Sample    7 110393331 110393332    7 110394460 110394461   gridss538fb_15o
      53  Sample    7 125746122 125746123    7 126166900 126166901   gridss544fb_65o
      54  Sample    7 126098487 126098491    7 126167440 126167444   gridss544bb_33o
      58  Sample    8  78515532  78515536    8  78517775  78517779   gridss589fb_39o
      59  Sample    8  78517419  78517420    8 112063211 112063212   gridss589bb_10o
      61  Sample    8  78517775  78517779    8  78518233  78518237    gridss589ff_8o
      63  Sample    8  78518239  78518240    8 112063329 112063330    gridss589bf_8o
      64  Sample    8 112062418 112062420    8 112063581 112063583   gridss602fb_47o
      68  Sample    8 131248114 131248117    8 131274644 131274647   gridss610bf_40o
      70  Sample    9  28031834  28031835    9  28059139  28059140   gridss627ff_34o
      71  Sample    9  28031862  28031863    9  28034466  28034467   gridss627bb_34o
      72  Sample    9  28034297  28034299    9  28157691  28157693   gridss627fb_81o
      76  Sample   10   7059510   7059512   19  17396809  17396811   gridss675bf_67o
      77  Sample   10   7132871   7132876   19  17397639  17397644  gridss675fb_329o
      78  Sample   10   7634372   7634373   18   9868616   9868617    gridss676bb_3o
      79  Sample   10  33386452  33386453   10  36119060  36119061   gridss686fb_82o
      80  Sample   10  36118407  36119259   10  86057424  86058119   gridss687ff_31o
      83  Sample   10  55476343  55476349   10  55476895  55476901   gridss695fb_15o
      85  Sample   10  60477223  60477224    3  25401058  25401059  gridss207fb_184h
      86  Sample   10  60477421  60477422   12  72667073  72667074   gridss697ff_11o
      87  Sample   10  83641805  83641806   10  83827665  83827666   gridss706fb_36o
      90  Sample   10  89700298  89700299   10  89712340  89712341  gridss708fb_131o
      92  Sample   11  37459923  37459927   11  40859856  40859860   gridss742bb_11o
      93  Sample   11  37460102  37460103   11  40859238  40859239   gridss742ff_12o
      96  Sample   11  80785597  80785602   11  81093779  81093784   gridss759fb_46o
      98  Sample   12  72666891  72666892    3  25400601  25400602  gridss207fb_181h
      100 Sample   12  92161145  92161147   12  92161181  92161183   gridss818fb_27o
      102 Sample   14  41217951  41217955   14  41244104  41244108   gridss897bf_24o
      104 Sample   14  73014648  73014650   14  73014745  73014747   gridss910bf_15o
      106 Sample   15  23685606  23685608   20  37274466  37274468   gridss933bb_40o
      107 Sample   15  23686071  23686072   20  37274466  37274467   gridss933bb_41o
      108 Sample   15  23706878  23706879   20  37274666  37274667   gridss933bf_69o
      109 Sample   15  23712616  23712619    6 138774179 138774182   gridss480ff_64h
      110 Sample   15  23717165  23717166    6 138774058 138774059   gridss480bb_60h
      111 Sample   15  23831657  23831661   15  23992699  23992703   gridss933ff_36o
      113 Sample   15  41621291  41621296   15  41628505  41628510   gridss940bf_39o
      115 Sample   15  84810724  84810725    7 150746656 150746657  gridss554fb_106h
      116 Sample   16  58624544  58624545   16  58663330  58663331  gridss988fb_159o
      118 Sample   16  78928632  78928639   16  79095000  79095007  gridss996fb_109o
      121 Sample   18  66379459  66379462   18  66382825  66382828 gridss1060fb_111o
      126 Sample   20  13160726  13160730   20  13164099  13164103  gridss1094fb_59o
      128 Sample   20  14962954  14962958   20  15013947  15013951  gridss1095fb_34o
      129 Sample   20  14988823  14988825   20  15108817  15108819  gridss1095fb_35o
      130 Sample   20  15000621  15000624   20  15013841  15013844  gridss1095fb_36o
      137 Sample   21  42818738  42818744   21  42820831  42820837 gridss1131fb_156o
      139 Sample   22  33759248  33759249   22  33838398  33838399  gridss1147fb_97o
      141 Sample    X  31196942  31196943    X  31216210  31216211 gridss1166fb_177o
      143 Sample    X  31301202  31301203    X  32038749  32038750   gridss1167fb_2o
      145 Sample    X  32077854  32077855    X  32293096  32293097  gridss1167fb_11o
      146 Sample    X  32098530  32098533    X  32201250  32201253  gridss1167fb_14o
      149 Sample    X  34059777  34059778    X  34062704  34062705   gridss1168fb_4o
             score strand1 strand2            svclass
      1    2454.77       +       +      translocation
      2    3447.02       +       -          inversion
      4     511.82       +       +      translocation
      5    1777.14       +       -          inversion
      7    4860.77       -       +          inversion
      8    6276.25       +       -          inversion
      11  13695.02       -       - tandem-duplication
      15   6345.71       -       -      translocation
      16  12983.54       +       +           deletion
      18   3113.75       +       -          inversion
      20    803.06       +       -          inversion
      22   3644.29       +       -          inversion
      24    789.60       +       -          inversion
      26   2107.45       -       +          inversion
      28   2623.52       -       +          inversion
      30   3345.95       +       -          inversion
      32   7031.15       +       -          inversion
      35   3880.05       +       +           deletion
      39   7840.24       +       -          inversion
      41   7540.40       +       -          inversion
      43   3590.63       +       -          inversion
      45   3148.99       +       -          inversion
      47   4129.85       -       +          inversion
      49   7525.08       -       +          inversion
      51   3522.52       +       -          inversion
      53   6728.99       +       -          inversion
      54   6826.11       -       - tandem-duplication
      58    474.28       +       -          inversion
      59    437.18       -       - tandem-duplication
      61    222.31       +       +           deletion
      63    441.86       -       +          inversion
      64    710.32       +       -          inversion
      68   1825.75       -       +          inversion
      70   3552.45       +       +           deletion
      71   3247.45       -       - tandem-duplication
      72   2316.28       +       -          inversion
      76   3264.52       -       +      translocation
      77   2795.68       +       -      translocation
      78   2002.54       -       -      translocation
      79   2301.50       +       -          inversion
      80    164.56       +       +           deletion
      83    525.95       +       -          inversion
      85   4556.81       -       +      translocation
      86   6154.84       +       +      translocation
      87    884.39       +       -          inversion
      90   6614.50       +       -          inversion
      92    428.49       -       - tandem-duplication
      93    388.72       +       +           deletion
      96   4342.11       +       -          inversion
      98   5254.92       -       +      translocation
      100  2742.22       +       -          inversion
      102   875.20       -       +          inversion
      104  4368.84       -       +          inversion
      106  1369.60       -       -      translocation
      107   514.56       -       -      translocation
      108  2504.24       -       +      translocation
      109  3342.51       +       +      translocation
      110  2744.39       -       -      translocation
      111  5066.51       +       +           deletion
      113  3955.88       -       +          inversion
      115  4525.53       -       +      translocation
      116  6023.65       +       -          inversion
      118  3422.61       +       -          inversion
      121  2414.34       +       -          inversion
      126  6231.55       +       -          inversion
      128  3325.98       +       -          inversion
      129  1636.74       +       -          inversion
      130  3354.89       +       -          inversion
      137  1114.21       +       -          inversion
      139  3228.90       +       -          inversion
      141  3468.47       +       -          inversion
      143  3559.36       +       -          inversion
      145  4144.53       +       -          inversion
      146  2926.90       +       -          inversion
      149  4983.57       +       -          inversion

# parse_purple_cnv_to_sigminer works correctly

    Code
      sigminer
    Output
          sample Chromosome  Start.bp    End.bp modal_cn minor_cn
      1    bobby       chr1         1  86871328   2.8129   0.8142
      2    bobby       chr1  86871329 117973563   2.0058   0.0000
      3    bobby       chr1 117973564 117973598   1.1874   0.0000
      4    bobby       chr1 117973599 123605522   2.0200   0.0000
      5    bobby       chr1 123605523 144101571   4.3472   0.0000
      6    bobby       chr1 144101572 149390802   3.9423   0.0000
      7    bobby       chr1 149390803 149390831   4.4050   0.0000
      8    bobby       chr1 149390832 207515141   3.9292   0.0000
      9    bobby       chr1 207515142 207807886   3.9810   0.0000
      10   bobby       chr1 207807887 207841474   2.9979   0.0000
      11   bobby       chr1 207841475 224458900   3.9409   0.0000
      12   bobby       chr1 224458901 224459192   5.6905   0.0000
      13   bobby       chr1 224459193 224459204   4.9319   0.0000
      14   bobby       chr1 224459205 224595093   5.9620   0.0000
      15   bobby       chr1 224595094 224598331   4.0059   0.0000
      16   bobby       chr1 224598332 224612418   6.0082   0.0000
      17   bobby       chr1 224612419 248956422   3.9033   0.0000
      18   bobby       chr2         1  85108247   3.0204   1.0013
      19   bobby       chr2  85108248  85108419   3.3643   1.0013
      20   bobby       chr2  85108420  93139350   3.0281   1.0146
      21   bobby       chr2  93139351  94278558   2.6304   1.0026
      22   bobby       chr2  94278559  94282214   2.8465   1.0026
      23   bobby       chr2  94282215  94282241   2.4653   1.0026
      24   bobby       chr2  94282242  94289919   2.6501   1.0026
      25   bobby       chr2  94289920 204314089   3.0240   1.0026
      26   bobby       chr2 204314090 228550862   3.0234   1.0024
      27   bobby       chr2 228550863 242193529   3.0238   1.0015
      28   bobby       chr3         1  24523615   2.0062   0.0000
      29   bobby       chr3  24523616  24524689   6.0437   2.0151
      30   bobby       chr3  24524690  25157914  10.0812   2.0218
      31   bobby       chr3  25157915  25290092  10.0303   1.8925
      32   bobby       chr3  25290093  25359111  12.0741   1.8863
      33   bobby       chr3  25359112  25359568  10.0614   1.9820
      34   bobby       chr3  25359569  26390426   8.0045   1.9820
      35   bobby       chr3  26390427  26622430  11.8826   2.2062
      36   bobby       chr3  26622431  26623008   7.9486   1.9852
      37   bobby       chr3  26623009  60147026   4.0147   1.9852
      38   bobby       chr3  60147027  60218814   2.8788   0.9576
      39   bobby       chr3  60218815  60218895   3.8878   1.8861
      40   bobby       chr3  60218896  60886452   3.9507   1.9490
      41   bobby       chr3  60886453  61027541   2.9732   1.0353
      42   bobby       chr3  61027542  73315061   4.0333   1.9906
      43   bobby       chr3  73315062  92214015   3.9908   1.9877
      44   bobby       chr3  92214016 186724386   4.0075   1.9870
      45   bobby       chr3 186724387 186795843   3.7045   1.7204
      46   bobby       chr3 186795844 198295559   3.9867   1.9759
      47   bobby       chr4         1  50726025   2.0234   0.9787
      48   bobby       chr4  50726026  65346238   3.8452   1.8417
      49   bobby       chr4  65346239  65346321   5.7139   1.8490
      50   bobby       chr4  65346322 187075166   3.8494   1.8490
      51   bobby       chr4 187075167 187075227   5.7828   1.8490
      52   bobby       chr4 187075228 190214555   3.8471   1.8460
      53   bobby       chr5         1  28787889   2.0015   0.0000
      54   bobby       chr5  28787890  28962988   0.9836   0.0000
      55   bobby       chr5  28962989  48272853   2.0080   0.0000
      56   bobby       chr5  48272854 136936564   2.0164   0.0000
      57   bobby       chr5 136936565 179546287   2.0035   0.0000
      58   bobby       chr5 179546288 179546320   0.8543   0.0000
      59   bobby       chr5 179546321 181538259   1.9913   0.0000
      60   bobby       chr6         1  26193811   3.8800   1.8791
      61   bobby       chr6  26193812  26193889   7.1966   1.8327
      62   bobby       chr6  26193890  26194178   5.4952   1.8327
      63   bobby       chr6  26194179  59191910   3.8296   1.8327
      64   bobby       chr6  59191911  64588483   3.7948   1.7948
      65   bobby       chr6  64588484 125172189   2.8655   0.9899
      66   bobby       chr6 125172190 138452921   2.8999   1.0111
      67   bobby       chr6 138452922 138453044   4.0662   0.9995
      68   bobby       chr6 138453045 170805979   2.8794   0.9995
      69   bobby       chr7         1  45477098   4.0401   1.9928
      70   bobby       chr7  45477099  52372657   4.0375   1.9965
      71   bobby       chr7  52372658  52372690   2.4395   0.3985
      72   bobby       chr7  52372691  52718963   3.9893   1.9893
      73   bobby       chr7  52718964  52719049   4.3783   2.0037
      74   bobby       chr7  52719050  57403873   3.9552   1.9515
      75   bobby       chr7  57403874  57436403   1.8959   0.0000
      76   bobby       chr7  57436404  59498943   3.9138   1.9099
      77   bobby       chr7  59498944  78352522   3.8783   1.8774
      78   bobby       chr7  78352523  78452931   3.0521   0.9451
      79   bobby       chr7  78452932  78560889   3.9843   1.9843
      80   bobby       chr7  78560890  78628369   2.9928   1.0012
      81   bobby       chr7  78628370  86215351   4.0466   1.9987
      82   bobby       chr7  86215352  86224384   4.9262   2.0199
      83   bobby       chr7  86224385  98811032   4.0279   1.9812
      84   bobby       chr7  98811033  98811366   4.2705   1.9812
      85   bobby       chr7  98811367 104844620   3.9648   1.9330
      86   bobby       chr7 104844621 104971854   6.1656   1.9946
      87   bobby       chr7 104971855 110753276   4.0427   1.9863
      88   bobby       chr7 110753277 110754404   3.1241   1.1220
      89   bobby       chr7 110754405 126106069   4.0319   2.0022
      90   bobby       chr7 126106070 126458434   1.9744   0.0000
      91   bobby       chr7 126458435 126526846   3.9751   1.8137
      92   bobby       chr7 126526847 126527388   6.0236   2.0197
      93   bobby       chr7 126527389 126527390   8.5808   2.0197
      94   bobby       chr7 126527391 136789102   6.0512   2.0197
      95   bobby       chr7 136789103 136789135   6.9555   2.0197
      96   bobby       chr7 136789136 144316500   5.9835   2.0041
      97   bobby       chr7 144316501 144391700   3.7836   1.8449
      98   bobby       chr7 144391701 144393372   5.7509   2.0037
      99   bobby       chr7 144393373 151049570   3.9680   1.9643
      100  bobby       chr7 151049571 159345973   1.9998   0.0000
      101  bobby       chr8         1  44955504   3.3362   1.5527
      102  bobby       chr8  44955505  77603298   3.3337   1.5538
      103  bobby       chr8  77603299  77605183   3.0915   1.5318
      104  bobby       chr8  77605184  77605540   3.2468   1.5597
      105  bobby       chr8  77605541  77605541   3.4582   1.5597
      106  bobby       chr8  77605542  77606000   3.3004   1.5597
      107  bobby       chr8  77606001  77606003   3.1762   1.5597
      108  bobby       chr8  77606004 111050190   3.3519   1.5597
      109  bobby       chr8 111050191 111050982   3.1339   1.5597
      110  bobby       chr8 111050983 111051101   3.3002   1.5597
      111  bobby       chr8 111051102 111051352   3.1341   1.5597
      112  bobby       chr8 111051353 130235869   3.3521   1.5613
      113  bobby       chr8 130235870 130262400   4.0753   1.6500
      114  bobby       chr8 130262401 145138636   3.3574   1.5621
      115  bobby       chr9         1  28031837   1.9977   0.0000
      116  bobby       chr9  28031838  28031864   0.8962   0.0000
      117  bobby       chr9  28031865  28034300   1.9396   0.0000
      118  bobby       chr9  28034301  28034468   1.0192   0.0000
      119  bobby       chr9  28034469  28059142   2.0366   0.0000
      120  bobby       chr9  28059143  28157693   1.0035   0.0000
      121  bobby       chr9  28157694  30338966   1.9830   0.0000
      122  bobby       chr9  30338967  44377362   3.9405   1.9438
      123  bobby       chr9  44377363 112683467   3.7055   1.7072
      124  bobby       chr9 112683468 138394717   3.6978   1.6972
      125  bobby      chr10         1   7017548   2.0078   0.0000
      126  bobby      chr10   7017549   7090912   2.9305   0.9604
      127  bobby      chr10   7090913   7592409   1.9583   0.0000
      128  bobby      chr10   7592410  15370880   2.8017   0.8168
      129  bobby      chr10  15370881  15371316   2.6001   0.6091
      130  bobby      chr10  15371317  33097525   2.8035   0.8126
      131  bobby      chr10  33097526  35829480   1.9920   0.0000
      132  bobby      chr10  35829481  35830132   1.9532   0.0000
      133  bobby      chr10  35830133  35830199   2.7622   0.0000
      134  bobby      chr10  35830200  40640101   1.9564   0.0000
      135  bobby      chr10  40640102  53716586   2.0028   0.0000
      136  bobby      chr10  53716587  53717137   1.7232   0.0000
      137  bobby      chr10  53717138  58717463   1.9845   0.0000
      138  bobby      chr10  58717464  58717662   3.6708   0.0000
      139  bobby      chr10  58717663  81882050   2.0122   0.0000
      140  bobby      chr10  81882051  82067909   1.8039   0.0000
      141  bobby      chr10  82067910  84297669   1.9902   0.0000
      142  bobby      chr10  84297670  87940542   2.0017   0.0000
      143  bobby      chr10  87940543  87952583   0.0000   0.0000
      144  bobby      chr10  87952584 133797422   2.0155   0.0000
      145  bobby      chr11         1  37438374   3.2305   0.0000
      146  bobby      chr11  37438375  37438553   3.3855   0.0000
      147  bobby      chr11  37438554  40837689   3.1771   0.0000
      148  bobby      chr11  40837690  40838308   2.8937   0.0000
      149  bobby      chr11  40838309  52751710   2.9734   0.0000
      150  bobby      chr11  52751711  79480569   2.9523   0.0000
      151  bobby      chr11  79480570  79480583   3.2647   0.0000
      152  bobby      chr11  79480584  81074557   2.8973   0.0000
      153  bobby      chr11  81074558  81382738   1.5434   0.0000
      154  bobby      chr11  81382739  93286583   2.9099   0.0000
      155  bobby      chr11  93286584 135086622   2.9004   0.0000
      156  bobby      chr12         1  35977329   3.0133   0.9991
      157  bobby      chr12  35977330  72273111   3.0178   1.0029
      158  bobby      chr12  72273112  72273294   4.8018   1.0029
      159  bobby      chr12  72273295  91767369   3.0273   1.0055
      160  bobby      chr12  91767370  91767404   2.1146   0.9899
      161  bobby      chr12  91767405 129287232   2.9861   0.9899
      162  bobby      chr12 129287233 129287234   2.0477   0.9899
      163  bobby      chr12 129287235 133275309   2.9879   0.9978
      164  bobby      chr13         1  17025623   3.1603   1.4423
      165  bobby      chr13  17025624  59982892   3.1603   1.4423
      166  bobby      chr13  59982893 114364328   3.1413   1.4330
      167  bobby      chr14         1  17086761   3.0172   0.0000
      168  bobby      chr14  17086762  40748747   3.0172   0.0000
      169  bobby      chr14  40748748  40774901   3.1562   0.0000
      170  bobby      chr14  40774902  72547940   3.0237   0.0000
      171  bobby      chr14  72547941  72548038   6.2177   0.0000
      172  bobby      chr14  72548039  81371676   3.0112   0.0000
      173  bobby      chr14  81371677  81371677   3.8058   0.0000
      174  bobby      chr14  81371678 104093751   3.0074   0.0000
      175  bobby      chr14 104093752 104093807   1.2377   0.0000
      176  bobby      chr14 104093808 107043718   3.0497   0.0000
      177  bobby      chr15         1  18362626   3.7529   1.7539
      178  bobby      chr15  18362627  23440459   3.7529   1.7539
      179  bobby      chr15  23440460  23440924   4.3044   2.0994
      180  bobby      chr15  23440925  23461731   4.6922   2.0994
      181  bobby      chr15  23461732  23467471   5.9258   2.0994
      182  bobby      chr15  23467472  23472018   4.6704   2.0994
      183  bobby      chr15  23472019  23586512   5.8757   2.0994
      184  bobby      chr15  23586513  23747555   3.8800   1.8800
      185  bobby      chr15  23747556  41329095   2.0053   0.0000
      186  bobby      chr15  41329096  41336310   4.0135   0.0000
      187  bobby      chr15  41336311  84141972   2.0133   0.0000
      188  bobby      chr15  84141973 101991189   4.0177   1.9954
      189  bobby      chr16         1  27024877   3.2850   1.3151
      190  bobby      chr16  27024878  34597000   3.2810   1.2867
      191  bobby      chr16  34597001  36193872   2.0044   0.0109
      192  bobby      chr16  36193873  36197505   2.6067   0.6132
      193  bobby      chr16  36197506  37295919   2.0119   0.0184
      194  bobby      chr16  37295920  58590641   2.0049   0.0000
      195  bobby      chr16  58590642  58629426   0.0126   0.0000
      196  bobby      chr16  58629427  78894739   1.9861   0.0000
      197  bobby      chr16  78894740  79061106   0.9427   0.0000
      198  bobby      chr16  79061107  90338345   1.9972   0.0000
      199  bobby      chr17         1  24849829   2.9948   0.9783
      200  bobby      chr17  24849830  83257441   3.0511   0.9934
      201  bobby      chr18         1   9868619   2.0197   0.0000
      202  bobby      chr18   9868620  18161052   2.8641   0.8177
      203  bobby      chr18  18161053  68712224   2.8484   0.8362
      204  bobby      chr18  68712225  68715589   2.1495   0.8362
      205  bobby      chr18  68715590  80373285   2.8666   0.8417
      206  bobby      chr19         1  17286001   2.8826   0.9042
      207  bobby      chr19  17286002  17286832   2.0157   0.9042
      208  bobby      chr19  17286833  25844926   2.9008   0.9047
      209  bobby      chr19  25844927  30116444   2.9942   0.9319
      210  bobby      chr19  30116445  30116542   3.4253   0.9162
      211  bobby      chr19  30116543  58617616   2.9328   0.9162
      212  bobby      chr20         1  13180081   4.0310   2.0019
      213  bobby      chr20  13180082  13183453   2.1207   0.0000
      214  bobby      chr20  13183454  14982310   3.9910   1.9905
      215  bobby      chr20  14982311  15008178   2.9844   0.9940
      216  bobby      chr20  15008179  15019977   2.5655   0.5750
      217  bobby      chr20  15019978  15033196   1.6123   0.6119
      218  bobby      chr20  15033197  15033302   2.6075   0.9252
      219  bobby      chr20  15033303  15128171   3.6913   1.6824
      220  bobby      chr20  15128172  28237289   4.0213   1.9934
      221  bobby      chr20  28237290  35226721   3.9942   1.9963
      222  bobby      chr20  35226722  35226722   8.1110   1.9657
      223  bobby      chr20  35226723  38645823   4.0015   1.9657
      224  bobby      chr20  38645824  38645824   4.4090   1.9820
      225  bobby      chr20  38645825  38646024   4.8797   1.9820
      226  bobby      chr20  38646025  60314367   4.0158   1.9820
      227  bobby      chr20  60314368  60314680   4.3675   1.9820
      228  bobby      chr20  60314681  62583344   4.0305   1.9946
      229  bobby      chr20  62583345  64444167   4.0630   1.9720
      230  bobby      chr21         1  11890183   2.9947   0.9840
      231  bobby      chr21  11890184  41446814   2.9947   0.9840
      232  bobby      chr21  41446815  41448906   2.6977   0.9840
      233  bobby      chr21  41448907  46709983   3.0424   1.0031
      234  bobby      chr22         1  14004552   3.9946   1.9764
      235  bobby      chr22  14004553  33363263   3.9946   1.9764
      236  bobby      chr22  33363264  33442412   2.8948   0.9133
      237  bobby      chr22  33442413  50818468   3.9822   1.9815

