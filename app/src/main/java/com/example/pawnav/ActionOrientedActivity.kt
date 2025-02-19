package com.example.pawnav

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.fragment.app.Fragment
import com.example.pawnav.databinding.ActivityActionOrientedBinding
import com.example.pawnav.databinding.ActivitySignUpBinding

class ActionOrientedActivity : AppCompatActivity() {

    private lateinit var binding: ActivityActionOrientedBinding

    private var currentFragmentIndex = 0
    private var fragments = listOf(
        FirstActionOrientedFragment(),
        SecondActionOrientedFragment(),
        ThirdActionOrientedFragment(),
        FourthActionOrientedFragment()
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityActionOrientedBinding.inflate(layoutInflater)
        setContentView(binding.root)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        // load the firstfragment
        loadFragment(fragments[currentFragmentIndex])

        binding.nextButton.setOnClickListener {
            if (currentFragmentIndex < fragments.size - 1) {
                currentFragmentIndex++
                loadFragment(fragments[currentFragmentIndex])
            } else {
                // if the last fragment is reached, go to the Main Activity
                navigateToAccountActivity()
            }
        }
    }

    private fun loadFragment(fragment: Fragment) {

        supportFragmentManager.beginTransaction()
            .replace(binding.fragmentLayout.id, fragment)
            .addToBackStack(null) // can be backed to the previous activity through back button
            .commit()


    }

    private fun navigateToAccountActivity() {
        val intent = Intent(this, MainActivity::class.java)
        startActivity(intent)
        finish()
    }
}