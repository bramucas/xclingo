
link(thing,universe).
link(event,thing).
link(activity,event).
link(actions,event).
link(move,actions).
link(locomotion,move).
link(leave,locomotion).
link(walk,locomotion).
link(carry,locomotion).
link(go_to,locomotion).
link(meander_47_7,go_to).
link(meander_47_7_1,meander_47_7).
link(transfer,actions).
link(receive,transfer).
link(obtain,receive).
link(take,obtain).
link(get_13_5_1,obtain).
link(get_13_5_1_1,get_13_5_1).
link(lose,transfer).
link(deliver,transfer).
link(entity,thing).
link(spatial_entity,entity).
link(tangible_entity,spatial_entity).
link(physical_object,tangible_entity).
link(living_entity,physical_object).
link(apple,living_entity).
link(john,living_entity).
link(inanimate_object,physical_object).
link(place,spatial_entity).
link(office,place).
link(actions,universe).
link(integers,universe).
instance(X_G,Y_G):-is_a(X_G,Y_G),universe(X_G),sort_hierarchy_nodes_(Y_G).
instance(X_G,Z_G):-instance(X_G,Y_G),link(Y_G,Z_G),sort_hierarchy_nodes_(Y_G),sort_hierarchy_nodes_(Z_G),universe(X_G).
subsort(X_G,Y_G):-link(X_G,Y_G),sort_hierarchy_nodes_(X_G),sort_hierarchy_nodes_(Y_G).
subsort(X_G,Z_G):-link(X_G,Y_G),subsort(Y_G,Z_G),sort_hierarchy_nodes_(X_G),sort_hierarchy_nodes_(Z_G),sort_hierarchy_nodes_(Y_G).
-subsort(X_G,Y_G):-not  subsort(X_G,Y_G),sort_hierarchy_nodes_(X_G),sort_hierarchy_nodes_(Y_G).
has_parent(X_G):-link(X_G,Y_G),sort_hierarchy_nodes_(Y_G),sort_hierarchy_nodes_(X_G).
-has_parent(X_G):-not  has_parent(X_G),sort_hierarchy_nodes_(X_G).
has_child(X_G):-link(Y_G,X_G),sort_hierarchy_nodes_(X_G),sort_hierarchy_nodes_(Y_G).
-has_child(X_G):-not  has_child(X_G),sort_hierarchy_nodes_(X_G).
source(X_G):--has_child(X_G),sort_hierarchy_nodes_(X_G).
-source(X_G):-not  source(X_G),sort_hierarchy_nodes_(X_G).
sink(X_G):--has_parent(X_G),sort_hierarchy_nodes_(X_G).
-sink(X_G):-not  sink(X_G),sort_hierarchy_nodes_(X_G).
dom_actions_vn_experiencer(X0_G,X1_G):-actions_vn_experiencer(X0_G,X1_G),entity(X1_G),actions(X0_G).
dom_actions_vn_experiencer(X0_G,X1_G):--actions_vn_experiencer(X0_G,X1_G),actions(X0_G),entity(X1_G).
-dom_actions_vn_experiencer(X0_G,X1_G):-not  dom_actions_vn_experiencer(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_event_object(X0_G,X1_G):-event_object(X0_G,X1_G),event(X0_G),entity(X1_G).
dom_event_object(X0_G,X1_G):--event_object(X0_G,X1_G),entity(X1_G),event(X0_G).
-dom_event_object(X0_G,X1_G):-not  dom_event_object(X0_G,X1_G),event(X0_G),entity(X1_G).
dom_event_agent(X0_G,X1_G):-event_agent(X0_G,X1_G),entity(X1_G),event(X0_G).
dom_event_agent(X0_G,X1_G):--event_agent(X0_G,X1_G),event(X0_G),entity(X1_G).
-dom_event_agent(X0_G,X1_G):-not  dom_event_agent(X0_G,X1_G),event(X0_G),entity(X1_G).
dom_event_origin(X0_G,X1_G):-event_origin(X0_G,X1_G),event(X0_G),spatial_entity(X1_G).
dom_event_origin(X0_G,X1_G):--event_origin(X0_G,X1_G),spatial_entity(X1_G),event(X0_G).
-dom_event_origin(X0_G,X1_G):-not  dom_event_origin(X0_G,X1_G),event(X0_G),spatial_entity(X1_G).
dom_actions_vn_asset(X0_G,X1_G):-actions_vn_asset(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_asset(X0_G,X1_G):--actions_vn_asset(X0_G,X1_G),actions(X0_G),thing(X1_G).
-dom_actions_vn_asset(X0_G,X1_G):-not  dom_actions_vn_asset(X0_G,X1_G),actions(X0_G),thing(X1_G).
dom_actions_vn_predicate(X0_G,X1_G):-actions_vn_predicate(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_predicate(X0_G,X1_G):--actions_vn_predicate(X0_G,X1_G),thing(X1_G),actions(X0_G).
-dom_actions_vn_predicate(X0_G,X1_G):-not  dom_actions_vn_predicate(X0_G,X1_G),actions(X0_G),thing(X1_G).
dom_actions_vn_patient(X0_G,X1_G):-actions_vn_patient(X0_G,X1_G),entity(X1_G),actions(X0_G).
dom_actions_vn_patient(X0_G,X1_G):--actions_vn_patient(X0_G,X1_G),entity(X1_G),actions(X0_G).
-dom_actions_vn_patient(X0_G,X1_G):-not  dom_actions_vn_patient(X0_G,X1_G),entity(X1_G),actions(X0_G).
dom_actions_vn_causer(X0_G,X1_G):-actions_vn_causer(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_causer(X0_G,X1_G):--actions_vn_causer(X0_G,X1_G),actions(X0_G),thing(X1_G).
-dom_actions_vn_causer(X0_G,X1_G):-not  dom_actions_vn_causer(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_cotheme(X0_G,X1_G):-actions_vn_cotheme(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_actions_vn_cotheme(X0_G,X1_G):--actions_vn_cotheme(X0_G,X1_G),entity(X1_G),actions(X0_G).
-dom_actions_vn_cotheme(X0_G,X1_G):-not  dom_actions_vn_cotheme(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_event_result(X0_G,X1_G):-event_result(X0_G,X1_G),entity(X1_G),event(X0_G).
dom_event_result(X0_G,X1_G):--event_result(X0_G,X1_G),entity(X1_G),event(X0_G).
-dom_event_result(X0_G,X1_G):-not  dom_event_result(X0_G,X1_G),entity(X1_G),event(X0_G).
dom_actions_vn_extent(X0_G,X1_G):-actions_vn_extent(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_actions_vn_extent(X0_G,X1_G):--actions_vn_extent(X0_G,X1_G),entity(X1_G),actions(X0_G).
-dom_actions_vn_extent(X0_G,X1_G):-not  dom_actions_vn_extent(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_actions_vn_attribute(X0_G,X1_G):-actions_vn_attribute(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_attribute(X0_G,X1_G):--actions_vn_attribute(X0_G,X1_G),actions(X0_G),thing(X1_G).
-dom_actions_vn_attribute(X0_G,X1_G):-not  dom_actions_vn_attribute(X0_G,X1_G),actions(X0_G),thing(X1_G).
-defined_experiencer(X0_G):-not  defined_experiencer(X0_G),event(X0_G).
-defined_beneficiary(X0_G):-not  defined_beneficiary(X0_G),event(X0_G).
dom_actions_vn_time(X0_G,X1_G):-actions_vn_time(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_time(X0_G,X1_G):--actions_vn_time(X0_G,X1_G),thing(X1_G),actions(X0_G).
-dom_actions_vn_time(X0_G,X1_G):-not  dom_actions_vn_time(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_reflexive(X0_G,X1_G):-actions_vn_reflexive(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_reflexive(X0_G,X1_G):--actions_vn_reflexive(X0_G,X1_G),actions(X0_G),thing(X1_G).
-dom_actions_vn_reflexive(X0_G,X1_G):-not  dom_actions_vn_reflexive(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_product(X0_G,X1_G):-actions_vn_product(X0_G,X1_G),entity(X1_G),actions(X0_G).
dom_actions_vn_product(X0_G,X1_G):--actions_vn_product(X0_G,X1_G),actions(X0_G),entity(X1_G).
-dom_actions_vn_product(X0_G,X1_G):-not  dom_actions_vn_product(X0_G,X1_G),actions(X0_G),entity(X1_G).
-defined_agent(X0_G):-not  defined_agent(X0_G),event(X0_G).
dom_actions_vn_agent(X0_G,X1_G):-actions_vn_agent(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_actions_vn_agent(X0_G,X1_G):--actions_vn_agent(X0_G,X1_G),entity(X1_G),actions(X0_G).
-dom_actions_vn_agent(X0_G,X1_G):-not  dom_actions_vn_agent(X0_G,X1_G),entity(X1_G),actions(X0_G).
-defined_path(X0_G):-not  defined_path(X0_G),event(X0_G).
-defined_recipient(X0_G):-not  defined_recipient(X0_G),event(X0_G).
-defined_destination(X0_G):-not  defined_destination(X0_G),event(X0_G).
dom_event_path(X0_G,X1_G):-event_path(X0_G,X1_G),spatial_entity(X1_G),event(X0_G).
dom_event_path(X0_G,X1_G):--event_path(X0_G,X1_G),spatial_entity(X1_G),event(X0_G).
-dom_event_path(X0_G,X1_G):-not  dom_event_path(X0_G,X1_G),event(X0_G),spatial_entity(X1_G).
-has_child(X0_G):-not  has_child(X0_G),sort_hierarchy_nodes_(X0_G).
dom_actions_vn_goal(X0_G,X1_G):-actions_vn_goal(X0_G,X1_G),entity(X1_G),actions(X0_G).
dom_actions_vn_goal(X0_G,X1_G):--actions_vn_goal(X0_G,X1_G),actions(X0_G),entity(X1_G).
-dom_actions_vn_goal(X0_G,X1_G):-not  dom_actions_vn_goal(X0_G,X1_G),actions(X0_G),entity(X1_G).
-defined_site(X0_G):-not  defined_site(X0_G),event(X0_G).
dom_actions_vn_destination(X0_G,X1_G):-actions_vn_destination(X0_G,X1_G),spatial_entity(X1_G),actions(X0_G).
dom_actions_vn_destination(X0_G,X1_G):--actions_vn_destination(X0_G,X1_G),actions(X0_G),spatial_entity(X1_G).
-dom_actions_vn_destination(X0_G,X1_G):-not  dom_actions_vn_destination(X0_G,X1_G),actions(X0_G),spatial_entity(X1_G).
dom_actions_vn_copatient(X0_G,X1_G):-actions_vn_copatient(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_actions_vn_copatient(X0_G,X1_G):--actions_vn_copatient(X0_G,X1_G),entity(X1_G),actions(X0_G).
-dom_actions_vn_copatient(X0_G,X1_G):-not  dom_actions_vn_copatient(X0_G,X1_G),actions(X0_G),entity(X1_G).
-defined_origin(X0_G):-not  defined_origin(X0_G),event(X0_G).
-instance(X0_G,X1_G):-not  instance(X0_G,X1_G),universe(X0_G),sort_hierarchy_nodes_(X1_G).
dom_event_recipient(X0_G,X1_G):-event_recipient(X0_G,X1_G),event(X0_G),entity(X1_G).
dom_event_recipient(X0_G,X1_G):--event_recipient(X0_G,X1_G),event(X0_G),entity(X1_G).
-dom_event_recipient(X0_G,X1_G):-not  dom_event_recipient(X0_G,X1_G),entity(X1_G),event(X0_G).
dom_event_beneficiary(X0_G,X1_G):-event_beneficiary(X0_G,X1_G),living_entity(X1_G),event(X0_G).
dom_event_beneficiary(X0_G,X1_G):--event_beneficiary(X0_G,X1_G),living_entity(X1_G),event(X0_G).
-dom_event_beneficiary(X0_G,X1_G):-not  dom_event_beneficiary(X0_G,X1_G),event(X0_G),living_entity(X1_G).
dom_event_site(X0_G,X1_G):-event_site(X0_G,X1_G),spatial_entity(X1_G),event(X0_G).
dom_event_site(X0_G,X1_G):--event_site(X0_G,X1_G),event(X0_G),spatial_entity(X1_G).
-dom_event_site(X0_G,X1_G):-not  dom_event_site(X0_G,X1_G),event(X0_G),spatial_entity(X1_G).
-defined_base(X0_G):-not  defined_base(X0_G),event(X0_G).
dom_actions_vn_initial_location(X0_G,X1_G):-actions_vn_initial_location(X0_G,X1_G),actions(X0_G),spatial_entity(X1_G).
dom_actions_vn_initial_location(X0_G,X1_G):--actions_vn_initial_location(X0_G,X1_G),spatial_entity(X1_G),actions(X0_G).
-dom_actions_vn_initial_location(X0_G,X1_G):-not  dom_actions_vn_initial_location(X0_G,X1_G),spatial_entity(X1_G),actions(X0_G).
dom_actions_vn_trajectory(X0_G,X1_G):-actions_vn_trajectory(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_trajectory(X0_G,X1_G):--actions_vn_trajectory(X0_G,X1_G),actions(X0_G),thing(X1_G).
-dom_actions_vn_trajectory(X0_G,X1_G):-not  dom_actions_vn_trajectory(X0_G,X1_G),actions(X0_G),thing(X1_G).
-source(X0_G):-not  source(X0_G),sort_hierarchy_nodes_(X0_G).
dom_event_donor(X0_G,X1_G):-event_donor(X0_G,X1_G),entity(X1_G),event(X0_G).
dom_event_donor(X0_G,X1_G):--event_donor(X0_G,X1_G),event(X0_G),entity(X1_G).
-dom_event_donor(X0_G,X1_G):-not  dom_event_donor(X0_G,X1_G),entity(X1_G),event(X0_G).
dom_actions_vn_initial_state(X0_G,X1_G):-actions_vn_initial_state(X0_G,X1_G),entity(X1_G),actions(X0_G).
dom_actions_vn_initial_state(X0_G,X1_G):--actions_vn_initial_state(X0_G,X1_G),entity(X1_G),actions(X0_G).
-dom_actions_vn_initial_state(X0_G,X1_G):-not  dom_actions_vn_initial_state(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_event_base(X0_G,X1_G):-event_base(X0_G,X1_G),thing(X1_G),event(X0_G).
dom_event_base(X0_G,X1_G):--event_base(X0_G,X1_G),event(X0_G),thing(X1_G).
-dom_event_base(X0_G,X1_G):-not  dom_event_base(X0_G,X1_G),event(X0_G),thing(X1_G).
-defined_donor(X0_G):-not  defined_donor(X0_G),event(X0_G).
-sink(X0_G):-not  sink(X0_G),sort_hierarchy_nodes_(X0_G).
dom_actions_vn_recipient(X0_G,X1_G):-actions_vn_recipient(X0_G,X1_G),entity(X1_G),actions(X0_G).
dom_actions_vn_recipient(X0_G,X1_G):--actions_vn_recipient(X0_G,X1_G),entity(X1_G),actions(X0_G).
-dom_actions_vn_recipient(X0_G,X1_G):-not  dom_actions_vn_recipient(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_actions_vn_value(X0_G,X1_G):-actions_vn_value(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_value(X0_G,X1_G):--actions_vn_value(X0_G,X1_G),actions(X0_G),thing(X1_G).
-dom_actions_vn_value(X0_G,X1_G):-not  dom_actions_vn_value(X0_G,X1_G),actions(X0_G),thing(X1_G).
dom_event_instrument(X0_G,X1_G):-event_instrument(X0_G,X1_G),entity(X1_G),event(X0_G).
dom_event_instrument(X0_G,X1_G):--event_instrument(X0_G,X1_G),entity(X1_G),event(X0_G).
-dom_event_instrument(X0_G,X1_G):-not  dom_event_instrument(X0_G,X1_G),event(X0_G),entity(X1_G).
-defined_toward(X0_G):-not  defined_toward(X0_G),event(X0_G).
-defined_raw_material(X0_G):-not  defined_raw_material(X0_G),event(X0_G).
dom_actions_vn_result(X0_G,X1_G):-actions_vn_result(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_result(X0_G,X1_G):--actions_vn_result(X0_G,X1_G),thing(X1_G),actions(X0_G).
-dom_actions_vn_result(X0_G,X1_G):-not  dom_actions_vn_result(X0_G,X1_G),thing(X1_G),actions(X0_G).
-defined_object(X0_G):-not  defined_object(X0_G),event(X0_G).
-defined_instrument(X0_G):-not  defined_instrument(X0_G),event(X0_G).
-is_a(X0_G,X1_G):-not  is_a(X0_G,X1_G),sort_hierarchy_nodes_(X1_G),universe(X0_G).
-has_parent(X0_G):-not  has_parent(X0_G),sort_hierarchy_nodes_(X0_G).
-defined_away_from(X0_G):-not  defined_away_from(X0_G),event(X0_G).
dom_actions_vn_cause(X0_G,X1_G):-actions_vn_cause(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_cause(X0_G,X1_G):--actions_vn_cause(X0_G,X1_G),actions(X0_G),thing(X1_G).
-dom_actions_vn_cause(X0_G,X1_G):-not  dom_actions_vn_cause(X0_G,X1_G),actions(X0_G),thing(X1_G).
dom_event_raw_material(X0_G,X1_G):-event_raw_material(X0_G,X1_G),tangible_entity(X1_G),event(X0_G).
dom_event_raw_material(X0_G,X1_G):--event_raw_material(X0_G,X1_G),tangible_entity(X1_G),event(X0_G).
-dom_event_raw_material(X0_G,X1_G):-not  dom_event_raw_material(X0_G,X1_G),event(X0_G),tangible_entity(X1_G).
dom_event_away_from(X0_G,X1_G):-event_away_from(X0_G,X1_G),event(X0_G),spatial_entity(X1_G).
dom_event_away_from(X0_G,X1_G):--event_away_from(X0_G,X1_G),spatial_entity(X1_G),event(X0_G).
-dom_event_away_from(X0_G,X1_G):-not  dom_event_away_from(X0_G,X1_G),event(X0_G),spatial_entity(X1_G).
dom_actions_vn_actor(X0_G,X1_G):-actions_vn_actor(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_actions_vn_actor(X0_G,X1_G):--actions_vn_actor(X0_G,X1_G),actions(X0_G),entity(X1_G).
-dom_actions_vn_actor(X0_G,X1_G):-not  dom_actions_vn_actor(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_event_destination(X0_G,X1_G):-event_destination(X0_G,X1_G),spatial_entity(X1_G),event(X0_G).
dom_event_destination(X0_G,X1_G):--event_destination(X0_G,X1_G),spatial_entity(X1_G),event(X0_G).
-dom_event_destination(X0_G,X1_G):-not  dom_event_destination(X0_G,X1_G),spatial_entity(X1_G),event(X0_G).
dom_actions_vn_topic(X0_G,X1_G):-actions_vn_topic(X0_G,X1_G),actions(X0_G),thing(X1_G).
dom_actions_vn_topic(X0_G,X1_G):--actions_vn_topic(X0_G,X1_G),actions(X0_G),thing(X1_G).
-dom_actions_vn_topic(X0_G,X1_G):-not  dom_actions_vn_topic(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_event_experiencer(X0_G,X1_G):-event_experiencer(X0_G,X1_G),entity(X1_G),event(X0_G).
dom_event_experiencer(X0_G,X1_G):--event_experiencer(X0_G,X1_G),event(X0_G),entity(X1_G).
-dom_event_experiencer(X0_G,X1_G):-not  dom_event_experiencer(X0_G,X1_G),event(X0_G),entity(X1_G).
-defined_result(X0_G):-not  defined_result(X0_G),event(X0_G).
dom_actions_vn_beneficiary(X0_G,X1_G):-actions_vn_beneficiary(X0_G,X1_G),actions(X0_G),living_entity(X1_G).
dom_actions_vn_beneficiary(X0_G,X1_G):--actions_vn_beneficiary(X0_G,X1_G),living_entity(X1_G),actions(X0_G).
-dom_actions_vn_beneficiary(X0_G,X1_G):-not  dom_actions_vn_beneficiary(X0_G,X1_G),actions(X0_G),living_entity(X1_G).
dom_actions_vn_pivot(X0_G,X1_G):-actions_vn_pivot(X0_G,X1_G),thing(X1_G),actions(X0_G).
dom_actions_vn_pivot(X0_G,X1_G):--actions_vn_pivot(X0_G,X1_G),actions(X0_G),thing(X1_G).
-dom_actions_vn_pivot(X0_G,X1_G):-not  dom_actions_vn_pivot(X0_G,X1_G),actions(X0_G),thing(X1_G).
dom_actions_vn_source(X0_G,X1_G):-actions_vn_source(X0_G,X1_G),actions(X0_G),spatial_entity(X1_G).
dom_actions_vn_source(X0_G,X1_G):--actions_vn_source(X0_G,X1_G),spatial_entity(X1_G),actions(X0_G).
-dom_actions_vn_source(X0_G,X1_G):-not  dom_actions_vn_source(X0_G,X1_G),spatial_entity(X1_G),actions(X0_G).
dom_actions_vn_material(X0_G,X1_G):-actions_vn_material(X0_G,X1_G),entity(X1_G),actions(X0_G).
dom_actions_vn_material(X0_G,X1_G):--actions_vn_material(X0_G,X1_G),entity(X1_G),actions(X0_G).
-dom_actions_vn_material(X0_G,X1_G):-not  dom_actions_vn_material(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_actions_vn_coagent(X0_G,X1_G):-actions_vn_coagent(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_actions_vn_coagent(X0_G,X1_G):--actions_vn_coagent(X0_G,X1_G),entity(X1_G),actions(X0_G).
-dom_actions_vn_coagent(X0_G,X1_G):-not  dom_actions_vn_coagent(X0_G,X1_G),entity(X1_G),actions(X0_G).
dom_actions_vn_location(X0_G,X1_G):-actions_vn_location(X0_G,X1_G),spatial_entity(X1_G),actions(X0_G).
dom_actions_vn_location(X0_G,X1_G):--actions_vn_location(X0_G,X1_G),actions(X0_G),spatial_entity(X1_G).
-dom_actions_vn_location(X0_G,X1_G):-not  dom_actions_vn_location(X0_G,X1_G),actions(X0_G),spatial_entity(X1_G).
dom_actions_vn_theme(X0_G,X1_G):-actions_vn_theme(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_actions_vn_theme(X0_G,X1_G):--actions_vn_theme(X0_G,X1_G),entity(X1_G),actions(X0_G).
-dom_actions_vn_theme(X0_G,X1_G):-not  dom_actions_vn_theme(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_actions_vn_instrument(X0_G,X1_G):-actions_vn_instrument(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_actions_vn_instrument(X0_G,X1_G):--actions_vn_instrument(X0_G,X1_G),entity(X1_G),actions(X0_G).
-dom_actions_vn_instrument(X0_G,X1_G):-not  dom_actions_vn_instrument(X0_G,X1_G),actions(X0_G),entity(X1_G).
dom_event_toward(X0_G,X1_G):-event_toward(X0_G,X1_G),spatial_entity(X1_G),event(X0_G).
dom_event_toward(X0_G,X1_G):--event_toward(X0_G,X1_G),spatial_entity(X1_G),event(X0_G).
-dom_event_toward(X0_G,X1_G):-not  dom_event_toward(X0_G,X1_G),spatial_entity(X1_G),event(X0_G).
dom_actions_vn_stimulus(X0_G,X1_G):-actions_vn_stimulus(X0_G,X1_G),actions(X0_G),thing(X1_G).
dom_actions_vn_stimulus(X0_G,X1_G):--actions_vn_stimulus(X0_G,X1_G),actions(X0_G),thing(X1_G).
-dom_actions_vn_stimulus(X0_G,X1_G):-not  dom_actions_vn_stimulus(X0_G,X1_G),thing(X1_G),actions(X0_G).
-subsort(X0_G,X1_G):-not  subsort(X0_G,X1_G),sort_hierarchy_nodes_(X0_G),sort_hierarchy_nodes_(X1_G).
-link(X0_G,X1_G):-not  link(X0_G,X1_G),sort_hierarchy_nodes_(X0_G),sort_hierarchy_nodes_(X1_G).
:-instance(X_G,move),-defined_object(X_G),event(X_G),universe(X_G).
:-instance(X_G,move),event_object(X_G,O_G),-instance(O_G,tangible_entity),universe(O_G),universe(X_G),event(X_G),entity(O_G).
:-instance(X_G,move),event_origin(X_G,Or_G),-instance(Or_G,spatial_entity),universe(X_G),spatial_entity(Or_G),event(X_G),universe(Or_G).
:-instance(X_G,move),event_destination(X_G,D_G),-instance(D_G,spatial_entity),universe(D_G),spatial_entity(D_G),event(X_G),universe(X_G).
:-instance(X_G,move),event_away_from(X_G,Aw_G),-instance(Aw_G,spatial_entity),event(X_G),universe(X_G),spatial_entity(Aw_G),universe(Aw_G).
:-instance(X_G,move),event_toward(X_G,T_G),-instance(T_G,spatial_entity),universe(X_G),event(X_G),spatial_entity(T_G),universe(T_G).
:-instance(X_G,move),event_path(X_G,P_G),-instance(P_G,spatial_entity),universe(P_G),spatial_entity(P_G),universe(X_G),event(X_G).
:-instance(X_G,move),event_object(X_G,Y_G),event_origin(X_G,Y_G),event(X_G),spatial_entity(Y_G),universe(X_G),entity(Y_G).
:-instance(X_G,move),event_object(X_G,Y_G),event_destination(X_G,Y_G),universe(X_G),event(X_G),spatial_entity(Y_G),entity(Y_G).
:-instance(X_G,move),event_object(X_G,Y_G),event_away_from(X_G,Y_G),event(X_G),spatial_entity(Y_G),universe(X_G),entity(Y_G).
:-instance(X_G,move),event_object(X_G,Y_G),event_toward(X_G,Y_G),universe(X_G),entity(Y_G),event(X_G),spatial_entity(Y_G).
:-instance(X_G,move),event_object(X_G,Y_G),event_path(X_G,Y_G),entity(Y_G),spatial_entity(Y_G),event(X_G),universe(X_G).
-event_origin(X_G,Or1_G):-instance(X_G,move),event_origin(X_G,Or_G),spatial_entity(Or1_G),spatial_entity(Or_G),Or1_G!=Or_G,event(X_G),universe(X_G).
-event_destination(X_G,D1_G):-instance(X_G,move),event_destination(X_G,D_G),spatial_entity(D1_G),spatial_entity(D_G),D1_G!=D_G,universe(X_G),event(X_G).
:-instance(X_G,locomotion),-defined_agent(X_G),event(X_G),universe(X_G).
:-instance(X_G,carry),-defined_agent(X_G),event(X_G),universe(X_G).
:-instance(X_G,carry),event_agent(X_G,A_G),-instance(A_G,tangible_entity),entity(A_G),universe(X_G),event(X_G),universe(A_G).
:-instance(X_G,go_to),-defined_destination(X_G),universe(X_G),event(X_G).
:-instance(X_G,leave),-defined_origin(X_G),event(X_G),universe(X_G).
event_object(X_G,Y_G):-instance(X_G,locomotion),event_agent(X_G,Y_G),event(X_G),entity(Y_G),universe(X_G).
event_agent(X_G,Y_G):-instance(X_G,locomotion),event_object(X_G,Y_G),universe(X_G),event(X_G),entity(Y_G).
event_agent(X_G,Y_G):-instance(X_G,meander_47_7),actions_vn_theme(X_G,Y_G),event(X_G),entity(Y_G),universe(X_G),actions(X_G).
event_destination(X_G,Y_G):-instance(X_G,meander_47_7),actions_vn_location(X_G,Y_G),event(X_G),spatial_entity(Y_G),universe(X_G),actions(X_G).
event_agent(X_G,Y_G):-instance(X_G,meander_47_7_1),actions_vn_theme(X_G,Y_G),entity(Y_G),universe(X_G),actions(X_G),event(X_G).
event_destination(X_G,Y_G):-instance(X_G,meander_47_7_1),actions_vn_location(X_G,Y_G),event(X_G),universe(X_G),spatial_entity(Y_G),actions(X_G).
:-instance(X_G,transfer),-defined_object(X_G),universe(X_G),event(X_G).
:-instance(X_G,transfer),event_donor(X_G,D_G),-instance(D_G,tangible_entity),universe(X_G),event(X_G),entity(D_G),universe(D_G).
:-instance(X_G,transfer),event_recipient(X_G,Y_G),event_donor(X_G,Y_G),universe(X_G),entity(Y_G),event(X_G).
:-instance(X_G,deliver),-defined_recipient(X_G),event(X_G),universe(X_G).
:-instance(X_G,deliver),event_recipient(X_G,R_G),-instance(R_G,tangible_entity),universe(R_G),universe(X_G),event(X_G),entity(R_G).
:-instance(X_G,deliver),event_donor(X_G,Y_G),event_agent(X_G,Y_G),entity(Y_G),event(X_G),universe(X_G).
:-instance(X_G,deliver),event_recipient(X_G,Y_G),event_agent(X_G,Y_G),entity(Y_G),event(X_G),universe(X_G).
:-instance(X_G,lose),-defined_donor(X_G),universe(X_G),event(X_G).
:-instance(X_G,lose),event_donor(X_G,D_G),-instance(D_G,tangible_entity),universe(X_G),universe(D_G),event(X_G),entity(D_G).
:-instance(X_G,receive),-defined_recipient(X_G),event(X_G),universe(X_G).
event_agent(X_G,Y_G):-instance(X_G,receive),event_recipient(X_G,Y_G),universe(X_G),entity(Y_G),event(X_G).
event_recipient(X_G,Y_G):-instance(X_G,receive),event_agent(X_G,Y_G),universe(X_G),event(X_G),entity(Y_G).
:-instance(X_G,take),-defined_donor(X_G),event(X_G),universe(X_G).
:-instance(X_G,take),event_donor(X_G,D_G),-instance(D_G,tangible_entity),event(X_G),entity(D_G),universe(X_G),universe(D_G).
event_agent(A_G,B_G):-instance(A_G,get_13_5_1),actions_vn_agent(A_G,B_G),universe(A_G),entity(B_G),event(A_G),actions(A_G).
event_object(A_G,B_G):-instance(A_G,get_13_5_1),actions_vn_asset(A_G,B_G),universe(A_G),entity(B_G),actions(A_G),thing(B_G),event(A_G).
event_donor(A_G,B_G):-instance(A_G,get_13_5_1),actions_vn_source(A_G,B_G),event(A_G),spatial_entity(B_G),entity(B_G),actions(A_G),universe(A_G).
event_recipient(A_G,B_G):-instance(A_G,get_13_5_1),actions_vn_beneficiary(A_G,B_G),entity(B_G),living_entity(B_G),event(A_G),universe(A_G),actions(A_G).
event_object(A_G,B_G):-instance(A_G,get_13_5_1),actions_vn_theme(A_G,B_G),entity(B_G),event(A_G),actions(A_G),universe(A_G).
event_agent(A_G,B_G):-instance(A_G,get_13_5_1_1),actions_vn_agent(A_G,B_G),event(A_G),actions(A_G),entity(B_G),universe(A_G).
event_object(A_G,B_G):-instance(A_G,get_13_5_1_1),actions_vn_asset(A_G,B_G),event(A_G),thing(B_G),actions(A_G),entity(B_G),universe(A_G).
event_recipient(A_G,B_G):-instance(A_G,get_13_5_1_1),actions_vn_beneficiary(A_G,B_G),actions(A_G),living_entity(B_G),entity(B_G),event(A_G),universe(A_G).
event_donor(A_G,B_G):-instance(A_G,get_13_5_1_1),actions_vn_source(A_G,B_G),event(A_G),universe(A_G),entity(B_G),actions(A_G),spatial_entity(B_G).
event_object(A_G,B_G):-instance(A_G,get_13_5_1_1),actions_vn_theme(A_G,B_G),actions(A_G),entity(B_G),universe(A_G),event(A_G).
defined_agent(X_G):-event_agent(X_G,Y_G),entity(Y_G),event(X_G).
defined_object(X_G):-event_object(X_G,Y_G),event(X_G),entity(Y_G).
defined_base(X_G):-event_base(X_G,Y_G),thing(Y_G),event(X_G).
defined_experiencer(X_G):-event_experiencer(X_G,Y_G),event(X_G),entity(Y_G).
defined_instrument(X_G):-event_instrument(X_G,Y_G),event(X_G),entity(Y_G).
defined_donor(X_G):-event_donor(X_G,Y_G),event(X_G),entity(Y_G).
defined_recipient(X_G):-event_recipient(X_G,Y_G),event(X_G),entity(Y_G).
defined_beneficiary(X_G):-event_beneficiary(X_G,Y_G),event(X_G),living_entity(Y_G).
defined_raw_material(X_G):-event_raw_material(X_G,Y_G),event(X_G),tangible_entity(Y_G).
defined_result(X_G):-event_result(X_G,Y_G),entity(Y_G),event(X_G).
defined_origin(X_G):-event_origin(X_G,Y_G),event(X_G),spatial_entity(Y_G).
defined_destination(X_G):-event_destination(X_G,Y_G),spatial_entity(Y_G),event(X_G).
defined_away_from(X_G):-event_away_from(X_G,Y_G),spatial_entity(Y_G),event(X_G).
defined_site(X_G):-event_site(X_G,Y_G),spatial_entity(Y_G),event(X_G).
defined_path(X_G):-event_path(X_G,Y_G),spatial_entity(Y_G),event(X_G).
defined_toward(X_G):-event_toward(X_G,Y_G),spatial_entity(Y_G),event(X_G).
is_a(r1,john).
is_a(r2,apple).
is_a(r3,office).
is_a(e1,get_13_5_1):-instance(r1,entity),instance(r2,entity).
is_a(e2,meander_47_7):-instance(r1,entity),instance(r3,spatial_entity).
actions_vn_agent(e1,r1):-instance(r1,entity).
actions_vn_theme(e1,r2):-instance(r1,entity),instance(r2,entity).
actions_vn_theme(e2,r1):-instance(r1,entity).
actions_vn_location(e2,r3):-instance(r1,entity),instance(r3,spatial_entity).
is_touching(X0_G,X1_G,VAR_0):-is_touching(X0_G,X1_G,I_G),not  -is_touching(X0_G,X1_G,VAR_1),dom_is_touching(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,tangible_entity(X0_G),timeStep(VAR_0),tangible_entity(X1_G),timeStep(I_G),timeStep(VAR_1),timeStep(VAR_2).
-is_touching(X0_G,X1_G,VAR_0):--is_touching(X0_G,X1_G,I_G),not  is_touching(X0_G,X1_G,VAR_1),dom_is_touching(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,tangible_entity(X0_G),tangible_entity(X1_G),timeStep(VAR_2),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G).
dom_is_touching(X0_G,X1_G,I_G):-is_touching(X0_G,X1_G,I_G),tangible_entity(X1_G),tangible_entity(X0_G),timeStep(I_G).
dom_is_touching(X0_G,X1_G,I_G):--is_touching(X0_G,X1_G,I_G),tangible_entity(X0_G),tangible_entity(X1_G),timeStep(I_G).
dom_is_touching(X0_G,X1_G,VAR_0):-dom_is_touching(X0_G,X1_G,I_G),not  -dom_is_touching(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(VAR_1),tangible_entity(X0_G),tangible_entity(X1_G),timeStep(I_G),timeStep(VAR_0).
-dom_is_touching(X0_G,X1_G,VAR_0):--dom_is_touching(X0_G,X1_G,I_G),not  dom_is_touching(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X0_G),timeStep(I_G),timeStep(VAR_1),timeStep(VAR_0),tangible_entity(X1_G).
is_over(X0_G,X1_G,VAR_0):-is_over(X0_G,X1_G,I_G),not  -is_over(X0_G,X1_G,VAR_1),dom_is_over(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_2),timeStep(VAR_0),timeStep(I_G),timeStep(VAR_1).
-is_over(X0_G,X1_G,VAR_0):--is_over(X0_G,X1_G,I_G),not  is_over(X0_G,X1_G,VAR_1),dom_is_over(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(I_G),spatial_entity(X0_G),timeStep(VAR_2),spatial_entity(X1_G),timeStep(VAR_0),timeStep(VAR_1).
dom_is_over(X0_G,X1_G,I_G):-is_over(X0_G,X1_G,I_G),spatial_entity(X1_G),spatial_entity(X0_G),timeStep(I_G).
dom_is_over(X0_G,X1_G,I_G):--is_over(X0_G,X1_G,I_G),spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G).
dom_is_over(X0_G,X1_G,VAR_0):-dom_is_over(X0_G,X1_G,I_G),not  -dom_is_over(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X0_G),spatial_entity(X1_G),timeStep(I_G),timeStep(VAR_1),timeStep(VAR_0).
-dom_is_over(X0_G,X1_G,VAR_0):--dom_is_over(X0_G,X1_G,I_G),not  dom_is_over(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_1),timeStep(VAR_0),timeStep(I_G).
is_blocked(X0_G,VAR_0):-is_blocked(X0_G,I_G),not  -is_blocked(X0_G,VAR_1),dom_is_blocked(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_0),spatial_entity(X0_G),timeStep(VAR_1),timeStep(VAR_2),timeStep(I_G).
-is_blocked(X0_G,VAR_0):--is_blocked(X0_G,I_G),not  is_blocked(X0_G,VAR_1),dom_is_blocked(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),timeStep(VAR_2),timeStep(VAR_1),timeStep(I_G),timeStep(VAR_0).
dom_is_blocked(X0_G,I_G):-is_blocked(X0_G,I_G),spatial_entity(X0_G),timeStep(I_G).
dom_is_blocked(X0_G,I_G):--is_blocked(X0_G,I_G),spatial_entity(X0_G),timeStep(I_G).
dom_is_blocked(X0_G,VAR_0):-dom_is_blocked(X0_G,I_G),not  -dom_is_blocked(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(I_G),timeStep(VAR_0),spatial_entity(X0_G),timeStep(VAR_1).
-dom_is_blocked(X0_G,VAR_0):--dom_is_blocked(X0_G,I_G),not  dom_is_blocked(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(VAR_0),timeStep(I_G),spatial_entity(X0_G),timeStep(VAR_1).
is_behind(X0_G,X1_G,VAR_0):-is_behind(X0_G,X1_G,I_G),not  -is_behind(X0_G,X1_G,VAR_1),dom_is_behind(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_2),spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G).
-is_behind(X0_G,X1_G,VAR_0):--is_behind(X0_G,X1_G,I_G),not  is_behind(X0_G,X1_G,VAR_1),dom_is_behind(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_0),timeStep(I_G),spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_2),timeStep(VAR_1).
dom_is_behind(X0_G,X1_G,I_G):-is_behind(X0_G,X1_G,I_G),timeStep(I_G),spatial_entity(X1_G),spatial_entity(X0_G).
dom_is_behind(X0_G,X1_G,I_G):--is_behind(X0_G,X1_G,I_G),timeStep(I_G),spatial_entity(X1_G),spatial_entity(X0_G).
dom_is_behind(X0_G,X1_G,VAR_0):-dom_is_behind(X0_G,X1_G,I_G),not  -dom_is_behind(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X0_G),timeStep(VAR_1),timeStep(I_G),spatial_entity(X1_G),timeStep(VAR_0).
-dom_is_behind(X0_G,X1_G,VAR_0):--dom_is_behind(X0_G,X1_G,I_G),not  dom_is_behind(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G).
is_known(X0_G,VAR_0):-is_known(X0_G,I_G),not  -is_known(X0_G,VAR_1),dom_is_known(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,entity(X0_G),timeStep(VAR_1),timeStep(VAR_0),timeStep(I_G),timeStep(VAR_2).
-is_known(X0_G,VAR_0):--is_known(X0_G,I_G),not  is_known(X0_G,VAR_1),dom_is_known(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_1),timeStep(VAR_2),timeStep(VAR_0),timeStep(I_G),entity(X0_G).
dom_is_known(X0_G,I_G):-is_known(X0_G,I_G),entity(X0_G),timeStep(I_G).
dom_is_known(X0_G,I_G):--is_known(X0_G,I_G),entity(X0_G),timeStep(I_G).
dom_is_known(X0_G,VAR_0):-dom_is_known(X0_G,I_G),not  -dom_is_known(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(I_G),entity(X0_G),timeStep(VAR_1),timeStep(VAR_0).
-dom_is_known(X0_G,VAR_0):--dom_is_known(X0_G,I_G),not  dom_is_known(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(VAR_0),timeStep(I_G),entity(X0_G),timeStep(VAR_1).
is_between(X0_G,X1_G,VAR_0):-is_between(X0_G,X1_G,I_G),not  -is_between(X0_G,X1_G,VAR_1),dom_is_between(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(I_G),timeStep(VAR_1),spatial_entity(X1_G),timeStep(VAR_0),spatial_entity(X0_G),timeStep(VAR_2).
-is_between(X0_G,X1_G,VAR_0):--is_between(X0_G,X1_G,I_G),not  is_between(X0_G,X1_G,VAR_1),dom_is_between(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_1),timeStep(VAR_2),timeStep(I_G),timeStep(VAR_0).
dom_is_between(X0_G,X1_G,I_G):-is_between(X0_G,X1_G,I_G),spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G).
dom_is_between(X0_G,X1_G,I_G):--is_between(X0_G,X1_G,I_G),spatial_entity(X0_G),spatial_entity(X1_G),timeStep(I_G).
dom_is_between(X0_G,X1_G,VAR_0):-dom_is_between(X0_G,X1_G,I_G),not  -dom_is_between(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(VAR_0),spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_1),timeStep(I_G).
-dom_is_between(X0_G,X1_G,VAR_0):--dom_is_between(X0_G,X1_G,I_G),not  dom_is_between(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),timeStep(VAR_0),timeStep(VAR_1),spatial_entity(X0_G),timeStep(I_G).
contained_in(X0_G,X1_G,VAR_0):-contained_in(X0_G,X1_G,I_G),not  -contained_in(X0_G,X1_G,VAR_1),dom_contained_in(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,tangible_entity(X0_G),timeStep(VAR_2),timeStep(I_G),tangible_entity(X1_G),timeStep(VAR_1),timeStep(VAR_0).
-contained_in(X0_G,X1_G,VAR_0):--contained_in(X0_G,X1_G,I_G),not  contained_in(X0_G,X1_G,VAR_1),dom_contained_in(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,tangible_entity(X0_G),timeStep(VAR_2),tangible_entity(X1_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G).
dom_contained_in(X0_G,X1_G,I_G):-contained_in(X0_G,X1_G,I_G),tangible_entity(X0_G),timeStep(I_G),tangible_entity(X1_G).
dom_contained_in(X0_G,X1_G,I_G):--contained_in(X0_G,X1_G,I_G),timeStep(I_G),tangible_entity(X1_G),tangible_entity(X0_G).
dom_contained_in(X0_G,X1_G,VAR_0):-dom_contained_in(X0_G,X1_G,I_G),not  -dom_contained_in(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X1_G),timeStep(VAR_0),tangible_entity(X0_G),timeStep(VAR_1),timeStep(I_G).
-dom_contained_in(X0_G,X1_G,VAR_0):--dom_contained_in(X0_G,X1_G,I_G),not  dom_contained_in(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X0_G),tangible_entity(X1_G),timeStep(VAR_1),timeStep(VAR_0),timeStep(I_G).
is_outside(X0_G,X1_G,VAR_0):-is_outside(X0_G,X1_G,I_G),not  -is_outside(X0_G,X1_G,VAR_1),dom_is_outside(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_0),timeStep(VAR_2),spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_1),timeStep(I_G).
-is_outside(X0_G,X1_G,VAR_0):--is_outside(X0_G,X1_G,I_G),not  is_outside(X0_G,X1_G,VAR_1),dom_is_outside(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),timeStep(VAR_0),timeStep(I_G),spatial_entity(X1_G),timeStep(VAR_1),timeStep(VAR_2).
dom_is_outside(X0_G,X1_G,I_G):-is_outside(X0_G,X1_G,I_G),spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G).
dom_is_outside(X0_G,X1_G,I_G):--is_outside(X0_G,X1_G,I_G),timeStep(I_G),spatial_entity(X1_G),spatial_entity(X0_G).
dom_is_outside(X0_G,X1_G,VAR_0):-dom_is_outside(X0_G,X1_G,I_G),not  -dom_is_outside(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X0_G),timeStep(I_G),timeStep(VAR_1),timeStep(VAR_0),spatial_entity(X1_G).
-dom_is_outside(X0_G,X1_G,VAR_0):--dom_is_outside(X0_G,X1_G,I_G),not  dom_is_outside(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),timeStep(I_G),timeStep(VAR_1),spatial_entity(X0_G),timeStep(VAR_0).
is_held(X0_G,VAR_0):-is_held(X0_G,I_G),not  -is_held(X0_G,VAR_1),dom_is_held(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,tangible_entity(X0_G),timeStep(I_G),timeStep(VAR_2),timeStep(VAR_1),timeStep(VAR_0).
-is_held(X0_G,VAR_0):--is_held(X0_G,I_G),not  is_held(X0_G,VAR_1),dom_is_held(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_2),tangible_entity(X0_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G).
dom_is_held(X0_G,I_G):-is_held(X0_G,I_G),tangible_entity(X0_G),timeStep(I_G).
dom_is_held(X0_G,I_G):--is_held(X0_G,I_G),tangible_entity(X0_G),timeStep(I_G).
dom_is_held(X0_G,VAR_0):-dom_is_held(X0_G,I_G),not  -dom_is_held(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(I_G),tangible_entity(X0_G),timeStep(VAR_0),timeStep(VAR_1).
-dom_is_held(X0_G,VAR_0):--dom_is_held(X0_G,I_G),not  dom_is_held(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(VAR_1),timeStep(VAR_0),tangible_entity(X0_G),timeStep(I_G).
confined_to(X0_G,X1_G,VAR_0):-confined_to(X0_G,X1_G,I_G),not  -confined_to(X0_G,X1_G,VAR_1),dom_confined_to(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(I_G),tangible_entity(X1_G),tangible_entity(X0_G),timeStep(VAR_1),timeStep(VAR_2),timeStep(VAR_0).
-confined_to(X0_G,X1_G,VAR_0):--confined_to(X0_G,X1_G,I_G),not  confined_to(X0_G,X1_G,VAR_1),dom_confined_to(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,tangible_entity(X0_G),tangible_entity(X1_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G),timeStep(VAR_2).
dom_confined_to(X0_G,X1_G,I_G):-confined_to(X0_G,X1_G,I_G),tangible_entity(X0_G),timeStep(I_G),tangible_entity(X1_G).
dom_confined_to(X0_G,X1_G,I_G):--confined_to(X0_G,X1_G,I_G),timeStep(I_G),tangible_entity(X0_G),tangible_entity(X1_G).
dom_confined_to(X0_G,X1_G,VAR_0):-dom_confined_to(X0_G,X1_G,I_G),not  -dom_confined_to(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X0_G),timeStep(VAR_0),tangible_entity(X1_G),timeStep(VAR_1),timeStep(I_G).
-dom_confined_to(X0_G,X1_G,VAR_0):--dom_confined_to(X0_G,X1_G,I_G),not  dom_confined_to(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X0_G),timeStep(VAR_1),timeStep(VAR_0),tangible_entity(X1_G),timeStep(I_G).
has_part(X0_G,X1_G,VAR_0):-has_part(X0_G,X1_G,I_G),not  -has_part(X0_G,X1_G,VAR_1),dom_has_part(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,entity(X0_G),entity(X1_G),timeStep(I_G),timeStep(VAR_2),timeStep(VAR_0),timeStep(VAR_1).
-has_part(X0_G,X1_G,VAR_0):--has_part(X0_G,X1_G,I_G),not  has_part(X0_G,X1_G,VAR_1),dom_has_part(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,entity(X0_G),entity(X1_G),timeStep(VAR_2),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G).
dom_has_part(X0_G,X1_G,I_G):-has_part(X0_G,X1_G,I_G),entity(X1_G),entity(X0_G),timeStep(I_G).
dom_has_part(X0_G,X1_G,I_G):--has_part(X0_G,X1_G,I_G),entity(X1_G),entity(X0_G),timeStep(I_G).
dom_has_part(X0_G,X1_G,VAR_0):-dom_has_part(X0_G,X1_G,I_G),not  -dom_has_part(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,entity(X0_G),entity(X1_G),timeStep(VAR_0),timeStep(I_G),timeStep(VAR_1).
-dom_has_part(X0_G,X1_G,VAR_0):--dom_has_part(X0_G,X1_G,I_G),not  dom_has_part(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(I_G),timeStep(VAR_1),timeStep(VAR_0),entity(X0_G),entity(X1_G).
is_contained(X0_G,VAR_0):-is_contained(X0_G,I_G),not  -is_contained(X0_G,VAR_1),dom_is_contained(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,tangible_entity(X0_G),timeStep(I_G),timeStep(VAR_0),timeStep(VAR_2),timeStep(VAR_1).
-is_contained(X0_G,VAR_0):--is_contained(X0_G,I_G),not  is_contained(X0_G,VAR_1),dom_is_contained(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G),timeStep(VAR_2),tangible_entity(X0_G).
dom_is_contained(X0_G,I_G):-is_contained(X0_G,I_G),tangible_entity(X0_G),timeStep(I_G).
dom_is_contained(X0_G,I_G):--is_contained(X0_G,I_G),tangible_entity(X0_G),timeStep(I_G).
dom_is_contained(X0_G,VAR_0):-dom_is_contained(X0_G,I_G),not  -dom_is_contained(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X0_G),timeStep(VAR_1),timeStep(I_G),timeStep(VAR_0).
-dom_is_contained(X0_G,VAR_0):--dom_is_contained(X0_G,I_G),not  dom_is_contained(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(VAR_1),tangible_entity(X0_G),timeStep(VAR_0),timeStep(I_G).
content(X0_G,X1_G,VAR_0):-content(X0_G,X1_G,I_G),not  -content(X0_G,X1_G,VAR_1),dom_content(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,tangible_entity(X0_G),entity(X1_G),timeStep(I_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(VAR_2).
-content(X0_G,X1_G,VAR_0):--content(X0_G,X1_G,I_G),not  content(X0_G,X1_G,VAR_1),dom_content(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(I_G),timeStep(VAR_2),entity(X1_G),tangible_entity(X0_G),timeStep(VAR_0),timeStep(VAR_1).
dom_content(X0_G,X1_G,I_G):-content(X0_G,X1_G,I_G),timeStep(I_G),tangible_entity(X0_G),entity(X1_G).
dom_content(X0_G,X1_G,I_G):--content(X0_G,X1_G,I_G),timeStep(I_G),tangible_entity(X0_G),entity(X1_G).
dom_content(X0_G,X1_G,VAR_0):-dom_content(X0_G,X1_G,I_G),not  -dom_content(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X0_G),entity(X1_G),timeStep(VAR_0),timeStep(I_G),timeStep(VAR_1).
-dom_content(X0_G,X1_G,VAR_0):--dom_content(X0_G,X1_G,I_G),not  dom_content(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X0_G),timeStep(I_G),entity(X1_G),timeStep(VAR_1),timeStep(VAR_0).
accessible_to(X0_G,X1_G,VAR_0):-accessible_to(X0_G,X1_G,I_G),not  -accessible_to(X0_G,X1_G,VAR_1),dom_accessible_to(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,thing(X1_G),entity(X0_G),timeStep(I_G),timeStep(VAR_2),timeStep(VAR_1),timeStep(VAR_0).
-accessible_to(X0_G,X1_G,VAR_0):--accessible_to(X0_G,X1_G,I_G),not  accessible_to(X0_G,X1_G,VAR_1),dom_accessible_to(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,thing(X1_G),entity(X0_G),timeStep(I_G),timeStep(VAR_0),timeStep(VAR_2),timeStep(VAR_1).
dom_accessible_to(X0_G,X1_G,I_G):-accessible_to(X0_G,X1_G,I_G),entity(X0_G),thing(X1_G),timeStep(I_G).
dom_accessible_to(X0_G,X1_G,I_G):--accessible_to(X0_G,X1_G,I_G),timeStep(I_G),thing(X1_G),entity(X0_G).
dom_accessible_to(X0_G,X1_G,VAR_0):-dom_accessible_to(X0_G,X1_G,I_G),not  -dom_accessible_to(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,thing(X1_G),entity(X0_G),timeStep(I_G),timeStep(VAR_0),timeStep(VAR_1).
-dom_accessible_to(X0_G,X1_G,VAR_0):--dom_accessible_to(X0_G,X1_G,I_G),not  dom_accessible_to(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,thing(X1_G),timeStep(VAR_0),timeStep(I_G),entity(X0_G),timeStep(VAR_1).
is_near(X0_G,X1_G,VAR_0):-is_near(X0_G,X1_G,I_G),not  -is_near(X0_G,X1_G,VAR_1),dom_is_near(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_0),timeStep(VAR_2),timeStep(VAR_1),timeStep(I_G).
-is_near(X0_G,X1_G,VAR_0):--is_near(X0_G,X1_G,I_G),not  is_near(X0_G,X1_G,VAR_1),dom_is_near(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X1_G),timeStep(VAR_0),timeStep(I_G),spatial_entity(X0_G),timeStep(VAR_1),timeStep(VAR_2).
dom_is_near(X0_G,X1_G,I_G):-is_near(X0_G,X1_G,I_G),spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G).
dom_is_near(X0_G,X1_G,I_G):--is_near(X0_G,X1_G,I_G),spatial_entity(X1_G),timeStep(I_G),spatial_entity(X0_G).
dom_is_near(X0_G,X1_G,VAR_0):-dom_is_near(X0_G,X1_G,I_G),not  -dom_is_near(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X0_G),timeStep(VAR_1),timeStep(I_G),spatial_entity(X1_G),timeStep(VAR_0).
-dom_is_near(X0_G,X1_G,VAR_0):--dom_is_near(X0_G,X1_G,I_G),not  dom_is_near(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G).
possesses(X0_G,X1_G,VAR_0):-possesses(X0_G,X1_G,I_G),not  -possesses(X0_G,X1_G,VAR_1),dom_possesses(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_2),entity(X1_G),timeStep(VAR_1),entity(X0_G),timeStep(I_G),timeStep(VAR_0).
-possesses(X0_G,X1_G,VAR_0):--possesses(X0_G,X1_G,I_G),not  possesses(X0_G,X1_G,VAR_1),dom_possesses(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_0),timeStep(VAR_1),entity(X0_G),entity(X1_G),timeStep(VAR_2),timeStep(I_G).
dom_possesses(X0_G,X1_G,I_G):-possesses(X0_G,X1_G,I_G),entity(X1_G),entity(X0_G),timeStep(I_G).
dom_possesses(X0_G,X1_G,I_G):--possesses(X0_G,X1_G,I_G),entity(X1_G),entity(X0_G),timeStep(I_G).
dom_possesses(X0_G,X1_G,VAR_0):-dom_possesses(X0_G,X1_G,I_G),not  -dom_possesses(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,entity(X1_G),entity(X0_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G).
-dom_possesses(X0_G,X1_G,VAR_0):--dom_possesses(X0_G,X1_G,I_G),not  dom_possesses(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(I_G),entity(X0_G),timeStep(VAR_0),entity(X1_G),timeStep(VAR_1).
is_closed(X0_G,VAR_0):-is_closed(X0_G,I_G),not  -is_closed(X0_G,VAR_1),dom_is_closed(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),timeStep(I_G),timeStep(VAR_1),timeStep(VAR_0),timeStep(VAR_2).
-is_closed(X0_G,VAR_0):--is_closed(X0_G,I_G),not  is_closed(X0_G,VAR_1),dom_is_closed(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_2),timeStep(VAR_1),spatial_entity(X0_G),timeStep(I_G),timeStep(VAR_0).
dom_is_closed(X0_G,I_G):-is_closed(X0_G,I_G),timeStep(I_G),spatial_entity(X0_G).
dom_is_closed(X0_G,I_G):--is_closed(X0_G,I_G),timeStep(I_G),spatial_entity(X0_G).
dom_is_closed(X0_G,VAR_0):-dom_is_closed(X0_G,I_G),not  -dom_is_closed(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(I_G),timeStep(VAR_1),spatial_entity(X0_G),timeStep(VAR_0).
-dom_is_closed(X0_G,VAR_0):--dom_is_closed(X0_G,I_G),not  dom_is_closed(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(I_G),spatial_entity(X0_G),timeStep(VAR_1),timeStep(VAR_0).
location(X0_G,X1_G,VAR_0):-location(X0_G,X1_G,I_G),not  -location(X0_G,X1_G,VAR_1),dom_location(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_0),tangible_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_1),timeStep(I_G),timeStep(VAR_2).
-location(X0_G,X1_G,VAR_0):--location(X0_G,X1_G,I_G),not  location(X0_G,X1_G,VAR_1),dom_location(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X1_G),tangible_entity(X0_G),timeStep(VAR_0),timeStep(I_G),timeStep(VAR_1),timeStep(VAR_2).
dom_location(X0_G,X1_G,I_G):-location(X0_G,X1_G,I_G),tangible_entity(X0_G),timeStep(I_G),spatial_entity(X1_G).
dom_location(X0_G,X1_G,I_G):--location(X0_G,X1_G,I_G),tangible_entity(X0_G),timeStep(I_G),spatial_entity(X1_G).
dom_location(X0_G,X1_G,VAR_0):-dom_location(X0_G,X1_G,I_G),not  -dom_location(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),timeStep(VAR_1),timeStep(VAR_0),tangible_entity(X0_G),timeStep(I_G).
-dom_location(X0_G,X1_G,VAR_0):--dom_location(X0_G,X1_G,I_G),not  dom_location(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X0_G),timeStep(VAR_1),spatial_entity(X1_G),timeStep(VAR_0),timeStep(I_G).
is_along(X0_G,X1_G,VAR_0):-is_along(X0_G,X1_G,I_G),not  -is_along(X0_G,X1_G,VAR_1),dom_is_along(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),timeStep(VAR_2),timeStep(I_G),timeStep(VAR_1),spatial_entity(X1_G),timeStep(VAR_0).
-is_along(X0_G,X1_G,VAR_0):--is_along(X0_G,X1_G,I_G),not  is_along(X0_G,X1_G,VAR_1),dom_is_along(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_2),spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G).
dom_is_along(X0_G,X1_G,I_G):-is_along(X0_G,X1_G,I_G),spatial_entity(X1_G),timeStep(I_G),spatial_entity(X0_G).
dom_is_along(X0_G,X1_G,I_G):--is_along(X0_G,X1_G,I_G),spatial_entity(X1_G),timeStep(I_G),spatial_entity(X0_G).
dom_is_along(X0_G,X1_G,VAR_0):-dom_is_along(X0_G,X1_G,I_G),not  -dom_is_along(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_0),timeStep(I_G),timeStep(VAR_1).
-dom_is_along(X0_G,X1_G,VAR_0):--dom_is_along(X0_G,X1_G,I_G),not  dom_is_along(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),timeStep(VAR_1),spatial_entity(X0_G),timeStep(I_G),timeStep(VAR_0).
is_inside(X0_G,X1_G,VAR_0):-is_inside(X0_G,X1_G,I_G),not  -is_inside(X0_G,X1_G,VAR_1),dom_is_inside(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G),timeStep(VAR_1),timeStep(VAR_0),timeStep(VAR_2).
-is_inside(X0_G,X1_G,VAR_0):--is_inside(X0_G,X1_G,I_G),not  is_inside(X0_G,X1_G,VAR_1),dom_is_inside(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X1_G),timeStep(VAR_0),spatial_entity(X0_G),timeStep(I_G),timeStep(VAR_2),timeStep(VAR_1).
dom_is_inside(X0_G,X1_G,I_G):-is_inside(X0_G,X1_G,I_G),spatial_entity(X0_G),spatial_entity(X1_G),timeStep(I_G).
dom_is_inside(X0_G,X1_G,I_G):--is_inside(X0_G,X1_G,I_G),spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G).
dom_is_inside(X0_G,X1_G,VAR_0):-dom_is_inside(X0_G,X1_G,I_G),not  -dom_is_inside(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),timeStep(I_G),timeStep(VAR_1),spatial_entity(X0_G),timeStep(VAR_0).
-dom_is_inside(X0_G,X1_G,VAR_0):--dom_is_inside(X0_G,X1_G,I_G),not  dom_is_inside(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),timeStep(VAR_1),timeStep(I_G),spatial_entity(X0_G),timeStep(VAR_0).
is_below(X0_G,X1_G,VAR_0):-is_below(X0_G,X1_G,I_G),not  -is_below(X0_G,X1_G,VAR_1),dom_is_below(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_2),timeStep(I_G),timeStep(VAR_1),timeStep(VAR_0).
-is_below(X0_G,X1_G,VAR_0):--is_below(X0_G,X1_G,I_G),not  is_below(X0_G,X1_G,VAR_1),dom_is_below(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_2),spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G).
dom_is_below(X0_G,X1_G,I_G):-is_below(X0_G,X1_G,I_G),timeStep(I_G),spatial_entity(X0_G),spatial_entity(X1_G).
dom_is_below(X0_G,X1_G,I_G):--is_below(X0_G,X1_G,I_G),spatial_entity(X0_G),spatial_entity(X1_G),timeStep(I_G).
dom_is_below(X0_G,X1_G,VAR_0):-dom_is_below(X0_G,X1_G,I_G),not  -dom_is_below(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_0),timeStep(I_G),timeStep(VAR_1).
-dom_is_below(X0_G,X1_G,VAR_0):--dom_is_below(X0_G,X1_G,I_G),not  dom_is_below(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(VAR_1),spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_0),timeStep(I_G).
is_accessible(X0_G,VAR_0):-is_accessible(X0_G,I_G),not  -is_accessible(X0_G,VAR_1),dom_is_accessible(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,entity(X0_G),timeStep(I_G),timeStep(VAR_0),timeStep(VAR_2),timeStep(VAR_1).
-is_accessible(X0_G,VAR_0):--is_accessible(X0_G,I_G),not  is_accessible(X0_G,VAR_1),dom_is_accessible(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,entity(X0_G),timeStep(VAR_2),timeStep(I_G),timeStep(VAR_0),timeStep(VAR_1).
dom_is_accessible(X0_G,I_G):-is_accessible(X0_G,I_G),timeStep(I_G),entity(X0_G).
dom_is_accessible(X0_G,I_G):--is_accessible(X0_G,I_G),timeStep(I_G),entity(X0_G).
dom_is_accessible(X0_G,VAR_0):-dom_is_accessible(X0_G,I_G),not  -dom_is_accessible(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,entity(X0_G),timeStep(VAR_1),timeStep(I_G),timeStep(VAR_0).
-dom_is_accessible(X0_G,VAR_0):--dom_is_accessible(X0_G,I_G),not  dom_is_accessible(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(I_G),entity(X0_G),timeStep(VAR_0),timeStep(VAR_1).
is_restrained(X0_G,VAR_0):-is_restrained(X0_G,I_G),not  -is_restrained(X0_G,VAR_1),dom_is_restrained(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,tangible_entity(X0_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G),timeStep(VAR_2).
-is_restrained(X0_G,VAR_0):--is_restrained(X0_G,I_G),not  is_restrained(X0_G,VAR_1),dom_is_restrained(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_1),timeStep(VAR_0),timeStep(I_G),tangible_entity(X0_G),timeStep(VAR_2).
dom_is_restrained(X0_G,I_G):-is_restrained(X0_G,I_G),timeStep(I_G),tangible_entity(X0_G).
dom_is_restrained(X0_G,I_G):--is_restrained(X0_G,I_G),tangible_entity(X0_G),timeStep(I_G).
dom_is_restrained(X0_G,VAR_0):-dom_is_restrained(X0_G,I_G),not  -dom_is_restrained(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X0_G),timeStep(I_G),timeStep(VAR_0),timeStep(VAR_1).
-dom_is_restrained(X0_G,VAR_0):--dom_is_restrained(X0_G,I_G),not  dom_is_restrained(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X0_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G).
is_beside(X0_G,X1_G,VAR_0):-is_beside(X0_G,X1_G,I_G),not  -is_beside(X0_G,X1_G,VAR_1),dom_is_beside(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_2),timeStep(VAR_0),timeStep(I_G),timeStep(VAR_1).
-is_beside(X0_G,X1_G,VAR_0):--is_beside(X0_G,X1_G,I_G),not  is_beside(X0_G,X1_G,VAR_1),dom_is_beside(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(I_G),spatial_entity(X0_G),timeStep(VAR_1),spatial_entity(X1_G),timeStep(VAR_0),timeStep(VAR_2).
dom_is_beside(X0_G,X1_G,I_G):-is_beside(X0_G,X1_G,I_G),spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G).
dom_is_beside(X0_G,X1_G,I_G):--is_beside(X0_G,X1_G,I_G),spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G).
dom_is_beside(X0_G,X1_G,VAR_0):-dom_is_beside(X0_G,X1_G,I_G),not  -dom_is_beside(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_0),timeStep(I_G),timeStep(VAR_1).
-dom_is_beside(X0_G,X1_G,VAR_0):--dom_is_beside(X0_G,X1_G,I_G),not  dom_is_beside(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_1),timeStep(VAR_0),timeStep(I_G).
is_in_front_of(X0_G,X1_G,VAR_0):-is_in_front_of(X0_G,X1_G,I_G),not  -is_in_front_of(X0_G,X1_G,VAR_1),dom_is_in_front_of(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_2),spatial_entity(X0_G),timeStep(VAR_1),timeStep(VAR_0),spatial_entity(X1_G),timeStep(I_G).
-is_in_front_of(X0_G,X1_G,VAR_0):--is_in_front_of(X0_G,X1_G,I_G),not  is_in_front_of(X0_G,X1_G,VAR_1),dom_is_in_front_of(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),timeStep(VAR_2),timeStep(VAR_0),timeStep(I_G),spatial_entity(X1_G),timeStep(VAR_1).
dom_is_in_front_of(X0_G,X1_G,I_G):-is_in_front_of(X0_G,X1_G,I_G),spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G).
dom_is_in_front_of(X0_G,X1_G,I_G):--is_in_front_of(X0_G,X1_G,I_G),spatial_entity(X0_G),spatial_entity(X1_G),timeStep(I_G).
dom_is_in_front_of(X0_G,X1_G,VAR_0):-dom_is_in_front_of(X0_G,X1_G,I_G),not  -dom_is_in_front_of(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(I_G),spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_0),timeStep(VAR_1).
-dom_is_in_front_of(X0_G,X1_G,VAR_0):--dom_is_in_front_of(X0_G,X1_G,I_G),not  dom_is_in_front_of(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X0_G),timeStep(VAR_1),spatial_entity(X1_G),timeStep(VAR_0),timeStep(I_G).
held_by(X0_G,X1_G,VAR_0):-held_by(X0_G,X1_G,I_G),not  -held_by(X0_G,X1_G,VAR_1),dom_held_by(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_0),tangible_entity(X0_G),timeStep(I_G),tangible_entity(X1_G),timeStep(VAR_2),timeStep(VAR_1).
-held_by(X0_G,X1_G,VAR_0):--held_by(X0_G,X1_G,I_G),not  held_by(X0_G,X1_G,VAR_1),dom_held_by(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_2),timeStep(I_G),tangible_entity(X0_G),timeStep(VAR_0),timeStep(VAR_1),tangible_entity(X1_G).
dom_held_by(X0_G,X1_G,I_G):-held_by(X0_G,X1_G,I_G),tangible_entity(X0_G),timeStep(I_G),tangible_entity(X1_G).
dom_held_by(X0_G,X1_G,I_G):--held_by(X0_G,X1_G,I_G),tangible_entity(X1_G),tangible_entity(X0_G),timeStep(I_G).
dom_held_by(X0_G,X1_G,VAR_0):-dom_held_by(X0_G,X1_G,I_G),not  -dom_held_by(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(VAR_0),tangible_entity(X0_G),tangible_entity(X1_G),timeStep(I_G),timeStep(VAR_1).
-dom_held_by(X0_G,X1_G,VAR_0):--dom_held_by(X0_G,X1_G,I_G),not  dom_held_by(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X1_G),timeStep(VAR_0),tangible_entity(X0_G),timeStep(I_G),timeStep(VAR_1).
is_on(X0_G,X1_G,VAR_0):-is_on(X0_G,X1_G,I_G),not  -is_on(X0_G,X1_G,VAR_1),dom_is_on(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),timeStep(VAR_2),timeStep(VAR_1),timeStep(I_G),spatial_entity(X1_G),timeStep(VAR_0).
-is_on(X0_G,X1_G,VAR_0):--is_on(X0_G,X1_G,I_G),not  is_on(X0_G,X1_G,VAR_1),dom_is_on(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_1),timeStep(I_G),timeStep(VAR_2),timeStep(VAR_0).
dom_is_on(X0_G,X1_G,I_G):-is_on(X0_G,X1_G,I_G),spatial_entity(X1_G),spatial_entity(X0_G),timeStep(I_G).
dom_is_on(X0_G,X1_G,I_G):--is_on(X0_G,X1_G,I_G),spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G).
dom_is_on(X0_G,X1_G,VAR_0):-dom_is_on(X0_G,X1_G,I_G),not  -dom_is_on(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X0_G),spatial_entity(X1_G),timeStep(I_G),timeStep(VAR_1),timeStep(VAR_0).
-dom_is_on(X0_G,X1_G,VAR_0):--dom_is_on(X0_G,X1_G,I_G),not  dom_is_on(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(I_G),spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_1),timeStep(VAR_0).
is_confined(X0_G,VAR_0):-is_confined(X0_G,I_G),not  -is_confined(X0_G,VAR_1),dom_is_confined(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,tangible_entity(X0_G),timeStep(VAR_2),timeStep(VAR_1),timeStep(I_G),timeStep(VAR_0).
-is_confined(X0_G,VAR_0):--is_confined(X0_G,I_G),not  is_confined(X0_G,VAR_1),dom_is_confined(X0_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_0),tangible_entity(X0_G),timeStep(VAR_2),timeStep(I_G),timeStep(VAR_1).
dom_is_confined(X0_G,I_G):-is_confined(X0_G,I_G),timeStep(I_G),tangible_entity(X0_G).
dom_is_confined(X0_G,I_G):--is_confined(X0_G,I_G),tangible_entity(X0_G),timeStep(I_G).
dom_is_confined(X0_G,VAR_0):-dom_is_confined(X0_G,I_G),not  -dom_is_confined(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(VAR_0),timeStep(I_G),timeStep(VAR_1),tangible_entity(X0_G).
-dom_is_confined(X0_G,VAR_0):--dom_is_confined(X0_G,I_G),not  dom_is_confined(X0_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X0_G),timeStep(VAR_0),timeStep(I_G),timeStep(VAR_1).
shut_out_of(X0_G,X1_G,VAR_0):-shut_out_of(X0_G,X1_G,I_G),not  -shut_out_of(X0_G,X1_G,VAR_1),dom_shut_out_of(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,tangible_entity(X1_G),tangible_entity(X0_G),timeStep(VAR_2),timeStep(I_G),timeStep(VAR_1),timeStep(VAR_0).
-shut_out_of(X0_G,X1_G,VAR_0):--shut_out_of(X0_G,X1_G,I_G),not  shut_out_of(X0_G,X1_G,VAR_1),dom_shut_out_of(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,tangible_entity(X0_G),tangible_entity(X1_G),timeStep(VAR_2),timeStep(I_G),timeStep(VAR_1),timeStep(VAR_0).
dom_shut_out_of(X0_G,X1_G,I_G):-shut_out_of(X0_G,X1_G,I_G),timeStep(I_G),tangible_entity(X1_G),tangible_entity(X0_G).
dom_shut_out_of(X0_G,X1_G,I_G):--shut_out_of(X0_G,X1_G,I_G),tangible_entity(X0_G),tangible_entity(X1_G),timeStep(I_G).
dom_shut_out_of(X0_G,X1_G,VAR_0):-dom_shut_out_of(X0_G,X1_G,I_G),not  -dom_shut_out_of(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X0_G),timeStep(VAR_0),tangible_entity(X1_G),timeStep(I_G),timeStep(VAR_1).
-dom_shut_out_of(X0_G,X1_G,VAR_0):--dom_shut_out_of(X0_G,X1_G,I_G),not  dom_shut_out_of(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X1_G),tangible_entity(X0_G),timeStep(I_G),timeStep(VAR_1),timeStep(VAR_0).
known_to(X0_G,X1_G,VAR_0):-known_to(X0_G,X1_G,I_G),not  -known_to(X0_G,X1_G,VAR_1),dom_known_to(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_1),entity(X0_G),timeStep(VAR_2),tangible_entity(X1_G),timeStep(I_G),timeStep(VAR_0).
-known_to(X0_G,X1_G,VAR_0):--known_to(X0_G,X1_G,I_G),not  known_to(X0_G,X1_G,VAR_1),dom_known_to(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(I_G),tangible_entity(X1_G),entity(X0_G),timeStep(VAR_2),timeStep(VAR_0),timeStep(VAR_1).
dom_known_to(X0_G,X1_G,I_G):-known_to(X0_G,X1_G,I_G),timeStep(I_G),tangible_entity(X1_G),entity(X0_G).
dom_known_to(X0_G,X1_G,I_G):--known_to(X0_G,X1_G,I_G),entity(X0_G),tangible_entity(X1_G),timeStep(I_G).
dom_known_to(X0_G,X1_G,VAR_0):-dom_known_to(X0_G,X1_G,I_G),not  -dom_known_to(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,tangible_entity(X1_G),timeStep(VAR_0),entity(X0_G),timeStep(I_G),timeStep(VAR_1).
-dom_known_to(X0_G,X1_G,VAR_0):--dom_known_to(X0_G,X1_G,I_G),not  dom_known_to(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,entity(X0_G),timeStep(VAR_1),timeStep(VAR_0),tangible_entity(X1_G),timeStep(I_G).
is_under(X0_G,X1_G,VAR_0):-is_under(X0_G,X1_G,I_G),not  -is_under(X0_G,X1_G,VAR_1),dom_is_under(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_2),timeStep(I_G),timeStep(VAR_0),timeStep(VAR_1).
-is_under(X0_G,X1_G,VAR_0):--is_under(X0_G,X1_G,I_G),not  is_under(X0_G,X1_G,VAR_1),dom_is_under(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X1_G),timeStep(VAR_0),spatial_entity(X0_G),timeStep(VAR_2),timeStep(VAR_1),timeStep(I_G).
dom_is_under(X0_G,X1_G,I_G):-is_under(X0_G,X1_G,I_G),timeStep(I_G),spatial_entity(X1_G),spatial_entity(X0_G).
dom_is_under(X0_G,X1_G,I_G):--is_under(X0_G,X1_G,I_G),spatial_entity(X1_G),spatial_entity(X0_G),timeStep(I_G).
dom_is_under(X0_G,X1_G,VAR_0):-dom_is_under(X0_G,X1_G,I_G),not  -dom_is_under(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(VAR_1),spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G),timeStep(VAR_0).
-dom_is_under(X0_G,X1_G,VAR_0):--dom_is_under(X0_G,X1_G,I_G),not  dom_is_under(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_1),timeStep(I_G),timeStep(VAR_0).
encloses(X0_G,X1_G,VAR_0):-encloses(X0_G,X1_G,I_G),not  -encloses(X0_G,X1_G,VAR_1),dom_encloses(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_0),timeStep(I_G),timeStep(VAR_2),timeStep(VAR_1).
-encloses(X0_G,X1_G,VAR_0):--encloses(X0_G,X1_G,I_G),not  encloses(X0_G,X1_G,VAR_1),dom_encloses(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_2),timeStep(VAR_1),timeStep(VAR_0),timeStep(I_G).
dom_encloses(X0_G,X1_G,I_G):-encloses(X0_G,X1_G,I_G),spatial_entity(X1_G),spatial_entity(X0_G),timeStep(I_G).
dom_encloses(X0_G,X1_G,I_G):--encloses(X0_G,X1_G,I_G),spatial_entity(X1_G),spatial_entity(X0_G),timeStep(I_G).
dom_encloses(X0_G,X1_G,VAR_0):-dom_encloses(X0_G,X1_G,I_G),not  -dom_encloses(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X0_G),timeStep(VAR_1),spatial_entity(X1_G),timeStep(I_G),timeStep(VAR_0).
-dom_encloses(X0_G,X1_G,VAR_0):--dom_encloses(X0_G,X1_G,I_G),not  dom_encloses(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),timeStep(VAR_0),timeStep(VAR_1),spatial_entity(X0_G),timeStep(I_G).
is_above(X0_G,X1_G,VAR_0):-is_above(X0_G,X1_G,I_G),not  -is_above(X0_G,X1_G,VAR_1),dom_is_above(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X1_G),spatial_entity(X0_G),timeStep(I_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(VAR_2).
-is_above(X0_G,X1_G,VAR_0):--is_above(X0_G,X1_G,I_G),not  is_above(X0_G,X1_G,VAR_1),dom_is_above(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X1_G),timeStep(VAR_2),timeStep(I_G),spatial_entity(X0_G),timeStep(VAR_0),timeStep(VAR_1).
dom_is_above(X0_G,X1_G,I_G):-is_above(X0_G,X1_G,I_G),spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G).
dom_is_above(X0_G,X1_G,I_G):--is_above(X0_G,X1_G,I_G),spatial_entity(X1_G),timeStep(I_G),spatial_entity(X0_G).
dom_is_above(X0_G,X1_G,VAR_0):-dom_is_above(X0_G,X1_G,I_G),not  -dom_is_above(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),timeStep(I_G),spatial_entity(X0_G),timeStep(VAR_0),timeStep(VAR_1).
-dom_is_above(X0_G,X1_G,VAR_0):--dom_is_above(X0_G,X1_G,I_G),not  dom_is_above(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G),timeStep(VAR_0),timeStep(VAR_1).
abuts(X0_G,X1_G,VAR_0):-abuts(X0_G,X1_G,I_G),not  -abuts(X0_G,X1_G,VAR_1),dom_abuts(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),timeStep(I_G),spatial_entity(X1_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(VAR_2).
-abuts(X0_G,X1_G,VAR_0):--abuts(X0_G,X1_G,I_G),not  abuts(X0_G,X1_G,VAR_1),dom_abuts(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X1_G),timeStep(I_G),spatial_entity(X0_G),timeStep(VAR_1),timeStep(VAR_2),timeStep(VAR_0).
dom_abuts(X0_G,X1_G,I_G):-abuts(X0_G,X1_G,I_G),timeStep(I_G),spatial_entity(X0_G),spatial_entity(X1_G).
dom_abuts(X0_G,X1_G,I_G):--abuts(X0_G,X1_G,I_G),spatial_entity(X0_G),spatial_entity(X1_G),timeStep(I_G).
dom_abuts(X0_G,X1_G,VAR_0):-dom_abuts(X0_G,X1_G,I_G),not  -dom_abuts(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),spatial_entity(X0_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(I_G).
-dom_abuts(X0_G,X1_G,VAR_0):--dom_abuts(X0_G,X1_G,I_G),not  dom_abuts(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X1_G),timeStep(VAR_1),spatial_entity(X0_G),timeStep(I_G),timeStep(VAR_0).
is_opposite(X0_G,X1_G,VAR_0):-is_opposite(X0_G,X1_G,I_G),not  -is_opposite(X0_G,X1_G,VAR_1),dom_is_opposite(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_0),timeStep(VAR_1),timeStep(VAR_2),timeStep(I_G).
-is_opposite(X0_G,X1_G,VAR_0):--is_opposite(X0_G,X1_G,I_G),not  is_opposite(X0_G,X1_G,VAR_1),dom_is_opposite(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,spatial_entity(X0_G),timeStep(VAR_2),timeStep(VAR_0),spatial_entity(X1_G),timeStep(VAR_1),timeStep(I_G).
dom_is_opposite(X0_G,X1_G,I_G):-is_opposite(X0_G,X1_G,I_G),timeStep(I_G),spatial_entity(X1_G),spatial_entity(X0_G).
dom_is_opposite(X0_G,X1_G,I_G):--is_opposite(X0_G,X1_G,I_G),spatial_entity(X1_G),timeStep(I_G),spatial_entity(X0_G).
dom_is_opposite(X0_G,X1_G,VAR_0):-dom_is_opposite(X0_G,X1_G,I_G),not  -dom_is_opposite(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_0),timeStep(I_G),timeStep(VAR_1).
-dom_is_opposite(X0_G,X1_G,VAR_0):--dom_is_opposite(X0_G,X1_G,I_G),not  dom_is_opposite(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,spatial_entity(X0_G),spatial_entity(X1_G),timeStep(VAR_1),timeStep(I_G),timeStep(VAR_0).
is_at(X0_G,X1_G,VAR_0):-is_at(X0_G,X1_G,I_G),not  -is_at(X0_G,X1_G,VAR_1),dom_is_at(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,entity(X0_G),timeStep(VAR_1),timeStep(VAR_0),spatial_entity(X1_G),timeStep(I_G),timeStep(VAR_2).
-is_at(X0_G,X1_G,VAR_0):--is_at(X0_G,X1_G,I_G),not  is_at(X0_G,X1_G,VAR_1),dom_is_at(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(I_G),spatial_entity(X1_G),entity(X0_G),timeStep(VAR_0),timeStep(VAR_2),timeStep(VAR_1).
dom_is_at(X0_G,X1_G,I_G):-is_at(X0_G,X1_G,I_G),timeStep(I_G),entity(X0_G),spatial_entity(X1_G).
dom_is_at(X0_G,X1_G,I_G):--is_at(X0_G,X1_G,I_G),spatial_entity(X1_G),entity(X0_G),timeStep(I_G).
dom_is_at(X0_G,X1_G,VAR_0):-dom_is_at(X0_G,X1_G,I_G),not  -dom_is_at(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,entity(X0_G),spatial_entity(X1_G),timeStep(I_G),timeStep(VAR_1),timeStep(VAR_0).
-dom_is_at(X0_G,X1_G,VAR_0):--dom_is_at(X0_G,X1_G,I_G),not  dom_is_at(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,entity(X0_G),timeStep(VAR_0),timeStep(I_G),spatial_entity(X1_G),timeStep(VAR_1).
blocked_with(X0_G,X1_G,VAR_0):-blocked_with(X0_G,X1_G,I_G),not  -blocked_with(X0_G,X1_G,VAR_1),dom_blocked_with(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_0),entity(X1_G),timeStep(VAR_2),spatial_entity(X0_G),timeStep(I_G),timeStep(VAR_1).
-blocked_with(X0_G,X1_G,VAR_0):--blocked_with(X0_G,X1_G,I_G),not  blocked_with(X0_G,X1_G,VAR_1),dom_blocked_with(X0_G,X1_G,VAR_2),VAR_0=I_G+1,VAR_1=I_G+1,VAR_2=I_G+1,timeStep(VAR_1),spatial_entity(X0_G),entity(X1_G),timeStep(VAR_0),timeStep(I_G),timeStep(VAR_2).
dom_blocked_with(X0_G,X1_G,I_G):-blocked_with(X0_G,X1_G,I_G),entity(X1_G),spatial_entity(X0_G),timeStep(I_G).
dom_blocked_with(X0_G,X1_G,I_G):--blocked_with(X0_G,X1_G,I_G),timeStep(I_G),spatial_entity(X0_G),entity(X1_G).
dom_blocked_with(X0_G,X1_G,VAR_0):-dom_blocked_with(X0_G,X1_G,I_G),not  -dom_blocked_with(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(VAR_0),spatial_entity(X0_G),entity(X1_G),timeStep(I_G),timeStep(VAR_1).
-dom_blocked_with(X0_G,X1_G,VAR_0):--dom_blocked_with(X0_G,X1_G,I_G),not  dom_blocked_with(X0_G,X1_G,VAR_1),VAR_0=I_G+1,VAR_1=I_G+1,timeStep(VAR_0),entity(X1_G),timeStep(VAR_1),timeStep(I_G),spatial_entity(X0_G).
location(O_G,D_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(D_G),entity(O_G),timeStep(TS_G),actions(X_G),event(X_G),universe(X_G),timeStep(VAR_0),tangible_entity(O_G),universe(D_G).
location(O_G,P_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),-instance(D_G,tangible_entity),location(D_G,P_G,TS_G),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,timeStep(VAR_0),spatial_entity(P_G),event(X_G),timeStep(TS_G),entity(O_G),tangible_entity(D_G),tangible_entity(O_G),spatial_entity(D_G),actions(X_G),universe(D_G),universe(X_G).
is_near(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_near(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,timeStep(VAR_0),timeStep(TS_G),event(X_G),actions(X_G),universe(X_G),spatial_entity(D_G),universe(D_G),spatial_entity(Y_G),spatial_entity(O_G),entity(O_G).
is_above(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_above(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(Y_G),spatial_entity(D_G),universe(X_G),actions(X_G),event(X_G),timeStep(TS_G),timeStep(VAR_0),entity(O_G),spatial_entity(O_G),universe(D_G).
is_below(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_below(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(D_G),timeStep(TS_G),universe(X_G),timeStep(VAR_0),event(X_G),actions(X_G),spatial_entity(O_G),spatial_entity(Y_G),entity(O_G),universe(D_G).
is_along(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_along(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,actions(X_G),entity(O_G),spatial_entity(D_G),spatial_entity(Y_G),timeStep(VAR_0),event(X_G),timeStep(TS_G),universe(D_G),universe(X_G),spatial_entity(O_G).
is_at(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_at(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,event(X_G),spatial_entity(Y_G),universe(X_G),entity(O_G),timeStep(VAR_0),timeStep(TS_G),spatial_entity(D_G),entity(D_G),universe(D_G),actions(X_G).
is_beside(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_beside(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,actions(X_G),event(X_G),spatial_entity(O_G),spatial_entity(Y_G),spatial_entity(D_G),timeStep(TS_G),universe(D_G),timeStep(VAR_0),entity(O_G),universe(X_G).
is_along(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_along(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(D_G),universe(X_G),spatial_entity(O_G),timeStep(TS_G),event(X_G),spatial_entity(Y_G),universe(D_G),actions(X_G),timeStep(VAR_0),entity(O_G).
is_between(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_between(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,timeStep(TS_G),spatial_entity(D_G),entity(O_G),spatial_entity(Y_G),timeStep(VAR_0),event(X_G),universe(D_G),actions(X_G),spatial_entity(O_G),universe(X_G).
is_behind(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_behind(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,event(X_G),actions(X_G),spatial_entity(D_G),entity(O_G),timeStep(TS_G),spatial_entity(Y_G),timeStep(VAR_0),universe(D_G),universe(X_G),spatial_entity(O_G).
is_in_front_of(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_in_front_of(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(Y_G),actions(X_G),timeStep(TS_G),event(X_G),universe(D_G),universe(X_G),spatial_entity(D_G),entity(O_G),spatial_entity(O_G),timeStep(VAR_0).
is_inside(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_inside(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,event(X_G),timeStep(VAR_0),timeStep(TS_G),spatial_entity(D_G),universe(D_G),spatial_entity(O_G),universe(X_G),spatial_entity(Y_G),entity(O_G),actions(X_G).
is_on(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_on(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(O_G),timeStep(TS_G),universe(X_G),spatial_entity(D_G),timeStep(VAR_0),universe(D_G),spatial_entity(Y_G),entity(O_G),actions(X_G),event(X_G).
is_opposite(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_opposite(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,entity(O_G),universe(D_G),event(X_G),universe(X_G),spatial_entity(D_G),spatial_entity(Y_G),timeStep(TS_G),timeStep(VAR_0),actions(X_G),spatial_entity(O_G).
is_outside(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_outside(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(O_G),event(X_G),actions(X_G),spatial_entity(Y_G),timeStep(VAR_0),spatial_entity(D_G),universe(D_G),entity(O_G),timeStep(TS_G),universe(X_G).
-encloses(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),-encloses(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,timeStep(TS_G),universe(X_G),spatial_entity(D_G),actions(X_G),spatial_entity(O_G),event(X_G),spatial_entity(Y_G),timeStep(VAR_0),entity(O_G),universe(D_G).
is_over(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_over(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(D_G),entity(O_G),universe(X_G),actions(X_G),timeStep(VAR_0),universe(D_G),spatial_entity(O_G),spatial_entity(Y_G),event(X_G),timeStep(TS_G).
is_under(O_G,Y_G,VAR_0):-event_object(X_G,O_G),event_destination(X_G,D_G),is_under(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,universe(D_G),spatial_entity(O_G),timeStep(TS_G),actions(X_G),timeStep(VAR_0),event(X_G),spatial_entity(D_G),entity(O_G),universe(X_G),spatial_entity(Y_G).
-location(O_G,L_G,VAR_0):-event_object(X_G,O_G),location(O_G,L_G,TS_G),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(L_G),timeStep(VAR_0),event(X_G),tangible_entity(O_G),actions(X_G),timeStep(TS_G),universe(X_G),entity(O_G).
-is_near(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_near(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_near(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,entity(O_G),timeStep(VAR_0),spatial_entity(O_G),spatial_entity(Y_G),event(X_G),universe(X_G),spatial_entity(D_G),actions(X_G),timeStep(TS_G),universe(D_G).
-abuts(O_G,Y_G,VAR_0):-event_object(X_G,O_G),abuts(O_G,Y_G,TS_G),event_destination(X_G,D_G),-abuts(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,timeStep(TS_G),spatial_entity(D_G),event(X_G),spatial_entity(Y_G),spatial_entity(O_G),universe(D_G),universe(X_G),entity(O_G),actions(X_G),timeStep(VAR_0).
-is_above(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_above(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_above(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,entity(O_G),timeStep(TS_G),spatial_entity(O_G),universe(D_G),timeStep(VAR_0),spatial_entity(Y_G),universe(X_G),actions(X_G),event(X_G),spatial_entity(D_G).
-is_below(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_below(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_below(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,universe(D_G),entity(O_G),spatial_entity(Y_G),timeStep(TS_G),actions(X_G),event(X_G),universe(X_G),spatial_entity(O_G),spatial_entity(D_G),timeStep(VAR_0).
-is_along(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_along(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_along(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,timeStep(VAR_0),spatial_entity(D_G),spatial_entity(Y_G),universe(D_G),spatial_entity(O_G),timeStep(TS_G),entity(O_G),universe(X_G),actions(X_G),event(X_G).
-is_at(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_at(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_at(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(Y_G),event(X_G),universe(D_G),entity(O_G),timeStep(TS_G),actions(X_G),universe(X_G),spatial_entity(D_G),entity(D_G),timeStep(VAR_0).
-is_between(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_between(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_between(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(O_G),spatial_entity(Y_G),timeStep(TS_G),spatial_entity(D_G),event(X_G),universe(X_G),entity(O_G),actions(X_G),timeStep(VAR_0),universe(D_G).
-is_behind(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_behind(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_behind(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,entity(O_G),event(X_G),actions(X_G),spatial_entity(D_G),timeStep(TS_G),universe(D_G),spatial_entity(O_G),spatial_entity(Y_G),timeStep(VAR_0),universe(X_G).
-is_in_front_of(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_in_front_of(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_in_front_of(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,universe(D_G),spatial_entity(D_G),spatial_entity(O_G),spatial_entity(Y_G),entity(O_G),actions(X_G),timeStep(TS_G),timeStep(VAR_0),event(X_G),universe(X_G).
-is_inside(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_inside(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_inside(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(D_G),universe(D_G),timeStep(TS_G),timeStep(VAR_0),universe(X_G),spatial_entity(O_G),actions(X_G),event(X_G),spatial_entity(Y_G),entity(O_G).
-encloses(O_G,Y_G,VAR_0):-event_object(X_G,O_G),encloses(O_G,Y_G,TS_G),event_destination(X_G,D_G),-encloses(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,timeStep(VAR_0),spatial_entity(Y_G),spatial_entity(D_G),actions(X_G),timeStep(TS_G),spatial_entity(O_G),event(X_G),entity(O_G),universe(D_G),universe(X_G).
-is_on(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_on(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_on(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(O_G),timeStep(TS_G),entity(O_G),actions(X_G),spatial_entity(D_G),event(X_G),spatial_entity(Y_G),timeStep(VAR_0),universe(D_G),universe(X_G).
-encloses(O_G,Y_G,VAR_0):-event_object(X_G,O_G),encloses(O_G,Y_G,TS_G),event_destination(X_G,D_G),-encloses(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,entity(O_G),timeStep(TS_G),actions(X_G),spatial_entity(D_G),universe(D_G),spatial_entity(Y_G),spatial_entity(O_G),event(X_G),universe(X_G),timeStep(VAR_0).
-is_opposite(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_opposite(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_opposite(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,event(X_G),spatial_entity(O_G),spatial_entity(Y_G),timeStep(TS_G),timeStep(VAR_0),universe(X_G),entity(O_G),actions(X_G),spatial_entity(D_G),universe(D_G).
-is_outside(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_outside(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_outside(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,event(X_G),timeStep(TS_G),spatial_entity(O_G),spatial_entity(D_G),universe(D_G),universe(X_G),actions(X_G),timeStep(VAR_0),spatial_entity(Y_G),entity(O_G).
-is_over(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_over(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_over(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,spatial_entity(D_G),spatial_entity(Y_G),timeStep(TS_G),timeStep(VAR_0),event(X_G),universe(D_G),universe(X_G),entity(O_G),spatial_entity(O_G),actions(X_G).
-is_under(O_G,Y_G,VAR_0):-event_object(X_G,O_G),is_under(O_G,Y_G,TS_G),event_destination(X_G,D_G),-is_under(D_G,Y_G,TS_G),instance(D_G,spatial_entity),occurs(X_G,TS_G),instance(X_G,move),VAR_0=TS_G+1,universe(D_G),entity(O_G),spatial_entity(O_G),spatial_entity(Y_G),event(X_G),timeStep(TS_G),timeStep(VAR_0),spatial_entity(D_G),actions(X_G),universe(X_G).
-possesses(D_G,O_G,VAR_0):-event_donor(X_G,D_G),event_object(X_G,O_G),occurs(X_G,TS_G),instance(X_G,transfer),VAR_0=TS_G+1,actions(X_G),timeStep(VAR_0),entity(O_G),event(X_G),timeStep(TS_G),entity(D_G),universe(X_G).
possesses(R_G,O_G,VAR_0):-event_recipient(X_G,R_G),event_object(X_G,O_G),occurs(X_G,TS_G),instance(X_G,transfer),VAR_0=TS_G+1,event(X_G),universe(X_G),entity(R_G),entity(O_G),timeStep(TS_G),actions(X_G),timeStep(VAR_0).
:-occurs(X_G,TS_G),instance(X_G,move),event_object(X_G,O_G),event_origin(X_G,Or_G),instance(Or_G,spatial_entity),-location(O_G,Or_G,TS_G),tangible_entity(O_G),actions(X_G),universe(X_G),event(X_G),entity(O_G),spatial_entity(Or_G),universe(Or_G),timeStep(TS_G).
:-occurs(X_G,TS_G),instance(X_G,move),event_object(X_G,O_G),event_origin(X_G,Or_G),instance(Or_G,tangible_entity),location(Or_G,P_G,TS_G),-location(O_G,P_G,TS_G),actions(X_G),entity(O_G),event(X_G),timeStep(TS_G),spatial_entity(Or_G),tangible_entity(O_G),spatial_entity(P_G),universe(Or_G),tangible_entity(Or_G),universe(X_G).
:-occurs(X_G,TS_G),instance(X_G,move),event_object(X_G,O_G),is_held(O_G,TS_G),-defined_agent(X_G),universe(X_G),timeStep(TS_G),event(X_G),entity(O_G),tangible_entity(O_G),actions(X_G).
:-occurs(X_G,TS_G),instance(X_G,move),event_object(X_G,O_G),is_held(O_G,TS_G),event_agent(X_G,A_G),-held_by(O_G,A_G,TS_G),actions(X_G),event(X_G),entity(A_G),tangible_entity(O_G),timeStep(TS_G),tangible_entity(A_G),entity(O_G),universe(X_G).
:-occurs(X_G,TS_G),instance(X_G,move),event_object(X_G,O_G),is_restrained(O_G,TS_G),tangible_entity(O_G),timeStep(TS_G),entity(O_G),universe(X_G),actions(X_G),event(X_G).
:-occurs(X_G,TS_G),instance(X_G,move),event_path(X_G,P_G),is_blocked(P_G,TS_G),universe(X_G),timeStep(TS_G),spatial_entity(P_G),event(X_G),actions(X_G).
:-occurs(X_G,TS_G),instance(X_G,carry),event_object(X_G,O_G),event_agent(X_G,A_G),-held_by(O_G,A_G,TS_G),event(X_G),tangible_entity(O_G),actions(X_G),universe(X_G),entity(O_G),timeStep(TS_G),tangible_entity(A_G),entity(A_G).
:-occurs(X_G,TS_G),instance(X_G,transfer),event_donor(X_G,D_G),event_object(X_G,O_G),-possesses(D_G,O_G,TS_G),entity(O_G),entity(D_G),event(X_G),actions(X_G),timeStep(TS_G),universe(X_G).
:-occurs(X_G,TS_G),instance(X_G,transfer),event_object(X_G,O_G),event_recipient(X_G,R_G),location(R_G,A_G,TS_G),location(O_G,B_G,TS_G),spatial_entity(A_G),spatial_entity(B_G),A_G!=B_G,actions(X_G),entity(R_G),universe(X_G),event(X_G),timeStep(TS_G),entity(O_G),tangible_entity(R_G),tangible_entity(O_G).
-location(X_G,Y_G,TS_G):-location(X_G,Z_G,TS_G),spatial_entity(Y_G),spatial_entity(Z_G),Y_G!=Z_G,tangible_entity(X_G),timeStep(TS_G).
is_near(X_G,Y_G,TS_G):-is_near(Y_G,X_G,TS_G),spatial_entity(X_G),spatial_entity(Y_G),timeStep(TS_G).
-is_near(X_G,Y_G,TS_G):--is_near(Y_G,X_G,TS_G),spatial_entity(X_G),spatial_entity(Y_G),timeStep(TS_G).
abuts(X_G,Y_G,TS_G):-abuts(Y_G,X_G,TS_G),spatial_entity(Y_G),spatial_entity(X_G),timeStep(TS_G).
-abuts(X_G,Y_G,TS_G):--abuts(Y_G,X_G,TS_G),spatial_entity(X_G),spatial_entity(Y_G),timeStep(TS_G).
is_beside(X_G,Y_G,TS_G):-is_beside(Y_G,X_G,TS_G),timeStep(TS_G),spatial_entity(Y_G),spatial_entity(X_G).
-is_beside(X_G,Y_G,TS_G):--is_beside(Y_G,X_G,TS_G),timeStep(TS_G),spatial_entity(Y_G),spatial_entity(X_G).
is_opposite(X_G,Y_G,TS_G):-is_opposite(Y_G,X_G,TS_G),spatial_entity(X_G),spatial_entity(Y_G),timeStep(TS_G).
-is_opposite(X_G,Y_G,TS_G):--is_opposite(Y_G,X_G,TS_G),timeStep(TS_G),spatial_entity(Y_G),spatial_entity(X_G).
-is_above(Y_G,X_G,TS_G):-is_above(X_G,Y_G,TS_G),spatial_entity(X_G),spatial_entity(Y_G),X_G!=Y_G,timeStep(TS_G).
-is_below(Y_G,X_G,TS_G):-is_below(X_G,Y_G,TS_G),spatial_entity(X_G),spatial_entity(Y_G),X_G!=Y_G,timeStep(TS_G).
-is_behind(Y_G,X_G,TS_G):-is_behind(X_G,Y_G,TS_G),spatial_entity(X_G),spatial_entity(Y_G),X_G!=Y_G,timeStep(TS_G).
-is_in_front_of(Y_G,X_G,TS_G):-is_in_front_of(X_G,Y_G,TS_G),spatial_entity(X_G),spatial_entity(Y_G),X_G!=Y_G,timeStep(TS_G).
-is_inside(Y_G,X_G,TS_G):-is_inside(X_G,Y_G,TS_G),spatial_entity(X_G),spatial_entity(Y_G),X_G!=Y_G,timeStep(TS_G).
-is_over(Y_G,X_G,TS_G):-is_over(X_G,Y_G,TS_G),spatial_entity(X_G),spatial_entity(Y_G),X_G!=Y_G,timeStep(TS_G).
-is_under(Y_G,X_G,TS_G):-is_under(X_G,Y_G,TS_G),spatial_entity(X_G),spatial_entity(Y_G),X_G!=Y_G,timeStep(TS_G).
-is_on(Y_G,X_G,TS_G):-is_on(X_G,Y_G,TS_G),spatial_entity(X_G),spatial_entity(Y_G),X_G!=Y_G,timeStep(TS_G).
-encloses(Y_G,X_G,TS_G):-encloses(X_G,Y_G,TS_G),spatial_entity(X_G),spatial_entity(Y_G),X_G!=Y_G,timeStep(TS_G).
possesses(B_G,A_G,TS_G):-held_by(A_G,B_G,TS_G),entity(B_G),entity(A_G),tangible_entity(B_G),tangible_entity(A_G),timeStep(TS_G).
-possesses(B_G,A_G,TS_G):--held_by(A_G,B_G,TS_G),entity(A_G),timeStep(TS_G),tangible_entity(A_G),tangible_entity(B_G),entity(B_G).
held_by(B_G,A_G,TS_G):-instance(B_G,tangible_entity),possesses(A_G,B_G,TS_G),tangible_entity(A_G),universe(B_G),timeStep(TS_G),entity(A_G),entity(B_G),tangible_entity(B_G).
-held_by(B_G,A_G,TS_G):-instance(B_G,tangible_entity),-possesses(A_G,B_G,TS_G),entity(B_G),tangible_entity(A_G),timeStep(TS_G),universe(B_G),entity(A_G),tangible_entity(B_G).
location(A_G,P_G,TS_G):-held_by(A_G,B_G,TS_G),location(B_G,P_G,TS_G),instance(A_G,tangible_entity),tangible_entity(B_G),tangible_entity(A_G),universe(A_G),timeStep(TS_G),spatial_entity(P_G).
-location(A_G,P_G,TS_G):-held_by(A_G,B_G,TS_G),-location(B_G,P_G,TS_G),instance(A_G,tangible_entity),tangible_entity(B_G),timeStep(TS_G),spatial_entity(P_G),tangible_entity(A_G),universe(A_G).
happened(e1,0).
happened(e2,1).
occurs(e1,0):-happened(e1,0).
occurs(e2,1):-happened(e2,1).
spatial_entity(r2).
spatial_entity(r3).
spatial_entity(r1).
universe(r2).
universe(r3).
universe(true).
universe(false).
universe(e1).
universe(e2).
universe(r1).
sort_hierarchy_nodes_(spatial_entity).
sort_hierarchy_nodes_(physical_object).
sort_hierarchy_nodes_(living_entity).
sort_hierarchy_nodes_(activity).
sort_hierarchy_nodes_(locomotion).
sort_hierarchy_nodes_(deliver).
sort_hierarchy_nodes_(office).
sort_hierarchy_nodes_(inanimate_object).
sort_hierarchy_nodes_(get_13_5_1_1).
sort_hierarchy_nodes_(integers).
sort_hierarchy_nodes_(get_13_5_1).
sort_hierarchy_nodes_(apple).
sort_hierarchy_nodes_(timeStep).
sort_hierarchy_nodes_(leave).
sort_hierarchy_nodes_(booleans).
sort_hierarchy_nodes_(place).
sort_hierarchy_nodes_(event).
sort_hierarchy_nodes_(obtain).
sort_hierarchy_nodes_(receive).
sort_hierarchy_nodes_(move).
sort_hierarchy_nodes_(tangible_entity).
sort_hierarchy_nodes_(comparable_integers_subsort).
sort_hierarchy_nodes_(lose).
sort_hierarchy_nodes_(meander_47_7_1).
sort_hierarchy_nodes_(go_to).
sort_hierarchy_nodes_(meander_47_7).
sort_hierarchy_nodes_(take).
sort_hierarchy_nodes_(transfer).
sort_hierarchy_nodes_(universe).
sort_hierarchy_nodes_(john).
sort_hierarchy_nodes_(carry).
sort_hierarchy_nodes_(actions).
sort_hierarchy_nodes_(thing).
sort_hierarchy_nodes_(entity).
sort_hierarchy_nodes_(walk).
entity(r2).
entity(r3).
entity(r1).
actions(e1).
actions(e2).
event(e1).
event(e2).
thing(r2).
thing(r3).
thing(e1).
thing(e2).
thing(r1).
living_entity(r2).
living_entity(r1).
tangible_entity(r2).
tangible_entity(r1).
timeStep(0).
timeStep(1).
timeStep(2).
event_path_(X1,X2):-event_path(X1,X2).
event_path__(X1,X2):--event_path(X1,X2).
dom_is_restrained_(X1,X2):-dom_is_restrained(X1,X2).
dom_is_restrained__(X1,X2):--dom_is_restrained(X1,X2).
is_near_(X1,X2,X3):-is_near(X1,X2,X3).
is_near__(X1,X2,X3):--is_near(X1,X2,X3).
defined_path_(X1):-defined_path(X1).
defined_path__(X1):--defined_path(X1).
defined_raw_material_(X1):-defined_raw_material(X1).
defined_raw_material__(X1):--defined_raw_material(X1).
is_under_(X1,X2,X3):-is_under(X1,X2,X3).
is_under__(X1,X2,X3):--is_under(X1,X2,X3).
event_raw_material_(X1,X2):-event_raw_material(X1,X2).
event_raw_material__(X1,X2):--event_raw_material(X1,X2).
observed_(X1,X2,X3):-observed(X1,X2,X3).
observed__(X1,X2,X3):--observed(X1,X2,X3).
is_outside_(X1,X2,X3):-is_outside(X1,X2,X3).
is_outside__(X1,X2,X3):--is_outside(X1,X2,X3).
dom_confined_to_(X1,X2,X3):-dom_confined_to(X1,X2,X3).
dom_confined_to__(X1,X2,X3):--dom_confined_to(X1,X2,X3).
dom_is_in_front_of_(X1,X2,X3):-dom_is_in_front_of(X1,X2,X3).
dom_is_in_front_of__(X1,X2,X3):--dom_is_in_front_of(X1,X2,X3).
dom_actions_vn_instrument_(X1,X2):-dom_actions_vn_instrument(X1,X2).
dom_actions_vn_instrument__(X1,X2):--dom_actions_vn_instrument(X1,X2).
dom_is_accessible_(X1,X2):-dom_is_accessible(X1,X2).
dom_is_accessible__(X1,X2):--dom_is_accessible(X1,X2).
has_part_(X1,X2,X3):-has_part(X1,X2,X3).
has_part__(X1,X2,X3):--has_part(X1,X2,X3).
dom_occurs_(X1,X2):-dom_occurs(X1,X2).
dom_occurs__(X1,X2):--dom_occurs(X1,X2).
event_toward_(X1,X2):-event_toward(X1,X2).
event_toward__(X1,X2):--event_toward(X1,X2).
is_above_(X1,X2,X3):-is_above(X1,X2,X3).
is_above__(X1,X2,X3):--is_above(X1,X2,X3).
dom_actions_vn_source_(X1,X2):-dom_actions_vn_source(X1,X2).
dom_actions_vn_source__(X1,X2):--dom_actions_vn_source(X1,X2).
shut_out_of_(X1,X2,X3):-shut_out_of(X1,X2,X3).
shut_out_of__(X1,X2,X3):--shut_out_of(X1,X2,X3).
defined_donor_(X1):-defined_donor(X1).
defined_donor__(X1):--defined_donor(X1).
dom_is_over_(X1,X2,X3):-dom_is_over(X1,X2,X3).
dom_is_over__(X1,X2,X3):--dom_is_over(X1,X2,X3).
defined_result_(X1):-defined_result(X1).
defined_result__(X1):--defined_result(X1).
dom_known_to_(X1,X2,X3):-dom_known_to(X1,X2,X3).
dom_known_to__(X1,X2,X3):--dom_known_to(X1,X2,X3).
dom_actions_vn_cause_(X1,X2):-dom_actions_vn_cause(X1,X2).
dom_actions_vn_cause__(X1,X2):--dom_actions_vn_cause(X1,X2).
dom_actions_vn_value_(X1,X2):-dom_actions_vn_value(X1,X2).
dom_actions_vn_value__(X1,X2):--dom_actions_vn_value(X1,X2).
dom_defined_toward_(X1):-dom_defined_toward(X1).
dom_defined_toward__(X1):--dom_defined_toward(X1).
dom_actions_vn_product_(X1,X2):-dom_actions_vn_product(X1,X2).
dom_actions_vn_product__(X1,X2):--dom_actions_vn_product(X1,X2).
defined_recipient_(X1):-defined_recipient(X1).
defined_recipient__(X1):--defined_recipient(X1).
dom_sink_(X1):-dom_sink(X1).
dom_sink__(X1):--dom_sink(X1).
dom_is_opposite_(X1,X2,X3):-dom_is_opposite(X1,X2,X3).
dom_is_opposite__(X1,X2,X3):--dom_is_opposite(X1,X2,X3).
actions_vn_copatient_(X1,X2):-actions_vn_copatient(X1,X2).
actions_vn_copatient__(X1,X2):--actions_vn_copatient(X1,X2).
dom_actions_vn_cotheme_(X1,X2):-dom_actions_vn_cotheme(X1,X2).
dom_actions_vn_cotheme__(X1,X2):--dom_actions_vn_cotheme(X1,X2).
dom_event_instrument_(X1,X2):-dom_event_instrument(X1,X2).
dom_event_instrument__(X1,X2):--dom_event_instrument(X1,X2).
event_origin_(X1,X2):-event_origin(X1,X2).
event_origin__(X1,X2):--event_origin(X1,X2).
dom_actions_vn_theme_(X1,X2):-dom_actions_vn_theme(X1,X2).
dom_actions_vn_theme__(X1,X2):--dom_actions_vn_theme(X1,X2).
dom_defined_site_(X1):-dom_defined_site(X1).
dom_defined_site__(X1):--dom_defined_site(X1).
defined_instrument_(X1):-defined_instrument(X1).
defined_instrument__(X1):--defined_instrument(X1).
dom_defined_origin_(X1):-dom_defined_origin(X1).
dom_defined_origin__(X1):--dom_defined_origin(X1).
actions_vn_experiencer_(X1,X2):-actions_vn_experiencer(X1,X2).
actions_vn_experiencer__(X1,X2):--actions_vn_experiencer(X1,X2).
actions_vn_source_(X1,X2):-actions_vn_source(X1,X2).
actions_vn_source__(X1,X2):--actions_vn_source(X1,X2).
dom_event_path_(X1,X2):-dom_event_path(X1,X2).
dom_event_path__(X1,X2):--dom_event_path(X1,X2).
actions_vn_recipient_(X1,X2):-actions_vn_recipient(X1,X2).
actions_vn_recipient__(X1,X2):--actions_vn_recipient(X1,X2).
actions_vn_initial_location_(X1,X2):-actions_vn_initial_location(X1,X2).
actions_vn_initial_location__(X1,X2):--actions_vn_initial_location(X1,X2).
dom_is_a_(X1,X2):-dom_is_a(X1,X2).
dom_is_a__(X1,X2):--dom_is_a(X1,X2).
actions_vn_beneficiary_(X1,X2):-actions_vn_beneficiary(X1,X2).
actions_vn_beneficiary__(X1,X2):--actions_vn_beneficiary(X1,X2).
dom_defined_experiencer_(X1):-dom_defined_experiencer(X1).
dom_defined_experiencer__(X1):--dom_defined_experiencer(X1).
dom_defined_recipient_(X1):-dom_defined_recipient(X1).
dom_defined_recipient__(X1):--dom_defined_recipient(X1).
dom_is_between_(X1,X2,X3):-dom_is_between(X1,X2,X3).
dom_is_between__(X1,X2,X3):--dom_is_between(X1,X2,X3).
is_beside_(X1,X2,X3):-is_beside(X1,X2,X3).
is_beside__(X1,X2,X3):--is_beside(X1,X2,X3).
dom_actions_vn_initial_location_(X1,X2):-dom_actions_vn_initial_location(X1,X2).
dom_actions_vn_initial_location__(X1,X2):--dom_actions_vn_initial_location(X1,X2).
dom_actions_vn_predicate_(X1,X2):-dom_actions_vn_predicate(X1,X2).
dom_actions_vn_predicate__(X1,X2):--dom_actions_vn_predicate(X1,X2).
dom_defined_beneficiary_(X1):-dom_defined_beneficiary(X1).
dom_defined_beneficiary__(X1):--dom_defined_beneficiary(X1).
dom_is_beside_(X1,X2,X3):-dom_is_beside(X1,X2,X3).
dom_is_beside__(X1,X2,X3):--dom_is_beside(X1,X2,X3).
dom_subsort_(X1,X2):-dom_subsort(X1,X2).
dom_subsort__(X1,X2):--dom_subsort(X1,X2).
dom_actions_vn_attribute_(X1,X2):-dom_actions_vn_attribute(X1,X2).
dom_actions_vn_attribute__(X1,X2):--dom_actions_vn_attribute(X1,X2).
dom_defined_away_from_(X1):-dom_defined_away_from(X1).
dom_defined_away_from__(X1):--dom_defined_away_from(X1).
defined_experiencer_(X1):-defined_experiencer(X1).
defined_experiencer__(X1):--defined_experiencer(X1).
abuts_(X1,X2,X3):-abuts(X1,X2,X3).
abuts__(X1,X2,X3):--abuts(X1,X2,X3).
actions_vn_product_(X1,X2):-actions_vn_product(X1,X2).
actions_vn_product__(X1,X2):--actions_vn_product(X1,X2).
has_child_(X1):-has_child(X1).
has_child__(X1):--has_child(X1).
dom_actions_vn_destination_(X1,X2):-dom_actions_vn_destination(X1,X2).
dom_actions_vn_destination__(X1,X2):--dom_actions_vn_destination(X1,X2).
defined_beneficiary_(X1):-defined_beneficiary(X1).
defined_beneficiary__(X1):--defined_beneficiary(X1).
dom_is_known_(X1,X2):-dom_is_known(X1,X2).
dom_is_known__(X1,X2):--dom_is_known(X1,X2).
is_confined_(X1,X2):-is_confined(X1,X2).
is_confined__(X1,X2):--is_confined(X1,X2).
actions_vn_instrument_(X1,X2):-actions_vn_instrument(X1,X2).
actions_vn_instrument__(X1,X2):--actions_vn_instrument(X1,X2).
dom_contained_in_(X1,X2,X3):-dom_contained_in(X1,X2,X3).
dom_contained_in__(X1,X2,X3):--dom_contained_in(X1,X2,X3).
dom_source_(X1):-dom_source(X1).
dom_source__(X1):--dom_source(X1).
dom_is_below_(X1,X2,X3):-dom_is_below(X1,X2,X3).
dom_is_below__(X1,X2,X3):--dom_is_below(X1,X2,X3).
is_accessible_(X1,X2):-is_accessible(X1,X2).
is_accessible__(X1,X2):--is_accessible(X1,X2).
source_(X1):-source(X1).
source__(X1):--source(X1).
defined_destination_(X1):-defined_destination(X1).
defined_destination__(X1):--defined_destination(X1).
dom_is_confined_(X1,X2):-dom_is_confined(X1,X2).
dom_is_confined__(X1,X2):--dom_is_confined(X1,X2).
dom_event_donor_(X1,X2):-dom_event_donor(X1,X2).
dom_event_donor__(X1,X2):--dom_event_donor(X1,X2).
actions_vn_result_(X1,X2):-actions_vn_result(X1,X2).
actions_vn_result__(X1,X2):--actions_vn_result(X1,X2).
is_at_(X1,X2,X3):-is_at(X1,X2,X3).
is_at__(X1,X2,X3):--is_at(X1,X2,X3).
dom_location_(X1,X2,X3):-dom_location(X1,X2,X3).
dom_location__(X1,X2,X3):--dom_location(X1,X2,X3).
dom_actions_vn_initial_state_(X1,X2):-dom_actions_vn_initial_state(X1,X2).
dom_actions_vn_initial_state__(X1,X2):--dom_actions_vn_initial_state(X1,X2).
dom_event_raw_material_(X1,X2):-dom_event_raw_material(X1,X2).
dom_event_raw_material__(X1,X2):--dom_event_raw_material(X1,X2).
is_closed_(X1,X2):-is_closed(X1,X2).
is_closed__(X1,X2):--is_closed(X1,X2).
dom_accessible_to_(X1,X2,X3):-dom_accessible_to(X1,X2,X3).
dom_accessible_to__(X1,X2,X3):--dom_accessible_to(X1,X2,X3).
is_opposite_(X1,X2,X3):-is_opposite(X1,X2,X3).
is_opposite__(X1,X2,X3):--is_opposite(X1,X2,X3).
defined_origin_(X1):-defined_origin(X1).
defined_origin__(X1):--defined_origin(X1).
is_below_(X1,X2,X3):-is_below(X1,X2,X3).
is_below__(X1,X2,X3):--is_below(X1,X2,X3).
actions_vn_cause_(X1,X2):-actions_vn_cause(X1,X2).
actions_vn_cause__(X1,X2):--actions_vn_cause(X1,X2).
dom_defined_donor_(X1):-dom_defined_donor(X1).
dom_defined_donor__(X1):--dom_defined_donor(X1).
defined_away_from_(X1):-defined_away_from(X1).
defined_away_from__(X1):--defined_away_from(X1).
actions_vn_agent_(X1,X2):-actions_vn_agent(X1,X2).
actions_vn_agent__(X1,X2):--actions_vn_agent(X1,X2).
sink_(X1):-sink(X1).
sink__(X1):--sink(X1).
actions_vn_stimulus_(X1,X2):-actions_vn_stimulus(X1,X2).
actions_vn_stimulus__(X1,X2):--actions_vn_stimulus(X1,X2).
actions_vn_value_(X1,X2):-actions_vn_value(X1,X2).
actions_vn_value__(X1,X2):--actions_vn_value(X1,X2).
dom_is_on_(X1,X2,X3):-dom_is_on(X1,X2,X3).
dom_is_on__(X1,X2,X3):--dom_is_on(X1,X2,X3).
dom_actions_vn_location_(X1,X2):-dom_actions_vn_location(X1,X2).
dom_actions_vn_location__(X1,X2):--dom_actions_vn_location(X1,X2).
dom_actions_vn_actor_(X1,X2):-dom_actions_vn_actor(X1,X2).
dom_actions_vn_actor__(X1,X2):--dom_actions_vn_actor(X1,X2).
dom_actions_vn_material_(X1,X2):-dom_actions_vn_material(X1,X2).
dom_actions_vn_material__(X1,X2):--dom_actions_vn_material(X1,X2).
dom_instance_(X1,X2):-dom_instance(X1,X2).
dom_instance__(X1,X2):--dom_instance(X1,X2).
is_a_(X1,X2):-is_a(X1,X2).
is_a__(X1,X2):--is_a(X1,X2).
encloses_(X1,X2,X3):-encloses(X1,X2,X3).
encloses__(X1,X2,X3):--encloses(X1,X2,X3).
dom_event_agent_(X1,X2):-dom_event_agent(X1,X2).
dom_event_agent__(X1,X2):--dom_event_agent(X1,X2).
known_to_(X1,X2,X3):-known_to(X1,X2,X3).
known_to__(X1,X2,X3):--known_to(X1,X2,X3).
dom_is_along_(X1,X2,X3):-dom_is_along(X1,X2,X3).
dom_is_along__(X1,X2,X3):--dom_is_along(X1,X2,X3).
is_contained_(X1,X2):-is_contained(X1,X2).
is_contained__(X1,X2):--is_contained(X1,X2).
actions_vn_pivot_(X1,X2):-actions_vn_pivot(X1,X2).
actions_vn_pivot__(X1,X2):--actions_vn_pivot(X1,X2).
actions_vn_asset_(X1,X2):-actions_vn_asset(X1,X2).
actions_vn_asset__(X1,X2):--actions_vn_asset(X1,X2).
content_(X1,X2,X3):-content(X1,X2,X3).
content__(X1,X2,X3):--content(X1,X2,X3).
actions_vn_cotheme_(X1,X2):-actions_vn_cotheme(X1,X2).
actions_vn_cotheme__(X1,X2):--actions_vn_cotheme(X1,X2).
is_over_(X1,X2,X3):-is_over(X1,X2,X3).
is_over__(X1,X2,X3):--is_over(X1,X2,X3).
dom_encloses_(X1,X2,X3):-dom_encloses(X1,X2,X3).
dom_encloses__(X1,X2,X3):--dom_encloses(X1,X2,X3).
dom_is_touching_(X1,X2,X3):-dom_is_touching(X1,X2,X3).
dom_is_touching__(X1,X2,X3):--dom_is_touching(X1,X2,X3).
actions_vn_patient_(X1,X2):-actions_vn_patient(X1,X2).
actions_vn_patient__(X1,X2):--actions_vn_patient(X1,X2).
accessible_to_(X1,X2,X3):-accessible_to(X1,X2,X3).
accessible_to__(X1,X2,X3):--accessible_to(X1,X2,X3).
dom_is_outside_(X1,X2,X3):-dom_is_outside(X1,X2,X3).
dom_is_outside__(X1,X2,X3):--dom_is_outside(X1,X2,X3).
dom_is_near_(X1,X2,X3):-dom_is_near(X1,X2,X3).
dom_is_near__(X1,X2,X3):--dom_is_near(X1,X2,X3).
dom_actions_vn_copatient_(X1,X2):-dom_actions_vn_copatient(X1,X2).
dom_actions_vn_copatient__(X1,X2):--dom_actions_vn_copatient(X1,X2).
dom_defined_object_(X1):-dom_defined_object(X1).
dom_defined_object__(X1):--dom_defined_object(X1).
dom_actions_vn_reflexive_(X1,X2):-dom_actions_vn_reflexive(X1,X2).
dom_actions_vn_reflexive__(X1,X2):--dom_actions_vn_reflexive(X1,X2).
dom_event_destination_(X1,X2):-dom_event_destination(X1,X2).
dom_event_destination__(X1,X2):--dom_event_destination(X1,X2).
dom_defined_result_(X1):-dom_defined_result(X1).
dom_defined_result__(X1):--dom_defined_result(X1).
dom_event_object_(X1,X2):-dom_event_object(X1,X2).
dom_event_object__(X1,X2):--dom_event_object(X1,X2).
dom_defined_base_(X1):-dom_defined_base(X1).
dom_defined_base__(X1):--dom_defined_base(X1).
is_on_(X1,X2,X3):-is_on(X1,X2,X3).
is_on__(X1,X2,X3):--is_on(X1,X2,X3).
actions_vn_coagent_(X1,X2):-actions_vn_coagent(X1,X2).
actions_vn_coagent__(X1,X2):--actions_vn_coagent(X1,X2).
dom_event_result_(X1,X2):-dom_event_result(X1,X2).
dom_event_result__(X1,X2):--dom_event_result(X1,X2).
event_agent_(X1,X2):-event_agent(X1,X2).
event_agent__(X1,X2):--event_agent(X1,X2).
is_touching_(X1,X2,X3):-is_touching(X1,X2,X3).
is_touching__(X1,X2,X3):--is_touching(X1,X2,X3).
dom_actions_vn_recipient_(X1,X2):-dom_actions_vn_recipient(X1,X2).
dom_actions_vn_recipient__(X1,X2):--dom_actions_vn_recipient(X1,X2).
dom_actions_vn_topic_(X1,X2):-dom_actions_vn_topic(X1,X2).
dom_actions_vn_topic__(X1,X2):--dom_actions_vn_topic(X1,X2).
actions_vn_theme_(X1,X2):-actions_vn_theme(X1,X2).
actions_vn_theme__(X1,X2):--actions_vn_theme(X1,X2).
location_(X1,X2,X3):-location(X1,X2,X3).
location__(X1,X2,X3):--location(X1,X2,X3).
actions_vn_extent_(X1,X2):-actions_vn_extent(X1,X2).
actions_vn_extent__(X1,X2):--actions_vn_extent(X1,X2).
dom_actions_vn_time_(X1,X2):-dom_actions_vn_time(X1,X2).
dom_actions_vn_time__(X1,X2):--dom_actions_vn_time(X1,X2).
dom_is_above_(X1,X2,X3):-dom_is_above(X1,X2,X3).
dom_is_above__(X1,X2,X3):--dom_is_above(X1,X2,X3).
occurs_(X1,X2):-occurs(X1,X2).
occurs__(X1,X2):--occurs(X1,X2).
is_known_(X1,X2):-is_known(X1,X2).
is_known__(X1,X2):--is_known(X1,X2).
dom_actions_vn_beneficiary_(X1,X2):-dom_actions_vn_beneficiary(X1,X2).
dom_actions_vn_beneficiary__(X1,X2):--dom_actions_vn_beneficiary(X1,X2).
dom_blocked_with_(X1,X2,X3):-dom_blocked_with(X1,X2,X3).
dom_blocked_with__(X1,X2,X3):--dom_blocked_with(X1,X2,X3).
dom_actions_vn_experiencer_(X1,X2):-dom_actions_vn_experiencer(X1,X2).
dom_actions_vn_experiencer__(X1,X2):--dom_actions_vn_experiencer(X1,X2).
defined_agent_(X1):-defined_agent(X1).
defined_agent__(X1):--defined_agent(X1).
dom_is_inside_(X1,X2,X3):-dom_is_inside(X1,X2,X3).
dom_is_inside__(X1,X2,X3):--dom_is_inside(X1,X2,X3).
dom_defined_raw_material_(X1):-dom_defined_raw_material(X1).
dom_defined_raw_material__(X1):--dom_defined_raw_material(X1).
actions_vn_predicate_(X1,X2):-actions_vn_predicate(X1,X2).
actions_vn_predicate__(X1,X2):--actions_vn_predicate(X1,X2).
event_recipient_(X1,X2):-event_recipient(X1,X2).
event_recipient__(X1,X2):--event_recipient(X1,X2).
dom_is_under_(X1,X2,X3):-dom_is_under(X1,X2,X3).
dom_is_under__(X1,X2,X3):--dom_is_under(X1,X2,X3).
defined_site_(X1):-defined_site(X1).
defined_site__(X1):--defined_site(X1).
actions_vn_attribute_(X1,X2):-actions_vn_attribute(X1,X2).
actions_vn_attribute__(X1,X2):--actions_vn_attribute(X1,X2).
dom_actions_vn_pivot_(X1,X2):-dom_actions_vn_pivot(X1,X2).
dom_actions_vn_pivot__(X1,X2):--dom_actions_vn_pivot(X1,X2).
dom_shut_out_of_(X1,X2,X3):-dom_shut_out_of(X1,X2,X3).
dom_shut_out_of__(X1,X2,X3):--dom_shut_out_of(X1,X2,X3).
dom_event_origin_(X1,X2):-dom_event_origin(X1,X2).
dom_event_origin__(X1,X2):--dom_event_origin(X1,X2).
dom_possesses_(X1,X2,X3):-dom_possesses(X1,X2,X3).
dom_possesses__(X1,X2,X3):--dom_possesses(X1,X2,X3).
dom_actions_vn_causer_(X1,X2):-dom_actions_vn_causer(X1,X2).
dom_actions_vn_causer__(X1,X2):--dom_actions_vn_causer(X1,X2).
confined_to_(X1,X2,X3):-confined_to(X1,X2,X3).
confined_to__(X1,X2,X3):--confined_to(X1,X2,X3).
is_held_(X1,X2):-is_held(X1,X2).
is_held__(X1,X2):--is_held(X1,X2).
dom_held_by_(X1,X2,X3):-dom_held_by(X1,X2,X3).
dom_held_by__(X1,X2,X3):--dom_held_by(X1,X2,X3).
dom_is_behind_(X1,X2,X3):-dom_is_behind(X1,X2,X3).
dom_is_behind__(X1,X2,X3):--dom_is_behind(X1,X2,X3).
dom_event_site_(X1,X2):-dom_event_site(X1,X2).
dom_event_site__(X1,X2):--dom_event_site(X1,X2).
actions_vn_causer_(X1,X2):-actions_vn_causer(X1,X2).
actions_vn_causer__(X1,X2):--actions_vn_causer(X1,X2).
is_behind_(X1,X2,X3):-is_behind(X1,X2,X3).
is_behind__(X1,X2,X3):--is_behind(X1,X2,X3).
dom_event_away_from_(X1,X2):-dom_event_away_from(X1,X2).
dom_event_away_from__(X1,X2):--dom_event_away_from(X1,X2).
dom_has_part_(X1,X2,X3):-dom_has_part(X1,X2,X3).
dom_has_part__(X1,X2,X3):--dom_has_part(X1,X2,X3).
defined_toward_(X1):-defined_toward(X1).
defined_toward__(X1):--defined_toward(X1).
dom_is_at_(X1,X2,X3):-dom_is_at(X1,X2,X3).
dom_is_at__(X1,X2,X3):--dom_is_at(X1,X2,X3).
dom_event_toward_(X1,X2):-dom_event_toward(X1,X2).
dom_event_toward__(X1,X2):--dom_event_toward(X1,X2).
dom_actions_vn_goal_(X1,X2):-dom_actions_vn_goal(X1,X2).
dom_actions_vn_goal__(X1,X2):--dom_actions_vn_goal(X1,X2).
dom_event_beneficiary_(X1,X2):-dom_event_beneficiary(X1,X2).
dom_event_beneficiary__(X1,X2):--dom_event_beneficiary(X1,X2).
dom_has_child_(X1):-dom_has_child(X1).
dom_has_child__(X1):--dom_has_child(X1).
is_along_(X1,X2,X3):-is_along(X1,X2,X3).
is_along__(X1,X2,X3):--is_along(X1,X2,X3).
actions_vn_trajectory_(X1,X2):-actions_vn_trajectory(X1,X2).
actions_vn_trajectory__(X1,X2):--actions_vn_trajectory(X1,X2).
event_site_(X1,X2):-event_site(X1,X2).
event_site__(X1,X2):--event_site(X1,X2).
event_experiencer_(X1,X2):-event_experiencer(X1,X2).
event_experiencer__(X1,X2):--event_experiencer(X1,X2).
dom_event_recipient_(X1,X2):-dom_event_recipient(X1,X2).
dom_event_recipient__(X1,X2):--dom_event_recipient(X1,X2).
happened_(X1,X2):-happened(X1,X2).
happened__(X1,X2):--happened(X1,X2).
is_between_(X1,X2,X3):-is_between(X1,X2,X3).
is_between__(X1,X2,X3):--is_between(X1,X2,X3).
subsort_(X1,X2):-subsort(X1,X2).
subsort__(X1,X2):--subsort(X1,X2).
event_beneficiary_(X1,X2):-event_beneficiary(X1,X2).
event_beneficiary__(X1,X2):--event_beneficiary(X1,X2).
dom_actions_vn_trajectory_(X1,X2):-dom_actions_vn_trajectory(X1,X2).
dom_actions_vn_trajectory__(X1,X2):--dom_actions_vn_trajectory(X1,X2).
event_donor_(X1,X2):-event_donor(X1,X2).
event_donor__(X1,X2):--event_donor(X1,X2).
instance_(X1,X2):-instance(X1,X2).
instance__(X1,X2):--instance(X1,X2).
event_away_from_(X1,X2):-event_away_from(X1,X2).
event_away_from__(X1,X2):--event_away_from(X1,X2).
dom_defined_destination_(X1):-dom_defined_destination(X1).
dom_defined_destination__(X1):--dom_defined_destination(X1).
dom_event_experiencer_(X1,X2):-dom_event_experiencer(X1,X2).
dom_event_experiencer__(X1,X2):--dom_event_experiencer(X1,X2).
actions_vn_goal_(X1,X2):-actions_vn_goal(X1,X2).
actions_vn_goal__(X1,X2):--actions_vn_goal(X1,X2).
is_restrained_(X1,X2):-is_restrained(X1,X2).
is_restrained__(X1,X2):--is_restrained(X1,X2).
dom_actions_vn_patient_(X1,X2):-dom_actions_vn_patient(X1,X2).
dom_actions_vn_patient__(X1,X2):--dom_actions_vn_patient(X1,X2).
actions_vn_topic_(X1,X2):-actions_vn_topic(X1,X2).
actions_vn_topic__(X1,X2):--actions_vn_topic(X1,X2).
is_in_front_of_(X1,X2,X3):-is_in_front_of(X1,X2,X3).
is_in_front_of__(X1,X2,X3):--is_in_front_of(X1,X2,X3).
dom_actions_vn_coagent_(X1,X2):-dom_actions_vn_coagent(X1,X2).
dom_actions_vn_coagent__(X1,X2):--dom_actions_vn_coagent(X1,X2).
dom_actions_vn_asset_(X1,X2):-dom_actions_vn_asset(X1,X2).
dom_actions_vn_asset__(X1,X2):--dom_actions_vn_asset(X1,X2).
actions_vn_initial_state_(X1,X2):-actions_vn_initial_state(X1,X2).
actions_vn_initial_state__(X1,X2):--actions_vn_initial_state(X1,X2).
held_by_(X1,X2,X3):-held_by(X1,X2,X3).
held_by__(X1,X2,X3):--held_by(X1,X2,X3).
actions_vn_material_(X1,X2):-actions_vn_material(X1,X2).
actions_vn_material__(X1,X2):--actions_vn_material(X1,X2).
is_inside_(X1,X2,X3):-is_inside(X1,X2,X3).
is_inside__(X1,X2,X3):--is_inside(X1,X2,X3).
event_instrument_(X1,X2):-event_instrument(X1,X2).
event_instrument__(X1,X2):--event_instrument(X1,X2).
actions_vn_reflexive_(X1,X2):-actions_vn_reflexive(X1,X2).
actions_vn_reflexive__(X1,X2):--actions_vn_reflexive(X1,X2).
dom_abuts_(X1,X2,X3):-dom_abuts(X1,X2,X3).
dom_abuts__(X1,X2,X3):--dom_abuts(X1,X2,X3).
actions_vn_location_(X1,X2):-actions_vn_location(X1,X2).
actions_vn_location__(X1,X2):--actions_vn_location(X1,X2).
dom_defined_path_(X1):-dom_defined_path(X1).
dom_defined_path__(X1):--dom_defined_path(X1).
possesses_(X1,X2,X3):-possesses(X1,X2,X3).
possesses__(X1,X2,X3):--possesses(X1,X2,X3).
dom_actions_vn_agent_(X1,X2):-dom_actions_vn_agent(X1,X2).
dom_actions_vn_agent__(X1,X2):--dom_actions_vn_agent(X1,X2).
dom_defined_agent_(X1):-dom_defined_agent(X1).
dom_defined_agent__(X1):--dom_defined_agent(X1).
dom_defined_instrument_(X1):-dom_defined_instrument(X1).
dom_defined_instrument__(X1):--dom_defined_instrument(X1).
event_destination_(X1,X2):-event_destination(X1,X2).
event_destination__(X1,X2):--event_destination(X1,X2).
link_(X1,X2):-link(X1,X2).
link__(X1,X2):--link(X1,X2).
event_result_(X1,X2):-event_result(X1,X2).
event_result__(X1,X2):--event_result(X1,X2).
defined_base_(X1):-defined_base(X1).
defined_base__(X1):--defined_base(X1).
contained_in_(X1,X2,X3):-contained_in(X1,X2,X3).
contained_in__(X1,X2,X3):--contained_in(X1,X2,X3).
actions_vn_actor_(X1,X2):-actions_vn_actor(X1,X2).
actions_vn_actor__(X1,X2):--actions_vn_actor(X1,X2).
dom_is_held_(X1,X2):-dom_is_held(X1,X2).
dom_is_held__(X1,X2):--dom_is_held(X1,X2).
actions_vn_time_(X1,X2):-actions_vn_time(X1,X2).
actions_vn_time__(X1,X2):--actions_vn_time(X1,X2).
event_object_(X1,X2):-event_object(X1,X2).
event_object__(X1,X2):--event_object(X1,X2).
dom_actions_vn_extent_(X1,X2):-dom_actions_vn_extent(X1,X2).
dom_actions_vn_extent__(X1,X2):--dom_actions_vn_extent(X1,X2).
dom_link_(X1,X2):-dom_link(X1,X2).
dom_link__(X1,X2):--dom_link(X1,X2).
dom_actions_vn_stimulus_(X1,X2):-dom_actions_vn_stimulus(X1,X2).
dom_actions_vn_stimulus__(X1,X2):--dom_actions_vn_stimulus(X1,X2).
has_parent_(X1):-has_parent(X1).
has_parent__(X1):--has_parent(X1).
dom_content_(X1,X2,X3):-dom_content(X1,X2,X3).
dom_content__(X1,X2,X3):--dom_content(X1,X2,X3).
dom_event_base_(X1,X2):-dom_event_base(X1,X2).
dom_event_base__(X1,X2):--dom_event_base(X1,X2).
defined_object_(X1):-defined_object(X1).
defined_object__(X1):--defined_object(X1).
blocked_with_(X1,X2,X3):-blocked_with(X1,X2,X3).
blocked_with__(X1,X2,X3):--blocked_with(X1,X2,X3).
dom_is_blocked_(X1,X2):-dom_is_blocked(X1,X2).
dom_is_blocked__(X1,X2):--dom_is_blocked(X1,X2).
dom_is_closed_(X1,X2):-dom_is_closed(X1,X2).
dom_is_closed__(X1,X2):--dom_is_closed(X1,X2).
is_blocked_(X1,X2):-is_blocked(X1,X2).
is_blocked__(X1,X2):--is_blocked(X1,X2).
event_base_(X1,X2):-event_base(X1,X2).
event_base__(X1,X2):--event_base(X1,X2).
dom_actions_vn_result_(X1,X2):-dom_actions_vn_result(X1,X2).
dom_actions_vn_result__(X1,X2):--dom_actions_vn_result(X1,X2).
dom_has_parent_(X1):-dom_has_parent(X1).
dom_has_parent__(X1):--dom_has_parent(X1).
dom_is_contained_(X1,X2):-dom_is_contained(X1,X2).
dom_is_contained__(X1,X2):--dom_is_contained(X1,X2).
actions_vn_destination_(X1,X2):-actions_vn_destination(X1,X2).
actions_vn_destination__(X1,X2):--actions_vn_destination(X1,X2).
% event_path_ event_path__ dom_is_restrained_ dom_is_restrained__ is_near_ is_near__ defined_path_ defined_path__ defined_raw_material_ defined_raw_material__ is_under_ is_under__ event_raw_material_ event_raw_material__ observed_ observed__ is_outside_ is_outside__ dom_confined_to_ dom_confined_to__ dom_is_in_front_of_ dom_is_in_front_of__ dom_actions_vn_instrument_ dom_actions_vn_instrument__ dom_is_accessible_ dom_is_accessible__ has_part_ has_part__ dom_occurs_ dom_occurs__ event_toward_ event_toward__ is_above_ is_above__ dom_actions_vn_source_ dom_actions_vn_source__ shut_out_of_ shut_out_of__ defined_donor_ defined_donor__ dom_is_over_ dom_is_over__ defined_result_ defined_result__ dom_known_to_ dom_known_to__ dom_actions_vn_cause_ dom_actions_vn_cause__ dom_actions_vn_value_ dom_actions_vn_value__ dom_defined_toward_ dom_defined_toward__ dom_actions_vn_product_ dom_actions_vn_product__ defined_recipient_ defined_recipient__ dom_sink_ dom_sink__ dom_is_opposite_ dom_is_opposite__ actions_vn_copatient_ actions_vn_copatient__ dom_actions_vn_cotheme_ dom_actions_vn_cotheme__ dom_event_instrument_ dom_event_instrument__ event_origin_ event_origin__ dom_actions_vn_theme_ dom_actions_vn_theme__ dom_defined_site_ dom_defined_site__ defined_instrument_ defined_instrument__ dom_defined_origin_ dom_defined_origin__ actions_vn_experiencer_ actions_vn_experiencer__ actions_vn_source_ actions_vn_source__ dom_event_path_ dom_event_path__ actions_vn_recipient_ actions_vn_recipient__ actions_vn_initial_location_ actions_vn_initial_location__ dom_is_a_ dom_is_a__ actions_vn_beneficiary_ actions_vn_beneficiary__ dom_defined_experiencer_ dom_defined_experiencer__ dom_defined_recipient_ dom_defined_recipient__ dom_is_between_ dom_is_between__ is_beside_ is_beside__ dom_actions_vn_initial_location_ dom_actions_vn_initial_location__ dom_actions_vn_predicate_ dom_actions_vn_predicate__ dom_defined_beneficiary_ dom_defined_beneficiary__ dom_is_beside_ dom_is_beside__ dom_subsort_ dom_subsort__ dom_actions_vn_attribute_ dom_actions_vn_attribute__ dom_defined_away_from_ dom_defined_away_from__ defined_experiencer_ defined_experiencer__ abuts_ abuts__ actions_vn_product_ actions_vn_product__ has_child_ has_child__ dom_actions_vn_destination_ dom_actions_vn_destination__ defined_beneficiary_ defined_beneficiary__ dom_is_known_ dom_is_known__ is_confined_ is_confined__ actions_vn_instrument_ actions_vn_instrument__ dom_contained_in_ dom_contained_in__ dom_source_ dom_source__ dom_is_below_ dom_is_below__ is_accessible_ is_accessible__ source_ source__ defined_destination_ defined_destination__ dom_is_confined_ dom_is_confined__ dom_event_donor_ dom_event_donor__ actions_vn_result_ actions_vn_result__ is_at_ is_at__ dom_location_ dom_location__ dom_actions_vn_initial_state_ dom_actions_vn_initial_state__ dom_event_raw_material_ dom_event_raw_material__ is_closed_ is_closed__ dom_accessible_to_ dom_accessible_to__ is_opposite_ is_opposite__ defined_origin_ defined_origin__ is_below_ is_below__ actions_vn_cause_ actions_vn_cause__ dom_defined_donor_ dom_defined_donor__ defined_away_from_ defined_away_from__ actions_vn_agent_ actions_vn_agent__ sink_ sink__ actions_vn_stimulus_ actions_vn_stimulus__ actions_vn_value_ actions_vn_value__ dom_is_on_ dom_is_on__ dom_actions_vn_location_ dom_actions_vn_location__ dom_actions_vn_actor_ dom_actions_vn_actor__ dom_actions_vn_material_ dom_actions_vn_material__ dom_instance_ dom_instance__ is_a_ is_a__ encloses_ encloses__ dom_event_agent_ dom_event_agent__ known_to_ known_to__ dom_is_along_ dom_is_along__ is_contained_ is_contained__ actions_vn_pivot_ actions_vn_pivot__ actions_vn_asset_ actions_vn_asset__ content_ content__ actions_vn_cotheme_ actions_vn_cotheme__ is_over_ is_over__ dom_encloses_ dom_encloses__ dom_is_touching_ dom_is_touching__ actions_vn_patient_ actions_vn_patient__ accessible_to_ accessible_to__ dom_is_outside_ dom_is_outside__ dom_is_near_ dom_is_near__ dom_actions_vn_copatient_ dom_actions_vn_copatient__ dom_defined_object_ dom_defined_object__ dom_actions_vn_reflexive_ dom_actions_vn_reflexive__ dom_event_destination_ dom_event_destination__ dom_defined_result_ dom_defined_result__ dom_event_object_ dom_event_object__ dom_defined_base_ dom_defined_base__ is_on_ is_on__ actions_vn_coagent_ actions_vn_coagent__ dom_event_result_ dom_event_result__ event_agent_ event_agent__ is_touching_ is_touching__ dom_actions_vn_recipient_ dom_actions_vn_recipient__ dom_actions_vn_topic_ dom_actions_vn_topic__ actions_vn_theme_ actions_vn_theme__ location_ location__ actions_vn_extent_ actions_vn_extent__ dom_actions_vn_time_ dom_actions_vn_time__ dom_is_above_ dom_is_above__ occurs_ occurs__ is_known_ is_known__ dom_actions_vn_beneficiary_ dom_actions_vn_beneficiary__ dom_blocked_with_ dom_blocked_with__ dom_actions_vn_experiencer_ dom_actions_vn_experiencer__ defined_agent_ defined_agent__ dom_is_inside_ dom_is_inside__ dom_defined_raw_material_ dom_defined_raw_material__ actions_vn_predicate_ actions_vn_predicate__ event_recipient_ event_recipient__ dom_is_under_ dom_is_under__ defined_site_ defined_site__ actions_vn_attribute_ actions_vn_attribute__ dom_actions_vn_pivot_ dom_actions_vn_pivot__ dom_shut_out_of_ dom_shut_out_of__ dom_event_origin_ dom_event_origin__ dom_possesses_ dom_possesses__ dom_actions_vn_causer_ dom_actions_vn_causer__ confined_to_ confined_to__ is_held_ is_held__ dom_held_by_ dom_held_by__ dom_is_behind_ dom_is_behind__ dom_event_site_ dom_event_site__ actions_vn_causer_ actions_vn_causer__ is_behind_ is_behind__ dom_event_away_from_ dom_event_away_from__ dom_has_part_ dom_has_part__ defined_toward_ defined_toward__ dom_is_at_ dom_is_at__ dom_event_toward_ dom_event_toward__ dom_actions_vn_goal_ dom_actions_vn_goal__ dom_event_beneficiary_ dom_event_beneficiary__ dom_has_child_ dom_has_child__ is_along_ is_along__ actions_vn_trajectory_ actions_vn_trajectory__ event_site_ event_site__ event_experiencer_ event_experiencer__ dom_event_recipient_ dom_event_recipient__ happened_ happened__ is_between_ is_between__ subsort_ subsort__ event_beneficiary_ event_beneficiary__ dom_actions_vn_trajectory_ dom_actions_vn_trajectory__ event_donor_ event_donor__ instance_ instance__ event_away_from_ event_away_from__ dom_defined_destination_ dom_defined_destination__ dom_event_experiencer_ dom_event_experiencer__ actions_vn_goal_ actions_vn_goal__ is_restrained_ is_restrained__ dom_actions_vn_patient_ dom_actions_vn_patient__ actions_vn_topic_ actions_vn_topic__ is_in_front_of_ is_in_front_of__ dom_actions_vn_coagent_ dom_actions_vn_coagent__ dom_actions_vn_asset_ dom_actions_vn_asset__ actions_vn_initial_state_ actions_vn_initial_state__ held_by_ held_by__ actions_vn_material_ actions_vn_material__ is_inside_ is_inside__ event_instrument_ event_instrument__ actions_vn_reflexive_ actions_vn_reflexive__ dom_abuts_ dom_abuts__ actions_vn_location_ actions_vn_location__ dom_defined_path_ dom_defined_path__ possesses_ possesses__ dom_actions_vn_agent_ dom_actions_vn_agent__ dom_defined_agent_ dom_defined_agent__ dom_defined_instrument_ dom_defined_instrument__ event_destination_ event_destination__ link_ link__ event_result_ event_result__ defined_base_ defined_base__ contained_in_ contained_in__ actions_vn_actor_ actions_vn_actor__ dom_is_held_ dom_is_held__ actions_vn_time_ actions_vn_time__ event_object_ event_object__ dom_actions_vn_extent_ dom_actions_vn_extent__ dom_link_ dom_link__ dom_actions_vn_stimulus_ dom_actions_vn_stimulus__ has_parent_ has_parent__ dom_content_ dom_content__ dom_event_base_ dom_event_base__ defined_object_ defined_object__ blocked_with_ blocked_with__ dom_is_blocked_ dom_is_blocked__ dom_is_closed_ dom_is_closed__ is_blocked_ is_blocked__ event_base_ event_base__ dom_actions_vn_result_ dom_actions_vn_result__ dom_has_parent_ dom_has_parent__ dom_is_contained_ dom_is_contained__ actions_vn_destination_ actions_vn_destination__

%!explain location(X,Y,Z).