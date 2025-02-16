package com.example.pawnav

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.view.View
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.pawnav.databinding.ActivitySignUpBinding
import com.example.pawnav.databinding.ActivityUploadProfilePhotoBinding
import com.google.android.material.snackbar.Snackbar
import kotlinx.coroutines.CoroutineStart
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class UploadProfilePhotoActivity : AppCompatActivity() {

    private lateinit var binding: ActivityUploadProfilePhotoBinding
    private lateinit var activityResultLauncher: ActivityResultLauncher<Intent>
    private lateinit var permissionLauncher: ActivityResultLauncher<String>
    private val selectedPicture : Bitmap? = null
    private var requestingCamera = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityUploadProfilePhotoBinding.inflate(layoutInflater)
        val view = binding.root
        setContentView(view)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        registerLauncher()
    }

    fun addFromGalleryClicked(view: View) {

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU){
            //Android 33+ -> READ_MEDIA_IMAGES

            if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_MEDIA_IMAGES) != PackageManager.PERMISSION_GRANTED){
                //permission denied
                //rationale
                if(ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.READ_MEDIA_IMAGES)){
                    Snackbar.make(view, "Permission is needed for gallery", Snackbar.LENGTH_INDEFINITE).setAction("Give Permission", View.OnClickListener {
                        //request permission
                        permissionLauncher.launch(Manifest.permission.READ_MEDIA_IMAGES)
                    }).show()
                }else{
                    //request permission
                    permissionLauncher.launch(Manifest.permission.READ_MEDIA_IMAGES)
                }
            }else{
                //go to gallery and make an action pick(take the data)
                //find the URI of the selected image
                val intentToGallery = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)
                activityResultLauncher.launch(intentToGallery)

            }

        }else{
            //Android 32- -> READ_EXTERNAL_STORAGE

            if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED){
                //permission denied
                //rationale
                if(ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.READ_EXTERNAL_STORAGE)){
                    Snackbar.make(view, "Permission is needed for gallery", Snackbar.LENGTH_INDEFINITE).setAction("Give Permission", View.OnClickListener {
                        //request permission
                        permissionLauncher.launch(Manifest.permission.READ_EXTERNAL_STORAGE)
                    }).show()
                }else{
                    //request permission
                    permissionLauncher.launch(Manifest.permission.READ_EXTERNAL_STORAGE)
                }
            }else{
                //go to gallery and make an action pick(take the data)
                //find the URI of the selected image
                val intentToGallery = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)
                activityResultLauncher.launch(intentToGallery)
            }
        }



    }

     private fun registerLauncher(){

         // activityResultLauncher -> is used to start an activity and get a result.
         //callback --> is used to start an activity and get the result
         activityResultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()){ result ->

             if (result.resultCode == RESULT_OK && result.data != null) { //if the user made a succesfull operation and it turned to be a successfull result
                 val imageUri = result.data?.data //check if a photo is selected from the gallery.
                 if (imageUri != null) {
                     //TO GALLERY
                     //create an intent to sent the photo to SignUpActivity
                     val resultIntent = Intent()
                     resultIntent.putExtra("selectedImage", imageUri.toString())
                     setResult(RESULT_OK, resultIntent)
                     finish()
                 }else { //if imageUri == null, the used didn't select a photo from gallery. so check if there is any photo comes from camera
                     //take the captured photo as a Bitmap
                     val imageBitmap = result.data?.extras?.get("data") as? Bitmap
                     if (imageBitmap != null) {
                         //save the bitmap and take URI
                         val savedImageUri = saveBitmapToFile(imageBitmap)
                         //create an intent to sent the photo to SignUpActivity
                         val resultIntent = Intent()
                         resultIntent.putExtra("capturedImageUri", savedImageUri.toString())
                         setResult(RESULT_OK, resultIntent)
                         finish()
                     } else {
                         Toast.makeText(this, "Kamera hatası: Fotoğraf alınamadı!", Toast.LENGTH_LONG).show()
                     }
                 }
             }
         }

         permissionLauncher = registerForActivityResult(ActivityResultContracts.RequestPermission()){ result ->
             if(result){
                 //permission granted
                 if(requestingCamera){
                     val intentToCamera = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
                     activityResultLauncher.launch(intentToCamera)
                 }else{
                     val intentToGallery = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)
                     activityResultLauncher.launch(intentToGallery)
                 }
             }else{
                 //permission denied
                 Toast.makeText(this@UploadProfilePhotoActivity,"Permission is needed!", Toast.LENGTH_LONG).show()
             }
         }
     }

    //to save a photo in Bitmap format as a temporary file and return its URI.
    private fun saveBitmapToFile(bitmap: Bitmap): Uri {
        val file = File(getExternalFilesDir(null), "profile_photo.jpg") //create a temporary file
        try {
            val stream = FileOutputStream(file) //opens a FileOutputStream to write the file.
            bitmap.compress(Bitmap.CompressFormat.JPEG, 90, stream) //converts bitmap image to JPEG format and compresses it.
            stream.flush() //allows all data in memory to be written to the file.
            stream.close() //ensures that the file is saved properly by closing the file stream.
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return Uri.fromFile(file) // return the URI of the file
    }



    fun takePhotoClicked(view: View) {

        requestingCamera = true

        if(ContextCompat.checkSelfPermission(this,Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED){
            if(ActivityCompat.shouldShowRequestPermissionRationale(this,Manifest.permission.CAMERA)){
                Snackbar.make(view, "Camera permission is needed", Snackbar.LENGTH_INDEFINITE).setAction("Give Permission"){
                    permissionLauncher.launch(Manifest.permission.CAMERA)
                }.show()
            }else{
                permissionLauncher.launch(Manifest.permission.CAMERA)
            }
        }else{
            val intentToCamera = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
            activityResultLauncher.launch(intentToCamera)
        }

    }
}