import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dialog_utils.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;
  bool _isSpeakerOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Teleconsultation Room',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: AppColors.emergency,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.fiber_manual_record, size: 10, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'LIVE 04:22',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Remote Doctor Stream Viewport
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundColor: AppColors.primaryLight,
                  child: const Text('🩺', style: TextStyle(fontSize: 48)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dr. Priya Sharma',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pulmonology • Apollo Hospitals Jubilee Hills',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🔒 End-to-End Encrypted Teleconsultation',
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),

          // Self PiP preview
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 100,
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: _isVideoOff
                    ? const Icon(Icons.videocam_off, color: Colors.white54)
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, color: Colors.white, size: 36),
                          SizedBox(height: 4),
                          Text('You',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 11)),
                        ],
                      ),
              ),
            ),
          ),

          // Bottom Controls Bar
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      _isMuted ? Icons.mic_off : Icons.mic,
                      color: _isMuted ? AppColors.emergency : Colors.white,
                    ),
                    onPressed: () => setState(() => _isMuted = !_isMuted),
                  ),
                  IconButton(
                    icon: Icon(
                      _isVideoOff ? Icons.videocam_off : Icons.videocam,
                      color: _isVideoOff ? AppColors.emergency : Colors.white,
                    ),
                    onPressed: () => setState(() => _isVideoOff = !_isVideoOff),
                  ),
                  IconButton(
                    icon: Icon(
                      _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        setState(() => _isSpeakerOn = !_isSpeakerOn),
                  ),
                  GestureDetector(
                    onTap: () {
                      DialogUtils.showSnackBar(
                          context, 'Teleconsultation session ended.');
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.emergency,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.call_end,
                          color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
