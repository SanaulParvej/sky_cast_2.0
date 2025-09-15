import 'package:flutter/material.dart';
import 'dart:ui';
import '../constants/app_constants.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final bool glassMorphism;
  final Border? border;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.glassMorphism = false,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    if (glassMorphism) {
      return Container(
        margin: margin ?? const EdgeInsets.all(AppConstants.paddingMedium),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppConstants.radiusLarge,
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient ?? AppConstants.glassGradient,
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppConstants.radiusLarge,
                ),
                border: Border.all(
                  color: AppConstants.glassBorderColor,
                  width: 1,
                ),
              ),
              child: Padding(
                padding:
                    padding ?? const EdgeInsets.all(AppConstants.paddingLarge),
                child: child,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: margin ?? const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppConstants.cardColor,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppConstants.radiusLarge,
        ),
        gradient: gradient,
        border: border,
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppConstants.paddingLarge),
        child: child,
      ),
    );
  }
}

class WeatherDetailCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;
  final Color? valueColor;
  final Color? labelColor;
  final Gradient? gradient;

  const WeatherDetailCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor,
    this.valueColor,
    this.labelColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      glassMorphism: true,
      padding: const EdgeInsets.all(AppConstants.paddingSmall),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: gradient ?? AppConstants.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (iconColor ?? AppConstants.primaryColor).withOpacity(
                    0.3,
                  ),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: AppConstants.iconSizeSmall + 2,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall + 2,
                fontWeight: FontWeight.bold,
                color: valueColor ?? AppConstants.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall - 1,
                color: labelColor ?? AppConstants.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final bool enabled;
  final TextInputType? keyboardType;

  const CustomTextField({
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
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingMedium,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppConstants.glassGradient,
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              border: Border.all(
                color: AppConstants.glassBorderColor,
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              enabled: enabled,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: AppConstants.textPrimaryColor,
                fontSize: AppConstants.fontSizeMedium,
              ),
              decoration: InputDecoration(
                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon, color: AppConstants.textSecondaryColor)
                    : null,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: AppConstants.textSecondaryColor.withOpacity(0.7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge,
                  vertical: AppConstants.paddingMedium,
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

class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;

  const LoadingWidget({super.key, this.message, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppConstants.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (color ?? AppConstants.primaryColor).withOpacity(0.3),
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
            const SizedBox(height: AppConstants.paddingLarge),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingLarge,
                vertical: AppConstants.paddingMedium,
              ),
              decoration: BoxDecoration(
                color: AppConstants.surfaceColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Text(
                message!,
                style: const TextStyle(
                  color: AppConstants.textPrimaryColor,
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppConstants.errorColor.withOpacity(0.1),
                border: Border.all(
                  color: AppConstants.errorColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                icon ?? Icons.cloud_off_outlined,
                size: AppConstants.iconSizeXLarge,
                color: AppConstants.errorColor,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppConstants.surfaceColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: AppConstants.textPrimaryColor,
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppConstants.paddingLarge),
              Container(
                decoration: BoxDecoration(
                  gradient: AppConstants.primaryGradient,
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingLarge,
                      vertical: AppConstants.paddingMedium,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
