package com.example.pawnav

import android.net.Uri
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.AnimationUtils
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.ViewFlipper
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import com.example.pawnav.databinding.FragmentAddPostBinding

class AddPostFragment : Fragment() {

    private lateinit var binding: FragmentAddPostBinding
    private lateinit var viewFlipper: ViewFlipper
    private val photoUris = ArrayList<Uri>()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentAddPostBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        viewFlipper = binding.viewFlipper

        // Fragment geri geldiğinde önceki fotoğrafları geri yükle
        arguments?.getParcelableArrayList<Uri>("photoUris")?.let {
            photoUris.clear()
            photoUris.addAll(it)
            loadImagesIntoViewFlipper(photoUris)
        }

        // Fotoğraf Seçici
        val multiplePhotoPickerLauncher = registerForActivityResult(ActivityResultContracts.PickMultipleVisualMedia()) { uris ->
            if (uris.isNotEmpty()) {
                photoUris.clear()
                photoUris.addAll(uris.take(4))
                loadImagesIntoViewFlipper(photoUris)

                // Fotoğrafları Bundle'a kaydet
                val bundle = Bundle()
                bundle.putParcelableArrayList("photoUris", photoUris)
                arguments = bundle
            }
        }

        binding.addImagesButton.setOnClickListener {
            multiplePhotoPickerLauncher.launch(
                PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly)
            )
        }

        binding.editImagesButton.setOnClickListener {
            val fragment = AddAnimalPhotosFragment()
            val transaction = requireActivity().supportFragmentManager.beginTransaction()
            fragment.arguments = arguments // Fotoğrafları yeni fragment'a taşı
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

        // Kullanıcının konum bilgisini geri yükleme
        val receivedLocation = arguments?.getString("locationKey")
        receivedLocation?.let {
            binding.lastSeenLocation.setText(it)
        }
    }

    private fun loadImagesIntoViewFlipper(uris: List<Uri>) {
        viewFlipper.removeAllViews()
        for (imageUri in uris) {
            val imageView = ImageView(requireContext())
            imageView.setImageURI(imageUri)
            imageView.layoutParams = RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.MATCH_PARENT,
            )
            viewFlipper.addView(imageView)
        }
    }
}
