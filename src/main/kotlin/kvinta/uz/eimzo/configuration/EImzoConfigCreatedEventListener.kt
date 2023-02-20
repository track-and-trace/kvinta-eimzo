package kvinta.uz.eimzo.configuration

import io.micronaut.context.event.BeanCreatedEvent
import io.micronaut.context.event.BeanCreatedEventListener
import io.micronaut.core.annotation.NonNull
import mu.KotlinLogging
import javax.inject.Singleton

@Singleton
class EImzoConfigCreatedEventListener : BeanCreatedEventListener<EImzoCryptoConfig> {

    private val log = KotlinLogging.logger {}

    override fun onCreated(@NonNull event: BeanCreatedEvent<EImzoCryptoConfig>): EImzoCryptoConfig {
        val config = event.bean as EImzoCryptoConfig
        log.trace("Loading Kvinta E-IMZO configuration: ${config.name}")

        return config
    }
}

