import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import '../../controllers/provider/user_provider.dart';
import '../../controllers/provider/restaurant_provider.dart';
import '../../controllers/provider/location_provider.dart';
import '../../common/app_style.dart';
import '../../common/custom_container.dart';
import '../../common/reusable_appbar.dart';
import '../../common/reusable_text.dart';
import '../bottom_navigation_bar/bottom_navigation_bar.dart';

class SetAddressPage extends StatefulWidget {
  final bool isFromHome;
  const SetAddressPage({super.key, this.isFromHome = false});

  @override
  State<SetAddressPage> createState() => _SetAddressPageState();
}

class _SetAddressPageState extends State<SetAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  GoogleMapController? _mapController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final lp = context.read<LocationProvider>();
      bool success = await lp.determinePosition(context: context);
      if (mounted && success && lp.pickedLocation != null) {
        _addressController.text = lp.address;
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: lp.pickedLocation!, zoom: 15),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress(LocationProvider locationProvider) async {
    final address = _addressController.text.trim().isEmpty
        ? locationProvider.address
        : _addressController.text.trim();

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter or pick an address")),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseDatabase.instance
            .ref()
            .child("users/${user.uid}/address")
            .set({
          "address": address,
          "latitude": locationProvider.pickedLocation?.latitude,
          "longitude": locationProvider.pickedLocation?.longitude,
          "isAddressSet": true,
        });

        if (mounted) {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          await userProvider.getUserData();

          if (mounted) {
            final updatedData = userProvider.currentUserData;
            if (updatedData != null &&
                updatedData.latitude != null &&
                updatedData.longitude != null) {
              Provider.of<RestaurantProvider>(context, listen: false)
                  .fetchNearbyRestaurants(
                      context, updatedData.latitude!, updatedData.longitude!);
            }

            if (widget.isFromHome) {
              Navigator.pop(context);
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false,
              );
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE3F7),
      appBar: CustomReusableAppBar(
        titleText: "Set Delivery Address",
        titleStyle: appStyle(34.sp, Colors.black, FontWeight.w600),
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          // prefill address field if available
          if (_addressController.text.isEmpty && locationProvider.address.isNotEmpty) {
            _addressController.text = locationProvider.address;
          }

          return CustomContainer(
            containerContent: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text: "Select your location",
                    style: appStyle(30.sp, Colors.black, FontWeight.w500),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    height: 300.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: locationProvider.pickedLocation == null
                          ? Center(
                              child: locationProvider.isLoading
                                  ? const CircularProgressIndicator()
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.location_off,
                                            size: 48.sp, color: Colors.grey),
                                        SizedBox(height: 10.h),
                                        ReusableText(
                                          text: "Location not selected",
                                          style: appStyle(
                                              16.sp, Colors.grey, FontWeight.w500),
                                        ),
                                        SizedBox(height: 10.h),
                                        ElevatedButton.icon(
                                          onPressed: () async {
                                            bool success = await locationProvider
                                                .determinePosition(
                                                    context: context);
                                            if (mounted &&
                                                success &&
                                                locationProvider
                                                        .pickedLocation !=
                                                    null) {
                                              _addressController.text =
                                                  locationProvider.address;
                                              _mapController?.animateCamera(
                                                CameraUpdate.newCameraPosition(
                                                  CameraPosition(
                                                      target: locationProvider
                                                          .pickedLocation!,
                                                      zoom: 15),
                                                ),
                                              );
                                            }
                                          },
                                          icon: const Icon(Icons.my_location,
                                              color: Colors.white),
                                          label: ReusableText(
                                              text: "Get Current Location",
                                              style: appStyle(14.sp, Colors.white, FontWeight.w500)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF8a2ae4),
                                          ),
                                        )
                                      ],
                                    ),
                            )
                          : Stack(
                              children: [
                                GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: locationProvider.pickedLocation!,
                                    zoom: 15,
                                  ),
                                  onMapCreated: (controller) {
                                    _mapController = controller;
                                    if (locationProvider.pickedLocation != null) {
                                      _mapController?.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              target: locationProvider.pickedLocation!,
                                              zoom: 15),
                                        ),
                                      );
                                    }
                                  },
                                  onTap: (latLng) async {
                                    await locationProvider.setPickedLocation(latLng);
                                    if (mounted) {
                                      _addressController.text =
                                          locationProvider.address;
                                    }
                                  },
                                  markers: {
                                    Marker(
                                      markerId: const MarkerId("picked"),
                                      position: locationProvider.pickedLocation!,
                                    ),
                                  },
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: false,
                                ),
                                Positioned(
                                  bottom: 10.h,
                                  right: 20.w,
                                  child: FloatingActionButton.small(
                                    onPressed: locationProvider.isLoading
                                        ? null
                                        : () async {
                                            bool success = await locationProvider
                                                .determinePosition(
                                                    context: context);
                                            if (mounted &&
                                                success &&
                                                locationProvider
                                                        .pickedLocation !=
                                                    null) {
                                              _addressController.text =
                                                  locationProvider.address;
                                              if (_mapController != null) {
                                                _mapController!.animateCamera(
                                                  CameraUpdate.newCameraPosition(
                                                    CameraPosition(
                                                        target: locationProvider
                                                            .pickedLocation!,
                                                        zoom: 15),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                    backgroundColor: const Color(0xFF8a2ae4),
                                    child: Icon(
                                      Icons.my_location_sharp,
                                      color: Colors.white,
                                      size: 24.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  ReusableText(
                    text: "Manual Address",
                    style: appStyle(14.sp, Colors.grey, FontWeight.w500),
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Enter address manually",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: (_isSaving || locationProvider.isLoading)
                          ? null
                          : () => _saveAddress(locationProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8a2ae4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: (_isSaving)
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : ReusableText(text: "Save Address & Continue",
                              style: appStyle(
                                  32.sp, Colors.white, FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
