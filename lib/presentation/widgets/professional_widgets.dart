import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_gradients.dart';

class ProfessionalCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final bool glassMorphism;
  final Gradient? gradient;
  final Color? backgroundColor;
  final double elevation;
  final Border? border;

  const ProfessionalCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.glassMorphism = false,
    this.gradient,
    this.backgroundColor,
    this.elevation = 0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppDimensions.radiusLarge;

    if (glassMorphism) {
      return Container(
        margin: margin ?? const EdgeInsets.all(AppDimensions.paddingMedium),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient ?? AppGradients.glassGradient,
                borderRadius: BorderRadius.circular(radius),
                border:
                    border ??
                    Border.all(color: AppColors.glassBorderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    padding ?? const EdgeInsets.all(AppDimensions.paddingLarge),
                child: child,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: margin ?? const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardColor,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: border,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppDimensions.paddingLarge),
        child: child,
      ),
    );
  }
}

class WeatherMetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;
  final Gradient? gradient;

  const WeatherMetricCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ProfessionalCard(
      glassMorphism: true,
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingSmall),
            decoration: BoxDecoration(
              gradient: gradient ?? AppGradients.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (iconColor ?? AppColors.accentColor).withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: AppDimensions.iconMedium,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textTertiaryColor),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class ProfessionalTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final bool enabled;
  final TextInputType? keyboardType;

  const ProfessionalTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmitted,
    this.onChanged,
    this.enabled = true,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingMedium,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppGradients.glassGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              border: Border.all(color: AppColors.glassBorderColor, width: 1),
            ),
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              enabled: enabled,
              keyboardType: keyboardType,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                prefixIcon: prefixIcon != null
                    ? Icon(
                        prefixIcon,
                        color: AppColors.textTertiaryColor,
                        size: AppDimensions.iconMedium,
                      )
                    : null,
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiaryColor.withOpacity(0.7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                  vertical: AppDimensions.paddingMedium,
                ),
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? color;
  final double size;

  const LoadingIndicator({super.key, this.message, this.color, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size,
            height: size,
            padding: EdgeInsets.all(size * 0.25),
            decoration: BoxDecoration(
              gradient: AppGradients.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (color ?? AppColors.accentColor).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppDimensions.paddingLarge),
            ProfessionalCard(
              glassMorphism: true,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
                vertical: AppDimensions.paddingMedium,
              ),
              child: Text(
                message!,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
