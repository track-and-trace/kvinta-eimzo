package kvinta.uz.eimzo.configuration

import io.micronaut.context.annotation.Context
import io.micronaut.context.annotation.EachProperty
import io.micronaut.context.annotation.Parameter
import io.micronaut.core.util.Toggleable
import javax.validation.constraints.NotNull

@Context
@EachProperty(value = "kvinta.uz.eimzo.containers")
data class EImzoCryptoConfig
constructor(@param:Parameter val name: String): Toggleable {

    @NotNull
    var cryptoContainerPath: String? = null

    @NotNull
    var password: String? = null

    @NotNull
    var tokenTtl: Long? = 0

    override fun toString(): String {
        return "EImzoCryptoContainer(name='$name', cryptoContainerPath=$cryptoContainerPath, password=$password)"
    }
}