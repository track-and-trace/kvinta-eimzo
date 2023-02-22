package kvinta.uz.eimzo

import io.micronaut.runtime.Micronaut
import io.swagger.v3.oas.annotations.OpenAPIDefinition
import io.swagger.v3.oas.annotations.info.Info
import org.bouncycastle.jce.provider.BouncyCastleProvider
import uz.yt.pkix.jcajce.provider.YTProvider
import java.security.Provider
import java.security.Security

@OpenAPIDefinition(
    info = Info(
        title = "Kvinta EIMZO signature Service",
        version = "0.1",
        description = "Swagger for Kvinta E-IMZO signature Service"
    )
)
object Application {

    @JvmStatic
    fun main(args: Array<String>) {
        val provider = BouncyCastleProvider()
        try {
            YTProvider.configure(provider)
            Security.addProvider(provider as Provider)
        } catch (e: Throwable) {
            throw RuntimeException("Failed to initialize BouncyCastle", e)
        }
        Micronaut.run(Application::class.java)
            .start()
    }
}