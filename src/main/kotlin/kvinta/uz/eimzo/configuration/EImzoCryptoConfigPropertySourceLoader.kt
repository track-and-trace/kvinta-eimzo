package kvinta.uz.eimzo.configuration

import io.micronaut.context.env.EnvironmentPropertySource
import io.micronaut.context.env.PropertySource
import io.micronaut.context.env.yaml.YamlPropertySourceLoader
import io.micronaut.core.io.ResourceLoader
import io.micronaut.core.io.file.DefaultFileSystemResourceLoader
import io.micronaut.core.util.StringUtils.convertDotToUnderscore
import mu.KotlinLogging
import java.io.InputStream
import java.nio.file.Files.*
import java.nio.file.Path
import java.nio.file.Paths
import java.util.*

class EImzoCryptoConfigPropertySourceLoader : YamlPropertySourceLoader() {

    private val log = KotlinLogging.logger {}

    private val configsFilePath = "eimzo.configs.file.path"

    override fun getOrder() = EnvironmentPropertySource.POSITION - 10

    override fun load(resourceName: String?, resourceLoader: ResourceLoader?): Optional<PropertySource?>? {
        return super.load(configsFilePath, resourceLoader)
    }

    override fun readInput(resourceLoader: ResourceLoader?, fileName: String?): Optional<InputStream> {
        val environmentName = System.getenv(convertDotToUnderscore(configsFilePath)) ?: ""
        log.info("Configuration file defined as environment variable $configsFilePath and value $environmentName")

        return when (environmentName.isEmpty()) {
            true -> Optional.empty()
            else -> getEnvValueAsStream(environmentName)
        }.also {
            log.info("Processed configuration file $environmentName with result $it")
        }
    }

    private fun getEnvValueAsStream(environmentName: String): Optional<InputStream> {
        val configLocationPath: Path = Paths.get(environmentName)
        log.info("Configuration file found as $configLocationPath")

        val exists = exists(configLocationPath)
        val regularFile = isRegularFile(configLocationPath)
        val readable = isReadable(configLocationPath)

        if (exists && regularFile && readable) {
            log.info("Configuration file will be loaded from $configLocationPath")
            return DefaultFileSystemResourceLoader(configLocationPath).getResourceAsStream(environmentName)
        }

        log.warn("Configuration file $configLocationPath was not loaded: exists = $exists, regularFile = $regularFile, readable = $readable")
        return Optional.empty()
    }
}
