CLASS zmc_polist_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMC_POLIST_TEST IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.
try.
DATA(lo_rfc_dest) = cl_rfc_destination_provider=>create_by_cloud_destination(
 i_name = |S41_RFCMC|
 i_service_instance_name = |ZSAP_COM_0276_MC| ).


 DATA(lv_destination) = lo_rfc_dest->get_destination_name( ).

  TYPES: BEGIN OF type_partial_po,
             ebeln TYPE c LENGTH 10,
             ebelp TYPE c LENGTH 5,
             bsart TYPE c LENGTH 4,
             bstyp TYPE c LENGTH 1,
             matnr TYPE c LENGTH 40,
             bukrs TYPE c LENGTH 4,
             werks TYPE c LENGTH 4,
             lgort TYPE c LENGTH 4,
             menge TYPE p LENGTH 7 DECIMALS 3,
             meins TYPE c LENGTH 3,
             vgbel TYPE c LENGTH 10,
             vgpos TYPE c LENGTH 6,
             gr    TYPE p LENGTH 7 DECIMALS 3,
             ir    TYPE p LENGTH 7 DECIMALS 3,
             email TYPE c LENGTH 255,
           END OF type_partial_po.

   TYPES: BEGIN OF ty_acdoca,
             rclnt TYPE c LENGTH 3,
             rldnr TYPE c LENGTH 2,
             rbukrs TYPE c LENGTH 4,
             gjahr TYPE c LENGTH 4,
             belnr TYPE c LENGTH 10,
             docln TYPE c LENGTH 6,
             ryear TYPE c LENGTH 4,
           END OF ty_acdoca.

 DATA: msg TYPE c LENGTH 255.
 DATA lt_cust TYPE STANDARD TABLE OF type_partial_po.
 DATA ls_cust TYPE type_partial_po.

 DATA lt_acdoca TYPE STANDARD TABLE OF ty_acdoca.
 data ls_acdoca TYPE ty_acdoca.

 CALL FUNCTION 'ZRFC_GET_PO_DETAILS'
 DESTINATION lv_destination
 tables
 t_orders = lt_cust.


* INSERT ztestpo FROM TABLE @lt_cust.
* CALL FUNCTION 'ZMC_ACDOCA'
* DESTINATION lv_destination
* tables
* t_acdoca = lt_acdoca.
*
* INSERT zmc_acdoca FROM TABLE @lt_acdoca.

 CASE sy-subrc.
 WHEN 0.
* LOOP AT lt_acdoca INTO ls_acdoca.
* if sy-tabix = 1.
* out->write( ls_acdoca-belnr && ',' && ls_acdoca-rldnr ).
* ENDIF.
* ENDLOOP.
 LOOP AT lt_cust INTO ls_cust.
 if sy-tabix = 1.
 out->write( ls_cust-ebeln && ',' && ls_cust-ebelp ).
 ENDIF.
 ENDLOOP.
 WHEN 1.
 out->write( |EXCEPTION SYSTEM_FAILURE | && msg ).
 WHEN 2.
 out->write( |EXCEPTION COMMUNICATION_FAILURE | && msg ).
 WHEN 3.
 out->write( |EXCEPTION OTHERS| ).
 ENDCASE.

CATCH cx_root INTO DATA(lx_root).
 out->write( lx_root->get_text( ) ).

 ENDTRY.
 ENDMETHOD.
ENDCLASS.
