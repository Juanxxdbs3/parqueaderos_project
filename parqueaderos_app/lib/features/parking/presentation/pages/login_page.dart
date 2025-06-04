import 'package:flutter/material.dart';
import 'package:parqueaderos_app/features/parking/presentation/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Colores principales
    const Color pastelViolet = Color(0xFFE6E6FA); // Violeta pastel
    const Color accentViolet = Color(0xFF7C4DFF); // Violeta acento
    const Color buttonViolet = Color(0xFF9575CD); // Botón violeta claro

    return Scaffold(
      backgroundColor: pastelViolet,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Logo
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "ParkItNow",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: accentViolet,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            // 2. Formulario
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Usuario",
                        prefixIcon: Icon(Icons.person, color: accentViolet),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        prefixIcon: Icon(Icons.lock, color: accentViolet),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonViolet,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          // Acción al iniciar sesión, manda a la página de inicio sin autenticación
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Iniciar sesión",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 3. Registro y Google
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "¿No tienes una cuenta?",
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Registrarse",
                        style: TextStyle(
                          color: accentViolet,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Row(
                      children: const [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("O"),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: accentViolet,
                          side: BorderSide(color: accentViolet),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.g_mobiledata, size: 28),
                        label: const Text(
                          "Continuar con Google",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 4. Idioma (abajo)
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: _LanguageDropdown(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageDropdown extends StatefulWidget {
  @override
  State<_LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<_LanguageDropdown> {
  String _selected = "Español";

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFF9575CD)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButton<String>(
          value: _selected,
          icon: const Icon(Icons.language, color: Color(0xFF7C4DFF)),
          items: const [
            DropdownMenuItem(
              value: "Español",
              child: Text("Español"),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selected = value!;
            });
          },
        ),
      ),
    );
  }
}
