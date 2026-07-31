/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BusinessError } from '@ohos.base';
import formHost from '@ohos.app.form.formHost';
import { CommonConstants, FormModel, FormModelValidCardType, RdbStoreManager } from '@ohos/launchercommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import ScreenLockThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { settings } from '@kit.BasicServicesKit';
import { DesktopLayoutState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { SimpleRdbStoreManager } from '@ohos/launchercommon/src/main/ets/db/SimpleRdbStoreManager';
import { ModeChangeUtils } from '@ohos/frameworkwrapper/src/main/ets/utils/ModeChangeUtils';
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG: string = 'FormClearUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class FormClearUtils {
  /**
   * 加载桌面前，清理没有被持久化的Card Id
   *
   * @param checkTimes
   */
  public static clearInvalidForm(checkTimes: number): void {
    try {
      formHost.isSystemReady((error: BusinessError) => {
        if (error) {
          log.showError('clear invalid form error, code: %{public}d, message: %{public}s', error.code, error.message);
          checkTimes++;
          setTimeout((): void => FormClearUtils.clearInvalidForm(checkTimes), checkTimes * 100);
        } else {
          log.showInfo('clear invalid card id');
          FormClearUtils.doClearInvalidForm();
        }
      });
    } catch (err) {
      log.error('clear invalid form error', err);
      checkTimes++;
      setTimeout((): void => FormClearUtils.clearInvalidForm(checkTimes), checkTimes * 100);
    }
  }

  private static doClearInvalidForm(): void {
    FormModel.getInstance().registerQueryValidCardIdCallback(FormModelValidCardType.RDB_GRIDLAYOUT_TABLE_INDEPENDENT,
      async (): Promise<string[]> => {
        let formIds: string[] = [];
        // 简易模式将布局表cardId添加清理白名单
        let simpleModeCardIdList = (await SimpleRdbStoreManager.getInstance().getAllFormInfos()).map(
          item => item.cardId.toString()
        );
        formIds.push(...simpleModeCardIdList);
        return formIds;
      }
    );

    //为云端模式2注册卡片
    FormModel.getInstance().registerQueryValidCardIdCallback(FormModelValidCardType.OUTDOOR_CARD,
      async (): Promise<string[]> => {
        let formIds: string[] = [];
        let cardIdList = (await RdbStoreManager.getInstance().getAllFormInfosForLightOutdoorMode()).map(
          (item: CardItemInfo) => item.cardId.toString()
        );
        formIds.push(...cardIdList);
        return formIds;
      }
    );

    FormModel.getInstance().registerQueryValidCardIdCallback(FormModelValidCardType.SCREEN_LOCK,
      async (): Promise<string[]> => {
        let cardIdList: string[] = await ScreenLockThemeManager.getInstance().getPersistenceCardId();
        return cardIdList;
      }
    );

    if (ModeChangeUtils.isSupportWindowPcModeSwitch()) {
      FormModel.getInstance().registerQueryValidCardIdCallback(FormModelValidCardType.QXS_PC_MODE_CARD,
        async (): Promise<string[]> => {
          let pcModeCardIdList: string[] = (await RdbStoreManager.getInstance().getAllFormInfosPcMode()).map(
            item => item.cardId.toString()
          );
          return pcModeCardIdList;
        }
      );
    }

    FormModel.getInstance().clearInvalidCards();
  }
}