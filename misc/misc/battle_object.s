metalblade_attack_mainloop:
    push {r14}
    ldr r1, [metalblade_attack_mainloop_pool]
    ldrb r0,[r7]    ; get which phase we left off on
    ldr r1,[r1,r0]
    mov r14,r15
    bx r1
    pop {r15}
    .balign 4, 0
metalblade_attack_mainloop_pool:
    .word metalblade_attack_init | 1
    .word metalblade_attack_update | 1

metalblade_attack_init:
    push {r14}
    ldrb r0, [r7,0x01]
    cmp r0, 0x00
    bne .initialized
    mov r0,0x04
    strb r0, [r7,0x01]
    ;set timer for phase
    mov r0,0x08
    strh r0, [r7,0x10]
    mov r0,0x0c
    bl object_set_animation
    bl object_set_default_counter_time
    b .endroutine
.initialized:
    ldrh r0, [r7,0x10]
    sub r0,0x01
    strh r0, [r7,0x10]
    bgt .endroutine
    mov r0,4
    strh r0,[r7]
.endroutine:
    pop {r15}

metalblade_attack_update:
    push {r4-r7,r14}
    ldrb r0, [r7,0x01]
    cmp r0, 0x00
    bne .initialized

    ;set timer for phase
    mov r0, 0x18
    strh r0, [r7,0x10]
    mov r0, 0x04
    strb r0, [r7,0x01]
    bl object_get_front_direction
    ldrb r1,[r5,0x12]   ; panel in front of you
    add r0,r1,r0        ; metal blade panelx
    ldrb r1,[r5,0x13]   ; metal blade panely
    mov r2,AttackElement_Break;metal blade element
    mov r3,0x16
    lsl r3,0x10         ; metal blade z coordinate
    ldr r4, [r7,0x0C]   ; metal blade parameters
    ldr r6, [r7,0x08]   ; metal blade damage
    bl spawn_metalblade
    b .endroutine
.initialized:
    ldrh r0, [r7,0x10]
    sub r0,r0,1
    strh r0, [r7,0x10]
    bgt .endroutine
    bl object_exit_attack_state ; exit attack state
.endroutine:
    pop {r4,r5,r6,r7,r15}

; creates metal blade object
spawn_metalblade:
    push {r14}
    push {r0,r1,r2,r5}  ; save panelx, panely, element, and parent
    mov r0, demo_object_id
    bl object_spawn_type3
    mov r0,r5
    pop {r1,r2,r3,r5}   ; restore panelx, panely, element, and parent
    beq .endroutine
    strb r1, [r0,0x12]  ; set panelx
    strb r2, [r0,0x13]  ; set panely
    strb r3, [r0,0x0E]  ; set element
    str r5, [r0,0x4C]   ; set parent object
    str r6, [r0,0x2C]   ; set damage
    ldrh r3, [r5,0x16]
    strh r3, [r0,0x16]  ; make child object same alliance as parent
.endroutine:
    pop r15

metalblade_object_mainloop:
    push r14
    ldr r1,[metalblade_object_mainloop_pool]
    ldrb r0, [r5,0x08]
    ldr r1, [r1,r0]
    mov r14,r15
    bx r1
    pop r15
    .balign 4, 0
metalblade_object_mainloop_pool:
    .word metalblade_object_init | 1
    .word metalblade_object_update | 1
    .word object_generic_destroy | 1  ; generic destructor works for most objects

metalblade_object_init:
    push {r4,r5,r6,r7,r14}

    ; set visable bit (2)
    ldrb r0, [r5]
    mov r1, 0x02
    orr r0,r1
    strb r0, [r5]

    ; set proper coordinates for panel
    bl object_set_coordinates_from_panels

    ; load metalblade sprite
    mov r0, 0x80
    mov r1, 0x00
    mov r2, 0x0D
    bl sprite_load

    ; initialize to animation 0
    mov r0,0x00
    strh r0, [r5,0x10]

    ; initialize essential sprite stuff
    bl sprite_set_animation
    bl sprite_load_animation_data
    bl sprite_update        ; updates sprite data
    bl sprite_has_shadow    ; First oam is considered shadow, wont move with z
    bl object_get_flip
    bl sprite_set_flip      ; make sure the object is facing the right direction based on alliance

    ; setup movement velocities
    bl object_get_front_direction
    mov r1,0x08         ; x velocity is 8 pixels
    mul r0,r1           ; set direction
    lsl r0,r0,0x10      ; coordinates are shift left 16
    str r0, [r5,0x40]   ; set velocity
    mov r1,0x06         ; x velocity is 6 pixels
    lsl r1,r1,0x10
    str r1, [r5,0x44]   ; set velocity

    ; setup number of times to loop
    mov r0,0x3
    str r0, [r5,0x60]

    bl object_create_collision_data
    tst r0,r0               ; important to check if data was created
    bne .collisioninit
    bl object_free_memory   ; if it wasnt destroy the object
    pop {r4,r5,r6,r7,r15}
