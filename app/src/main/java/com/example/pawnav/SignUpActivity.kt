package com.example.pawnav

import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.pawnav.databinding.ActivityLoginBinding
import com.example.pawnav.databinding.ActivitySignUpBinding
import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.auth

class SignUpActivity : AppCompatActivity() {
    private lateinit var binding: ActivitySignUpBinding
    private lateinit var auth: FirebaseAuth
    private lateinit var activityResultLauncher: ActivityResultLauncher<Intent>
    private val selectedPicture : Bitmap? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySignUpBinding.inflate(layoutInflater)
        val view = binding.root
        setContentView(view)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        // Initialize Firebase Auth
        auth = Firebase.auth

        registerLauncher()
    }

    fun signUpClicked(view: View){

        val email = binding.signUpEmailText.text.toString()
        val password = binding.signUpPasswordText.text.toString()

        if(email.equals("") || password.equals("")){
            Toast.makeText(this,"Enter e-mail and password", Toast.LENGTH_LONG).show()
        }else{
            auth.createUserWithEmailAndPassword(email,password).addOnSuccessListener {
                //success
                val intent = Intent(this@SignUpActivity, ActionOrientedActivity::class.java)
                startActivity(intent)
                finish()
            }.addOnFailureListener {
                //fail
                Toast.makeText(this@SignUpActivity,it.localizedMessage,Toast.LENGTH_LONG).show()
            }
        }
    }

    fun addPhotoImage(view: View) {
        val intent= Intent(this@SignUpActivity, UploadProfilePhotoActivity::class.java)
        activityResultLauncher.launch(intent)
    }

    //Assigns the code that will process the result returned from another activity to the activityResultLauncher variable.
   private fun registerLauncher() {
        activityResultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == RESULT_OK && result.data != null) {
                // take the URI that is sent by UploadProfilePhotoActivity
                val imageUriString = result.data?.getStringExtra("selectedImage")
                if (!imageUriString.isNullOrEmpty()) {
                    //change the String URI value to URI format
                    val imageUri = Uri.parse(imageUriString)
                    binding.uploadPhoto.setImageURI(imageUri)
                }else {
                    // Kameradan gelen dosya URI'sini al ve göster
                    val capturedImageUriString = result.data?.getStringExtra("capturedImageUri")
                    if (!capturedImageUriString.isNullOrEmpty()) {
                        val capturedImageUri = Uri.parse(capturedImageUriString)
                        binding.uploadPhoto.setImageURI(capturedImageUri)
                    } else {
                        Toast.makeText(this, "Fotoğraf yüklenemedi!", Toast.LENGTH_LONG).show()
                    }
                }
            }
        }
    }




}