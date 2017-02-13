class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(controller:"login",action:"login")
//        "/"(view:"/index")
        "/baidumap"(view:'/mapCore')
        "/socketio"(view:"/socketio/index")
        "500"(view:'/error')
        "404"(view:'/notFound')
        "/op"(view:'/treeGridDemo/treeGridDemo')
        "/demo"(view:'/login/demo')
        "/baseBoundDevice"(controller: "baseBoundDevice")

//        "/$baseBoundDevice/$year/$month/$day/$id"(controller: "baseBoundDevice", action: "index")
    }
}
