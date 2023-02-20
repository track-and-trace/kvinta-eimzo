package kvinta.uz.eimzo.models

import com.fasterxml.jackson.annotation.JsonInclude
import io.micronaut.core.annotation.Introspected

@Introspected
@JsonInclude(JsonInclude.Include.NON_EMPTY)
data class EImzoSignResponse (
    val signature: String? = null,
    val error: String? = null
)