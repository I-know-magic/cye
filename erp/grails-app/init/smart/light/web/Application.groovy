package smart.light.web

import grails.boot.GrailsApp
import grails.boot.config.GrailsAutoConfiguration
import org.springframework.context.annotation.Bean
import org.springframework.web.client.RestTemplate

class Application extends GrailsAutoConfiguration {
    @Bean
    public RestTemplate restTemplate(){
        return new RestTemplate()
    }
    static void main(String[] args) {
        GrailsApp.run(Application, args)
    }
}