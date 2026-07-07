--NMC Master MOTORES - Sheet1
SELECT
    o243345.date_released,
    o100934.mfg_order_name                                                                                          AS "WIP/JOB",
    o100934.item_number,
    o1083657.production_line,
    rtrim(substr(apps.xxinv_get_catalog_details_f(o1083657.inventory_item_id), 276, 25))                            AS "Stack Height",
    rtrim(substr(apps.xxinv_get_catalog_details_f(o1083657.inventory_item_id), 251, 25))                            AS "Number Of Speeds",
    o100934.start_date,
    o100934.completion_date,
	o211221.attribute5 AS "First_completion_date",                 
    o211221.attribute1,
    --o211221.start_quantity - o100934.completed_quantity                                                             AS "Remaining Qty",
    --o211221.Start_quantity,
    o100365.item_type,
    o211221.attribute3,
    o100365.description,
    rtrim(substr(apps.xxinv_get_category_details_f(o1083657.inventory_item_id, o1083657.organization_id), 351, 50)) AS "Motor Type Usage",
    o100934.mfg_order_status,
    o211221.attribute4,
    o100365.inventory_item_status_code,
    o211221.last_update_date,
    o100934.description  Description_1,
    o100934.mfg_order_type,
    o100934.organization_name,
    o1083657.Classification,
    o1083657.Construction_Material,
    o1083657.motor_type,
    o243345.quantity_remaining AS "Remaining Qty",
    o243345.Quantity_Completed,
    o243345.Start_quantity,
    nvl(o1083657.item_cost, 0) AS item_cost,
    nvl(o243345.quantity_remaining * o1083657.item_cost,0 ) AS Total_amount,
    o243345.Total_quantity
