

add_library(glad SHARED ${CMAKE_CURRENT_LIST_DIR}/src/glad.c)
target_include_directories(glad PUBLIC ${CMAKE_CURRENT_LIST_DIR}/include)
target_compile_definitions(glad PRIVATE GLAD_GLAPI_EXPORT_BUILD PUBLIC GLAD_GLAPI_EXPORT)

if(Windows)
    target_compile_definitions(glad PRIVATE _WIN32)
endif()