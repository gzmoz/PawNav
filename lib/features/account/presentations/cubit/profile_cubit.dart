import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/account/domain/usecases/get_current_profile.dart';
import 'package:pawnav/features/account/presentations/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState>{
  final GetCurrentProfile getCurrentProfile;

  ProfileCubit(this.getCurrentProfile) : super(ProfileInitial());

  Future<void> loadProfile() async{
    emit(ProfileLoading());

    try{
      final profile = await getCurrentProfile();

      if(profile == null){
        emit(ProfileError("Profile not Found"));
      }else{
        emit(ProfileLoaded(profile));
      }
    }catch(e){
      emit(ProfileError(e.toString()));
    }
  }
}