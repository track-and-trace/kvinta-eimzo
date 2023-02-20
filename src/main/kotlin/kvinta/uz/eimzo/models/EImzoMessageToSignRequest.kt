package kvinta.uz.eimzo.models

import com.fasterxml.jackson.annotation.JsonInclude
import io.micronaut.core.annotation.Introspected

@Introspected
@JsonInclude(JsonInclude.Include.ALWAYS)
data class EImzoMessageToSignRequest(
    val message: String,
    val detached: Boolean,
    val cryptoContainerName: String?
)