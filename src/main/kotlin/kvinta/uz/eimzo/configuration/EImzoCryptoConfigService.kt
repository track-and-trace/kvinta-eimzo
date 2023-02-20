package kvinta.uz.eimzo.configuration

interface EImzoCryptoConfigService {
    fun getEImzoCryptoConfigByName(name: String?): EImzoCryptoConfig?
}