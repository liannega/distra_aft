import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPermissions {
  final String userId;
  final String userName;
  final String userType;
  final String selectedEntity;
  final Map<String, bool> modulePermissions;
  final Map<String, bool> actionPermissions;

  UserPermissions({
    required this.userId,
    required this.userName,
    required this.userType,
    required this.selectedEntity,
    required this.modulePermissions,
    required this.actionPermissions,
  });
}

class PredefinedUsers {
  static const Map<String, Map<String, String>> users = {
    'admin': {
      'password': '123456',
      'name': 'Carlos Rodríguez',
      'role': 'Administrador del Sistema',
      'profile': 'admin',
    },
    'supervisor': {
      'password': '123456',
      'name': 'María González',
      'role': 'Supervisor Regional',
      'profile': 'supervisor',
    },
    'operador': {
      'password': '123456',
      'name': 'José Martínez',
      'role': 'Operador Local',
      'profile': 'operator',
    },
    'invitado': {
      'password': '123456',
      'name': 'Usuario Invitado',
      'role': 'Solo Consulta',
      'profile': 'guest',
    },
  };

  static bool validateUser(String username, String password) {
    return users.containsKey(username.toLowerCase()) &&
        users[username.toLowerCase()]!['password'] == password;
  }

  static Map<String, String>? getUserInfo(String username) {
    return users[username.toLowerCase()];
  }
}

class UserProfiles {
  static Map<String, bool> _getAdminPermissions() {
    return {
      'dominio_entidades': true,
      'empresa_servicios': true,
      'casa_matriz': true,
      'agencias': true,
      'agencia_la_palma': true,
      'agencia_habana_este': true,
      'agencia_matanzas': true,
      'agencia_varadero': true,
      'agencia_villa_clara': true,
      'agencia_camaguey': true,
      'agencia_santiago': true,
    };
  }

  static Map<String, bool> _getSupervisorPermissions() {
    return {
      'dominio_entidades': true,
      'empresa_servicios': true,
      'casa_matriz': true,
      'agencias': true,
      'agencia_la_palma': true,
      'agencia_habana_este': true,
      'agencia_matanzas': false,
      'agencia_varadero': true,
      'agencia_villa_clara': false,
      'agencia_camaguey': true,
      'agencia_santiago': false,
    };
  }

  static Map<String, bool> _getOperatorPermissions() {
    return {
      'dominio_entidades': true,
      'empresa_servicios': true,
      'casa_matriz': false,
      'agencias': true,
      'agencia_la_palma': false,
      'agencia_habana_este': true,
      'agencia_matanzas': false,
      'agencia_varadero': false,
      'agencia_villa_clara': false,
      'agencia_camaguey': false,
      'agencia_santiago': false,
    };
  }

  static Map<String, bool> _getGuestPermissions() {
    return {
      'dominio_entidades': true,
      'empresa_servicios': true,
      'casa_matriz': false,
      'agencias': true,
      'agencia_la_palma': false,
      'agencia_habana_este': false,
      'agencia_matanzas': false,
      'agencia_varadero': false,
      'agencia_villa_clara': false,
      'agencia_camaguey': false,
      'agencia_santiago': false,
    };
  }

  static UserPermissions createUserPermissions(
    String profile,
    String username,
  ) {
    final userInfo = PredefinedUsers.getUserInfo(username);

    switch (profile) {
      case 'admin':
        return UserPermissions(
          userId: 'admin_001',
          userName: userInfo?['name'] ?? 'Administrador',
          userType: 'authenticated',
          selectedEntity: 'Empresa de Servicios Automotores SA',
          modulePermissions: _getAdminPermissions(),
          actionPermissions: {
            'read_assets': true,
            'write_assets': true,
            'create_verification': true,
            'modify_verification': true,
            'delete_verification': true,
            'export_data': true,
            'import_data': true,
          },
        );
      case 'supervisor':
        return UserPermissions(
          userId: 'supervisor_001',
          userName: userInfo?['name'] ?? 'Supervisor',
          userType: 'authenticated',
          selectedEntity: 'Empresa de Servicios Automotores SA',
          modulePermissions: _getSupervisorPermissions(),
          actionPermissions: {
            'read_assets': true,
            'write_assets': true,
            'create_verification': true,
            'modify_verification': true,
            'delete_verification': false,
            'export_data': true,
            'import_data': false,
          },
        );
      case 'operator':
        return UserPermissions(
          userId: 'operator_001',
          userName: userInfo?['name'] ?? 'Operador',
          userType: 'different',
          selectedEntity: 'Agencia Habana del Este',
          modulePermissions: _getOperatorPermissions(),
          actionPermissions: {
            'read_assets': true,
            'write_assets': true,
            'create_verification': false,
            'modify_verification': false,
            'delete_verification': false,
            'export_data': false,
            'import_data': false,
          },
        );
      case 'guest':
      default:
        return UserPermissions(
          userId: 'guest_001',
          userName: userInfo?['name'] ?? 'Invitado',
          userType: 'different',
          selectedEntity: 'Solo Consulta',
          modulePermissions: _getGuestPermissions(),
          actionPermissions: {
            'read_assets': true,
            'write_assets': false,
            'create_verification': false,
            'modify_verification': false,
            'delete_verification': false,
            'export_data': false,
            'import_data': false,
          },
        );
    }
  }
}

class UserPermissionsNotifier extends StateNotifier<UserPermissions?> {
  UserPermissionsNotifier() : super(null);

  void setUserFromLogin(String username) {
    final userInfo = PredefinedUsers.getUserInfo(username);
    if (userInfo != null) {
      final profile = userInfo['profile']!;
      state = UserProfiles.createUserPermissions(profile, username);
    }
  }

  void clearPermissions() {
    state = null;
  }

  bool hasModulePermission(String moduleKey) {
    return state?.modulePermissions[moduleKey] ?? false;
  }

  bool hasActionPermission(String actionKey) {
    return state?.actionPermissions[actionKey] ?? false;
  }
}

final userPermissionsProvider =
    StateNotifierProvider<UserPermissionsNotifier, UserPermissions?>(
      (ref) => UserPermissionsNotifier(),
    );

final modulePermissionProvider = Provider.family<bool, String>((
  ref,
  moduleKey,
) {
  final permissions = ref.watch(userPermissionsProvider);
  return permissions?.modulePermissions[moduleKey] ?? false;
});

final actionPermissionProvider = Provider.family<bool, String>((
  ref,
  actionKey,
) {
  final permissions = ref.watch(userPermissionsProvider);
  return permissions?.actionPermissions[actionKey] ?? false;
});
