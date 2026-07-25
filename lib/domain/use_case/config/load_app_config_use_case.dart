import 'package:flutter_bloc_template/base/use_case/base_use_case.dart';
import 'package:flutter_bloc_template/base/use_case/sync_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../entity/config/load_app_config_entity.dart';

@injectable
class LoadAppConfigUseCase extends SyncUseCase<LoadAppConfigEntity, NoParam?> {
  @override
  LoadAppConfigEntity invoke(NoParam? param) {
    return LoadAppConfigEntity(
      isFirstLaunchApp: true,
      isDarkMode: false,
      isLoggedIn: false,
    );
  }
  // @override
  // Future<LoadAppConfigEntity> invoke(NoParam? param) async {
  //   return LoadAppConfigEntity(
  //     isFirstLaunchApp: true,
  //     isDarkMode: false,
  //     isLoggedIn: false,
  //   );
  // }
}
