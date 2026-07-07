--MPS RAW
SELECT
    o100754.unit_selling_price * o100754.ordered_quantity ext_price,
    concat(concat(o100754.line_number, '.'),
           o100754.shipment_number)                       order_lines,
    o100754.customer_number                               customer_number,
    o100752.customer_po_number                            customer_purchase_order_numb,
    o100752.date_ordered                                  date_ordered,
    o100365.description                                   description,
    o100365.item_type                                     item_type,
    o100365.item_type_name                                item_type_name,
    o100754.ordered_item                                  ordered_item,
    o100754.ordered_quantity                              ordered_quantity,
    o100752.order_number                                  order_number,
    o100752.order_type                                    order_type,
    o100365.organization_code                             organization_code,
    o100754.promise_date                                  promise_date,
    o100754.request_date                                  request_date,
    o100754.salesperson                                   salesperson,
    o100754.schedule_ship_date                            schedule_ship_date,
    o100754.unit_selling_price                            unit_selling_price,
    o100752.freight_terms                                 freight_terms,
    o100752.created_by_name                               created_by_name,
    o100754.status                                        status,
    o206949.ship_from_org_id                              ship_from_org_id,
    o100754.line_xxom_ship_to_name_2                      ship_to_name,
    o100752.shipping_method                               shipping_method,
    o1083657.motor_type                                   motor_type,
    o1083657.basic_nema_frame_size                        basic_nema_frame_size,
    o1083657.production_line                              production_line,
    o100754.schedule_arrival_date,
    o100754.creation_date                                 AS release_date,
    o100754.ACTUAL_SHIPMENT_DATE,
    o100754.SHIPPED_QUANTITY ,
    nvl((SELECT MAX('Y')
              FROM oe_order_holds_all oha,
                   oe_hold_sources_all ohs,
                   oe_hold_definitions ohd
             WHERE     oha.header_id               = o206949.header_id
                   AND oha.line_id                 = o206949.line_id
                   AND oha.hold_source_id          = ohs.hold_source_id
                   AND NVL(oha.released_flag,'N')  = 'N'
                   AND ohs.hold_id = ohd.hold_id),'N') hold_flag
    --o100754.shipped_quantity
FROM
    invfg_organization_items  o100365,
    oefg_order_headers        o100752,
    oefg_order_lines          o100754,
    apps.ams_oe_order_lines_v o206949,
    (
        SELECT
            sy.segment1             item_name,
            al.name                 organization_name,
            pa.organization_code    organization_code,
            it.organization_id,
            caset.category_set_name category_type_name,
            it.inventory_item_id,
            it.category_set_id,
            it.category_id,
            (
                SELECT
                    cross_reference
                FROM
                    mtl_cross_references
                WHERE
                        inventory_item_id = it.inventory_item_id
                    AND upper(cross_reference_type) = 'EMR STANDARD CATALOG'
                    AND ROWNUM = 1
            )                       catalog_number,
            (
                SELECT
                    element_value
                FROM
                    apps.mtl_descr_element_values_v
                WHERE
                        upper(element_name) = 'MOTOR TYPE'
                    AND inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       motor_type,
            (
                SELECT
                    element_value
                FROM
                    apps.mtl_descr_element_values_v
                WHERE
                        upper(element_name) = 'BASIC NEMA FRAME SIZE'
                    AND inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       basic_nema_frame_size,
            (
                SELECT
                    ca1.segment1
                    || '.'
                    || ca1.segment2
                FROM
                    apps.mtl_categories      ca1,
                    apps.mtl_item_categories it1,
                    apps.mtl_category_sets   caset1
                WHERE
                        it1.category_id = ca1.category_id
                    AND it1.category_set_id = caset1.category_set_id
                    AND upper(caset1.category_set_name) = 'EMC PRODUCTION LINE'
                    AND it1.organization_id = it.organization_id
                    AND it1.inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       production_line
        FROM
            mtl_categories            ca,
            mtl_category_sets         caset,
            mtl_system_items          sy,
            mtl_parameters            pa,
            hr_all_organization_units al,
            mtl_item_categories       it
        WHERE
                it.organization_id = al.organization_id
            AND it.organization_id = pa.organization_id
            AND it.inventory_item_id = sy.inventory_item_id
            AND it.organization_id = sy.organization_id
            AND it.category_set_id = caset.category_set_id
            AND it.category_id = ca.category_id
            AND it.category_set_id IN (
                SELECT
                    it1.category_set_id
                FROM
                    mtl_item_categories it1
                WHERE
                        it1.inventory_item_id = sy.inventory_item_id
                    AND it1.organization_id = sy.organization_id
                    AND ROWNUM = 1
            )  
--AND PA.ORGANIZATION_CODE = 'C55'
            AND hr_security.show_bis_record(it.organization_id) = 'TRUE'
    )                         o1083657
WHERE
    ( ( o100752.header_id = o100754.header_id )
      AND ( o100365.inventory_item_id (+) = o100754.ordered_item_id
            AND o100365.organization_id (+) = o100754.ship_from_org_id )
      AND ( o100752.header_id = o206949.header_id )
      AND ( o206949.line_id = o100754.line_id
            AND o206949.header_id = o100754.header_id
            AND o206949.inventory_item_id = o100754.ordered_item_id
            AND o206949.ship_from_org_id = o100754.ship_from_org_id )
      AND ( o206949.inventory_item_id = o100365.inventory_item_id
            AND o206949.ship_from_org_id = o100365.organization_id )
      AND ( o100754.ship_from_org_id = o100365.organization_id
            AND o100754.ordered_item_id = o100365.inventory_item_id )
      AND ( o1083657.inventory_item_id = o100365.inventory_item_id
            AND o1083657.organization_id = o100365.organization_id )
      AND ( o1083657.inventory_item_id = o100754.ordered_item_id
            AND o1083657.organization_id = o100754.ship_from_org_id ) )
       -- and o100752.order_number = 7899667
     --   and o100754.ordered_item in ('P063FGM1576015B' ,'CH63AAE1004015B')
  /* AND o100365.organization_code like 'C15'
  --  AND o100754.schedule_ship_date > :from_date 
    AND ( o100754.ordered_quantity IS NOT NULL or o100754.ordered_quantity = 0)
    And o100754.status in ('Awaiting Shipping','Entered','On Hold') */
   
ORDER BY
    o100754.ordered_item ASC,
    o100754.schedule_ship_date ASC