FROM
    apps.invfg_organization_items o100365,
    apps.wipfg_mfg_orders         o100934,
    (
        SELECT
            wdj.*,
            to_char(wdj.date_completed, 'YYYY') "Completed Year",
            to_char(wdj.date_completed, 'MON')  "Completed MON",
            to_char(wdj.date_completed, 'MM')   "Completed MM"
        FROM
            wip.wip_discrete_jobs wdj
    )                        o211221,
    (
        SELECT
            we.wip_entity_id                                                    "Mfg Order Id",
            we.wip_entity_name                                                  job,
            msib.segment1                                                       assembly,
            wdj.description                                                     DESCRIPTION,
            wdj.start_quantity                                                  Start_quantity,
            wdj.start_quantity - wdj.quantity_completed - wdj.quantity_scrapped QUANTITY_REMAINING,
            wdj.quantity_completed                                              QUANTITY_COMPLETED,
            wdj.net_quantity AS Total_quantity,
            wdj.lot_number                                                      "LOT NUMBER",
            wdj.date_released,
            wdj.date_completed,
            to_char(wdj.date_completed, 'YYYY')                                 "Year Completed",
            to_char(wdj.date_completed, 'MON')                                  "Month Completed",
            l.meaning                                                           "JOB STATUS",
            mp.organization_code                                                "Organization Code",
            wdj.scheduled_start_date                                            "SCHEDULED START DATE",
            wdj.scheduled_completion_date                                       "SCHEDULED COMPLETION DATE",
            wdj.due_date                                                        "DUE DATE",
            msib.inventory_item_id                                              "INVENTORY ITEM ID",
            wdj.organization_id                                                 "ORGANIZATION ID",
            wdj.attribute1                                                      "REVISED SCHEDULED DATE",
            wdj.attribute2                                                      "REASON CODE",
			wdj.attribute5                                                      "First_completion_date"
            
        FROM
            apps.wip_entities       we,
           apps.wip_discrete_jobs  wdj,
            apps.mtl_system_items_b msib,
            apps.mfg_lookups        l,
            apps.mtl_parameters     mp
        WHERE
                we.wip_entity_id = wdj.wip_entity_id
             --AND we.wip_entity_name = '7891346-1'   
            AND we.primary_item_id = msib.inventory_item_id
            AND we.organization_id = msib.organization_id
            AND wdj.status_type = l.lookup_code
            AND l.lookup_type = 'WIP_JOB_STATUS'
            AND wdj.organization_id = mp.organization_id
    )                        o243345,
    ( /* Formatted on 2008/11/19 16:24 (Formatter Plus v4.8.8) */
        SELECT
            sy.segment1             item_name,
            al.name                 organization_name,
            pa.organization_code    organization_code,
            it.organization_id,
            caset.category_set_name category_type_name,
            decode(ca.structure_id, 101, ca.segment1, 201, ca.segment1,
                   50136, ca.segment1
                          || '.'
                          || ca.segment2
                          || '.'
                          || ca.segment3, 50184, ca.segment1, 50185,
                   ca.segment1, 50226, ca.segment1
                                       || '.'
                                       || ca.segment2, 50227, ca.segment1,
                   50230, ca.segment1
                          || '.'
                          || ca.segment2
                          || '.'
                          || ca.segment3, 50249, ca.segment1, 50250,
                   ca.segment1
                   || '.'
                   || ca.segment2
                   || '.'
                   || ca.segment3
                   || '.'
                   || ca.segment4
                   || '.'
                   || ca.segment5, 50251, ca.segment1, 50271, ca.segment1
                                                              || '.'
                                                              || ca.segment2
                                                              || '.'
                                                              || ca.segment3
                                                              || '.'
                                                              || ca.segment4,
                   50291, ca.segment1, 50292, ca.segment1
                                              || '.'
                                              || ca.segment2, 50293,
                   ca.segment1, 50294, ca.segment1
                                       || '.'
                                       || ca.segment2
                                       || '.'
                                       || ca.segment3
                                       || '.'
                                       || ca.segment4, 50295, ca.segment1
                                                              || '.'
                                                              || ca.segment2,
                   50296, ca.segment1, 50297, ca.segment1, 50298,
                   ca.segment1, 50312, ca.segment1, 50313, ca.segment1
                                                           || ','
                                                           || ca.segment2,
                   50314, ca.segment1
                          || '.'
                          || ca.segment2
                          || '.'
                          || ca.segment3
                          || '.'
                          || ca.segment4
                          || '.'
                          || ca.segment5
                          || '.'
                          || ca.segment6, 50332, ca.segment1
                                                 || '.'
                                                 || ca.segment2
                                                 || '.'
                                                 || ca.segment3
                                                 || '.'
                                                 || ca.segment4
                                                 || '.'
                                                 || ca.segment5
                                                 || '.'
                                                 || ca.segment6
                                                 || '.'
                                                 || ca.segment7, NULL)   category_name,
            it.inventory_item_id,
            it.category_set_id,
            it.category_id,
            (
                SELECT
                    cross_reference
                FROM
                    apps.mtl_cross_references
                WHERE
                        inventory_item_id = it.inventory_item_id
                    AND cross_reference_type = 'EMR Standard Catalog'
                    AND ROWNUM = 1
            )                       catalog_number,
            (
                SELECT
                    description
                FROM
                   apps.fnd_flex_values_vl
                WHERE
                    ( ( '' IS NULL )
                      OR ( structured_hierarchy_level IN (
                        SELECT
                            hierarchy_id
                        FROM
                            apps.fnd_flex_hierarchies_vl h
                        WHERE
                                h.flex_value_set_id = 1010490
                            AND h.hierarchy_name LIKE ''
                    ) ) )
                    AND ( flex_value_set_id = 1010490 )
                    AND flex_value = rtrim(substr(apps.xxinv_get_category_details_f(it.inventory_item_id, it.organization_id), 2051, 50))
            )                       appl_description,
            (
                SELECT
                    nvl(cic.item_cost, cic1.item_cost)
                FROM
                    apps.cst_item_costs cic,
                    apps.cst_item_costs cic1
                WHERE
                        cic.organization_id = 390
                    AND cic.inventory_item_id = it.inventory_item_id
                    AND cic.cost_type_id = 1
                    AND cic1.organization_id = it.organization_id
                    AND cic1.inventory_item_id = it.inventory_item_id
                    AND cic1.cost_type_id = 1
            )                       item_cost,
            (
                SELECT
                    ca1.segment1
                FROM
                    apps.mtl_categories      ca1,
                    apps.mtl_item_categories it1,
                    apps.mtl_category_sets   caset1
                WHERE
                        it1.category_id = ca1.category_id
                    AND it1.category_set_id = caset1.category_set_id
                    AND caset1.category_set_name = 'Frame Size Usage'
                    AND it1.organization_id = it.organization_id
                    AND it1.inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       frame_size_usage,
            (
                SELECT
                    element_value
                FROM
                    apps.mtl_descr_element_values_v
                WHERE
                        element_name = 'Number of Poles'
                    AND inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       number_of_poles,
            (
                SELECT
                    element_value
                FROM
                    apps.mtl_descr_element_values_v
                WHERE
                        element_name = 'Number of Phases'
                    AND inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       number_of_phases,
            (
                SELECT
                    element_value
                FROM
                    apps.mtl_descr_element_values_v
                WHERE
                        element_name = 'Enclosure Description'
                    AND inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       enclosure_description,
            (
                SELECT
                    element_value
                FROM
                    apps.mtl_descr_element_values_v
                WHERE
                        element_name = 'Rated Horsepower'
                    AND inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       rated_horsepower,
            (
                SELECT
                    element_value
                FROM
                    apps.mtl_descr_element_values_v
                WHERE
                        element_name = 'Rated RPM'
                    AND inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       rated_rpm,
            (
                SELECT
                    element_value
                FROM
                    apps.mtl_descr_element_values_v
                WHERE
                        element_name = 'Rated Voltage'
                    AND inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       rated_voltage,
            (
                SELECT
                    element_value
                FROM
                    apps.mtl_descr_element_values_v
                WHERE
                        element_name = 'Motor Type'
                    AND inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       motor_type,
            (
                SELECT
                    element_value
                FROM
                    apps.mtl_descr_element_values_v
                WHERE
                        element_name = 'Basic NEMA Frame Size'
                    AND inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       basic_nema_frame_size,
            (
                SELECT
                    element_value
                FROM
                    apps.mtl_descr_element_values_v
                WHERE
                        element_name = 'NEMA Motor Suffix'
                    AND inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       nema_motor_suffix,
            (
                SELECT
                    element_value
                FROM
                    apps.mtl_descr_element_values_v
                WHERE
                        element_name = 'Rated Frequency'
                    AND inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       rated_frequency,
            (
                SELECT
                    ca1.segment3
                FROM
                    apps.mtl_categories      ca1,
                    apps.mtl_item_categories it1,
                    apps.mtl_category_sets   caset1
                WHERE
                        it1.category_id = ca1.category_id
                    AND it1.category_set_id = caset1.category_set_id
                    AND caset1.category_set_name = 'EMR Product Hierarchy Global'
                    AND it1.organization_id = it.organization_id
                    AND it1.inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       type,
            (
                SELECT
                    ca1.segment2
                FROM
                    apps.mtl_categories      ca1,
                    apps.mtl_item_categories it1,
                    apps.mtl_category_sets   caset1
                WHERE
                        it1.category_id = ca1.category_id
                    AND it1.category_set_id = caset1.category_set_id
                    AND caset1.category_set_name = 'EMC Product Application'
                    AND it1.organization_id = it.organization_id
                    AND it1.inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       application,
            (
                SELECT
                    ca1.segment4
                FROM
                    apps.mtl_categories      ca1,
                    apps.mtl_item_categories it1,
                    apps.mtl_category_sets   caset1
                WHERE
                        it1.category_id = ca1.category_id
                    AND it1.category_set_id = caset1.category_set_id
                    AND caset1.category_set_name = 'EMC Product Application'
                    AND it1.organization_id = it.organization_id
                    AND it1.inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       rating_class,
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
                    AND caset1.category_set_name = 'EMC Production Line'
                    AND it1.organization_id = it.organization_id
                    AND it1.inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       production_line,
            (
                SELECT
                    ca1.segment1              
                FROM
                    apps.mtl_categories      ca1,
                    apps.mtl_item_categories it1,
                    apps.mtl_category_sets   caset1
                WHERE
                        it1.category_id = ca1.category_id
                    AND it1.category_set_id = caset1.category_set_id
                    AND caset1.category_set_name  = 'Classification'      --','Construction Material')
                    AND it1.organization_id = it.organization_id
                    AND it1.inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       Classification,
            (
                SELECT
                    ca1.segment1              
                FROM
                    apps.mtl_categories      ca1,
                    apps.mtl_item_categories it1,
                    apps.mtl_category_sets   caset1
                WHERE
                        it1.category_id = ca1.category_id
                    AND it1.category_set_id = caset1.category_set_id
                    AND caset1.category_set_name  = 'Construction Material'      --','Construction Material')
                    AND it1.organization_id = it.organization_id
                    AND it1.inventory_item_id = it.inventory_item_id
                    AND ROWNUM = 1
            )                       Construction_Material
            
            
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
   --AND pa.organization_code = 'C55'
            --AND hr_security.show_bis_record(it.organization_id) = 'TRUE'
    )                        o1083657
WHERE 
     ( ( o100365.inventory_item_id = o100934.inventory_item_id
        AND o100365.organization_id = o100934.organization_id )
      AND ( o100934.mfg_order_id = o211221.wip_entity_id )
      AND ( o243345."Mfg Order Id" = o100934.mfg_order_id )
      AND ( o1083657.inventory_item_id = o100365.inventory_item_id
            AND o1083657.organization_id = o100365.organization_id ) )
     /*AND ( ( o100934.mfg_order_status = 'Released'
            OR o100934.mfg_order_status = 'On Hold'
            OR o100934.mfg_order_status = 'Unreleased' ) ) 
    AND ( o100934.organization_name = 'CIM IO Plant Monterrey' ) */
   --and o100934.item_number = '2078246-000'
ORDER BY
    o100934.completion_date ASC