package kvinta.uz.eimzo

import io.micronaut.runtime.Micronaut
import io.swagger.v3.oas.annotations.OpenAPIDefinition
import io.swagger.v3.oas.annotations.info.Info

@OpenAPIDefinition(
    info = Info(
        title = "Kvinta E-IMZO signature Service",
        version = "0.1",
        description = "Swagger for Kvinta E-IMZO signature Service"
    )
)
object Application {

    @JvmStatic
    fun main(args: Array<String>) {
        Micronaut.run(Application::class.java)
            .start()
    }
}