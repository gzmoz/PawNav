package com.example.pawnav

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
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
/**
 * handles selecting a profile picture from the gallery or camera.
 */
class UploadProfilePhotoActivity : AppCompatActivity() {

    private lateinit var binding: ActivityUploadProfilePhotoBinding
    private lateinit var activityResultLauncher: ActivityResultLauncher<Intent>
    private lateinit var permissionLauncher: ActivityResultLauncher<String>
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

    /**
     * opens the gallery and request permission to select an image.
     */
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

    /**
     * registers activity launchers for gallery and camera selection.
     */
    private fun registerLauncher(){

        // activityResultLauncher -> is used to start an activity and get a result.
        //callback --> is used to start an activity and get the result
        activityResultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == RESULT_OK && result.data != null) {
                val imageUri = result.data?.data
                val imageBitmap = result.data?.extras?.get("data") as? Bitmap

                val selectedUri = imageUri ?: imageBitmap?.let { saveBitmapToFile(it) }

                if (selectedUri != null) {
                    Log.d("ImageSelection", "Sending URI: $selectedUri")
                    val resultIntent = Intent().apply {
                        putExtra("selectedImage", selectedUri.toString())
                    }
                    setResult(RESULT_OK, resultIntent)
                    finish()
                } else {
                    Toast.makeText(this, "Fotoğraf alınamadı!", Toast.LENGTH_LONG).show()
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

    /**
     * Saves a bitmap image as a temporary file and returns its URI.
     * Used when a photo is taken with the camera.
     *
     * @param bitmap The captured image as a Bitmap.
     * @return The URI of the saved file, or null if an error occurs.
     */

    private fun saveBitmapToFile(bitmap: Bitmap): Uri? {
        val file = File(getExternalFilesDir(null), "profile_photo.jpg")
        return try {
            val stream = FileOutputStream(file)
            bitmap.compress(Bitmap.CompressFormat.JPEG, 90, stream)
            stream.flush()
            stream.close()
            Uri.fromFile(file)
        } catch (e: IOException) {
            e.printStackTrace()
            null
        }
    }

    /**
     * opens the camera and requests permission if needed.
     * allows the user to take a photo.
     */
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