.collisioninit:
    mov r1,0x04     ; self collision type
    mov r2,0x05     ; target collision type
    mov r3,0x01     ; hit modifiers
    bl object_setup_collision_data
    mov r0,0x0A     ; Break hit effect
    bl object_set_collision_hit_effect
    bl object_present_collision_data
    mov r0,0x8F
    bl sound_play   ; play whir sound

    ;set to update routine
    mov r0,4
    strh r0, [r5,0x08]
    pop {r4,r5,r6,r7,r15}

metalblade_object_update:
    push {r14}
    bl object_remove_collision_data
    bl object_spawn_collision_effect
    ldr r0, [r5,0x54]
    ldr r1, [r0,0x70]
    tst r1,r1
    beq .nocollision
    bl object_clear_collision_reigon
.nocollision:
    ldrh r4, [r5,0x12]
    ldrb r0, [r5,0x09]
    ldr r1, [metalblade_object_update_pool]
    ldr r0, [r1,r0]
    mov r14,r15
    bx r0
    bl object_set_panels_from_coordinates
    bl object_update_collision_panels
    bl object_present_collision_data
    ldrh r0, [r5,0x12]
    cmp r0,r4
    beq .dontupdate
    mov r0,0x01
    bl object_set_collision_reigon
.dontupdate:
    bl object_update_sprite
    pop {r15}

metalblade_object_update_pool:
    .word metalblade_object_update_initialmove | 1  ; move foward looking for targets
    .word metalblade_object_update_downmove | 1     ; move down 1 panel
    .word metalblade_object_update_leftmove | 1     ; move left 1 panel
    .word metalblade_object_update_upmove | 1       ; move up 1 panel
    .word metalblade_object_update_rightmove | 1    ; move right 1 panel

magtect_attack_mainloop:
    push {r4,r5,r6,r7,r14}
    ldrb r0, [r7,0x01]
    cmp r0, 0x00
    bne .initialized
    mov r0,0x04
    strb r0, [r7,0x01]

    ; set timer for phase
    mov r0,0x08
    strh r0, [r7,0x10]
    mov r0,0x0c
    bl object_set_animation
    bl object_set_default_counter_time
    bl object_get_front_direction
    ldrb r1,[r5,0x12]           ; panel in front of you
    add r0,r1,r0                ; magtect panelx
    ldrb r1,[r5,0x13]           ; magtect panely
    mov r2,AttackElement_Elec   ; magtect element
    mov r3,0x00                 ; magtect z coordinate
    ldr r4, [r7,0x0C]           ; magtect parameters
    ldr r6, [r7,0x08]           ; magtect blade damage
    mov r7,0x4C
    add r7,r5,r7
    bl spawn_magtect
    str r0, [r5,0x4C]           ; store child object
    b .endroutine
.initialized:
    ; as long as megtect still exists attack continues
    ldr r0, [r5,0x4C]
    tst r0,r0
    bne .endroutine
    bl object_exit_attack_state
.endroutine:
    pop {r4,r5,r6,r7,r15}

; creates magtect object
spawn_magtect:
    push {r14}
    push {r0,r1,r2,r5}
    mov r0, demo_object_id
    bl object_spawn_type3
    mov r0,r5
    pop {r1,r2,r3,r5}
    beq .endroutine
    strb r1, [r0,0x12]
    strb r2, [r0,0x13]
    strb r3, [r0,0x0E]
    str r5, [r0,0x4C]
    str r6, [r0,0x2C]
    ldrh r3, [r5,0x16]
    strh r3, [r0,0x16]
    str r7, [r0,0x60]
.endroutine:
    pop {r15}

magtect_object_mainloop:
    push {r14}
    ldr r1, [magtect_object_mainloop_pool]
    ldrb r0, [r5,0x08]
    ldr r1, [r1,r0]
    mov r14,r15
    bx r1
    pop {r15}
    .balign 4, 0
magtect_object_mainloop_pool:
    .word magtect_object_init | 1
    .word magtect_object_update | 1
    .word object_generic_destroy | 1    ; boilerplate destructor

