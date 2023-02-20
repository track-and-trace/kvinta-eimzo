package kvinta.uz.eimzo.configuration.impl

import kvinta.uz.eimzo.configuration.EImzoCryptoConfig
import kvinta.uz.eimzo.configuration.EImzoCryptoConfigService
import io.micronaut.context.ApplicationContext
import mu.KotlinLogging
import javax.inject.Inject
import javax.inject.Singleton

private val log = KotlinLogging.logger {}

@Singleton
class EImzoCryptoConfigServiceImpl(
    @Inject val applicationContext: ApplicationContext
) : EImzoCryptoConfigService {

    private val configs: List<EImzoCryptoConfig> = getConfigs()

    private fun getConfigs(): List<EImzoCryptoConfig> {
        val beansOfType = applicationContext.getBeansOfType(EImzoCryptoConfig::class.java)
        return beansOfType.toList()
    }

    override fun getEImzoCryptoConfigByName(name: String?): EImzoCryptoConfig? {
        val eImzoCryptoConfig = configs.find { name.equals(it.name, ignoreCase = true) }
        return eImzoCryptoConfig.also {
            log.info("Configuration for name = '$name' loaded as '$it'")
        }
    }
}