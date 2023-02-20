package kvinta.uz.eimzo.controller

import kvinta.uz.eimzo.clients.EImzoCryptoClient
import io.micronaut.http.annotation.Body
import io.micronaut.http.annotation.Controller
import io.micronaut.http.annotation.Post
import kvinta.uz.eimzo.models.EImzoMessageToSignRequest
import kvinta.uz.eimzo.models.EImzoSignResponse
import mu.KotlinLogging
import kvinta.uz.eimzo.utils.obfuscateShort
import javax.inject.Inject

private val log = KotlinLogging.logger {}

@Controller
open class EImzoCryptoController(
    @Inject val eImzoCryptoClient: EImzoCryptoClient
) {

    @Post("/sign")
    fun signMessage(@Body request: EImzoMessageToSignRequest): EImzoSignResponse {
        val response = eImzoCryptoClient.sign(request)
        log.debug("Response from EImzo sign message function with input $request was ${obfuscateShort(response.signature)}")

        return response
    }
}