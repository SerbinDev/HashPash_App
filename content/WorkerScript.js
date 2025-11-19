

WorkerScript.onMessage = function(message) {
    var hash = SignVerify.encryptMessage(message.text, message.publicKey);
    hash += "---";

    if (message.filePath) {
        var hash2 = EncryptImage.encryptRSA(message.filePath, message.publicKey);
        hash += hash2;
    }

    // ارسال نتیجه رمزنگاری به UI
    WorkerScript.sendMessage({ hash: hash });
}
