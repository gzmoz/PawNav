package com.example.pawnav

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.example.pawnav.databinding.FragmentAddPostBinding

class AddPostFragment : Fragment() {

    private lateinit var binding: FragmentAddPostBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentAddPostBinding.inflate(inflater,container,false)
        // Inflate the layout for this fragment
        return binding.root
        //binding.root represents the the top-level (ConstraintLayout, LinearLayout, FrameLayout, etc.) element in your XML file.
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.addPetPhoto.setOnClickListener {
            val fragment = AddAnimalPhotosFragment()
            val transaction = requireActivity().supportFragmentManager.beginTransaction()
            transaction.replace(R.id.frame_layout, fragment)
            transaction.addToBackStack(null)
            transaction.commit()
        }

        binding.lastSeenLocation.setOnClickListener {
            val fragment = LastSeenLocationFragment()
            val transaction = requireActivity().supportFragmentManager.beginTransaction()
            transaction.replace(R.id.frame_layout, fragment)
            transaction.addToBackStack(null)
            transaction.commit()
        }
    }


}