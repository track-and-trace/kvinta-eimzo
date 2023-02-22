package kvinta.uz.eimzo.clients

import kvinta.uz.eimzo.configuration.EImzoCryptoConfig
import kvinta.uz.eimzo.configuration.EImzoCryptoConfigService
import kvinta.uz.eimzo.models.EImzoMessageToSignRequest
import kvinta.uz.eimzo.models.EImzoSignResponse
import org.bouncycastle.jce.provider.BouncyCastleProvider
import org.bouncycastle.util.encoders.Base64
import uz.yt.cams.common.util.KeyUtils
import uz.yt.cams.pki.DocumentSigner
import uz.yt.pkix.jcajce.provider.YTProvider
import java.io.FileInputStream
import java.lang.IllegalArgumentException
import java.nio.file.Paths
import java.security.AccessController
import java.security.KeyStore
import java.security.PrivilegedExceptionAction
import java.security.Provider
import java.security.Security
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class  EImzoCryptoClient(
    @Inject val eImzoCryptoConfigService: EImzoCryptoConfigService
) {

    fun sign(request: EImzoMessageToSignRequest) : EImzoSignResponse {
        val provider = Security.getProvider("BC")
        val keyUtils = KeyUtils(provider)
        val config = eImzoCryptoConfigService.getEImzoCryptoConfigByName(request.cryptoContainerName)
            ?: throw IllegalArgumentException("Configuration with name ${request.cryptoContainerName} not found")

        val attached = request.detached

        val keyStore = initKeyStore(config)
        val aliases = keyStore.aliases()
        var alias: String? = null
        while (aliases.hasMoreElements()) {
            alias = aliases.nextElement()
        }
        val cki = keyUtils.fetchKeyInfo(keyStore, alias, config.password)
        val signer = DocumentSigner(provider, cki.certificateChain, cki.privateKey)
        val pkcs7 = signer.getPkcs7(request.message.toByteArray(), attached)

        return EImzoSignResponse(signature = Base64.toBase64String(pkcs7))
    }

    private fun initKeyStore(config: EImzoCryptoConfig) : KeyStore {
        val keyStore = KeyStore.getInstance("PKCS12")
        val fis = AccessController.doPrivileged(PrivilegedExceptionAction { config.cryptoContainerPath?.let { FileInputStream(it) } })
        keyStore.load(fis, config.password?.toCharArray())
        fis.close()
        return keyStore
    }
}