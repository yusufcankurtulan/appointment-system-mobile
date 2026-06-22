# TODO (BlackboxAI)

## Done / In Progress / Next
- [ ] Create design-matching LoginScreen (PremiumBackground + GlassContainer, no AppBar, centered content, show/hide password)
- [ ] Redesign RegisterScreen (no AppBar, PremiumBackground, glass form centered, show/hide password)
- [ ] Update Register flow: replace "Kayıt Ol" with premium bottom-right "İleri" FAB; validate then navigate to /location-permission with form data
- [ ] Create LocationPermissionScreen onboarding UI (PremiumBackground + GlassContainer), request permission with deniedForever handling, loading + dialogs
- [ ] On permission granted: call auth.register using passed form data; store tokens already handled in AuthRepository; redirect to Home
- [ ] Update GoRouter routes.dart to add /location-permission and ensure navigation works
- [ ] Run flutter analyze (and tests if available)

