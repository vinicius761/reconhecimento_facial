String obterIniciais(String? nomeCompleto) {
  if (nomeCompleto == null || nomeCompleto.trim().isEmpty) {
    return '--';
  }

  // Remove espaços extras e divide por palavra
  List<String> partes = nomeCompleto.trim().split(RegExp(r'\s+'));

  if (partes.length == 1) {
    // Se tiver apenas um nome, pega as duas primeiras letras ou a única letra existente
    return partes[0].substring(0, partes[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  // Pega a primeira letra do primeiro nome e a primeira letra do último nome
  String primeiraLetra = partes.first[0];
  String ultimaLetra = partes.last[0];

  return '$primeiraLetra$ultimaLetra'.toUpperCase();
}
