package com.example.pawnav

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.pawnav.databinding.ActivitySignUpBinding
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.storage.FirebaseStorage
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream

/**
 * this class handles user sign-up, profile photo selection, and firebase integration
 */
class SignUpActivity : AppCompatActivity() {
    private lateinit var binding: ActivitySignUpBinding
    private lateinit var auth: FirebaseAuth
    private lateinit var firestore: FirebaseFirestore
    private lateinit var storage: FirebaseStorage
    private lateinit var activityResultLauncher: ActivityResultLauncher<Intent>
    private var selectedPicture: Uri? = null

    /**
     * initializes Firebase, sets up UI, and registers the photo selection launcher
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySignUpBinding.inflate(layoutInflater)
        setContentView(binding.root)

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        // Initialize Firebase
        auth = FirebaseAuth.getInstance()
        storage = FirebaseStorage.getInstance()
        firestore = FirebaseFirestore.getInstance()

        registerLauncher()
    }

    /**
     * user registration with Firebase Authentication
     */
    fun signUpClicked(view: View) {
        val email = binding.signUpEmailText.text.toString().trim()
        val password = binding.signUpPasswordText.text.toString().trim()
        val userName = binding.signUpNameText.text.toString().trim()

        if (email.isEmpty() || password.isEmpty() || userName.isEmpty()) {
            Toast.makeText(this, "Lütfen tüm alanları doldurun", Toast.LENGTH_LONG).show()
            return
        }

        auth.createUserWithEmailAndPassword(email, password).addOnSuccessListener {
            val userId = auth.currentUser?.uid
            if (userId != null) {
                //uploadToFirebase(userId, userName, email)
                uploadToFirebase(userId, userName, email, selectedPicture)

            } else {
                Toast.makeText(this, "Authentication failed!", Toast.LENGTH_LONG).show()
            }
        }.addOnFailureListener { e ->
            Toast.makeText(this, e.localizedMessage, Toast.LENGTH_LONG).show()
        }
    }

    /**
     * uploads the profile picture to Firebase Storage.
     * saves the download URL to Firestore.
     */
    private fun uploadToFirebase(userId: String, userName: String, email: String, selectedPicture: Uri?) {
        if (selectedPicture != null) {
            val file = copyUriToFile(selectedPicture)
            if (file != null) {
                val fileUri = Uri.fromFile(file)
                val imageName = "$userId.jpg"
                val imageReference = storage.reference.child("ProfileImages/$imageName")

                imageReference.putFile(fileUri)
                    .addOnSuccessListener {
                        imageReference.downloadUrl.addOnSuccessListener { uri ->
                            Log.d("FirebaseUpload", "Resim yüklendi: $uri")
                            saveUserToFirestore(userId, uri.toString(), userName, email)
                        }.addOnFailureListener {
                            Toast.makeText(this, "Image upload failed!", Toast.LENGTH_LONG).show()
                            saveUserToFirestore(userId, "", userName, email)
                        }
                    }
                    .addOnFailureListener {
                        Toast.makeText(this, "Failed to upload image", Toast.LENGTH_LONG).show()
                        saveUserToFirestore(userId, "", userName, email)
                    }
            } else {
                Toast.makeText(this, "Dosya yolu bulunamadı!", Toast.LENGTH_LONG).show()
            }
        } else {
            saveUserToFirestore(userId, "", userName, email)
        }
    }

    /**
     * converts a URI to a file for Firebase upload.
     */
    private fun copyUriToFile(uri: Uri): File? {
        return try {
            val inputStream: InputStream? = contentResolver.openInputStream(uri)
            val file = File(cacheDir, "temp_profile_photo.jpg")
            val outputStream = FileOutputStream(file)
            inputStream?.copyTo(outputStream)
            inputStream?.close()
            outputStream.close()
            file
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    /**
     * saves user information to Firestore.
     */
    private fun saveUserToFirestore(userId: String, photoUrl: String, userName: String, email: String) {
        val userInfo = hashMapOf(
            "userId" to userId,
            "downloadUrl" to photoUrl,
            "userName" to userName,
            "email" to email
        )

        firestore.collection("Users").document(userId).set(userInfo)
            .addOnSuccessListener {
                val intent = Intent(this, ActionOrientedActivity::class.java)
                startActivity(intent)
                finish()
            }
            .addOnFailureListener {
                Toast.makeText(this, "Failed to save user data!", Toast.LENGTH_LONG).show()
            }
    }

    /**
     * opens UploadProfilePhotoActivity to select a profile picture.
     */
    fun addPhotoImage(view: View) {
        val intent = Intent(this, UploadProfilePhotoActivity::class.java)
        activityResultLauncher.launch(intent)
    }

    /**
     * registers an activity launcher to handle profile photo selection.
     */
    private fun registerLauncher() {
        activityResultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == RESULT_OK && result.data != null) {
                val imageUriString = result.data?.getStringExtra("selectedImage")
                Log.d("ImageSelection", "Received URI: $imageUriString")
                if (!imageUriString.isNullOrEmpty()) {
                    selectedPicture = Uri.parse(imageUriString)
                    binding.uploadPhoto.setImageURI(selectedPicture)
                }else {
                    Toast.makeText(this, "Fotoğraf yüklenemedi!", Toast.LENGTH_LONG).show()
                }
            }
        }
    }
}