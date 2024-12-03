import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class ReceiveCallCell extends StatefulWidget {
  const ReceiveCallCell({
    super.key,
    required this.doctorName,
    required this.hospitalName,
    required this.reservationDateTimes,
    required this.onTap,
  });
  final String doctorName;
  final String hospitalName;
  final String reservationDateTimes;
  final Function onTap;

  @override
  State<ReceiveCallCell> createState() => _ReceiveCallCellState();
}

class _ReceiveCallCellState extends State<ReceiveCallCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    final borderRadius = BorderRadius.circular(10);

    return GestureDetector(
      onTap: () => widget.onTap.call(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 波紋アニメーションの背景
          CustomPaint(
            painter: RoundedWavePainter(
              _animationController,
              borderRadius: borderRadius,
            ),
            child: SizedBox(
              width: deviceWidth * 0.9,
              height: 100,
            ),
          ),
          Container(
            height: 100,
            width: deviceWidth * 0.9,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: borderRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.call, color: Colors.green),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 5,
                        left: 10,
                        right: 10,
                      ),
                      child: CustomText(
                        text: '通話の準備ができました',
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: '${widget.doctorName}先生',
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        const SizedBox(width: 5),
                        CustomText(
                          text: '(${widget.hospitalName})',
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    CustomText(
                      text: widget.reservationDateTimes,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedWavePainter extends CustomPainter {
  final Animation<double> _animation;
  final BorderRadius borderRadius;

  RoundedWavePainter(this._animation, {required this.borderRadius})
      : super(repaint: _animation);

  void drawWave(Canvas canvas, Rect rect, double value) {
    /// 透明度の設定[4.0]
    double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);

    /// 色の設定
    Color color = Color.fromRGBO(76, 175, 80, opacity);

    /// 波紋のサイズ変化[4.0]
    double scale = 1.0 + value / 4.0;

    Rect scaledRect = Rect.fromCenter(
      center: rect.center,
      width: rect.width * scale,
      height: rect.height * scale,
    );

    final RRect roundedRect = RRect.fromRectAndCorners(
      scaledRect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    final Paint paint = Paint()..color = color;
    canvas.drawRRect(roundedRect, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    for (int wave = 3; wave >= 0; wave--) {
      drawWave(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(RoundedWavePainter oldDelegate) {
    return true;
  }
}