magtect_object_init:
    push {r4,r5,r6,r7,r14}

    ; set visable bit (2)
    ldrb r0, [r5]
    mov r1, 0x02
    orr r0,r1
    strb r0, [r5]

    ; set proper coordinates for panel
    bl object_set_coordinates_from_panels

    ; load magtect sprite
    mov r0, 0x80
    mov r1, 0x00
    mov r2, 0x0D
    bl sprite_load

    ; initialize to animation 0
    mov r0,0x00
    strh r0, [r5,0x10]

    ; initialize essential sprite stuff
    bl sprite_set_animation
    bl sprite_load_animation_data
    bl sprite_update        ; updates sprite data
    bl sprite_has_shadow    ; Shadow should not follow main sprite accross Z
    bl object_get_flip
    bl sprite_set_flip
    bl object_create_collision_data
    tst r0,r0
    bne .collisioninit
    bl magtect_destroy
    pop {r4,r5,r6,r7,r15}
.collisioninit:
    mov r1,0x29
    mov r2,0x0D
    mov r3,0x03
    bl object_setup_collision_data
    mov r0,0x03
    bl object_set_collision_hit_effect

    ; give 40 HP
    mov r0,40
    strh r0, [r5,0x24]
    strh r0, [r5,0x26]

    ; set to update routine
    mov r0,4
    strh r0, [r5,0x08]
    pop {r4,r5,r6,r7,r15}

magtect_destroy:
    push {r14}
    bl object_clear_collision_region
    mov r0,0x08
    str r0, [r5,0x08]   ; set to destroy routine
    mov r0,0x00
    ldr r1, [r5,0x60]   ; get parents pointer to this object
    str r0, [r1]        ; clear object
    pop {r15}

magtect_object_update:
    push {r14}
    bl object_remove_collision_data
    bl object_spawn_collision_effect
    mov r0,0x00
    bl object_apply_damage
    tst r0,r0           ; check if dead
    bne .dead
    ldr r0, [r5,0x60]   ; get parents refence to this object
    ldr r0, [r0]        ; check if its still there
    tst r0,r0
    beq .dead           ; if its cleared parent is not in attack state
    ldrb r0, [r5,0x09]
    ldr r1, [magtect_object_update_pool]
    ldr r0, [r1,r0]
    mov r14,r15
    bx r0
    bl object_update_sprite
    b .endroutine
.dead:
    bl magtect_destroy
.endroutine:
    bl object_present_collision_data
    pop {r15}
    .balign 4, 0
magtect_object_update_pool:
    .word magtect_object_update_idle | 1    ; wait for button presses
    .word magtect_object_update_pull | 1    ; pull enemy towards magtect while B pressed
    .word magtect_object_update_attack | 1  ; magnet attack

magtect_object_update_idle:
    push {r4,r5,r6,r7,r14}
    ldrb r0, [r5,0x0A]
    tst r0,r0
    bne .initialized
    mov r0,0x00
    strb r0, [r5,0x10]  ; idle animation
    mov r0,0x04
    strb r0, [r5,0x0A]
.initialized:
    ldr r0, [r5,0x4C]   ; get parent
    ldr r0, [r0,0x58]   ; get parent AI data
    ldrh r1, [r0,0x22]  ; get keys held
    mov r2,GBAKEY_A
    tst r1,r2
    beq .dead
    mov r2, GBAKey_B
    tst r1,r2
    beq .endroutine
    ; B pressed goto pull
    mov r0,0x04
    strb r0, [r5,0x09]
    mov r0,0x00
    strb r0, [r5,0x0A]
    b .endroutine
.dead:
    bl magtect_destroy
.endroutine:
    pop {r4,r5,r6,r7,r15}

magtect_object_update_pull:
    push {r4,r5,r6,r7,r14}
    ldrb r0, [r5,0x0A]
    tst r0,r0
    bne .initialized
    mov r0,0x01
    strb r0, [r5,0x10]  ; pull animation
    mov r0,0x04
    strb r0, [r5,0x0A]
    mov r0,0xF3
    bl sound_play       ; play wavey sound
.initialized:
    ; create collision object to pull enemies
    bl object_get_front_direction
    ldrb r1, [r5,0x12]
    add r0,r1,r0                ; get panelx in front of magtect
    ldrb r1, [r5,0x13]          ; get panel y
    mov r2, AttackElement_NULL  ; no element
    mov r3,0x00                 ; z = 0