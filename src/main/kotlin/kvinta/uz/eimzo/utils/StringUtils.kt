package kvinta.uz.eimzo.utils

fun obfuscateShort(data: String?): String {
    val dataS = data.toString()
    return if (dataS.length > 5 * 2 + 3 + 4) "${dataS.take(5)}...${dataS.takeLast(5)}(${dataS.length})" else dataS
}