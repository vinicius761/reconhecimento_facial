class Validators {
  static String? campoVazio(
    String? value, {
    String mensagem = 'Este campo é obrigatório',
  }) {
    if (value == null || value.trim().isEmpty) {
      return mensagem;
    }
    return null; // Retorna null quando o valor é válido
  }
}
