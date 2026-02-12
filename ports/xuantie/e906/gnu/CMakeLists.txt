
target_sources(${PROJECT_NAME}
    PRIVATE
    # {{BEGIN_TARGET_SOURCES}}
	${CMAKE_CURRENT_LIST_DIR}/src/tx_port.c
	${CMAKE_CURRENT_LIST_DIR}/src/tx_thread_context.S
	${CMAKE_CURRENT_LIST_DIR}/src/tx_thread_interrupt_control.S
	${CMAKE_CURRENT_LIST_DIR}/src/tx_thread_schedule.S
	${CMAKE_CURRENT_LIST_DIR}/src/tx_thread_system_return.S
	${CMAKE_CURRENT_LIST_DIR}/src/tx_timer_interrupt.c
    # {{END_TARGET_SOURCES}}
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/inc
)
