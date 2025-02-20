package com.example.pawnav

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.pawnav.databinding.ActivityLoginBinding
import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.auth

class LoginActivity : AppCompatActivity() {

    private lateinit var binding: ActivityLoginBinding

    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityLoginBinding.inflate(layoutInflater)
        val view = binding.root
        setContentView(view)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        // Initialize Firebase Auth
        auth = Firebase.auth

        //create a current user to check if the user already signed in
        val currentUser = auth.currentUser
        if(currentUser != null){
            //user already signed in
            val intent = Intent(this, MainActivity ::class.java)
            startActivity(intent)
            finish()
        }

        binding.signUpLink.setOnClickListener(){
            val intent = Intent(this,SignUpActivity::class.java)
            startActivity(intent)
        }
    }

    fun loginClicked(view: View) {
        val email = binding.loginEmailText.text.toString()
        val password = binding.loginPasswordText.text.toString()

        if(email.equals("") || password.equals("")){
            Toast.makeText(this@LoginActivity, "Enter e-mail and password", Toast.LENGTH_LONG).show()
        }else{
            auth.signInWithEmailAndPassword(email,password).addOnSuccessListener {
                val intent = Intent(this@LoginActivity, MainActivity::class.java)
                startActivity(intent)
                finish()
            }.addOnFailureListener {
                Toast.makeText(this@LoginActivity, it.localizedMessage, Toast.LENGTH_LONG).show()
            }
        }
    }
}