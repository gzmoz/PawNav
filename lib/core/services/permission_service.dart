import 'package:permission_handler/permission_handler.dart';

class PermissionService{

  Future<bool> requestGalleryPermission() async{

    var status = await Permission.photos.status; //Telefonun galeri izni şu an ne durumda? diye soruyoruz

    if(status.isGranted) return true; //Zaten izin varsa tekrar sormaya gerek yok true döndürüp çıkıyoruz

    var result = await Permission.photos.request(); //sistem izin popup'ını açar

    if(result.isGranted) return true; //Popup sonrası izin verildiyse fonksiyon başarıyla biter

    if(result.isPermanentlyDenied){ //Kullanıcı "Bir daha sorma" derse,seçeneğini işaretlediyse → artık popup ile izin istenemez.
      await openAppSettings();
    }
    return false; //Tüm ihtimallerden sonra hala izin alınamadıysa:
  }

  Future<bool> requestCameraPermission()  async {
    var status = await Permission.camera.status;

    if (status.isGranted) return true;

    var result = await Permission.camera.request();

    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  Future<bool> requestLocationPermission()async{
    var status  = await Permission.location.status;

    if(status.isGranted) return true;

    var result = await Permission.location.request();

    if(result.isGranted) return true;

    if(result.isPermanentlyDenied){
      await openAppSettings();
    }
    return false;
  }


}