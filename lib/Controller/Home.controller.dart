import 'package:facial/Models/MenuItem.model.dart';
import 'package:facial/Models/Ponto.model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isVisivel = true.obs;

  RxList<PontoModel> pontos = <PontoModel>[
    PontoModel.fromJson({
      "id": 1,
      "tipo": "ENTRADA",
      "horario": "2026-09-18T08:00:00Z",
    }),
    PontoModel.fromJson({
      "id": 2,
      "tipo": "SAIDA_ALMOCO",
      "horario": "2026-09-18T12:00:00Z",
    }),
    PontoModel.fromJson({
      "id": 3,
      "tipo": "RETORNO_ALMOCO",
      "horario": "2026-09-18T13:00:00Z",
    }),
    PontoModel.fromJson({
      "id": 4,
      "tipo": "SAIDA",
      "horario": "2026-09-18T17:00:00Z",
    }),
    PontoModel.fromJson({
      "id": 5,
      "tipo": "ENTRADA",
      "horario": "2026-09-19T08:05:00Z",
    }),
    PontoModel.fromJson({
      "id": 6,
      "tipo": "SAIDA_ALMOCO",
      "horario": "2026-09-19T12:02:00Z",
    }),
    PontoModel.fromJson({
      "id": 7,
      "tipo": "RETORNO_ALMOCO",
      "horario": "2026-09-19T13:01:00Z",
    }),
    PontoModel.fromJson({
      "id": 8,
      "tipo": "SAIDA",
      "horario": "2026-09-19T17:03:00Z",
    }),
    PontoModel.fromJson({
      "id": 9,
      "tipo": "ENTRADA",
      "horario": "2026-09-20T07:58:00Z",
    }),
    PontoModel.fromJson({
      "id": 10,
      "tipo": "SAIDA_ALMOCO",
      "horario": "2026-09-20T11:59:00Z",
    }),
    PontoModel.fromJson({
      "id": 11,
      "tipo": "RETORNO_ALMOCO",
      "horario": "2026-09-20T13:00:00Z",
    }),
    PontoModel.fromJson({
      "id": 12,
      "tipo": "SAIDA",
      "horario": "2026-09-20T17:00:00Z",
    }),
    PontoModel.fromJson({
      "id": 13,
      "tipo": "ENTRADA",
      "horario": "2026-09-21T08:10:00Z",
    }),
    PontoModel.fromJson({
      "id": 14,
      "tipo": "SAIDA_ALMOCO",
      "horario": "2026-09-21T12:15:00Z",
    }),
    PontoModel.fromJson({
      "id": 15,
      "tipo": "RETORNO_ALMOCO",
      "horario": "2026-09-21T13:10:00Z",
    }),
    PontoModel.fromJson({
      "id": 16,
      "tipo": "SAIDA",
      "horario": "2026-09-21T17:12:00Z",
    }),
    PontoModel.fromJson({
      "id": 17,
      "tipo": "ENTRADA",
      "horario": "2026-09-22T08:00:00Z",
    }),
    PontoModel.fromJson({
      "id": 18,
      "tipo": "SAIDA_ALMOCO",
      "horario": "2026-09-22T12:00:00Z",
    }),
    PontoModel.fromJson({
      "id": 19,
      "tipo": "RETORNO_ALMOCO",
      "horario": "2026-09-22T13:00:00Z",
    }),
    PontoModel.fromJson({
      "id": 20,
      "tipo": "SAIDA",
      "horario": "2026-09-22T17:05:00Z",
    }),
  ].obs;

  RxList<MenuItemModel> menuItem = <MenuItemModel>[
    MenuItemModel.fromJson({
      "id": 1,
      "titulo": "Bater Ponto",
      "descricao": "Registro com reconhecimento facial",
      "icone": "camera_alt_outlined",
      "rota": "/reconhecimento-facial",
    }),
    MenuItemModel.fromJson({
      "id": 2,
      "titulo": "Histórico de Ponto",
      "descricao": "Espelho de ponto e marcações",
      "icone": "history",
      "rota": "/historico-ponto",
    }),
    MenuItemModel.fromJson({
      "id": 3,
      "titulo": "Solicitar Atestado",
      "descricao": "Envio de comprovantes e justificativas",
      "icone": "upload_file_outlined",
      "rota": "/solicitar-atestado",
    }),
    MenuItemModel.fromJson({
      "id": 4,
      "titulo": "Holerite / Paystub",
      "descricao": "Demonstrativo de pagamento em PDF",
      "icone": "receipt_long_outlined",
      "rota": "/holerite",
    }),
    MenuItemModel.fromJson({
      "id": 5,
      "titulo": "Minhas Férias",
      "descricao": "Saldos e solicitações de período",
      "icone": "beach_access_outlined",
      "rota": "/ferias",
    }),
    MenuItemModel.fromJson({
      "id": 6,
      "titulo": "Informe de Rendimentos",
      "descricao": "Comprovante para IRPF",
      "icone": "description_outlined",
      "rota": "/informe-rendimentos",
    }),
    MenuItemModel.fromJson({
      "id": 7,
      "titulo": "Banco de Horas",
      "descricao": "Extrato de horas extras e compensações",
      "icone": "access_time_outlined",
      "rota": "/banco-horas",
    }),
    MenuItemModel.fromJson({
      "id": 8,
      "titulo": "Meu Perfil",
      "descricao": "Dados cadastrais e alteração de senha",
      "icone": "person_outline",
      "rota": "/perfil",
    }),
  ].obs;

  void setIsVisivel() {
    isVisivel.value = !isVisivel.value;
  }
}
