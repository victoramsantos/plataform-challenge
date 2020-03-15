package com.example.hello

import io.ktor.application.*
import io.ktor.http.*
import io.ktor.response.*
import io.ktor.routing.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import java.util.logging.Logger
import kotlin.math.sqrt

fun main(args: Array<String>) {
    val target = System.getenv("TARGET") ?: "World"
    val port = System.getenv("PORT") ?: "8080"
    embeddedServer(Netty, port.toInt()) {
        routing {
            get("/{stress?}") {
                println("Handling request")
                val stress = call.parameters["stress"]?:""
                if(stress.isNotEmpty()){
                    stressing()
                }
                call.respondText("Hello $target!", ContentType.Text.Html)
            }
        }
    }.start(wait = true)
}

fun stressing() : Double{
    println("Stressing request")
    var x : Double = 0.0
    for(i in 0..10000000){
        x += sqrt(i.toDouble())
    }
    return x
}