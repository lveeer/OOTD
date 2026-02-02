import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// iOS HIG 风格加载组件
/// 改进动画效果、添加 Liquid Glass 材质效果
class LoadingWidget extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const LoadingWidget({
    super.key,
    this.message,
    this.size = 40.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final primaryColor = color ?? AppColors.primary;
    final textColor = AppColors.secondaryLabelColor(brightness);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 3,
              backgroundColor: brightness == Brightness.light
                  ? AppColors.lightFill
                  : AppColors.darkFill,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: textColor,
                fontSize: AppConstants.fontSizeM,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// iOS HIG 风格加载遮罩层
/// 使用 Liquid Glass 材质效果
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;
  final Color? overlayColor;

  const LoadingOverlay({
    super.key,
    required this.child,
    this.isLoading = false,
    this.message,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ??
                (Theme.of(context).brightness == Brightness.light
                    ? AppColors.overlayLight
                    : AppColors.overlayDark),
            child: LoadingWidget(message: message),
          ),
      ],
    );
  }
}

/// iOS HIG 风格骨架屏加载组件
/// 用于内容加载前的占位
class SkeletonLoader extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppTheme.cardRadius,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final baseColor = brightness == Brightness.light
        ? AppColors.lightFill
        : AppColors.darkFill;
    final highlightColor = brightness == Brightness.light
        ? AppColors.lightSecondaryFill
        : AppColors.darkSecondaryFill;

    return Shimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// 骨架屏渐变动画效果
class Shimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const Shimmer({
    super.key,
    required this.child,
    required this.baseColor,
    required this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              transform: _SlidingGradientTransform(
                slidePercent: _animation.value,
              ),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// 骨架屏滑动渐变变换
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// iOS HIG 风格刷新指示器
class GlassRefreshIndicator extends StatelessWidget {
  final String? message;
  final Color? color;

  const GlassRefreshIndicator({
    super.key,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final primaryColor = color ?? AppColors.primary;
    final textColor = AppColors.secondaryLabelColor(brightness);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 2,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: TextStyle(
                color: textColor,
                fontSize: AppConstants.fontSizeS,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}